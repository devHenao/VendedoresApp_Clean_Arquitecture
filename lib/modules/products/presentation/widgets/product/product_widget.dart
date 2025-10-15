import '../../../../../core/backend/schema/structs/index.dart';
import 'package:app_vendedores/modules/products/presentation/widgets/product_detail/product_detail_helper.dart';
import '../../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_model.dart';
import 'product_widgets.dart';
import 'product_controller.dart';
export 'product_model.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    this.selecionado,
    required this.callBackSeleccionado,
    double? cantidad,
    required this.callbackCantidad,
    required this.productItem,
    double? precio,
    double? saldo,
    this.callbackEliminar,
  })  : cantidad = cantidad ?? 0.0,
        precio = precio ?? 0.0,
        saldo = saldo ?? 0.0;

  final bool? selecionado;
  final Future Function(bool? state)? callBackSeleccionado;
  final double cantidad;
  final Future Function(double? pCantidad)? callbackCantidad;
  final DataProductStruct? productItem;
  final double precio;
  final double saldo;
  final Future Function()? callbackEliminar;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ProductController _controller;
  late TextEditingController _textController;
  late ProductModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductModel());

    _controller = ProductController(
      productItem: widget.productItem,
      initialCantidad: widget.cantidad,
      isInitiallySelected: widget.selecionado ?? false,
      infoSeller: FFAppState().infoSeller,
      dataCliente: FFAppState().dataCliente,
      onProductSelected: (isSelected) async => await widget.callBackSeleccionado?.call(isSelected),
      onQuantityUpdated: (quantity) async => await widget.callbackCantidad?.call(quantity),
      onProductRemoved: () async => await widget.callbackEliminar?.call(),
    );

    _textController = TextEditingController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!mounted) return;

    final controllerValue = _controller.contador.toString();
    if (_textController.text != controllerValue) {
      _textController.text = controllerValue;
    }

    final message = _controller.uiMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.message),
          backgroundColor: message.isError ? GlobalTheme.of(context).error : GlobalTheme.of(context).success,
        ),
      );
      _controller.clearMessage();
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
    context.watch<FFAppState>();

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: GlobalTheme.of(context).secondaryBackground,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProductInfo(
                    productItem: widget.productItem,
                    precio: widget.precio,
                    saldo: widget.saldo,
                  ),
                  ProductActions(
                    selecionado: widget.selecionado,
                    saldo: widget.saldo,
                    contador: _controller.contador,
                    saldoBodegaVendedor: _controller.saldoBodegaVendedor,
                    textController: _textController,
                    focusNode: _model.amountFocusNode ??= FocusNode(),
                    validator: _model.amountTextControllerValidator?.asValidator(context),
                    onAdd: _controller.addToCart,
                    onRemove: _controller.removeFromCart,
                    onSubtract: _controller.decrement,
                    onIncrement: _controller.increment,
                    onQuantityChanged: (value) {
                      EasyDebounce.debounce(
                        'quantity-debounce',
                        const Duration(milliseconds: 800),
                        () => _controller.updateQuantityFromText(value),
                      );
                    },
                  ),
                ].divide(const SizedBox(height: 5.0)),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.saldo > 0)
                            Builder(
                              builder: (context) => InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final result = await ProductDetailHelper.showProductDetailDialog(
                                  context: context,
                                  codprecio: FFAppState().dataCliente.codprecio,
                                  codproduc: widget.productItem!.codproduc,
                                  cantidad: _model.contador,
                                );

                                if (result != null) {
                                  if (result > 0) {
                                    if (widget.selecionado != true) {
                                      await widget.callBackSeleccionado?.call(true);
                                    }
                                    _model.contador = result;
                                    _model.updatePage(() {});
                                    safeSetState(() {
                                      _model.amountTextController?.text = _model.contador.toString();
                                    });
                                    await widget.callbackCantidad?.call(_model.contador);
                                  } else {
                                    await widget.callBackSeleccionado?.call(false);
                                    await widget.callbackCantidad?.call(0.0);
                                    await widget.callbackEliminar?.call();
                                  }
                                }
                              },
                              child: Icon(
                                Icons.list,
                                color: GlobalTheme.of(context).primary,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (functions.onList(
                              FFAppState().store.map((e) => e.codigo).toList(),
                              widget.productItem!.codproduc) ==
                          true)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: GlobalTheme.of(context).primary,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: const  EdgeInsetsDirectional.fromSTEB(
                                    5.0, 5.0, 5.0, 5.0),
                                child: Text(
                                  functions
                                      .acumulate(
                                          FFAppState()
                                              .store
                                              .map((e) => e.cantidad)
                                              .toList(),
                                          widget.productItem!.codproduc,
                                          FFAppState()
                                              .store
                                              .map((e) => e.codigo)
                                              .toList())
                                      .toString(),
                                  style: GlobalTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Manrope',
                                        color:
                                            GlobalTheme.of(context).info,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ].divide(const SizedBox(height: 5.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
