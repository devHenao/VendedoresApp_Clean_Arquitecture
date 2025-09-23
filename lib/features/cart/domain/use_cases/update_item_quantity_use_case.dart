import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/cart/domain/repositories/cart_repository.dart';

class UpdateItemQuantityUseCase {
  final CartRepository repository;

  UpdateItemQuantityUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemCode, int quantity) async {
    return await repository.updateItemQuantity(itemCode, quantity);
  }
}
