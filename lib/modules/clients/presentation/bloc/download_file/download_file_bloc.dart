import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:app_vendedores/modules/clients/domain/usecases/client_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              try {
                // Primero emitir éxito sin verificar la existencia del archivo
                // ya que sabemos que se descargó correctamente
                emit(state.copyWith(
                  status: DownloadFileStatus.success,
                  filePath: filePath,
                ));
                
                // Intentar abrir el archivo en segundo plano
                _tryOpenFile(filePath);
              } catch (e) {
                log('Error inesperado: $e', name: 'DownloadFileBloc');
                // No emitir error aquí para no mostrar mensaje de error al usuario
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

  Future<void> _tryOpenFile(String filePath) async {
    try {
      final file = File(filePath);
      bool exists = await file.exists();
      
      // Si el archivo no existe, esperar un momento y volver a intentar
      if (!exists) {
        await Future.delayed(const Duration(milliseconds: 500));
        exists = await file.exists();
      }
      
      if (exists) {
        final result = await OpenFile.open(filePath);
        
        if (result.type != ResultType.done) {
          // Si no se pudo abrir, ofrecer opción de compartir
          await Share.shareXFiles([XFile(filePath)]);
        }
      }
    } catch (e) {
      log('Error al abrir el archivo: $e', name: 'DownloadFileBloc');
    }
  }

  void _onDownloadFileErrorShown(
    DownloadFileErrorShown event,
    Emitter<DownloadFileState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}
