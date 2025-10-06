import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

class ClientService {
  Client? _selectedClient;

  Client? get selectedClient => _selectedClient;

  bool get hasSelectedClient => _selectedClient != null;

  void setSelectedClient(Client client) {
    _selectedClient = client;
  }

  void clearSelectedClient() {
    _selectedClient = null;
  }
}
