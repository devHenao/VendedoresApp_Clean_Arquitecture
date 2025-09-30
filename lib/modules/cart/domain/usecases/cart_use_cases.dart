import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/cart/domain/entities/cart_item.dart';
import 'package:app_vendedores/modules/cart/domain/repositories/cart_repository.dart';

/// Caso de uso para obtener los ítems del carrito
class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call() async {
    return await repository.getCartItems();
  }
}

/// Caso de uso para agregar un ítem al carrito
class AddItemUseCase {
  final CartRepository repository;

  AddItemUseCase(this.repository);

  Future<Either<Failure, void>> call(CartItem item) async {
    return await repository.addItem(item);
  }
}

/// Caso de uso para eliminar un ítem del carrito
class RemoveItemUseCase {
  final CartRepository repository;

  RemoveItemUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemCode) async {
    return await repository.removeItem(itemCode);
  }
}

/// Caso de uso para actualizar la cantidad de un ítem en el carrito
class UpdateItemQuantityUseCase {
  final CartRepository repository;

  UpdateItemQuantityUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemCode, int quantity) async {
    return await repository.updateItemQuantity(itemCode, quantity);
  }
}

/// Caso de uso para vaciar el carrito
class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearCart();
  }
}

/// Caso de uso para realizar el pedido
class PlaceOrderUseCase {
  final CartRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(String nit, List<CartItem> items) async {
    return await repository.placeOrder(nit, items);
  }
}
