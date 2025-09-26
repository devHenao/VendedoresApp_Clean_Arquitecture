import 'package:equatable/equatable.dart';
import 'package:app_vendedores/features/clients/domain/entities/client.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object> get props => [];
}

class LoadClients extends ClientEvent {}

class SearchClients extends ClientEvent {
  final String query;

  const SearchClients(this.query);

  @override
  List<Object> get props => [query];
}

class GetClientByNit extends ClientEvent {
  final String nit;

  const GetClientByNit(this.nit);

  @override
  List<Object> get props => [nit];
}

class UpdateClient extends ClientEvent {
  final Client client;

  const UpdateClient(this.client);

  @override
  List<Object> get props => [client];
}

class LoadDepartments extends ClientEvent {}

class LoadCitiesByDepartment extends ClientEvent {
  final String department;

  const LoadCitiesByDepartment(this.department);

  @override
  List<Object> get props => [department];
}
