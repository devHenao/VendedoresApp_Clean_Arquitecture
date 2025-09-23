import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/use_cases/sign_in_use_case.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/datasources/cart_remote_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/use_cases/add_item_use_case.dart';
import 'features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'features/cart/domain/use_cases/get_cart_items_use_case.dart';
import 'features/cart/domain/use_cases/place_order_use_case.dart';
import 'features/cart/domain/use_cases/remove_item_use_case.dart';
import 'features/cart/domain/use_cases/update_item_quantity_use_case.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Blocs
  getIt.registerFactory(() => AuthBloc(signInUseCase: getIt()));
  getIt.registerFactory(() => CartBloc(
        getCartItemsUseCase: getIt(),
        addItemUseCase: getIt(),
        removeItemUseCase: getIt(),
        updateItemQuantityUseCase: getIt(),
        clearCartUseCase: getIt(),
        placeOrderUseCase: getIt(),
      ));

  // Use cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddItemUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveItemUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateItemQuantityUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearCartUseCase(getIt()));
  getIt.registerLazySingleton(() => PlaceOrderUseCase(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
      authRepository: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(dio: getIt()),
  );
  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => InternetConnection());
}
