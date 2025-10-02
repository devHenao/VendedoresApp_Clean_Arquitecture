import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/cart/presentation/widgets/item_shopping_cart/item_shopping_cart_widget.dart';
import 'package:app_vendedores/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:app_vendedores/modules/cart/presentation/bloc/cart_event.dart';
import 'package:app_vendedores/modules/cart/presentation/bloc/cart_state.dart';
import 'package:app_vendedores/core/theme/theme.dart';
import 'package:app_vendedores/flutter_flow/flutter_flow_widgets.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is OrderPlacementSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido realizado con éxito')),
          );
        } else if (state is OrderPlacementFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al realizar el pedido: ${state.message}')),
          );
        } else if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error en el carrito: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is CartLoading || state is CartInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartLoaded) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/17568902.png', width: 200),
                  const SizedBox(height: 16),
                  const Text('No tienes productos agregados'),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mi carrito', style: FlutterFlowTheme.of(context).headlineMedium),
                    Text('Total: \$${state.total.toStringAsFixed(2)}', style: FlutterFlowTheme.of(context).titleMedium),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return ItemShoppingCartWidget(
                      key: ValueKey(item.codigo),
                      item: item,
                      onQuantityChanged: (newQuantity) {
                        context.read<CartBloc>().add(UpdateItemQuantity(item.codigo, newQuantity));
                      },
                      onRemove: () {
                        context.read<CartBloc>().add(RemoveItem(item.codigo));
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FFButtonWidget(
                      onPressed: () {
                        // This needs access to client NIT, which should be managed by another BLoC
                        // For now, we'll dispatch the event, but a proper implementation needs the NIT
                        // final clientState = context.read<ClientBloc>().state;
                        // if (clientState is ClientLoaded) {
                        //   context.read<CartBloc>().add(PlaceOrder(clientState.client.nit));
                        // }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funcionalidad de pedido pendiente de implementación de cliente.')),
                        );
                      },
                      text: 'Realizar pedido',
                      options: FFButtonOptions(
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Manrope',
                              color: Colors.white,
                            ),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        context.read<CartBloc>().add(ClearCart());
                      },
                      text: 'Cancelar pedido',
                      options: FFButtonOptions(
                        color: FlutterFlowTheme.of(context).error,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Manrope',
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('Algo salió mal.'));
      },
    );
  }

}
