import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateClientEvent extends Equatable {
  const UpdateClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadClientEvent extends UpdateClientEvent {
  final String clientId;
  const LoadClientEvent(this.clientId);
}

class UpdateClientSubmittedEvent extends UpdateClientEvent {
  final Client client;
  const UpdateClientSubmittedEvent(this.client);
}

class DepartmentChangedEvent extends UpdateClientEvent {
  final String department;
  const DepartmentChangedEvent(this.department);
}

class CityChangedEvent extends UpdateClientEvent {
  final String cityCode;
  
  const CityChangedEvent({required this.cityCode});
  
  @override
  List<Object?> get props => [cityCode];
}

class SetClientEvent extends UpdateClientEvent {
  final Client client;
  const SetClientEvent(this.client);
}
