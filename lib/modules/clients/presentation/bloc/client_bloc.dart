import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/use_cases/client_use_cases.dart';
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
    on<GetClientByNit>(_onGetClientByNit);
    on<UpdateClient>(_onUpdateClient);
    on<LoadDepartments>(_onLoadDepartments);
    on<LoadCitiesByDepartment>(_onLoadCitiesByDepartment);
  }

  Future<void> _onLoadClients(LoadClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrClients = await getClientsUseCase();
    failureOrClients.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (clients) => emit(ClientLoaded(clients: clients)),
    );
  }

  Future<void> _onSearchClients(SearchClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrClients = await searchClientsUseCase(event.query);
    failureOrClients.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (clients) => emit(ClientLoaded(clients: clients)),
    );
  }

  Future<void> _onGetClientByNit(GetClientByNit event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrClient = await getClientByNitUseCase(event.nit);
    failureOrClient.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (client) => emit(ClientLoaded(clients: [client])),
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
    emit(ClientLoading());
    final failureOrDepartments = await getDepartmentsUseCase();
    failureOrDepartments.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (departments) => emit(DepartmentsLoaded(departments: departments)),
    );
  }

  Future<void> _onLoadCitiesByDepartment(LoadCitiesByDepartment event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrCities = await getCitiesByDepartmentUseCase(event.department);
    failureOrCities.fold(
      (failure) => emit(ClientError(message: failure.toString())),
      (cities) => emit(CitiesLoaded(cities: cities)),
    );
  }
}
