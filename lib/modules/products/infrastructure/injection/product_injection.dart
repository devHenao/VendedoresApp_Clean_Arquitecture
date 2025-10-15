import 'package:get_it/get_it.dart';
import 'package:app_vendedores/modules/products/infrastructure/datasources/product_remote_data_source.dart';
import 'package:app_vendedores/modules/products/infrastructure/repositories/product_repository_impl.dart';
import 'package:app_vendedores/modules/products/domain/repositories/product_repository.dart';
import 'package:app_vendedores/modules/products/domain/usecases/get_products_use_case.dart';

final sl = GetIt.instance;

void initProductsDependencies() {
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl()),
  );
}
