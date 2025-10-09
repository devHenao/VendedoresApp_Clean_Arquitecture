import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/usecases/client_use_cases.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_event.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final GetClientsUseCase getClientsUseCase;
  final SearchClientsUseCase searchClientsUseCase;
  final UpdateClientUseCase updateClientUseCase;
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final GetCitiesByDepartmentUseCase getCitiesByDepartmentUseCase;
  final DownloadFileBloc? downloadFileBloc;
  
  // Cache local de clientes
  List<Client> _cachedClients = [];

  ClientBloc({
    required this.getClientsUseCase,
    required this.searchClientsUseCase,
    required this.updateClientUseCase,
    required this.getDepartmentsUseCase,
    required this.getCitiesByDepartmentUseCase,
    this.downloadFileBloc,
  }) : super(ClientInitial()) {
    on<LoadClients>(_onLoadClients);
    on<SearchClients>(_onSearchClients);
    on<UpdateClient>(_onUpdateClient);
    on<LoadDepartments>(_onLoadDepartments);
    on<LoadCitiesByDepartment>(_onLoadCitiesByDepartment);
    on<UpdateDateRange>(_onUpdateDateRange);
    on<DownloadClientFile>(_onDownloadClientFile);
  }

  Future<void> _onDownloadClientFile(
    DownloadClientFile event,
    Emitter<ClientState> emit,
  ) async {
    if (downloadFileBloc != null) {
      downloadFileBloc!.add(
        DownloadFileRequested(
          clientId: event.clientId,
          type: event.type,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    }
  }

  Future<void> _onUpdateDateRange(UpdateDateRange event, Emitter<ClientState> emit) async {
    if (state is ClientLoaded) {
      final currentState = state as ClientLoaded;
      emit(currentState.copyWith(
        startDate: event.startDate ?? currentState.startDate,
        endDate: event.endDate ?? currentState.endDate,
      ));
    } else {
      emit(ClientLoaded(
        clients: const [],
        startDate: event.startDate ?? state.startDate,
        endDate: event.endDate ?? state.endDate,
      ));
    }
  }

  Future<void> _onSearchClients(SearchClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading(startDate: state.startDate, endDate: state.endDate));
    final failureOrClients = await searchClientsUseCase(event.query);
    failureOrClients.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (clients) => emit(ClientLoaded(
        clients: clients,
        startDate: state.startDate,
        endDate: state.endDate,
      )),
    );
  }

  Future<void> _onLoadClients(LoadClients event, Emitter<ClientState> emit) async {
    // Mostrar estado de carga
    emit(ClientLoading(startDate: state.startDate, endDate: state.endDate));
    
    // Si ya tenemos clientes en caché, mostrarlos inmediatamente
    if (_cachedClients.isNotEmpty) {
      emit(ClientLoaded(
        clients: _cachedClients,
        startDate: state.startDate,
        endDate: state.endDate,
      ));
    }

    // Obtener datos del servidor
    final failureOrClients = await getClientsUseCase();
    
    failureOrClients.fold(
      (failure) {
        // Si hay error pero tenemos datos en caché, mantenerlos
        if (_cachedClients.isNotEmpty) {
          emit(ClientError(
            message: 'Error al actualizar: ${failure.toString()}',
            cachedClients: _cachedClients,
            startDate: state.startDate,
            endDate: state.endDate,
          ));
        } else {
          emit(ClientError(
            message: failure.toString(),
            startDate: state.startDate,
            endDate: state.endDate,
          ));
        }
      },
      (clients) {
        // Actualizar caché
        _cachedClients = clients;
        emit(ClientLoaded(
          clients: clients,
          startDate: state.startDate,
          endDate: state.endDate,
        ));
      },
    );
  }

  Future<void> _onUpdateClient(UpdateClient event, Emitter<ClientState> emit) async {
    // Show loading state
    if (state is ClientLoaded) {
      final currentState = state as ClientLoaded;
      emit(currentState.copyWith(isLoading: true));
    } else {
      emit(ClientLoading(startDate: state.startDate, endDate: state.endDate));
    }

    try {
      final failureOrClient = await updateClientUseCase(event.client);
      
      await failureOrClient.fold(
        (failure) async {
          // If there's an error but we have cached data, keep it
          if (_cachedClients.isNotEmpty) {
            emit(ClientError(
              message: 'Error al actualizar: ${failure.toString()}',
              cachedClients: _cachedClients,
              startDate: state.startDate,
              endDate: state.endDate,
            ));
          } else {
            emit(ClientError(
              message: failure.toString(),
              startDate: state.startDate,
              endDate: state.endDate,
            ));
          }
        },
        (updatedClient) async {
          // Update the client in the local cache
          final index = _cachedClients.indexWhere((c) => c.nit == updatedClient.nit);
          if (index != -1) {
            _cachedClients[index] = updatedClient;
          } else {
            _cachedClients.add(updatedClient);
          }
          
          // Update the UI with the new client data
          if (state is ClientLoaded) {
            final currentState = state as ClientLoaded;
            final updatedClients = List<Client>.from(currentState.clients);
            final clientIndex = updatedClients.indexWhere((c) => c.nit == updatedClient.nit);
            
            if (clientIndex != -1) {
              updatedClients[clientIndex] = updatedClient;
            } else {
              updatedClients.add(updatedClient);
            }
            
            emit(currentState.copyWith(
              clients: updatedClients,
              isLoading: false,
            ));
          } else {
            emit(ClientLoaded(
              clients: _cachedClients,
              startDate: state.startDate,
              endDate: state.endDate,
              isLoading: false,
            ));
          }
          
          // Emit the update event
          emit(ClientUpdated(client: updatedClient));
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      if (_cachedClients.isNotEmpty) {
        emit(ClientError(
          message: 'Error inesperado: $e',
          cachedClients: _cachedClients,
          startDate: state.startDate,
          endDate: state.endDate,
        ));
      } else {
        emit(ClientError(
          message: 'Error inesperado: $e',
          startDate: state.startDate,
          endDate: state.endDate,
        ));
      }
    }
  }

  Future<void> _onLoadDepartments(LoadDepartments event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrDepartments = await getDepartmentsUseCase();
    failureOrDepartments.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (departments) => emit(DepartmentsLoaded(departments: departments.cast<String>())),
    );
  }

  Future<void> _onLoadCitiesByDepartment(LoadCitiesByDepartment event, Emitter<ClientState> emit) async {
    emit(ClientLoading(startDate: state.startDate, endDate: state.endDate));
    final failureOrCities = await getCitiesByDepartmentUseCase(event.department);
    failureOrCities.fold(
      (failure) => emit(ClientError(
        message: failure.toString(),
        startDate: state.startDate,
        endDate: state.endDate,
      )),
      (cities) {
        // Convert the list of city strings to a list of Map<String, String>
        final List<Map<String, String>> cityMaps = cities.map((city) => 
          <String, String>{'name': city.toString()}
        ).toList();
        
        emit(CitiesLoaded(
          cities: cityMaps,
          startDate: state.startDate,
          endDate: state.endDate,
        ));
      },
    );
  }
}
