import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/domain/usecases/client_use_cases.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_state.dart';

class UpdateClientBloc extends Bloc<UpdateClientEvent, UpdateClientState> {
  final UpdateClientUseCase updateClientUseCase;
  final GetDepartmentsUseCase getDepartmentsUseCase;
  final GetCitiesUseCase getCitiesUseCase;

  UpdateClientBloc({
    required this.updateClientUseCase,
    required this.getDepartmentsUseCase,
    required this.getCitiesUseCase,
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
    
    try {
      await updateClientUseCase(event.client);
      emit(currentState.copyWith(
        isSubmitting: false,
        isSuccess: true,
        client: event.client, // Actualizar el cliente en el estado
      ));
    } catch (e) {
      emit(currentState.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      ));
      
      // Re-emitir el estado anterior para mantener los datos
      emit(currentState.copyWith(
        isSubmitting: false,
      ));
    }
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
    ));

    try {
      final cities = await getCitiesUseCase(event.department);
      if (state is UpdateClientLoaded) {
        emit((state as UpdateClientLoaded).copyWith(cities: cities));
      }
    } catch (e) {
      emit(currentState.copyWith(
        errorMessage: 'Error al cargar las ciudades: $e',
      ));
    }
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
    try {
      final departments = await getDepartmentsUseCase();
      
      emit(UpdateClientLoaded(
        client: event.client,
        departments: departments,
        selectedDepartment: event.client.nomdpto,
      ));

      if (event.client.nomdpto != null) {
        final cities = await getCitiesUseCase(event.client.nomdpto!);
        if (state is UpdateClientLoaded) {
          emit((state as UpdateClientLoaded).copyWith(
            cities: cities,
            selectedCity: event.client.nomciud,
          ));
        }
      }
    } catch (e) {
      emit(UpdateClientError('Error al cargar los datos: $e'));
    }
  }
}
