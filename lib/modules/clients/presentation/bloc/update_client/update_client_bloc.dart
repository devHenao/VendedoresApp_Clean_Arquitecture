import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/usecases/client_use_cases.dart';
import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/update_client/update_client_state.dart';

class UpdateClientBloc extends Bloc<UpdateClientEvent, UpdateClientState> {
  final UpdateClientUseCase updateClientUseCase;
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final GetCitiesByDepartmentUseCase getCitiesByDepartmentUseCase;

  UpdateClientBloc({
    required this.updateClientUseCase,
    required this.getDepartmentsUseCase,
    required this.getCitiesByDepartmentUseCase,
  }) : super(UpdateClientInitial()) {
    on<UpdateClientSubmittedEvent>(_onUpdateClient);
    on<DepartmentChangedEvent>(_onDepartmentChanged);
    on<CityChangedEvent>(_onCityChanged);
    on<SetClientEvent>(_onSetClient);
  }

  Future<void> _onUpdateClient(
    UpdateClientSubmittedEvent event,
    Emitter<UpdateClientState> emit,
  ) async {
    if (state is! UpdateClientLoaded) return;

    final currentState = state as UpdateClientLoaded;
    
    // Create a new client with the updated cdciiu from the current state
    final clientToUpdate = event.client.copyWith(
      cdciiu: currentState.selectedCityCode,
      nomciud: currentState.selectedCityName,
      nomdpto: currentState.selectedDepartment,
    );
    
    emit(currentState.copyWith(isSubmitting: true));

    final result = await updateClientUseCase(clientToUpdate);
    result.fold(
      (failure) => emit(currentState.copyWith(
        isSubmitting: false,
        errorMessage: failure.toString(),
      )),
      (updatedClient) => emit(currentState.copyWith(
        isSubmitting: false,
        isSuccess: true,
        client: updatedClient,
      )),
    );
  }

  Future<void> _onDepartmentChanged(
    DepartmentChangedEvent event,
    Emitter<UpdateClientState> emit,
  ) async {
    if (state is! UpdateClientLoaded) return;

    final currentState = state as UpdateClientLoaded;
    
    final updatedClient = currentState.client.copyWith(
      nomdpto: event.department,
      nomciud: null, 
    );

    emit(currentState.copyWith(
      client: updatedClient,
      selectedDepartment: event.department,
      cities: [],
      selectedCityCode: null,
      isLoadingCities: true,
    ));

    try {
      final citiesResult = await getCitiesByDepartmentUseCase(event.department);

      citiesResult.fold(
        (failure) {
          emit(currentState.copyWith(
            client: updatedClient,
            selectedDepartment: event.department,
            cities: [],
            selectedCityCode: null,
            errorMessage: 'Error al cargar las ciudades: $failure',
            isLoadingCities: false,
          ));
        },
        (citiesMap) {
          final cities = citiesMap
              .map<Map<String, String>>((city) => {
                    'name': city['nomciud'].toString().toUpperCase(),
                    'code': city['codigo'].toString(),
                  })
              .toList();

          emit(currentState.copyWith(
            client: updatedClient,
            selectedDepartment: event.department,
            cities: cities,
            isLoadingCities: false,
          ));
        },
      );
    } catch (e) {
      emit(currentState.copyWith(
        client: updatedClient,
        selectedDepartment: event.department,
        errorMessage: 'Error inesperado al cargar las ciudades: $e',
        isLoadingCities: false,
      ));
    }
  }

  void _onCityChanged(
    CityChangedEvent event,
    Emitter<UpdateClientState> emit,
  ) {
    if (state is! UpdateClientLoaded) return;

    final currentState = state as UpdateClientLoaded;
    
    // Find the selected city from the cities list
    final selectedCity = currentState.cities.firstWhere(
      (city) => city['code'] == event.cityCode,
      orElse: () => {'name': '', 'code': ''},
    );
    
    // Update the client with the new city and cdciiu
    final updatedClient = currentState.client.copyWith(
      nomciud: selectedCity['name'],
      cdciiu: event.cityCode, // This is the important part - set cdciiu to the city code
    );

    emit(currentState.copyWith(
      client: updatedClient,
      selectedCityCode: event.cityCode,
    ));
  }

  Future<void> _onSetClient(
    SetClientEvent event,
    Emitter<UpdateClientState> emit,
  ) async {
    emit(UpdateClientLoading());

    final departmentsResult = await getDepartmentsUseCase();

    if (departmentsResult.isLeft()) {
      final failure = departmentsResult.getOrElse(() => []) as Failure;
      emit(UpdateClientError('Error al cargar los departamentos: $failure'));
      return;
    }

    final departmentsData = departmentsResult.getOrElse(() => []);

    final List<String> departments = (departmentsData as List)
        .where((d) => d is Map && d['nomdpto'] != null)
        .map<String>((d) => d['nomdpto'].toString())
        .toList();

    List<Map<String, String>> cities = [];
    String? selectedCityCode;
    String? selectedDepartment = event.client.nomdpto;

    // If client has a cdciiu, use it to find the correct city and department
    if (event.client.cdciiu != null && event.client.cdciiu!.isNotEmpty) {
      // Load all departments to find the correct one
      for (final dept in departments) {
        final citiesResult = await getCitiesByDepartmentUseCase(dept);
        
        await citiesResult.fold(
          (l) => null,
          (citiesMap) async {
            final deptCities = citiesMap
                .map<Map<String, String>>((city) => ({
                      'name': city['nomciud'].toString().toUpperCase(),
                      'code': city['codigo'].toString(),
                    }))
                .toList();

            // Try to find the city by cdciiu
            try {
              final city = deptCities.firstWhere(
                (city) => city['code'] == event.client.cdciiu,
              );
              
              selectedCityCode = city['code'];
              selectedDepartment = dept;
              cities = deptCities;
            } catch (e) {
              // City not found in this department, continue to next department
            }
          },
        );
        
        // If we found the city, no need to check other departments
        if (selectedCityCode != null) break;
      }
    } 
    // Fall back to the old method if cdciiu is not set or city not found
    else if (selectedDepartment != null && selectedDepartment.isNotEmpty) {
      final citiesResult = await getCitiesByDepartmentUseCase(selectedDepartment);

      await citiesResult.fold(
        (l) => null,
        (citiesMap) {
          cities = citiesMap
              .map<Map<String, String>>((city) => ({
                    'name': city['nomciud'].toString().toUpperCase(),
                    'code': city['codigo'].toString(),
                  }))
              .toList();

          if (event.client.nomciud != null && event.client.nomciud!.isNotEmpty) {
            try {
              final selectedCity = cities.firstWhere(
                (city) => city['name'] == event.client.nomciud,
              );
              selectedCityCode = selectedCity['code'];
            } catch (e) {
              selectedCityCode = null;
            }
          }
        },
      );
    }

    if (!emit.isDone) {
      emit(UpdateClientLoaded(
        client: event.client,
        departments: departments,
        cities: cities,
        selectedDepartment: selectedDepartment,
        selectedCityCode: selectedCityCode,
      ));
    }
  }
}
