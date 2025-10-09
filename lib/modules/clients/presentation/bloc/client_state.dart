import 'package:equatable/equatable.dart';
import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

abstract class ClientState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const ClientState({
    required this.startDate,
    required this.endDate,
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
       
  DateTime getEffectiveStartDate() => startDate;
  
  DateTime getEffectiveEndDate() => endDate;
  
  @override
  List<Object> get props => [startDate, endDate];
}

class ClientInitial extends ClientState {
  ClientInitial() : super(
    startDate: ClientState.firstDayOfMonth,
    endDate: ClientState.lastDayOfMonth,
  );
}

class ClientLoading extends ClientState {
  ClientLoading({DateTime? startDate, DateTime? endDate}) : super(
    startDate: startDate ?? ClientState.firstDayOfMonth,
    endDate: endDate ?? ClientState.lastDayOfMonth,
  );
}

class ClientLoaded extends ClientState {
  final List<Client> clients;
  final bool isLoading;

  ClientLoaded({
    required this.clients,
    DateTime? startDate,
    DateTime? endDate,
    this.isLoading = false,
  }) : super(
    startDate: startDate ?? ClientState.firstDayOfMonth,
    endDate: endDate ?? ClientState.lastDayOfMonth,
  );
  
  @override
  List<Object> get props => [...super.props, clients, isLoading];
  
  ClientLoaded copyWith({
    List<Client>? clients,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLoading,
  }) {
    return ClientLoaded(
      clients: clients ?? this.clients,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ClientUpdated extends ClientState {
  final Client client;

  ClientUpdated({required this.client}) : super(
    startDate: ClientState.firstDayOfMonth,
    endDate: ClientState.lastDayOfMonth,
  );

  @override
  List<Object> get props => [...super.props, client];
}

class DepartmentsLoaded extends ClientState {
  final List<String> departments;

  DepartmentsLoaded({required this.departments}) : super(
    startDate: ClientState.firstDayOfMonth,
    endDate: ClientState.lastDayOfMonth,
  );

  @override
  List<Object> get props => [...super.props, ...departments];
}

class CitiesLoaded extends ClientState {
  final List<Map<String, String>> cities;

  CitiesLoaded({
    required this.cities,
    DateTime? startDate,
    DateTime? endDate,
  }) : super(
    startDate: startDate ?? ClientState.firstDayOfMonth,
    endDate: endDate ?? ClientState.lastDayOfMonth,
  );

  @override
  List<Object> get props => [...super.props, ...cities];
}

class ClientError extends ClientState {
  final String message;
  final List<Client>? cachedClients;

  ClientError({
    required this.message, 
    this.cachedClients,
    DateTime? startDate,
    DateTime? endDate,
  }) : super(
    startDate: startDate ?? ClientState.firstDayOfMonth,
    endDate: endDate ?? ClientState.lastDayOfMonth,
  );

  @override
  List<Object> get props => [
        message, 
        ...?cachedClients, 
        startDate, 
        endDate
      ];

  @override
  bool get stringify => true;
}
