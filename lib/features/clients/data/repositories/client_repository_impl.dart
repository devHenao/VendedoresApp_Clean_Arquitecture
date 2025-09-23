import 'package:dartz/dartz.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/features/clients/data/datasources/client_remote_data_source.dart';
import 'package:app_vendedores/features/clients/domain/entities/client.dart';
import 'package:app_vendedores/features/clients/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AuthRepository authRepository;

  ClientRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.authRepository,
  });

  @override
  Future<Either<Failure, List<Client>>> getClients() async {
    if (await networkInfo.isConnected) {
      try {
        final userEither = await authRepository.getCurrentUser();
        return userEither.fold(
          (failure) => Left(failure),
          (user) async {
            try {
              final remoteClients = await remoteDataSource.getClients(user.token);
              return Right(remoteClients);
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
