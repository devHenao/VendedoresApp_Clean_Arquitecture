import 'dart:io';
import 'dart:async';

import 'package:app_vendedores/modules/clients/domain/usecases/client_use_cases.dart';
import 'package:bloc/bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/modules/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_state.dart';

class DownloadFileBloc extends Bloc<DownloadFileEvent, DownloadFileState> {
  final DownloadClientFileUseCase downloadClientFile;
  final NetworkInfo networkInfo;
  final AuthRepository authRepository;

  DownloadFileBloc({
    required this.downloadClientFile,
    required this.networkInfo,
    required this.authRepository,
  }) : super(const DownloadFileState()) {
    on<DownloadFileRequested>(_onDownloadFileRequested);
    on<DownloadFileReset>(_onDownloadFileReset);
    on<DownloadFileErrorShown>(_onDownloadFileErrorShown);
  }

  Future<void> _onDownloadFileRequested(
    DownloadFileRequested event,
    Emitter<DownloadFileState> emit,
  ) async {
    // Verificar conexión a internet
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      emit(state.copyWith(
        status: DownloadFileStatus.failure,
        errorMessage: 'No hay conexión a internet',
        failure: const NetworkFailure(),
      ));
      return;
    }

    // Obtener token de autenticación
    final userOrFailure = await authRepository.getCurrentUser();
    await userOrFailure.fold(
      (failure) async {
        emit(state.copyWith(
          status: DownloadFileStatus.failure,
          errorMessage: 'Error de autenticación',
          failure: failure,
        ));
      },
      (user) async {
        emit(state.copyWith(status: DownloadFileStatus.loading));

        try {
          final result = await downloadClientFile(
            clientId: event.clientId,
            token: user.token,
            type: event.type,
            startDate: event.startDate,
            endDate: event.endDate,
          );

          await result.fold(
            (failure) async {
              String errorMessage;
              if (failure is ServerFailure) {
                errorMessage = failure.message;
              } else if (failure is UnauthorizedFailure) {
                errorMessage = 'No autorizado';
              } else if (failure is FileDownloadFailure) {
                errorMessage = failure.message;
              } else if (failure is NetworkFailure) {
                errorMessage = 'Error de conexión';
              } else {
                errorMessage = 'Error desconocido';
              }

              emit(state.copyWith(
                status: DownloadFileStatus.failure,
                errorMessage: errorMessage,
                failure: failure,
              ));
            },
            (filePath) async {
              // Verificar si el archivo existe
              final file = File(filePath);
              if (await file.exists()) {
                // Abrir el archivo con la aplicación predeterminada
                final result = await OpenFile.open(filePath);
                
                if (result.type != ResultType.done) {
                  // Si no se pudo abrir, ofrecer opción de compartir
                  await Share.shareXFiles([XFile(filePath)]);
                }
                
                emit(state.copyWith(
                  status: DownloadFileStatus.success,
                  filePath: filePath,
                ));
              } else {
                emit(state.copyWith(
                  status: DownloadFileStatus.failure,
                  errorMessage: 'No se pudo encontrar el archivo descargado',
                  failure: const FileDownloadFailure('Archivo no encontrado'),
                ));
              }
            },
          );
        } catch (e) {
          emit(state.copyWith(
            status: DownloadFileStatus.failure,
            errorMessage: 'Error al procesar el archivo: $e',
            failure: FileDownloadFailure(e.toString()),
          ));
        }
      },
    );
  }

  void _onDownloadFileReset(
    DownloadFileReset event,
    Emitter<DownloadFileState> emit,
  ) {
    emit(const DownloadFileState());
  }

  void _onDownloadFileErrorShown(
    DownloadFileErrorShown event,
    Emitter<DownloadFileState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}
