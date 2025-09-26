import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String token;
  final String name;
  final String email;

  const User({
    required this.token,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [token, name, email];
}
