import 'package:app_vendedores/modules/cart/domain/entities/cart_item.dart';
import '../../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'item_shopping_cart_model.dart';
import 'item_shopping_cart_widgets.dart';
import 'item_shopping_cart_controller.dart';
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
  late ItemShoppingCartController _controller;
  late TextEditingController _textController;
  late ItemShoppingCartModel _model; // Still needed for validator

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemShoppingCartModel());

    _controller = ItemShoppingCartController(
      item: widget.item,
      onQuantityChanged: widget.onQuantityChanged,
      onRemove: widget.onRemove,
    );

    _textController = TextEditingController();
    _controller.addListener(_onControllerUpdate);

    // Set initial text
    _textController.text = _controller.quantity.toString();
  }

  void _onControllerUpdate() {
    if (!mounted) return;

    final controllerValue = _controller.quantity.toString();
    if (_textController.text != controllerValue) {
      _textController.text = controllerValue;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _textController.dispose();
    _model.dispose();
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
            color: GlobalTheme.of(context).secondaryBackground,
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
                        ItemActions(onRemove: _controller.remove),
                        Expanded(
                          child: QuantityControls(
                            onIncrement: _controller.increment,
                            onDecrement: _controller.decrement,
                            onQuantityChangedFromText: _controller.updateQuantityFromText,
                            controller: _textController,
                            focusNode: _model.amountCartFocusNode!, // Re-using from old model
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
