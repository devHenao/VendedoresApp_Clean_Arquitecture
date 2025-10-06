import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/repositories/client_repository.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';

/// Caso de uso para obtener todos los clientes
class GetClientsUseCase {
  final ClientRepository repository;

  GetClientsUseCase(this.repository);

  Future<Either<Failure, List<Client>>> call() async {
    return await repository.getClients();
  }
}

/// Caso de uso para buscar clientes por un término de búsqueda
class SearchClientsUseCase {
  final ClientRepository repository;

  SearchClientsUseCase(this.repository);

  Future<Either<Failure, List<Client>>> call(String query) async {
    return await repository.searchClients(query);
  }
}

/// Caso de uso para actualizar la información de un cliente
class UpdateClientUseCase {
  final ClientRepository repository;

  UpdateClientUseCase(this.repository);

  Future<Either<Failure, Client>> call(Client client) async {
    return await repository.updateClient(client);
  }
}

/// Caso de uso para obtener la lista de departamentos
class GetDepartmentsUseCase {
  final ClientRepository repository;

  GetDepartmentsUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await repository.getDepartments();
  }
}

/// Caso de uso para obtener las ciudades de un departamento
class GetCitiesByDepartmentUseCase {
  final ClientRepository repository;

  GetCitiesByDepartmentUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(String department) async {
    return await repository.getCitiesByDepartment(department);
  }
}

/// Caso de uso para descargar un archivo de un cliente
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