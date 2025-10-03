part of 'recovery_password_bloc.dart';

abstract class RecoveryPasswordEvent extends Equatable {
  const RecoveryPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordRequested extends RecoveryPasswordEvent {
  const ResetPasswordRequested({required this.nit, required this.email});

  final String nit;
  final String email;

  @override
  List<Object> get props => [nit, email];
}
