import 'package:dio/dio.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(String token, String codprecio, int pageNumber, int pageSize, String filter);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts(String token, String codprecio, int pageNumber, int pageSize, String filter) async {
    const url = 'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appSeller/products/postListProductByCodPrecio';
    final headers = {'Authorization': 'Bearer $token'};
    final body = {
      'codprecio': codprecio,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'filter': filter,
    };

    try {
      final response = await dio.post(url, data: body, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['data'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException(response.data['data'] ?? 'Error al obtener los productos');
      }
    } catch (e) {
      throw ServerException('Error al conectar con el servidor');
    }
  }
}
