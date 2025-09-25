import '/backend/schema/structs/index.dart';
import '/componentes/product_detail/product_detail_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'product_model.dart';
import 'product_widgets.dart';
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
  late ProductModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.cantidad > 0) {
        _model.contador = widget.cantidad;
      } else {
        // If the product is selected (in cart from other warehouses) but this warehouse has 0, start at 0.
        // Otherwise, if not selected at all, default to 1 for a new addition.
        _model.contador = (widget.selecionado ?? false) ? 0.0 : 1.0;
      }
      _model.updatePage(() {});
      safeSetState(() {
        _model.amountTextController?.text = _model.contador!.toString();
      });

      // If product is already selected, fetch its specific stock for validation.
      if (widget.selecionado ?? false) {
        _model.apiResultDetailProduct =
            await ProductsGroup.getListStorageByProductCall.call(
          token: FFAppState().infoSeller.token,
          codprecio: FFAppState().dataCliente.codprecio,
          codproduc: widget.productItem?.codproduc,
        );
        if (_model.apiResultDetailProduct?.succeeded ?? true) {
          final bodegasJson = getJsonField(
            (_model.apiResultDetailProduct?.jsonBody ?? ''),
            r'''$.data''',
            true,
          );
          final bodegas = (bodegasJson as List?)
                  ?.map((e) => DetailProductStruct.maybeFromMap(e)!)
                  .toList() ??
              [];
          _model.saldoBodegaVendedor = functions.getSaldoPorBodega(
            FFAppState().infoSeller.storageDefault,
            bodegas,
          );
          _model.updatePage(() {});
        }
      }
    });

    _model.amountTextController ??= TextEditingController(text: '1');
    _model.amountFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.amountTextController?.dispose();
    _model.amountFocusNode?.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                    contador: _model.contador,
                    saldoBodegaVendedor: _model.saldoBodegaVendedor,
                    textController: _model.amountTextController!,
                    focusNode: _model.amountFocusNode!,
                    validator: _model.amountTextControllerValidator.asValidator(context),
                    onAdd: () async {
                      try {
                        _model.apiResultDetailProduct = await ProductsGroup.getListStorageByProductCall.call(
                          token: FFAppState().infoSeller.token,
                          codprecio: FFAppState().dataCliente.codprecio,
                          codproduc: widget.productItem?.codproduc,
                        );
                        if (!mounted) return;
                        if ((_model.apiResultDetailProduct?.succeeded ?? true)) {
                          final bodegasJson = getJsonField((_model.apiResultDetailProduct?.jsonBody ?? ''), r'''$.data''', true,);
                          final bodegas = (bodegasJson as List?)?.map((e) => DetailProductStruct.maybeFromMap(e)!).toList() ?? [];
                          final saldoBodegaVendedor = functions.getSaldoPorBodega(FFAppState().infoSeller.storageDefault, bodegas,);
                          if (saldoBodegaVendedor > 0) {
                            _model.saldoBodegaVendedor = saldoBodegaVendedor;
                            _model.updatePage(() {});
                            await widget.callBackSeleccionado?.call(true);
                            if (!mounted) return;
                            await widget.callbackCantidad?.call(1.0);
                            if (!mounted) return;
                            _model.contador = 1.0;
                            _model.updatePage(() {});
                            safeSetState(() {
                              _model.amountTextController?.text = _model.contador!.toString();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('¡El producto ha sido agregado al carrito!', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground,),),
                                duration: const Duration(milliseconds: 1500),
                                backgroundColor: FlutterFlowTheme.of(context).success,
                              ),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('La bodega ${FFAppState().infoSeller.storageDefault} no tiene saldo, debes elegir otra bodega desde el detalle', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground,),),
                                duration: const Duration(milliseconds: 3000),
                                backgroundColor: FlutterFlowTheme.of(context).error,
                              ),
                            );
                          }
                        } else {
                          if (!mounted) return;
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('No se pudo verificar el stock del producto.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(alertDialogContext), child: const Text('Ok'),),
                                ],
                              );
                            },
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text('Error al verificar el stock: $e'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(alertDialogContext), child: const Text('Ok'),),
                              ],
                            );
                          },
                        );
                      }
                    },
                    onRemove: () async {
                      _model.contador = 0.0;
                      _model.updatePage(() {});
                      await widget.callBackSeleccionado?.call(false,);
                      await widget.callbackCantidad?.call(0.0,);
                      safeSetState(() {
                        _model.amountTextController?.text = '1';
                      });
                      await widget.callbackEliminar?.call();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Se ha eliminado el producto del carrito', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground,),),
                            duration: const Duration(milliseconds: 1500),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                    },
                    onSubtract: () async {
                      _model.contador = (_model.contador!) - 1;
                      _model.updatePage(() {});
                      safeSetState(() {
                        _model.amountTextController?.text = _model.contador!.toString();
                      });
                      await widget.callbackCantidad?.call(double.tryParse(_model.amountTextController.text),);
                    },
                    onIncrement: () async {
                      if ((_model.contador!) + 1 <= (_model.saldoBodegaVendedor ?? 0)) {
                        _model.contador = (_model.contador!) + 1;
                        _model.updatePage(() {});
                        safeSetState(() {
                          _model.amountTextController?.text = _model.contador!.toString();
                        });
                        await widget.callbackCantidad?.call(double.tryParse(_model.amountTextController.text),);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No se puede superar el saldo de la bodega ${FFAppState().infoSeller.storageDefault}, debes elegir otra bodega desde el detalle', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground,),),
                            duration: const Duration(milliseconds: 3000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                    },
                    onQuantityChanged: (value) {
                      EasyDebounce.debounce(
                        '_model.amountTextController',
                        const Duration(milliseconds: 2000),
                        () async {
                          final enteredAmount = double.tryParse(_model.amountTextController.text) ?? 0.0;
                          final maxStock = _model.saldoBodegaVendedor ?? 0.0;
                          if (enteredAmount > maxStock) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No se puede superar el saldo de la bodega ${FFAppState().infoSeller.storageDefault}, debes elegir otra bodega desde el detalle', style: TextStyle(color: FlutterFlowTheme.of(context).secondaryBackground,),),
                                duration: const Duration(milliseconds: 3000),
                                backgroundColor: FlutterFlowTheme.of(context).error,
                              ),
                            );
                            _model.contador = maxStock;
                            safeSetState(() {
                              _model.amountTextController?.text = maxStock.toString();
                            });
                          } else {
                            _model.contador = enteredAmount > 0 ? enteredAmount : 1.0;
                          }
                          _model.updatePage(() {});
                          await widget.callbackCantidad?.call(_model.contador,);
                        },
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
                                final result = await showDialog<double>(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: const AlignmentDirectional(0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: ProductDetailWidget(
                                        codprecio:
                                            FFAppState().dataCliente.codprecio,
                                        codproduc:
                                            widget.productItem!.codproduc,
                                        cantidad: _model.contador!,
                                      ),
                                    );
                                  },
                                );

                                if (result != null) {
                                  if (result > 0) {
                                    // If the product was not selected before, mark it as selected now.
                                    if (widget.selecionado != true) {
                                      await widget.callBackSeleccionado?.call(true);
                                    }

                                    // Update quantity and UI
                                    _model.contador = result;
                                    _model.updatePage(() {});
                                    safeSetState(() {
                                      _model.amountTextController?.text = _model.contador.toString();
                                    });
                                    await widget.callbackCantidad?.call(_model.contador);
                                  } else {
                                    // If result is 0, deselect the product.
                                    await widget.callBackSeleccionado?.call(false);
                                    await widget.callbackCantidad?.call(0.0);
                                    await widget.callbackEliminar?.call();
                                  }
                                }
                              },
                              child: Icon(
                                Icons.list,
                                color: FlutterFlowTheme.of(context).primary,
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
                              color: FlutterFlowTheme.of(context).primary,
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
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Manrope',
                                        color:
                                            FlutterFlowTheme.of(context).info,
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
