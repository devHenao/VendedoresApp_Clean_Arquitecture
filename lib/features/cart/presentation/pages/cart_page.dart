import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:app_vendedores/features/cart/presentation/bloc/cart_event.dart';
import 'package:app_vendedores/features/cart/presentation/widgets/cart_view.dart';
import 'package:app_vendedores/injection_container.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<CartBloc>()..add(LoadCart()),
        child: const CartView(),
      ),
    );
  }
}
