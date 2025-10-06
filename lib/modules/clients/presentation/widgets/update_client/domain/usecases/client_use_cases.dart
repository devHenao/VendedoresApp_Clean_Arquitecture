import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import '../repositories/client_repository.dart';

// class GetClientUseCase {
//   final ClientRepository repository;

//   GetClientUseCase(this.repository);

//   Future<Client> call(String id) async {
//     return await repository.getClient(id);
//   }
// }


class UpdateClientUseCase {
  final ClientRepository repository;

  UpdateClientUseCase(this.repository);

  Future<void> call(Client client) async {
    return await repository.updateClient(client);
  }
}

class GetDepartmentsUseCase {
  final ClientRepository repository;

  GetDepartmentsUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getDepartments();
  }
}

class GetCitiesUseCase {
  final ClientRepository repository;

  GetCitiesUseCase(this.repository);

  Future<List<String>> call(String department) async {
    return await repository.getCities(department);
  }
}