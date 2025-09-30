import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/client_view.dart';
import 'package:app_vendedores/injection_container.dart';
import 'package:app_vendedores/shared/menu/menu_widgets.dart';
import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import 'package:go_router/go_router.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const MenuHeader(),
            const MenuItems(),
            const Spacer(),
            MenuActions(onSignOut: () async {
              await authManager.signOut();
              // ignore: use_build_context_synchronously
              context.goNamed('Login');
            }),
            const SizedBox(height: 20),
            const MenuFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => getIt<ClientBloc>()..add(LoadClients()),
        child: const ClientView(),
      ),
    );
  }
}
