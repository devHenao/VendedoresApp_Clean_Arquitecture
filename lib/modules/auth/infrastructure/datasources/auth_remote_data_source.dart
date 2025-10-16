import 'package:dio/dio.dart';
import 'package:app_vendedores/modules/auth/infrastructure/models/user_model.dart';
import 'package:app_vendedores/core/errors/exceptions.dart';

class LoginResponse {
  final UserModel user;
  final Map<String, dynamic> sellerData;

  const LoginResponse({
    required this.user,
    required this.sellerData,
  });
}

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String identification, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginResponse> login(String identification, String email, String password) async {
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
        final userModel = UserModel.fromJson(response.data['data']);
        return LoginResponse(
          user: userModel,
          sellerData: response.data['data'] as Map<String, dynamic>,
        );
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
