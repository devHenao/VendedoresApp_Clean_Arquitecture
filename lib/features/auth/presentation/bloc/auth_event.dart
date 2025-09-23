import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends AuthEvent {
  final String identification;
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.identification,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [identification, email, password];
}
