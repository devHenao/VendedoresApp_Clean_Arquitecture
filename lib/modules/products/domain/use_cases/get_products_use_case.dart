import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/products/domain/entities/product.dart';
import 'package:app_vendedores/modules/products/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call(Params params) async {
    return await repository.getProducts(params.codprecio, params.pageNumber, params.pageSize, params.filter);
  }
}

class Params extends Equatable {
  final String codprecio;
  final int pageNumber;
  final int pageSize;
  final String filter;

  const Params({
    required this.codprecio,
    required this.pageNumber,
    required this.pageSize,
    required this.filter,
  });

  @override
  List<Object?> get props => [codprecio, pageNumber, pageSize, filter];
}
