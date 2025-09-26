import 'package:dio/dio.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/cart/infrastructure/models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<void> placeOrder(String token, String nit, List<CartItemModel> items);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> placeOrder(String token, String nit, List<CartItemModel> items) async {
    const url = 'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appSeller/products/createOrderClient';
    final headers = {'Authorization': 'Bearer $token'};
    final body = {
      'nit': nit,
      'listProducts': items.map((item) => item.toJson()).toList(),
    };

    try {
      final response = await dio.post(url, data: body, options: Options(headers: headers));
      if (response.statusCode != 200) {
        throw ServerException(response.data['data'] ?? 'Error al crear la orden');
      }
    } catch (e) {
      throw ServerException('Error al conectar con el servidor');
    }
  }
}
