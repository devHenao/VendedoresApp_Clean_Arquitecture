import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/clients/domain/entities/client.dart';

abstract class ClientRepository {
  Future<Either<Failure, List<Client>>> getClients();
}
