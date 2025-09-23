import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/features/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/features/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/features/clients/presentation/widgets/client_view.dart';
import 'package:app_vendedores/injection_container.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<ClientBloc>()..add(LoadClients()),
        child: const ClientView(),
      ),
    );
  }
}
