import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import 'package:app_vendedores/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:app_vendedores/modules/cart/presentation/bloc/cart_event.dart';
import 'package:app_vendedores/modules/cart/presentation/widgets/cart_view.dart';
import 'package:app_vendedores/shared/menu/menu_widgets.dart';
import 'package:app_vendedores/injection_container.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
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
      body: BlocProvider(
        create: (_) => getIt<CartBloc>()..add(LoadCart()),
        child: const CartView(),
      ),
    );
  }
}
