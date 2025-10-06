import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import 'package:app_vendedores/modules/clients/domain/repositories/client_repository.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_event.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/download_file/download_file_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/update_client/presentation/bloc/update_client_bloc.dart';
import 'package:app_vendedores/modules/clients/domain/usecases/client_use_cases.dart';
import 'package:app_vendedores/modules/clients/presentation/widgets/client_view.dart';
import 'package:app_vendedores/shared/menu/menu_widgets.dart';
import 'package:app_vendedores/injection_container.dart';

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
              if (context.mounted) {
                GoRouter.of(context).go('/');
              }
            }),
            const SizedBox(height: 20),
            const MenuFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          final repository = getIt<ClientRepository>();
          
          final updateClientUseCase = UpdateClientUseCase(repository);
          final getDepartmentsUseCase = GetDepartmentsUseCase(repository);
          final getCitiesByDepartmentUseCase = GetCitiesByDepartmentUseCase(repository);
          
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<ClientBloc>()..add(LoadClients()),
              ),
              BlocProvider(
                create: (_) => getIt<DownloadFileBloc>(),
              ),
              BlocProvider(
                create: (_) => UpdateClientBloc(
                  updateClientUseCase: updateClientUseCase,
                  getDepartmentsUseCase: getDepartmentsUseCase,
                  getCitiesByDepartmentUseCase: getCitiesByDepartmentUseCase,
                ),
              ),
            ],
            child: const ClientView(),
          );
        },
      ),
    );
  }
}
