import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/reset_password.dart';

part 'recovery_password_event.dart';
part 'recovery_password_state.dart';

class RecoveryPasswordBloc extends Bloc<RecoveryPasswordEvent, RecoveryPasswordState> {
  RecoveryPasswordBloc({required ResetPassword resetPassword}) 
      : _resetPassword = resetPassword,
        super(const RecoveryPasswordState()) {
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  final ResetPassword _resetPassword;

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<RecoveryPasswordState> emit,
  ) async {
    emit(state.copyWith(status: RecoveryPasswordStatus.loading));
    try {
      await _resetPassword(nit: event.nit, email: event.email);
      emit(state.copyWith(status: RecoveryPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(status: RecoveryPasswordStatus.error, errorMessage: e.toString()));
    }
  }
}
