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
    emit(currentState.copyWith(isSubmitting: true));

    final result = await updateClientUseCase(event.client);
    result.fold(
      (failure) => emit(currentState.copyWith(
        isSubmitting: false,
        errorMessage: failure.toString(),
      )),
      (client) => emit(currentState.copyWith(
        isSubmitting: false,
        isSuccess: true,
        client: client,
      )),
    );
  }

Future<void> _onDepartmentChanged(
  DepartmentChangedEvent event,
  Emitter<UpdateClientState> emit,
) async {
  if (state is! UpdateClientLoaded) return;
  
  final currentState = state as UpdateClientLoaded;

  emit(currentState.copyWith(
    selectedDepartment: event.department,
    cities: [], // Clear cities when department changes
    selectedCityCode: null, // Reset selected city
    isSubmitting: true, // Show loading indicator
  ));

  // Load cities for the selected department
  final citiesResult = await getCitiesByDepartmentUseCase(event.department);
  
  citiesResult.fold(
    (failure) {
      emit(currentState.copyWith(
        errorMessage: 'Error al cargar las ciudades: $failure',
        isSubmitting: false,
      ));
    },
    (citiesMap) {
      // Convert API response to list of city maps with both name and code
      final cities = citiesMap.map<Map<String, String>>((city) => {
        'name': city['nomciud'].toString().toUpperCase(),
        'code': city['codigo'].toString(),
      }).toList();
      
      emit(currentState.copyWith(
        cities: cities,
        isSubmitting: false,
      ));
    },
  );
}
  void _onCityChanged(
    CityChangedEvent event,
    Emitter<UpdateClientState> emit,
  ) {
    if (state is! UpdateClientLoaded) return;
    
    final currentState = state as UpdateClientLoaded;
    
    emit(currentState.copyWith(
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

    if (event.client.nomdpto != null && event.client.nomdpto!.isNotEmpty) {
      final citiesResult = await getCitiesByDepartmentUseCase(event.client.nomdpto!);
      
      citiesResult.fold(
        (l) => [],
        (citiesMap) {
          cities = citiesMap.map<Map<String, String>>((city) => ({
                'name': city['nomciud'].toString().toUpperCase(),
                'code': city['codigo'].toString(),
              })).toList();
          
          // Find the selected city code if we have a city name
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
        selectedDepartment: event.client.nomdpto,
        selectedCityCode: selectedCityCode,
      ));
    }
  }
}
