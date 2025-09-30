import 'package:equatable/equatable.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

abstract class ClientState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Client> originalClients;
  final bool isFiltered;

  const ClientState({
    this.startDate,
    this.endDate,
    required this.originalClients,
    this.isFiltered = false,
  });
       
  static DateTime get firstDayOfMonth => _firstDayOfMonth();
  static DateTime get lastDayOfMonth => _lastDayOfMonth();
  
  static DateTime _firstDayOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }
  
  static DateTime _lastDayOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0);
  }

  List<Client> get clients {
    if (!isFiltered || (startDate == null && endDate == null)) {
      return originalClients;
    }
    // Si no hay fechas de filtrado, devolver todos los clientes
    if (startDate == null && endDate == null) {
      return originalClients;
    }
    
    // Filtrar clientes basado en las fechas si están disponibles
    return originalClients.where((client) {
      // Como no tenemos una fecha de creación, siempre devolvemos true
      // para que no se filtre ningún cliente por fecha
      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [startDate, endDate, originalClients, isFiltered];
}

class ClientInitial extends ClientState {
  ClientInitial() : super(
    startDate: null,
    endDate: null,
    originalClients: const [],
    isFiltered: false,
  );
}

class ClientLoading extends ClientState {
  ClientLoading({
    DateTime? startDate, 
    DateTime? endDate,
    List<Client> clients = const [],
    bool isFiltered = false,
  }) : super(
    startDate: startDate,
    endDate: endDate,
    originalClients: clients,
    isFiltered: isFiltered,
  );
}

class ClientLoaded extends ClientState {
  const ClientLoaded({
    required List<Client> clients,
    DateTime? startDate,
    DateTime? endDate,
    bool isFiltered = false,
  }) : super(
    startDate: startDate,
    endDate: endDate,
    originalClients: clients,
    isFiltered: isFiltered,
  );
  
  @override
  List<Object?> get props => [
    ...super.props, 
    startDate, 
    endDate, 
    originalClients, 
    isFiltered
  ];
  
  ClientLoaded copyWith({
    List<Client>? clients,
    DateTime? startDate,
    DateTime? endDate,
    bool? isFiltered,
  }) {
    return ClientLoaded(
      clients: clients ?? originalClients,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isFiltered: isFiltered ?? this.isFiltered,
    );
  }
}

class ClientUpdated extends ClientState {
  final Client client;

  ClientUpdated({required this.client}) : super(
    startDate: null,
    endDate: null,
    originalClients: const [],
    isFiltered: false,
  );
  
  @override
  List<Object?> get props => [client, ...super.props];
}

class DepartmentsLoaded extends ClientState {
  final List<String> departments;

  DepartmentsLoaded({required this.departments}) : super(
    startDate: null,
    endDate: null,
    originalClients: const [],
    isFiltered: false,
  );

  @override
  List<Object?> get props => [departments, ...super.props];
}

class CitiesLoaded extends ClientState {
  final List<Map<String, dynamic>> cities;

  CitiesLoaded({
    required this.cities,
    DateTime? startDate,
    DateTime? endDate,
  }) : super(
    startDate: startDate,
    endDate: endDate,
    originalClients: const [],
    isFiltered: false,
  );

  @override
  List<Object?> get props => [cities, ...super.props];
}
class ClientError extends ClientState {
  final String message;

  ClientError({required this.message}) : super(
    startDate: null,
    endDate: null,
    originalClients: const [],
    isFiltered: false,
  );

  @override
  List<Object?> get props => [message, ...super.props];
}
