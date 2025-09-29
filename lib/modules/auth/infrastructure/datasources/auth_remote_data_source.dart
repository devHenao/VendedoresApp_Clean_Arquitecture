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
    try {
      final response = await dio.post(
        'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appAuthSeller/loginSeller',
        data: {
          'identification': identification,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['data'] ?? 'Error de servidor');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error de red');
    } catch (e) {
      throw ServerException('Ocurrió un error inesperado: ${e.toString()}');
    }
  }
}
