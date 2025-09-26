import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/modules/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/modules/cart/infrastructure/datasources/cart_local_data_source.dart';
import 'package:app_vendedores/modules/cart/infrastructure/datasources/cart_remote_data_source.dart';
import 'package:app_vendedores/modules/cart/infrastructure/models/cart_item_model.dart';
import 'package:app_vendedores/modules/cart/domain/entities/cart_item.dart';
import 'package:app_vendedores/modules/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final AuthRepository authRepository;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.authRepository,
  });

  @override
  Future<Either<Failure, void>> addItem(CartItem item) async {
    try {
      final items = await localDataSource.getCartItems();
      final existingItemIndex = items.indexWhere((i) => i.codigo == item.codigo);
      if (existingItemIndex != -1) {
        items[existingItemIndex] = CartItemModel.fromEntity(item);
      } else {
        items.add(CartItemModel.fromEntity(item));
      }
      await localDataSource.cacheCartItems(items);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.cacheCartItems([]);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> placeOrder(String nit, List<CartItem> items) async {
    if (await networkInfo.isConnected) {
      try {
        final tokenEither = await authRepository.getCurrentUser();
        return tokenEither.fold(
          (failure) => Left(failure),
          (user) async {
            try {
              await remoteDataSource.placeOrder(user.token, nit, items.map((item) => CartItemModel.fromEntity(item)).toList());
              await localDataSource.cacheCartItems([]);
              return const Right(null);
            } on ServerException catch (e) {
              return Left(ServerFailure(e.message));
            }
          },
        );
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(String itemCode) async {
    try {
      final items = await localDataSource.getCartItems();
      items.removeWhere((item) => item.codigo == itemCode);
      await localDataSource.cacheCartItems(items);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateItemQuantity(String itemCode, int quantity) async {
    try {
      final items = await localDataSource.getCartItems();
      final itemIndex = items.indexWhere((item) => item.codigo == itemCode);
      if (itemIndex != -1) {
        final item = items[itemIndex];
        final updatedItem = item.copyWith(cantidad: quantity);
        items[itemIndex] = CartItemModel.fromEntity(updatedItem);
        await localDataSource.cacheCartItems(items);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
