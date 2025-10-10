import 'package:equatable/equatable.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object> get props => [];
}

class SelectClient extends ClientEvent {
  final String? clientNit;

  const SelectClient(this.clientNit);

  @override
  List<Object> get props => [clientNit ?? ''];
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

class DownloadClientFile extends ClientEvent {
  final String clientId;
  final DownloadType type;
  final DateTime? startDate;
  final DateTime? endDate;

  const DownloadClientFile({
    required this.clientId,
    required this.type,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object> get props => [
        clientId,
        type,
        if (startDate != null) startDate!,
        if (endDate != null) endDate!,
      ];
}

class UpdateDateRange extends ClientEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const UpdateDateRange({this.startDate, this.endDate});

  @override
  List<Object> get props => [
        if (startDate != null) startDate!,
        if (endDate != null) endDate!,
      ];
}
