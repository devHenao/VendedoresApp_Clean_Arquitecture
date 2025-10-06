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
      cities: [],
      selectedCity: null,
      isSubmitting: true, // Para mostrar un indicador de carga
    ));

    final citiesResult = await getCitiesByDepartmentUseCase(event.department);
    citiesResult.fold(
      (failure) => emit(currentState.copyWith(
        errorMessage: 'Error al cargar las ciudades: $failure',
        isSubmitting: false,
      )),
      (citiesMap) {
        final cities = citiesMap.map((c) => c['name'].toString()).toList();
        if (state is UpdateClientLoaded) {
          emit((state as UpdateClientLoaded).copyWith(cities: cities, isSubmitting: false));
        }
      },
    );
  }

  void _onCityChanged(
    CityChangedEvent event,
    Emitter<UpdateClientState> emit,
  ) {
    if (state is! UpdateClientLoaded) return;
    final currentState = state as UpdateClientLoaded;

    emit(currentState.copyWith(selectedCity: event.city));
  }

  Future<void> _onSetClient(
    SetClientEvent event,
    Emitter<UpdateClientState> emit,
  ) async {
    emit(UpdateClientLoading());

    final departmentsResult = await getDepartmentsUseCase();

    // Manejar el caso de fallo para los departamentos
    if (departmentsResult.isLeft()) {
      final failure = departmentsResult.getOrElse(() => []) as Failure;
      emit(UpdateClientError('Error al cargar los departamentos: $failure'));
      return;
    }

    final departmentsMap = departmentsResult.getOrElse(() => []);
    final departments = departmentsMap.map((d) => d['name'].toString()).toList();
    List<String> cities = [];

    // Si hay un departamento, cargar las ciudades
    if (event.client.nomdpto != null && event.client.nomdpto!.isNotEmpty) {
      final citiesResult = await getCitiesByDepartmentUseCase(event.client.nomdpto!);
      // No es necesario manejar el fallo aquí, si falla, la lista de ciudades quedará vacía
      cities = citiesResult.fold(
        (l) => [],
        (r) => r.map((c) => c['name'].toString()).toList(),
      );
    }

    // Si el emitter sigue activo, emitir el estado final
    if (!emit.isDone) {
      emit(UpdateClientLoaded(
        client: event.client,
        departments: departments,
        cities: cities,
        selectedDepartment: event.client.nomdpto,
        selectedCity: event.client.nomciud,
      ));
    }
  }
}
