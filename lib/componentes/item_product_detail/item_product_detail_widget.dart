import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'item_product_detail_model.dart';
import 'item_product_detail_widgets.dart';
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

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemProductDetailModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.dataBodega = widget.itemList;
      _model.contador = widget.pCantidad;
      safeSetState(() {});
      safeSetState(() {
        _model.amountTextController?.text = widget.pCantidad.toString();
      });
    });

    _model.amountTextController ??= TextEditingController(text: '0');
    _model.amountFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

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
                    onRemove: () async {
                      _model.contador = 0.0;
                      safeSetState(() {});
                      await widget.callbackSeleccionadoBodega?.call(false);
                      await widget.callbackCantidad?.call(0.0);
                      safeSetState(() {
                        _model.amountTextController?.text = '0';
                      });
                      await widget.callbackEliminarBodega?.call();
                    },
                    onSubtract: () async {
                      _model.contador = (_model.contador!) - 1;
                      safeSetState(() {});
                      safeSetState(() {
                        _model.amountTextController?.text = _model.contador!.toString();
                      });
                      await widget.callbackCantidad?.call(
                        double.tryParse(_model.amountTextController.text),
                      );
                    },
                    onAdd: () async {
                      _model.contador = (_model.contador ?? 0) + 1;
                      safeSetState(() {
                        _model.amountTextController?.text = _model.contador!.toString();
                      });
                      await widget.callbackCantidad?.call(_model.contador);
                    },
                    onQuantityChanged: (value) => EasyDebounce.debounce(
                      '_model.amountTextController',
                      const Duration(milliseconds: 2000),
                      () async {
                        _model.contador = valueOrDefault<double>(
                          _model.amountTextController.text.isEmpty
                              ? 0.0
                              : double.tryParse(_model.amountTextController.text),
                          1.0,
                        );
                        safeSetState(() {});
                        safeSetState(() {
                          _model.amountTextController?.text = _model.contador!.toString();
                        });
                        await widget.callbackCantidad?.call(_model.contador);
                      },
                    ),
                    textController: _model.amountTextController!,
                    focusNode: _model.amountFocusNode!,
                    validator: _model.amountTextControllerValidator.asValidator(context),
                    isSubtractDisabled: _model.contador! <= 0.0,
                    isAddDisabled: (widget.itemList?.saldo ?? 0) <= 0 ||
                        (_model.contador ?? 0) >= (widget.itemList?.saldo ?? 0),
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
