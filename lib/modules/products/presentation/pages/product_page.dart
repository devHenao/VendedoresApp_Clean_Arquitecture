import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import 'package:app_vendedores/modules/products/presentation/widgets/product_view.dart';
import 'package:app_vendedores/shared/menu/menu_widgets.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_bloc.dart';
import 'package:app_vendedores/modules/clients/presentation/bloc/client_state.dart';

class ProductPage extends StatelessWidget {
  final String codprecio;
  
  const ProductPage({
    super.key, 
    this.codprecio = '',
  });

  @override
  Widget build(BuildContext context) {
    String effectiveCodPrecio = codprecio;
    try {
      if (effectiveCodPrecio.isEmpty) {
        final state = context.read<ClientBloc>().state;
        if (state is ClientLoaded && state.selectedClientNit != null && state.selectedClientNit!.isNotEmpty) {
          final selectedNit = state.selectedClientNit!;
          final selectedList = state.clients.where((c) => c.nit == selectedNit);
          if (selectedList.isNotEmpty) {
            effectiveCodPrecio = selectedList.first.codprecio ?? '';
          }
        }
      }
    } catch (_) {}
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
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
      body: ProductView(codprecio: effectiveCodPrecio),
    );
  }
}
