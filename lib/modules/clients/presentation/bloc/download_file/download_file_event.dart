import 'package:equatable/equatable.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';

abstract class DownloadFileEvent extends Equatable {
  const DownloadFileEvent();

  @override
  List<Object> get props => [];
}

class DownloadFileRequested extends DownloadFileEvent {
  final String clientId;
  final DownloadType type;
  final DateTime? startDate;
  final DateTime? endDate;

  const DownloadFileRequested({
    required this.clientId,
    required this.type,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object> get props => [clientId, type];
}

class DownloadFileReset extends DownloadFileEvent {}

class DownloadFileErrorShown extends DownloadFileEvent {
  final String error;

  const DownloadFileErrorShown(this.error);

  @override
  List<Object> get props => [error];
}
