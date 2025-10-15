import 'package:dio/dio.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/products/infrastructure/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(String token, String vendedor, int pageNumber, int pageSize, String filter);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts(String token, String vendedor, int pageNumber, int pageSize, String filter) async {
    const baseUrl = 'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appSeller';
    final url = '$baseUrl/products/getListProductByCodPrecio/$vendedor';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final requestBody = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'filters': [
        {
          'type': 'like',
          'field': 'descripcio',
          'valueFilter': filter,
        },
        {
          'type': 'like',
          'field': 'codproduc',
          'valueFilter': filter,
        },
        {
          'type': '==',
          'field': 'codbarras',
          'valueFilter': filter,
        },
      ],
    };

    try {
      final response = await dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        if (responseData is Map && responseData.containsKey('data')) {
          final List<dynamic> productsList = responseData['data'];
          return productsList.map((json) => ProductModel.fromJson(json)).toList();
        } else {
          throw ServerException('Formato de respuesta inesperado del servidor');
        }
      } else {
        throw ServerException(response.data['message'] ?? 'Error al obtener los productos');
      }
    } catch (e) {
      throw ServerException('Error al conectar con el servidor: $e');
    }
  }
}
