import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

abstract class UpdateClientEvent {}

class LoadClientEvent extends UpdateClientEvent {
  final String clientId;
  LoadClientEvent(this.clientId);
}

class UpdateClientSubmittedEvent extends UpdateClientEvent {
  final Client client;
  UpdateClientSubmittedEvent(this.client);
}

class DepartmentChangedEvent extends UpdateClientEvent {
  final String department;
  DepartmentChangedEvent(this.department);
}

class CityChangedEvent extends UpdateClientEvent {
  final String city;
  CityChangedEvent(this.city);
}

class SetClientEvent extends UpdateClientEvent {
  final Client client;
  SetClientEvent(this.client);
}
