import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addItem(CartItem item);
  Future<Either<Failure, void>> removeItem(String itemCode);
  Future<Either<Failure, void>> updateItemQuantity(String itemCode, int quantity);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, void>> placeOrder(String nit, List<CartItem> items);
}
