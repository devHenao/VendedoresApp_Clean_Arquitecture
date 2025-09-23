import 'package:app_vendedores/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String token,
    required String name,
    required String email,
  }) : super(token: token, name: name, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['data']['token'],
      name: json['data']['nombre'],
      email: json['data']['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'nombre': name,
      'email': email,
    };
  }
}
