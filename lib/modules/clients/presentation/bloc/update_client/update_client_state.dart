import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

abstract class UpdateClientState {}

class UpdateClientInitial extends UpdateClientState {}

class UpdateClientLoading extends UpdateClientState {}

class UpdateClientLoaded extends UpdateClientState {
  final Client client;
  final List<String> departments;
  final List<Map<String, String>> cities; // Store both name and code
  final String? selectedDepartment;
  final String? selectedCityCode; // Store the selected city code
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  UpdateClientLoaded({
    required this.client,
    this.departments = const [],
    this.cities = const [],
    this.selectedDepartment,
    this.selectedCityCode,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  // Helper getter to get the selected city name
  String? get selectedCityName {
    if (selectedCityCode == null) return null;
    try {
      return cities.firstWhere(
        (city) => city['code'] == selectedCityCode,
        orElse: () => {'name': ''},
      )['name'];
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        client,
        departments,
        cities,
        selectedDepartment,
        selectedCityCode,
        isSubmitting,
        isSuccess,
        errorMessage,
      ];

  UpdateClientLoaded copyWith({
    Client? client,
    List<String>? departments,
    List<Map<String, String>>? cities,
    String? selectedDepartment,
    String? selectedCityCode,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UpdateClientLoaded(
      client: client ?? this.client,
      departments: departments ?? this.departments,
      cities: cities ?? this.cities,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedCityCode: selectedCityCode ?? this.selectedCityCode,
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
