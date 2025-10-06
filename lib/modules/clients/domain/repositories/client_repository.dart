import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/enums/download_type.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
  
  Future<Either<Failure, List<Client>>> searchClients(String query);
  
  Future<Either<Failure, Client>> getClientByNit(String nit);
  
  Future<Either<Failure, Client>> updateClient(Client client);
  
  Future<Either<Failure, List<Map<String, dynamic>>>> getDepartments();
  
  Future<Either<Failure, String>> downloadFile({
    required String clientId,
    required String token,
    required DownloadType type,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  Future<Either<Failure, List<Map<String, dynamic>>>> getCitiesByDepartment(String department);
}
