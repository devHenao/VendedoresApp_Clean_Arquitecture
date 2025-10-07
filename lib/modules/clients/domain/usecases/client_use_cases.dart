import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/repositories/client_repository.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';

class GetClientsUseCase {
  final ClientRepository repository;

  GetClientsUseCase(this.repository);

  Future<Either<Failure, List<Client>>> call() async {
    return await repository.getClients();
  }
}

class SearchClientsUseCase {
  final ClientRepository repository;

  SearchClientsUseCase(this.repository);

  Future<Either<Failure, List<Client>>> call(String query) async {
    return await repository.searchClients(query);
  }
}

class UpdateClientUseCase {
  final ClientRepository repository;

  UpdateClientUseCase(this.repository);

  Future<Either<Failure, Client>> call(Client client) async {
    return await repository.updateClient(client);
  }
}

class GetDepartmentsUseCase {
  final ClientRepository repository;

  GetDepartmentsUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await repository.getDepartments();
  }
}

class GetCitiesByDepartmentUseCase {
  final ClientRepository repository;

  GetCitiesByDepartmentUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(String department) async {
    return await repository.getCitiesByDepartment(department);
  }
}

class DownloadClientFileUseCase {
  final ClientRepository repository;

  DownloadClientFileUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String clientId,
    required String token,
    required DownloadType type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.downloadFile(
      clientId: clientId,
      token: token,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }
}