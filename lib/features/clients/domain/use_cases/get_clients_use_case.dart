import 'package:dartz/dartz.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/clients/domain/entities/client.dart';
import 'package:app_vendedores/features/clients/domain/repositories/client_repository.dart';

class GetClientsUseCase {
  final ClientRepository repository;

  GetClientsUseCase(this.repository);

  Future<Either<Failure, List<Client>>> call() async {
    return await repository.getClients();
  }
}
