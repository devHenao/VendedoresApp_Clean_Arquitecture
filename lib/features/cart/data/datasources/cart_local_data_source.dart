import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_vendedores/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> cacheCartItems(List<CartItemModel> items);
}

const cachedCartItemsKey = 'CACHED_CART_ITEMS';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCartItems() {
    final jsonString = sharedPreferences.getString(cachedCartItemsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((json) => CartItemModel.fromJson(json)).toList(),
      );
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> cacheCartItems(List<CartItemModel> items) {
    return sharedPreferences.setString(
      cachedCartItemsKey,
      json.encode(items.map((item) => item.toJson()).toList()),
    );
  }
}
