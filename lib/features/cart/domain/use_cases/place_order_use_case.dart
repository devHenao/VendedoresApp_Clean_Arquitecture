import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/cart/domain/entities/cart_item.dart';
import 'package:app_vendedores/features/cart/domain/repositories/cart_repository.dart';

class PlaceOrderUseCase {
  final CartRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(String nit, List<CartItem> items) async {
    return await repository.placeOrder(nit, items);
  }
}
