import 'package:dartz/dartz.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/products/infrastructure/datasources/product_remote_data_source.dart';
import 'package:app_vendedores/modules/products/domain/entities/product.dart';
import 'package:app_vendedores/modules/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts(String token, String vendedor, int pageNumber, int pageSize, String filter) async {
    try {
      final productModels = await remoteDataSource.getProducts(token, vendedor, pageNumber, pageSize, filter);
      final products = productModels.map((model) => Product(
        codproduc: model.codproduc,
        precio: model.precio,
        descripcio: model.descripcio,
        descuento1: model.descuento1,
        descuento2: model.descuento2,
        saldo: model.saldo,
        unidadmed: model.unidadmed,
        codbarras: model.codbarras,
        codtariva: model.codtariva,
        iva: model.iva,
        selected: model.selected,
        cantidad: model.cantidad,
      )).toList();

      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
