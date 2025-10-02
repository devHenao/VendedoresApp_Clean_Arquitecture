import '../../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'product_detail_widgets.dart';
import 'product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_detail_model.dart';
export 'product_detail_model.dart';

class ProductDetailWidget extends StatefulWidget {
  const ProductDetailWidget({
    super.key,
    required this.codprecio,
    required this.codproduc,
    required this.cantidad,
  });

  final String? codprecio;
  final String? codproduc;
  final double? cantidad;

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget>
    with TickerProviderStateMixin {
  late ProductDetailModel _model;
  late ProductDetailController _controller;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductDetailModel());

    _controller = ProductDetailController(
      codprecio: widget.codprecio!,
      codproduc: widget.codproduc!,
      appState: FFAppState(),
    );
    _controller.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
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
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: const Color(0xFFE0E3E7),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailHeader(productDetails: _controller.warehouses),
                  if (_controller.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_controller.errorMessage != null)
                    Center(child: Text(_controller.errorMessage!))
                  else
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: WarehouseList(
                        warehouses: _controller.warehouses,
                        itemProductDetailModels: _model, // Still needed
                        onQuantityChanged: _controller.handleQuantityChanged,
                        onRemoveFromWarehouse: _controller.handleRemoveFromWarehouse,
                        onSelectFromWarehouse: _controller.handleSelectFromWarehouse,
                      ),
                    ),
                  if (!_controller.isLoading)
                    ProductDetailActions(onClose: () {
                      Navigator.pop(context, _controller.quantityForCallback);
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
