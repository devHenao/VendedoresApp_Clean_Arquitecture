import 'package:dartz/dartz.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/features/clients/data/datasources/client_remote_data_source.dart';
import 'package:app_vendedores/features/clients/domain/entities/client.dart';
import 'package:app_vendedores/features/clients/domain/repositories/client_repository.dart';
import 'package:app_vendedores/features/clients/data/models/client_model.dart';

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
    return _handleNetworkCall<List<Client>>(
      () async {
        final token = await _getToken();
        final clients = await remoteDataSource.getClients(token);
        return clients.map((model) => model.toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<Client>>> searchClients(String query) async {
    return _handleNetworkCall<List<Client>>(
      () async {
        final token = await _getToken();
        final clients = await remoteDataSource.searchClients(token, query);
        return clients.map((model) => model.toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, Client>> getClientByNit(String nit) async {
    return _handleNetworkCall<Client>(
      () async {
        final token = await _getToken();
        final client = await remoteDataSource.getClientByNit(token, nit);
        return client.toEntity();
      },
    );
  }

  @override
  Future<Either<Failure, Client>> updateClient(Client client) async {
    return _handleNetworkCall<Client>(
      () async {
        final token = await _getToken();
        final clientModel = ClientModel.fromEntity(client);
        final updatedClient = await remoteDataSource.updateClient(token, clientModel);
        return updatedClient.toEntity();
      },
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getDepartments() async {
    return _handleNetworkCall<List<Map<String, dynamic>>>(
      () async {
        final token = await _getToken();
        return await remoteDataSource.getDepartments(token);
      },
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCitiesByDepartment(String department) async {
    return _handleNetworkCall<List<Map<String, dynamic>>>(
      () async {
        final token = await _getToken();
        return await remoteDataSource.getCitiesByDepartment(token, department);
      },
    );
  }

  // Helper method to handle network calls and error handling
  Future<Either<Failure, T>> _handleNetworkCall<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return const Left(ServerFailure('No hay conexión a internet'));
    }

    try {
      final userEither = await authRepository.getCurrentUser();
      return userEither.fold(
        (failure) => Left(failure),
        (_) async {
          try {
            final result = await call();
            return Right(result);
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          } catch (e) {
            return Left(ServerFailure('Error inesperado: $e'));
          }
        },
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  // Helper method to get authentication token
  Future<String> _getToken() async {
    final userEither = await authRepository.getCurrentUser();
    return userEither.fold(
      (failure) => throw ServerException(failure.toString()),
      (user) => user.token,
    );
  }
}
