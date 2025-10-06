import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

abstract class UpdateClientState {}

class UpdateClientInitial extends UpdateClientState {}

class UpdateClientLoading extends UpdateClientState {}

class UpdateClientLoaded extends UpdateClientState {
  final Client client;
  final List<String> departments;
  final List<String> cities;
  final String? selectedDepartment;
  final String? selectedCity;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  UpdateClientLoaded({
    required this.client,
    this.departments = const [],
    this.cities = const [],
    this.selectedDepartment,
    this.selectedCity,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  UpdateClientLoaded copyWith({
    Client? client,
    List<String>? departments,
    List<String>? cities,
    String? selectedDepartment,
    String? selectedCity,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UpdateClientLoaded(
      client: client ?? this.client,
      departments: departments ?? this.departments,
      cities: cities ?? this.cities,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedCity: selectedCity ?? this.selectedCity,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class UpdateClientSuccess extends UpdateClientState {}

class UpdateClientError extends UpdateClientState {
  final String message;
  UpdateClientError(this.message);
}
