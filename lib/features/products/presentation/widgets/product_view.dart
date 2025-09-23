import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/features/products/presentation/bloc/product_bloc.dart';
import 'package:app_vendedores/features/products/presentation/bloc/product_event.dart';
import 'package:app_vendedores/features/products/presentation/bloc/product_state.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              // Assuming the client's codprecio is available from another BLoC or state management solution
              // For now, we'll use a placeholder.
              context.read<ProductBloc>().add(LoadProducts(codprecio: '', filter: value));
            },
            decoration: InputDecoration(
              labelText: 'Buscar por nombre o código',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return const Center(child: Text('No se encontraron productos'));
                }
                return ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ListTile(
                      title: Text(product.descripcio),
                      subtitle: Text(product.codproduc),
                      trailing: Text('\$${product.precio.toStringAsFixed(2)}'),
                      onTap: () {
                        // Handle product selection
                      },
                    );
                  },
                );
              } else if (state is ProductError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Cargando productos...'));
            },
          ),
        ),
      ],
    );
  }
}
