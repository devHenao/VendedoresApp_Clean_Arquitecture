import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'product_detail_widgets.dart';
import 'package:app_vendedores/modules/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:app_vendedores/modules/products/presentation/bloc/product_detail/product_detail_event.dart';
import 'package:app_vendedores/modules/products/presentation/bloc/product_detail/product_detail_state.dart';
import 'package:app_vendedores/app_state.dart';

class ProductDetailWidget extends StatefulWidget {
  const ProductDetailWidget({
    super.key,
    required this.codprecio,
    required this.codproduc,
    required this.cantidad,
    required this.appState,
  });

  final String? codprecio;
  final String? codproduc;
  final double? cantidad;
  final FFAppState appState;

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailBloc(appState: widget.appState)
        ..add(LoadProductDetail(
          codprecio: widget.codprecio!,
          codproduc: widget.codproduc!,
          cantidad: widget.cantidad,
        )),
      child: Align(
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 570.0,
            ),
            decoration: BoxDecoration(
              color: GlobalTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: const Color(0xFFE0E3E7),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductDetailHeader(productDetails: state is ProductDetailLoaded ? state.warehouses : []),
                        if (state is ProductDetailLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (state is ProductDetailError)
                          Center(child: Text(state.message))
                        else if (state is ProductDetailLoaded)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                            child: WarehouseList(
                              warehouses: state.warehouses,
                              onQuantityChanged: (item, quantity) async {
                                context.read<ProductDetailBloc>().add(UpdateQuantity(
                                  item: item.toString(),
                                  quantity: quantity ?? 0,
                                ));
                              },
                              onRemoveFromWarehouse: (item) async {
                                context.read<ProductDetailBloc>().add(RemoveFromWarehouse(
                                  item: item.toString(),
                                ));
                              },
                              onSelectFromWarehouse: (item, selected) async {
                                context.read<ProductDetailBloc>().add(SelectFromWarehouse(
                                  item: item.toString(),
                                  selected: selected,
                                ));
                              },
                            ),
                          ),
                        if (state is! ProductDetailLoading)
                          ProductDetailActions(onClose: () {
                            final quantity = (state is ProductDetailLoaded)
                              ? state.warehouses
                                  .where((item) => item.bodega == widget.appState.infoSeller.storageDefault)
                                  .fold<double>(0, (sum, item) => sum + (item.cantidad ?? 0))
                              : 0.0;
                            Navigator.pop(context, quantity);
                          }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
