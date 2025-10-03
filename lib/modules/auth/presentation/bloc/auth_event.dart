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
  final bool rememberMe;

  const LoginButtonPressed({
    required this.identification,
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object> get props => [identification, email, password, rememberMe];
}
