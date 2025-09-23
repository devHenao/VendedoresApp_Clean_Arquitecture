import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/cart/domain/entities/cart_item.dart';
import 'package:app_vendedores/features/cart/domain/repositories/cart_repository.dart';

class AddItemUseCase {
  final CartRepository repository;

  AddItemUseCase(this.repository);

  Future<Either<Failure, void>> call(CartItem item) async {
    return await repository.addItem(item);
  }
}
