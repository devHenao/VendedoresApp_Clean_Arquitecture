import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/clients/domain/models/client_model.dart';

abstract class ClientRemoteDataSource {
  Future<void> updateClient(String token, ClientModel client);
  Future<List<Map<String, dynamic>>> getDepartments(String token);
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(
      String token, String department);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final Dio dio;
  static const String baseUrl =
      'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appSeller';

  static const String baseUrlMaster =
      'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appMaster';

  ClientRemoteDataSourceImpl({required this.dio});

  Map<String, String> _getHeaders(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

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
        throw ServerException(
            response.data['message'] ?? 'Error al actualizar el cliente');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? 'Error al actualizar el cliente');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDepartments(String token) async {
    const url = '$baseUrlMaster/getListDepto';
    final options = Options(headers: _getHeaders(token));

    try {
      print('Solicitando lista de departamentos...');
      final response = await dio.get(url, options: options);

      print('Respuesta de departamentos (raw): ${response.data}');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Verificar si la respuesta tiene la estructura esperada
        if (response.data is! Map<String, dynamic>) {
          throw const FormatException('Formato de respuesta inválido');
        }

        // Verificar si hay un error en la respuesta
        if (response.data['error'] != null) {
          throw ServerException(response.data['error'].toString());
        }

        // Verificar si existe la propiedad 'data' y es una lista
        if (response.data['data'] == null) {
          throw const FormatException(
              'No se encontraron datos de departamentos');
        }

        if (response.data['data'] is! List) {
          throw const FormatException(
              'Formato de datos de departamentos inválido');
        }

        // Convertir la respuesta a una lista de mapas
        final List<dynamic> departmentsData = response.data['data'];

        final result = departmentsData.map<Map<String, dynamic>>((dept) {
          if (dept is Map<String, dynamic>) {
            return dept;
          } else if (dept is String) {
            return {'name': dept};
          }
          return {'name': dept?.toString() ?? 'Departamento desconocido'};
        }).toList();

        print('Departamentos procesados: $result');
        return result;
      } else {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? 'Error al obtener los departamentos'
            : 'Error al obtener los departamentos (${response.statusCode})';
        throw ServerException(errorMessage.toString());
      }
    } on DioException catch (e) {
      print('Error en getDepartments: ${e.message}');
      print('Datos de error: ${e.response?.data}');

      String errorMessage = 'Error al obtener los departamentos';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage =
              e.response!.data['message']?.toString() ?? errorMessage;
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      throw ServerException(errorMessage);
    } catch (e) {
      print('Error inesperado en getDepartments: $e');
      throw ServerException('Error inesperado al obtener los departamentos');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(
      String token, String department) async {
    final url = '$baseUrlMaster/getListCities';
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    
    // Usando el mismo formato que en la versión que funcionaba
    final data = jsonEncode({'nomdpto': department});

    try {
      print('Solicitando ciudades para departamento: $department');
      print('URL: $url');
      print('Headers: ${options.headers}');
      print('Body: $data');

      final response = await dio.post(
        url,
        data: data,
        options: options,
      );

      print('Respuesta de ciudades: ${response.data}');

      if (response.statusCode == 200) {
        // Verificar si la respuesta tiene la estructura esperada
        if (response.data is! Map<String, dynamic>) {
          throw const FormatException('Formato de respuesta inválido');
        }

        // Verificar si hay un error en la respuesta
        if (response.data['error'] != null) {
          throw ServerException(response.data['error'].toString());
        }

        // Verificar si existe la propiedad 'data' y es una lista
        if (response.data['data'] == null) {
          throw const FormatException('No se encontraron datos de ciudades');
        }

        if (response.data['data'] is! List) {
          throw const FormatException('Formato de datos de ciudades inválido');
        }

        // Convertir la respuesta a una lista de mapas
        final List<dynamic> citiesData = response.data['data'];

        return citiesData.map<Map<String, dynamic>>((city) {
          if (city is Map<String, dynamic>) {
            return city;
          } else if (city is String) {
            return {'name': city};
          }
          return {'name': city?.toString() ?? 'Ciudad desconocida'};
        }).toList();
      } else {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? 'Error al obtener las ciudades'
            : 'Error al obtener las ciudades (${response.statusCode})';
        throw ServerException(errorMessage.toString());
      }
    } on DioException catch (e) {
      print('Error en getCitiesByDepartment: ${e.message}');
      print('Datos de error: ${e.response?.data}');
      print('Request: ${e.requestOptions.data}');
      print('Headers: ${e.requestOptions.headers}');

      String errorMessage = 'Error al obtener las ciudades';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message']?.toString() ?? errorMessage;
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      throw ServerException(errorMessage);
    } catch (e) {
      print('Error inesperado en getCitiesByDepartment: $e');
      throw ServerException('Error inesperado al obtener las ciudades: $e');
    }
  }



}
