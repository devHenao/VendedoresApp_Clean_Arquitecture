import 'dart:async';

import 'package:dio/dio.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/clients/infraestructure/models/client_model.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';

abstract class ClientRemoteDataSource {
  Future<List<ClientModel>> getClients(String token);
  Future<List<ClientModel>> searchClients(String token, String query);
  Future<ClientModel> getClientByNit(String token, String nit);
  Future<ClientModel> updateClient(String token, ClientModel client);
  Future<List<Map<String, dynamic>>> getDepartments(String token);
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(String token, String department);
  Future<String> downloadFile({
    required String clientId,
    required String token,
    required DownloadType type,
    DateTime? startDate,
    DateTime? endDate,
  });
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
    const url = '$baseUrl/clients/getListClientByVenden';
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
      throw ServerException(e.response?.data?['message'] ?? 'Error al obtener los departamentos');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(String token, String department) async {
    const url = '$baseUrl/maestras/ciudades';
    final options = Options(headers: _getHeaders(token));
    final data = {'departamento': department};

    try {
      final response = await dio.post(url, data: data, options: options);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw ServerException('Error al obtener las ciudades');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message'] ?? 'Error al obtener las ciudades');
    }
  }

  @override
  Future<String> downloadFile({
    required String clientId,
    required String token,
    required DownloadType type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    String endpoint;
    final data = {'clientId': clientId};

    switch (type) {
      case DownloadType.wallet:
        endpoint = '/reports/wallet';
        break;
      case DownloadType.orders:
        endpoint = '/reports/orders';
        if (startDate != null) data['startDate'] = startDate.toIso8601String();
        if (endDate != null) data['endDate'] = endDate.toIso8601String();
        break;
      case DownloadType.sales:
        endpoint = '/reports/sales';
        if (startDate != null) data['startDate'] = startDate.toIso8601String();
        if (endDate != null) data['endDate'] = endDate.toIso8601String();
        break;
    }

    final url = '$baseUrl$endpoint';
    final options = Options(
      headers: _getHeaders(token),
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout: const Duration(minutes: 5),
    );

    try {
      final response = await dio.post(
        url,
        data: data,
        options: options,
      );

      if (response.statusCode == 200) {
        // Aquí deberías manejar la respuesta binaria del archivo
        // Por ahora, solo devolvemos un mensaje de éxito
        return 'Archivo descargado exitosamente';
      } else {
        throw ServerException(response.data?['message'] ?? 'Error al descargar el archivo');
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message'] ?? 'Error al conectar con el servidor');
    }
  }
}
