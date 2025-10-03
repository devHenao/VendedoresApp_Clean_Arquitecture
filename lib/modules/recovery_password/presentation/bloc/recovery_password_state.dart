part of 'recovery_password_bloc.dart';

enum RecoveryPasswordStatus { initial, loading, success, error }

class RecoveryPasswordState extends Equatable {
  const RecoveryPasswordState({
    this.status = RecoveryPasswordStatus.initial,
    this.errorMessage,
  });

  final RecoveryPasswordStatus status;
  final String? errorMessage;

  RecoveryPasswordState copyWith({
    RecoveryPasswordStatus? status,
    String? errorMessage,
  }) {
    return RecoveryPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
