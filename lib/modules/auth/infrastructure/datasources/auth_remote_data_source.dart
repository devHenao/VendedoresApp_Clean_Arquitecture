import 'package:dio/dio.dart';
import 'package:app_vendedores/modules/auth/infrastructure/models/user_model.dart';
import 'package:app_vendedores/core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String identification, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String identification, String email, String password) async {
    final response = await dio.post(
      'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appAuthSeller/loginSeller',
      data: {
        'identification': identification,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException(response.data['data'] ?? 'Error de servidor');
    }
  }
}
