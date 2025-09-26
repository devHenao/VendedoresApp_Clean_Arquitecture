import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_state.dart';
import 'package:app_vendedores/modules/auth/presentation/widgets/login_form.dart';
import 'package:go_router/go_router.dart';
import 'package:app_vendedores/injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<AuthBloc>(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              GoRouter.of(context).goNamed('Clientes');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
            }
          },
          child: const LoginForm(),
        ),
      ),
    );
  }
}
