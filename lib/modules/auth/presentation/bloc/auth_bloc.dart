import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/auth/domain/usecases/sign_in_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;

  AuthBloc({required this.signInUseCase}) : super(AuthInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      final failureOrUser = await signInUseCase(Params(
        identification: event.identification,
        email: event.email,
        password: event.password,
      ));
      failureOrUser.fold(
        (failure) => emit(AuthFailure(message: failure.props.first.toString())),
        (user) => emit(AuthSuccess(user: user)),
      );
    });
  }
}
