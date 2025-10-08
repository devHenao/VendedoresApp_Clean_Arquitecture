import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'modules/auth/infrastructure/datasources/auth_local_data_source.dart';
import 'modules/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'modules/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'modules/auth/domain/repositories/auth_repository.dart';
import 'modules/auth/domain/usecases/sign_in_use_case.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';
import 'modules/cart/infrastructure/datasources/cart_local_data_source.dart';
import 'modules/cart/infrastructure/datasources/cart_remote_data_source.dart';
import 'modules/cart/infrastructure/repositories/cart_repository_impl.dart';
import 'modules/cart/domain/repositories/cart_repository.dart';
import 'modules/cart/domain/usecases/cart_use_cases.dart';
import 'modules/cart/presentation/bloc/cart_bloc.dart';
import 'modules/clients/infraestructure/datasources/client_remote_data_source.dart';
import 'modules/clients/infraestructure/repositories/client_repository_impl.dart';
import 'modules/clients/domain/repositories/client_repository.dart';
import 'modules/clients/domain/usecases/client_use_cases.dart';
import 'modules/clients/presentation/bloc/client_bloc.dart';
import 'modules/clients/presentation/bloc/download_file/download_file_bloc.dart';
import 'modules/products/infrastructure/datasources/product_remote_data_source.dart';
import 'modules/products/infrastructure/repositories/product_repository_impl.dart';
import 'modules/products/domain/repositories/product_repository.dart';
import 'modules/products/domain/usecases/get_products_use_case.dart';
import 'modules/products/presentation/bloc/product_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Blocs
  getIt.registerFactory(() => AuthBloc(
        signInUseCase: getIt(),
        prefs: getIt<SharedPreferences>(),
      ));
  getIt.registerFactory(() => CartBloc(
        getCartItemsUseCase: getIt(),
        addItemUseCase: getIt(),
        removeItemUseCase: getIt(),
        updateItemQuantityUseCase: getIt(),
        clearCartUseCase: getIt(),
        placeOrderUseCase: getIt(),
      ));
  getIt.registerFactory(() => ClientBloc(
        getClientsUseCase: getIt(),
        searchClientsUseCase: getIt(),
        updateClientUseCase: getIt(),
        getDepartmentsUseCase: getIt(),
        getCitiesByDepartmentUseCase: getIt(),
      ));
      
  getIt.registerFactory(() => DownloadFileBloc(
        downloadClientFile: getIt(),
        networkInfo: getIt(),
        authRepository: getIt(),
      ));
  getIt.registerFactory(() => ProductBloc(
        getProductsUseCase: getIt(),
      ));

  // Use cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  
  // Cart Use Cases
  getIt.registerLazySingleton(() => GetCartItemsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddItemUseCase(getIt()));
  getIt.registerLazySingleton(() => RemoveItemUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateItemQuantityUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearCartUseCase(getIt()));
  getIt.registerLazySingleton(() => PlaceOrderUseCase(getIt()));
  // Client Use Cases
  getIt.registerLazySingleton(() => GetClientsUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchClientsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateClientUseCase(getIt()));
  getIt.registerLazySingleton(() => GetDepartmentsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCitiesByDepartmentUseCase(getIt()));
  getIt.registerLazySingleton(() => DownloadClientFileUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));

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

  getIt.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
      authRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt(),
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

  getIt.registerLazySingleton<ClientRemoteDataSource>(
    () => ClientRemoteDataSourceImpl(dio: getIt()),
  );
  
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  getIt.registerLazySingleton(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(milliseconds: 15000);
    dio.options.receiveTimeout = const Duration(milliseconds: 15000);
    dio.options.sendTimeout = const Duration(milliseconds: 15000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });
  getIt.registerLazySingleton(() => InternetConnection());
}

