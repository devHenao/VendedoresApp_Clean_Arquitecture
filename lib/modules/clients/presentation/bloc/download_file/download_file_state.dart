import 'package:equatable/equatable.dart';
import 'package:app_vendedores/core/errors/failures.dart';

enum DownloadFileStatus { initial, loading, success, failure }

class DownloadFileState extends Equatable {
  final DownloadFileStatus status;
  final String? filePath;
  final String? errorMessage;
  final Failure? failure;

  const DownloadFileState({
    this.status = DownloadFileStatus.initial,
    this.filePath,
    this.errorMessage,
    this.failure,
  });

  bool get isLoading => status == DownloadFileStatus.loading;
  bool get isSuccess => status == DownloadFileStatus.success;
  bool get isFailure => status == DownloadFileStatus.failure;
  bool get hasError => errorMessage != null;

  DownloadFileState copyWith({
    DownloadFileStatus? status,
    String? filePath,
    String? errorMessage,
    Failure? failure,
  }) {
    return DownloadFileState(
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, filePath, errorMessage, failure];
}
