import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/core/network/network_info.dart';
import 'package:app_vendedores/modules/auth/domain/repositories/auth_repository.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:app_vendedores/modules/clients/domain/models/client_model.dart';

import '../../domain/repositories/client_repository.dart';
import '../datasources/client_remote_data_source.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;
  final NetworkInfo networkInfo;

  ClientRepositoryImpl(
      {required this.remoteDataSource,
      required this.networkInfo,
      required this.authRepository});

  Future<String> _getToken() async {
    final user = await authRepository.getCurrentUser();
    return user.fold(
        (failure) => throw UnauthorizedException(), (user) => user.token);
  }

  @override
  Future<void> updateClient(Client client) async {
    try {
      final token = await _getToken();
      // Since ClientModel extends Client, we can directly cast if the runtime type is ClientModel
      // or create a new ClientModel from the Client's properties
      final clientModel = client is ClientModel 
          ? client 
          : ClientModel.fromEntity(client);
      await remoteDataSource.updateClient(token, clientModel);
    } catch (e) {
      throw Exception('Failed to update client: $e');
    }
  }

  @override
  Future<List<String>> getDepartments() async {
    try {
      final token = await _getToken();
      final departments = await remoteDataSource.getDepartments(token);
      
      // Extraer el nombre de manera segura de cada departamento
      return departments.map<String>((dept) {
        try {
          final name = dept['name'];
          if (name == null) return '';
          return name.toString();
        } catch (e) {
          return '';
        }
      }).where((name) => name.isNotEmpty).toList();
    } catch (e) {
      print('Error en getDepartments: $e');
      throw Exception('Error al cargar los departamentos: $e');
    }
  }

  @override
  Future<List<String>> getCities(String department) async {
    try {
      if (department.isEmpty) return [];
      
      final token = await _getToken();
      final cities = await remoteDataSource.getCitiesByDepartment(token, department);
      
      // Extraer el nombre de manera segura de cada ciudad
      return cities.map<String>((city) {
        try {
          final name = city['name'];
          if (name == null) return '';
          return name.toString();
        } catch (e) {
          return '';
        }
      }).where((name) => name.isNotEmpty).toList();
    } catch (e) {
      print('Error en getCities: $e');
      throw Exception('Error al cargar las ciudades: $e');
    }
  }
}
