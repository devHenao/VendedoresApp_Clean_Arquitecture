import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/products/presentation/bloc/product_bloc.dart';
import 'package:app_vendedores/modules/products/presentation/bloc/product_event.dart';
import 'package:app_vendedores/modules/products/presentation/widgets/product_view.dart';
import 'package:app_vendedores/injection_container.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<ProductBloc>()..add(const LoadProducts(codprecio: '')),
        child: const ProductView(),
      ),
    );
  }
}
