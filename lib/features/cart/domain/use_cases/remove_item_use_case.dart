import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/cart/domain/repositories/cart_repository.dart';

class RemoveItemUseCase {
  final CartRepository repository;

  RemoveItemUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemCode) async {
    return await repository.removeItem(itemCode);
  }
}
