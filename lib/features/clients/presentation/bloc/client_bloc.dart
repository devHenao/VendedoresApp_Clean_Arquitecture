import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final GetClientsUseCase getClientsUseCase;

  ClientBloc({required this.getClientsUseCase}) : super(ClientInitial()) {
    on<LoadClients>(_onLoadClients);
    on<SearchClients>(_onSearchClients);
  }

  Future<void> _onLoadClients(LoadClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrClients = await getClientsUseCase();
    failureOrClients.fold(
      (failure) => emit(ClientError(message: failure.props.first.toString())),
      (clients) => emit(ClientLoaded(clients: clients)),
    );
  }

  Future<void> _onSearchClients(SearchClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    final failureOrClients = await getClientsUseCase();
    failureOrClients.fold(
      (failure) => emit(ClientError(message: failure.props.first.toString())),
      (clients) {
        final filteredClients = clients
            .where((client) =>
                client.nombre.toLowerCase().contains(event.query.toLowerCase()) ||
                client.nit.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(ClientLoaded(clients: filteredClients));
      },
    );
  }
}
