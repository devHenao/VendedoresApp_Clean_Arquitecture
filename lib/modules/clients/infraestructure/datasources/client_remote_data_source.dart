import 'package:dio/dio.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/clients/infraestructure/models/client_model.dart';

abstract class ClientRemoteDataSource {
  Future<List<ClientModel>> getClients(String token);
  Future<List<ClientModel>> searchClients(String token, String query);
  Future<ClientModel> getClientByNit(String token, String nit);
  Future<ClientModel> updateClient(String token, ClientModel client);
  Future<List<Map<String, dynamic>>> getDepartments(String token);
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(String token, String department);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appSeller';

  ClientRemoteDataSourceImpl({required this.dio});

  Map<String, String> _getHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  @override
  Future<List<ClientModel>> getClients(String token) async {
    const url = '$baseUrl/clients/listClientByVenden';
    final options = Options(headers: _getHeaders(token));

    try {
      final response = await dio.get(url, options: options);
      if (response.statusCode == 200) {
        final dynamic data = response.data['data'];
        List<dynamic> clientList;
        if (data is List) {
          clientList = data;
        } else if (data is Map) {
          clientList = data.values.toList();
        } else {
          throw ServerException('Formato de datos de clientes inesperado');
        }
        return clientList.map((json) => ClientModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(response.data['data'] ?? 'Error al obtener los clientes');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message'] ?? 'Error al conectar con el servidor');
    }
  }

  @override
  Future<List<ClientModel>> searchClients(String token, String query) async {
    const url = '$baseUrl/clients/search';
    final options = Options(headers: _getHeaders(token));
    final data = {'query': query};

    try {
      final response = await dio.post(url, data: data, options: options);
      if (response.statusCode == 200) {
        final dynamic data = response.data['data'];
        List<dynamic> clientList;
        if (data is List) {
          clientList = data;
        } else if (data is Map) {
          clientList = data.values.toList();
        } else {
          throw ServerException('Formato de datos de búsqueda inesperado');
        }
        return clientList.map((json) => ClientModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(response.data['message'] ?? 'Error al buscar clientes');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message'] ?? 'Error al buscar clientes');
    }
  }

  @override
  Future<ClientModel> getClientByNit(String token, String nit) async {
    final url = '$baseUrl/clients/$nit';
    final options = Options(headers: _getHeaders(token));

    try {
      final response = await dio.get(url, options: options);
      if (response.statusCode == 200) {
        return ClientModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Error al obtener el cliente');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message'] ?? 'Error al obtener el cliente');
    }
  }

  @override
  Future<ClientModel> updateClient(String token, ClientModel client) async {
    final url = '$baseUrl/clients/${client.nit}';
    final options = Options(headers: _getHeaders(token));
    final data = client.toJson();

    try {
      final response = await dio.put(url, data: data, options: options);
      if (response.statusCode == 200) {
        return ClientModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Error al actualizar el cliente');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message'] ?? 'Error al actualizar el cliente');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDepartments(String token) async {
    const url = '$baseUrl/maestras/departamentos';
    final options = Options(headers: _getHeaders(token));

    try {
      final response = await dio.get(url, options: options);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw ServerException('Error al obtener los departamentos');
      }
    } on DioException catch (e) {
      throw ServerException('Error al obtener los departamentos');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(String token, String department) async {
    const url = '$baseUrl/maestras/ciudades';
    final options = Options(headers: _getHeaders(token));
    final params = {'departamento': department};

    try {
      final response = await dio.get(url, queryParameters: params, options: options);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw ServerException('Error al obtener las ciudades');
      }
    } on DioException catch (e) {
      throw ServerException('Error al obtener las ciudades');
    }
  }
}
