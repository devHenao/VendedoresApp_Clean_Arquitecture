import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

/// Repositorio que define las operaciones disponibles para el manejo de clientes
abstract class ClientRepository {
  /// Obtiene la lista de todos los clientes
  Future<Either<Failure, List<Client>>> getClients();
  
  /// Busca clientes por un término de búsqueda
  Future<Either<Failure, List<Client>>> searchClients(String query);
  
  /// Obtiene un cliente por su NIT
  Future<Either<Failure, Client>> getClientByNit(String nit);
  
  /// Actualiza la información de un cliente
  Future<Either<Failure, Client>> updateClient(Client client);
  
  /// Obtiene la lista de departamentos
  Future<Either<Failure, List<Map<String, dynamic>>>> getDepartments();
  
  /// Obtiene la lista de ciudades por departamento
  Future<Either<Failure, List<Map<String, dynamic>>>> getCitiesByDepartment(String department);
}
