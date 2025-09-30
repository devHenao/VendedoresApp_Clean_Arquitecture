import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/usecases/client_use_cases.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final GetClientsUseCase getClientsUseCase;
  final SearchClientsUseCase searchClientsUseCase;
  final GetClientByNitUseCase getClientByNitUseCase;
  final UpdateClientUseCase updateClientUseCase;
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final GetCitiesByDepartmentUseCase getCitiesByDepartmentUseCase;

  ClientBloc({
    required this.getClientsUseCase,
    required this.searchClientsUseCase,
    required this.getClientByNitUseCase,
    required this.updateClientUseCase,
    required this.getDepartmentsUseCase,
    required this.getCitiesByDepartmentUseCase,
  }) : super(ClientInitial()) {
    on<LoadClients>(_onLoadClients);
    on<SearchClients>(_onSearchClients);
    on<UpdateClient>(_onUpdateClient);
    on<LoadDepartments>(_onLoadDepartments);
    on<LoadCitiesByDepartment>(_onLoadCitiesByDepartment);
    on<GetClientByNit>(_onGetClientByNit);
    on<UpdateDateRange>(_onUpdateDateRange);
  }

  Future<void> _onUpdateDateRange(UpdateDateRange event, Emitter<ClientState> emit) async {
    if (state is ClientLoaded) {
      final currentState = state as ClientLoaded;
      emit(currentState.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
        isFiltered: event.startDate != null || event.endDate != null,
      ));
    } else if (state is ClientLoading) {
      final currentState = state as ClientLoading;
      emit(ClientLoading(
        startDate: event.startDate ?? currentState.startDate,
        endDate: event.endDate ?? currentState.endDate,
        clients: currentState.originalClients,
        isFiltered: event.startDate != null || event.endDate != null,
      ));
    } else {
      emit(ClientLoaded(
        clients: const [],
        startDate: event.startDate,
        endDate: event.endDate,
        isFiltered: event.startDate != null || event.endDate != null,
      ));
    }
  }

  Future<void> _onSearchClients(SearchClients event, Emitter<ClientState> emit) async {
    // Mantener los clientes existentes mientras se busca
    final List<Client> currentClients = state is ClientLoaded 
        ? (state as ClientLoaded).originalClients 
        : <Client>[];
        
    emit(ClientLoading(
      startDate: state.startDate,
      endDate: state.endDate,
      clients: currentClients,
      isFiltered: state.isFiltered,
    ));
    
    final failureOrClients = await searchClientsUseCase(event.query);
    
    failureOrClients.fold(
      (failure) {
        // Si hay un error en la búsqueda, volver a mostrar los clientes originales
        if (currentClients.isNotEmpty) {
          emit(ClientLoaded(
            clients: currentClients,
            startDate: state.startDate,
            endDate: state.endDate,
            isFiltered: state.isFiltered,
          ));
        } else {
          emit(ClientError(message: failure.toString()));
        }
      },
      (clients) => emit(ClientLoaded(
        clients: clients,
        startDate: state.startDate,
        endDate: state.endDate,
        isFiltered: state.isFiltered,
      )),
    );
  }

  Future<void> _onLoadClients(LoadClients event, Emitter<ClientState> emit) async {
    // Mantener los clientes existentes mientras se cargan los nuevos
    final List<Client> currentClients = state is ClientLoaded 
        ? (state as ClientLoaded).originalClients 
        : <Client>[];
        
    emit(ClientLoading(
      startDate: state.startDate,
      endDate: state.endDate,
      clients: currentClients,
      isFiltered: state.isFiltered,
    ));
    
    final failureOrClients = await getClientsUseCase();
    
    failureOrClients.fold(
      (failure) {
        // En caso de error, mantener los clientes existentes si los hay
        if (currentClients.isNotEmpty) {
          emit(ClientLoaded(
            clients: currentClients,
            startDate: state.startDate,
            endDate: state.endDate,
            isFiltered: state.isFiltered,
          ));
        } else {
          emit(ClientError(message: failure.toString()));
        }
      },
      (clients) => emit(ClientLoaded(
        clients: clients,
        startDate: state.startDate,
        endDate: state.endDate,
        isFiltered: state.isFiltered,
      )),
    );
  }

  Future<void> _onGetClientByNit(GetClientByNit event, Emitter<ClientState> emit) async {
    emit(ClientLoading(
      startDate: state.startDate,
      endDate: state.endDate,
      clients: state.originalClients,
      isFiltered: state.isFiltered,
    ));
    
    final failureOrClient = await getClientByNitUseCase(event.nit);
    
    failureOrClient.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (client) => emit(ClientLoaded(
        clients: [client],
        startDate: state.startDate,
        endDate: state.endDate,
        isFiltered: state.isFiltered,
      )),
    );
  }

  Future<void> _onUpdateClient(UpdateClient event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrClient = await updateClientUseCase(event.client);
    failureOrClient.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (client) => emit(ClientUpdated(client: client)),
    );
  }

  Future<void> _onLoadDepartments(LoadDepartments event, Emitter<ClientState> emit) async {
    emit(ClientLoading(
      startDate: state.startDate,
      endDate: state.endDate,
      clients: state.originalClients,
      isFiltered: state.isFiltered,
    ));
    
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
      (failure) => emit(ClientError(message: failure.toString())),
      (cities) => emit(CitiesLoaded(
        cities: cities.map((city) => {'name': city}).toList(),
        startDate: state.startDate,
        endDate: state.endDate,
      )),
    );
  }
}
