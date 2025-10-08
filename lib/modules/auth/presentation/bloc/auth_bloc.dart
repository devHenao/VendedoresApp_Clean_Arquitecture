import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_vendedores/modules/auth/domain/usecases/sign_in_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SharedPreferences prefs;

  static const String _keyEmail = 'remembered_email';
  static const String _keyPassword = 'remembered_password';
  static const String _keyRememberMe = 'remember_me';

  AuthBloc({required this.signInUseCase, required this.prefs}) : super(AuthInitial()) {
    _checkSavedCredentials();
    
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      
      try {
        final result = await signInUseCase(Params(
          identification: event.identification,
          email: event.email,
          password: event.password,
        ));
        
        return result.fold(
          (failure) => emit(AuthFailure(message: failure.props.first.toString())),
          (user) async {
            if (event.rememberMe) {
              await prefs.setString(_keyEmail, event.email);
              await prefs.setString(_keyPassword, event.password);
              await prefs.setBool(_keyRememberMe, true);
            } else {
              await prefs.remove(_keyEmail);
              await prefs.remove(_keyPassword);
              await prefs.setBool(_keyRememberMe, false);
            }
            emit(AuthSuccess(user: user));
          },
        );
      } catch (e) {
        emit(AuthFailure(message: 'Error during login: $e'));
      }
    });
  }

  Future<void> _checkSavedCredentials() async {
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
    if (rememberMe) {
      final email = prefs.getString(_keyEmail) ?? '';
      final password = prefs.getString(_keyPassword) ?? '';
      
      if (email.isNotEmpty && password.isNotEmpty) {
      }
    }
  }
  
  Future<void> clearCredentials() async {
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.setBool(_keyRememberMe, false);
  }
}
