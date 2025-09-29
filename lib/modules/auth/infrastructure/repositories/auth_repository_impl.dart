import 'package:dartz/dartz.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/modules/auth/infrastructure/datasources/auth_local_data_source.dart';
import 'package:app_vendedores/modules/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'package:app_vendedores/modules/auth/domain/entities/user.dart';
import 'package:app_vendedores/modules/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import 'package:app_vendedores/app_state.dart';
import 'package:app_vendedores/backend/schema/structs/data_seller_struct.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(
      String identification, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(identification, email, password);
        localDataSource.cacheUser(remoteUser);
        await authManager.signIn(
          authenticationToken: remoteUser.token,
          uid: remoteUser.email, // O usa otro identificador único si lo prefieres
        );
        // Actualizar el FFAppState con la información del vendedor
        FFAppState().infoSeller = DataSellerStruct(
          nameVenden: remoteUser.name,
          emailVenden: remoteUser.email,
          // Asegúrate de mapear otros campos si son necesarios
        );
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final localUser = await localDataSource.getLastUser();
      return Right(localUser);
    } on CacheException {
      return const Left(CacheFailure('No user found in cache'));
    }
  }
}
