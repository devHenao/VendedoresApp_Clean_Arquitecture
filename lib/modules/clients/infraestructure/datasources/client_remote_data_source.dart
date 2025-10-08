import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/clients/infraestructure/models/client_model.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';

abstract class ClientRemoteDataSource {
  Future<List<ClientModel>> getClients(String token);
  Future<List<ClientModel>> searchClients(String token, String query);
  Future<ClientModel> getClientByNit(String token, String nit);
  Future<ClientModel> updateClient(String token, ClientModel client);
  Future<List<Map<String, dynamic>>> getDepartments(String token);
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(
      String token, String department);
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
        return clientList
            .map((json) => ClientModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
            response.data['data'] ?? 'Error al obtener los clientes');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? 'Error al conectar con el servidor');
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
        return clientList
            .map((json) => ClientModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
            response.data['message'] ?? 'Error al buscar clientes');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? 'Error al buscar clientes');
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
        throw ServerException(
            response.data['message'] ?? 'Error al obtener el cliente');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data?['message'] ?? 'Error al obtener el cliente');
    }
  }

  @override
  Future<ClientModel> updateClient(String token, ClientModel client) async {
    const url = '$baseUrl/clients/updateClientByNit';
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
      final response = await dio.get(url, options: options);

      if (response.statusCode == 200) {
        if (response.data is! Map<String, dynamic>) {
          throw const FormatException('Formato de respuesta inválido');
        }

        if (response.data['error'] != null) {
          throw ServerException(response.data['error'].toString());
        }

        if (response.data['data'] == null) {
          throw const FormatException(
              'No se encontraron datos de departamentos');
        }

        if (response.data['data'] is! List) {
          throw const FormatException(
              'Formato de datos de departamentos inválido');
        }

        final List<dynamic> departmentsData = response.data['data'];

        final result = departmentsData.map<Map<String, dynamic>>((dept) {
          if (dept is Map<String, dynamic>) {
            return dept;
          } else if (dept is String) {
            return {'name': dept};
          }
          return {'name': dept?.toString() ?? 'Departamento desconocido'};
        }).toList();

        return result;
      } else {
        final errorMessage = response.data is Map
            ? response.data['message'] ?? 'Error al obtener los departamentos'
            : 'Error al obtener los departamentos (${response.statusCode})';
        throw ServerException(errorMessage.toString());
      }
    } on DioException catch (e) {

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
      throw ServerException('Error inesperado al obtener los departamentos');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCitiesByDepartment(
      String token, String department) async {
    const url = '$baseUrlMaster/getListCities';
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    final data = jsonEncode({'nomdpto': department});

    try {

      final response = await dio.post(
        url,
        data: data,
        options: options,
      );

      if (response.statusCode == 200) {
        if (response.data is! Map<String, dynamic>) {
          throw const FormatException('Formato de respuesta inválido');
        }

        if (response.data['error'] != null) {
          throw ServerException(response.data['error'].toString());
        }

        if (response.data['data'] == null) {
          throw const FormatException('No se encontraron datos de ciudades');
        }

        if (response.data['data'] is! List) {
          throw const FormatException('Formato de datos de ciudades inválido');
        }

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

      String errorMessage = 'Error al obtener las ciudades';
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
      throw ServerException('Error inesperado al obtener las ciudades: $e');
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
    try {
      String endpoint;
      final params = <String, dynamic>{};

      switch (type) {
        case DownloadType.wallet:
          endpoint = '/clients/getWalletClient';
          break;
        case DownloadType.orders:
          endpoint = '/clients/getOrderClient';
          if (startDate != null) {
            params['startDate'] =
                '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
          }
          if (endDate != null) {
            params['endDate'] =
                '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
          }
          break;
        case DownloadType.sales:
          endpoint = '/clients/getLastSalesClient';
          if (startDate != null) {
            params['startDate'] =
                '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
          }
          if (endDate != null) {
            params['endDate'] =
                '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
          }
          break;
      }

      final url = '$baseUrl$endpoint/$clientId';
      final uri = Uri.parse(url)
          .replace(queryParameters: params.isNotEmpty ? params : null);

      final response = await dio.get(
        uri.toString(),
        options: Options(
          headers: _getHeaders(token),
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      final bytes = response.data as List<int>;

      if (response.statusCode == 200) {
        String extension = 'pdf'; 
        final contentType =
            response.headers.value('content-type')?.toLowerCase() ?? '';

        if (contentType.contains('excel') ||
            contentType.contains('spreadsheet')) {
          extension = 'xlsx';
        }
        final fileName =
            '${type.toString().split('.').last}_${DateTime.now().millisecondsSinceEpoch}.$extension';

        if (Platform.isAndroid) {
          const methodChannel =
              MethodChannel('com.mycompany.appvendedores/media_store');
          try {
            final mimeType = extension == 'pdf'
                ? 'application/pdf'
                : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

            final savedFilePath =
                await methodChannel.invokeMethod<String>('saveFile', {
              'fileBytes': bytes,
              'fileName': fileName,
              'mimeType': mimeType,
            });

            if (savedFilePath == null) {
              throw Exception(
                  'No se pudo guardar el archivo en el almacenamiento externo');
            }
            return savedFilePath;
          } catch (e) {
            throw ServerException('Error al guardar el archivo: $e');
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$fileName';
          await File(filePath).writeAsBytes(bytes);
          return filePath;
        } else {
          throw ServerException('Plataforma no soportada');
        }
      } else if (response.statusCode == 400) {
        throw ServerException(
            'No se encontraron datos para generar el reporte');
      } else {
        throw ServerException(
            'Error al descargar el archivo (${response.statusCode})');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error de conexión');
    } catch (e) {
      throw ServerException('Error inesperado: $e');
    }
  }
}
