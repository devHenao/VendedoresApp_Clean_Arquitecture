import 'package:equatable/equatable.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final List<Client> clients;

  const ClientLoaded({required this.clients});

  @override
  List<Object> get props => [clients];
}

class ClientUpdated extends ClientState {
  final Client client;

  const ClientUpdated({required this.client});

  @override
  List<Object> get props => [client];
}

class DepartmentsLoaded extends ClientState {
  final List<Map<String, dynamic>> departments;

  const DepartmentsLoaded({required this.departments});

  @override
  List<Object> get props => [departments];
}

class CitiesLoaded extends ClientState {
  final List<Map<String, dynamic>> cities;

  const CitiesLoaded({required this.cities});

  @override
  List<Object> get props => [cities];
}

class ClientError extends ClientState {
  final String message;

  const ClientError({required this.message});

  @override
  List<Object> get props => [message];
}
