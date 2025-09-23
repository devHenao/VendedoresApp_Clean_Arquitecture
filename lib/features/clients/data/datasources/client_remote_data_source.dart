import 'package:dio/dio.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/features/clients/data/models/client_model.dart';

abstract class ClientRemoteDataSource {
  Future<List<ClientModel>> getClients(String token);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final Dio dio;

  ClientRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ClientModel>> getClients(String token) async {
    final url = 'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appSeller/clients/listClientByVenden';
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await dio.get(url, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ClientModel.fromJson(json)).toList();
      } else {
        throw ServerException(response.data['data'] ?? 'Error al obtener los clientes');
      }
    } catch (e) {
      throw ServerException('Error al conectar con el servidor');
    }
  }
}
