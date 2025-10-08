import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/modules/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/modules/clients/infraestructure/datasources/client_remote_data_source.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/repositories/client_repository.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';
import 'package:app_vendedores/modules/clients/infraestructure/models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AuthRepository authRepository;

  ClientRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.authRepository,
  });

  Future<Either<Failure, T>> _handleNetworkCall<T>(
    Future<T> Function() call, {
    bool requiresNetwork = true,
  }) async {
    if (requiresNetwork) {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure());
      }
    }

    try {
      final result = await call();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on FileDownloadException catch (e) {
      return Left(FileDownloadFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final user = await authRepository.getCurrentUser();
    return user.fold(
      (failure) => throw UnauthorizedException(),
      (user) => user.token,
    );
  }

  @override
  Future<Either<Failure, List<Client>>> getClients() async {
    return _handleNetworkCall(
      () async {
        final token = await _getToken();
        final clients = await remoteDataSource.getClients(token);
        return clients.map((model) => model.toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<Client>>> searchClients(String query) async {
    return _handleNetworkCall(
      () async {
        final token = await _getToken();
        final clients = await remoteDataSource.searchClients(token, query);
        return clients.map((model) => model.toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, Client>> updateClient(Client client) async {
    return _handleNetworkCall(
      () async {
        final token = await _getToken();
        final updatedClient = await remoteDataSource.updateClient(
          token,
          ClientModel.fromEntity(client),
        );
        return updatedClient.toEntity();
      },
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCitiesByDepartment(
      String department) async {
    return _handleNetworkCall(
      () async {
        final token = await _getToken();
        return await remoteDataSource.getCitiesByDepartment(token, department);
      },
    );
  }

  @override
  Future<Either<Failure, String>> downloadFile({
    required String clientId,
    required String token,
    required DownloadType type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _handleNetworkCall(
      () => remoteDataSource.downloadFile(
        clientId: clientId,
        token: token,
        type: type,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getDepartments() async {
    return _handleNetworkCall(
      () async {
        final token = await _getToken();
        return await remoteDataSource.getDepartments(token);
      },
    );
  }
}
