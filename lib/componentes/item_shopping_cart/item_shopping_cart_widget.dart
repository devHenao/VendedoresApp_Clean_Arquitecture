import 'package:app_vendedores/features/cart/domain/entities/cart_item.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'item_shopping_cart_model.dart';
import 'item_shopping_cart_widgets.dart'; 
export 'item_shopping_cart_model.dart';

class ItemShoppingCartWidget extends StatefulWidget {
  const ItemShoppingCartWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  State<ItemShoppingCartWidget> createState() => _ItemShoppingCartWidgetState();
}

class _ItemShoppingCartWidgetState extends State<ItemShoppingCartWidget> {
  late ItemShoppingCartModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemShoppingCartModel());

    _model.amountCartTextController ??= TextEditingController(text: widget.item.cantidad.toString());
    _model.amountCartFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHeader(item: widget.item),
                  ProductDetails(item: widget.item, model: _model),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ItemActions(onRemove: widget.onRemove),
                        Expanded(
                          child: QuantityControls(
                            item: widget.item,
                            onQuantityChanged: widget.onQuantityChanged,
                            controller: _model.amountCartTextController!,
                            focusNode: _model.amountCartFocusNode!,
                            validator: _model.amountCartTextControllerValidator.asValidator(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ].divide(const SizedBox(height: 10.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
