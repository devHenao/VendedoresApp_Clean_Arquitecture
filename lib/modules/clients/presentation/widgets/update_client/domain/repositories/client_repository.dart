// lib/modules/clients/domain/repositories/client_repository.dart

import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

abstract class ClientRepository {
  // Future<Client> getClient(String id);

  Future<void> updateClient(Client client);

  Future<List<String>> getDepartments();
  
  Future<List<String>> getCities(String department);
}