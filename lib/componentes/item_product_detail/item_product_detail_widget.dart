import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'item_product_detail_model.dart';
import 'item_product_detail_widgets.dart';
import 'item_product_detail_controller.dart';
export 'item_product_detail_model.dart';

class ItemProductDetailWidget extends StatefulWidget {
  const ItemProductDetailWidget({
    super.key,
    required this.itemList,
    required this.callbackCantidad,
    double? pCantidad,
    this.callbackEliminarBodega,
    required this.callbackSeleccionadoBodega,
  }) : pCantidad = pCantidad ?? 0.0;

  final DetailProductStruct? itemList;
  final Future Function(double? pCantidad)? callbackCantidad;
  final double pCantidad;
  final Future Function()? callbackEliminarBodega;
  final Future Function(bool state)? callbackSeleccionadoBodega;

  @override
  State<ItemProductDetailWidget> createState() =>
      _ItemProductDetailWidgetState();
}

class _ItemProductDetailWidgetState extends State<ItemProductDetailWidget> {
  late ItemProductDetailModel _model;
  late ItemProductDetailController _controller;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemProductDetailModel());

    _controller = ItemProductDetailController(
      item: widget.itemList!,
      initialQuantity: widget.pCantidad,
      onQuantityChanged: (qty) async => await widget.callbackCantidad?.call(qty),
      onSelected: (selected) async => await widget.callbackSeleccionadoBodega?.call(selected),
      onRemoved: () async => await widget.callbackEliminarBodega?.call(),
    );

    _textController = TextEditingController();
    _controller.addListener(_onControllerUpdate);

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
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.itemList != null)
                    ProductStorageDetails(item: widget.itemList!),
                  ProductStorageControls(
                    onRemove: _controller.remove,
                    onSubtract: _controller.decrement,
                    onAdd: _controller.increment,
                    onQuantityChanged: (value) => EasyDebounce.debounce(
                      'detail-quantity-debounce',
                      const Duration(milliseconds: 800),
                      () => _controller.updateQuantityFromText(value),
                    ),
                    textController: _textController,
                    focusNode: _model.amountFocusNode!, // Re-using from old model
                    validator: _model.amountTextControllerValidator.asValidator(context),
                    isSubtractDisabled: _controller.isSubtractDisabled,
                    isAddDisabled: _controller.isAddDisabled,
                  ),
                ],
              ),
            ),
          ].divide(const SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}
