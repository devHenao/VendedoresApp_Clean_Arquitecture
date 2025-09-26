import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/clients/domain/entities/client.dart';
import 'package:app_vendedores/features/clients/domain/repositories/client_repository.dart';

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

/// Caso de uso para obtener un cliente por su NIT
class GetClientByNitUseCase {
  final ClientRepository repository;

  GetClientByNitUseCase(this.repository);

  Future<Either<Failure, Client>> call(String nit) async {
    return await repository.getClientByNit(nit);
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
