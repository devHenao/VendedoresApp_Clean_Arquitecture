import 'package:dartz/dartz.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/features/products/data/datasources/product_remote_data_source.dart';
import 'package:app_vendedores/features/products/domain/entities/product.dart';
import 'package:app_vendedores/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AuthRepository authRepository;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.authRepository,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts(String codprecio, int pageNumber, int pageSize, String filter) async {
    if (await networkInfo.isConnected) {
      try {
        final userEither = await authRepository.getCurrentUser();
        return userEither.fold(
          (failure) => Left(failure),
          (user) async {
            try {
              final remoteProducts = await remoteDataSource.getProducts(user.token, codprecio, pageNumber, pageSize, filter);
              return Right(remoteProducts);
            } on ServerException catch (e) {
              return Left(ServerFailure(e.message));
            }
          },
        );
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }
}
