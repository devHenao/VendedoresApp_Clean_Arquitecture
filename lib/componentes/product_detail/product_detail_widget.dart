import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/item_product_detail/item_product_detail_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductDetailModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResultDetail =
          await ProductsGroup.getListStorageByProductCall.call(
        token: FFAppState().infoSeller.token,
        codprecio: widget!.codprecio,
        codproduc: widget!.codproduc,
      );

      if ((_model.apiResultDetail?.succeeded ?? true)) {
        _model.resultadoBodega = await actions.actualizarListaProductosBodega(
          (getJsonField(
            (_model.apiResultDetail?.jsonBody ?? ''),
            r'''$.data''',
            true,
          )!
                  .toList()
                  .map<DetailProductStruct?>(DetailProductStruct.maybeFromMap)
                  .toList() as Iterable<DetailProductStruct?>)
              .withoutNulls
              .toList(),
          FFAppState().shoppingCart.toList(),
        );
        _model.listDetail =
            _model.resultadoBodega!.toList().cast<DetailProductStruct>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(getJsonField(
                (_model.apiResultDetail?.jsonBody ?? ''),
                r'''$.data''',
              ).toString().toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    });

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: FlutterFlowTheme.of(context).success,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 570.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Color(0xFFE0E3E7),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Detalle de producto',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ].divide(const SizedBox(width: 5.0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 24.0,
                    thickness: 2.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  if (_model.listDetail.isNotEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Descripción:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              _model.listDetail.isNotEmpty
                                  ? valueOrDefault<String>(
                                      _model.listDetail.firstOrNull?.descripcio,
                                      '-',
                                    )
                                  : 'description',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Valor unitario:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              _model.listDetail.isNotEmpty
                                  ? valueOrDefault<String>(
                                      formatNumber(
                                        _model.listDetail.firstOrNull?.precio,
                                        formatType: FormatType.decimal,
                                        decimalType: DecimalType.periodDecimal,
                                        currency: '\$',
                                      ),
                                      '-',
                                    )
                                  : 'precio',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ].divide(const SizedBox(width: 5.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Código:',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              _model.listDetail.isNotEmpty
                                  ? valueOrDefault<String>(
                                      _model.listDetail.firstOrNull?.codigo,
                                      '-',
                                    )
                                  : 'code',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ].divide(const SizedBox(width: 5.0)),
                        ),
                      ],
                    ),
                  if (!(_model.listDetail.isNotEmpty))
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 15.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cargando...',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Manrope',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                ),
                          ).animateOnPageLoad(
                              animationsMap['textOnPageLoadAnimation']!),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 12.0, 0.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final listBodegas = _model.listDetail.toList();
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listBodegas.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10.0),
                          itemBuilder: (context, listBodegasIndex) {
                            final listBodegasItem =
                                listBodegas[listBodegasIndex];
                            return wrapWithModel(
                              model: _model.itemProductDetailModels.getModel(
                                listBodegasIndex.toString(),
                                listBodegasIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              updateOnChange: true,
                              child: ItemProductDetailWidget(
                                key: Key(
                                  'Keyo8r_${listBodegasIndex.toString()}',
                                ),
                                pCantidad: listBodegasItem.cantidad,
                                itemList: listBodegasItem,
                                callbackCantidad: (pCantidad) async {
                                  _model.resultadoCantidad =
                                      await actions.modificarCantidadBodega(
                                    listBodegasItem,
                                    _model.listDetail.toList(),
                                    pCantidad,
                                  );
                                  _model.listDetail = _model.resultadoCantidad!
                                      .toList()
                                      .cast<DetailProductStruct>();
                                  _model.updatePage(() {});
                                  _model.resultadoCarrito = await actions
                                      .agregarProductoCarrito(
                                    FFAppState().shoppingCart.toList(),
                                    DataProductStruct(
                                      codproduc: listBodegasItem.codigo,
                                      precio: listBodegasItem.precio,
                                      descripcio:
                                          listBodegasItem.descripcio,
                                      selected: true,
                                      saldo: listBodegasItem.saldo,
                                      cantidad: listBodegasItem.cantidad,
                                      unidadmed:
                                          listBodegasItem.unidadmed,
                                      codtariva:
                                          listBodegasItem.codtariva,
                                      iva: listBodegasItem.iva,
                                      codbarras: '',
                                    ),
                                    listBodegasItem.bodega,
                                    listBodegasItem.codcc,
                                    listBodegasItem.codlote,
                                    listBodegasItem.cantidad,
                                  );
                                  FFAppState().shoppingCart = _model
                                      .resultadoCarrito!
                                      .toList()
                                      .cast<DetailProductStruct>();
                                  _model.updatedStore = await actions.updateStoreQuantity(
                                    FFAppState().shoppingCart.toList(),
                                  );
                                  FFAppState().store = _model.updatedStore!.toList().cast<DetailProductStruct>();
                                  FFAppState().update(() {});

                                  if (listBodegasItem.bodega == FFAppState().infoSeller.storageDefault) {
                                    _model.updatedQuantityForCallback = pCantidad;
                                    _model.updatePage(() {});
                                  }

                                  safeSetState(() {});
                                },
                                callbackEliminarBodega: () async {
                                  if (FFAppState()
                                          .infoSeller
                                          .storageDefault != 
                                      listBodegasItem.bodega) {
                                    _model.resultadoEliminarBodega =
                                        await actions
                                            .eliminarProductoCarrito(
                                      listBodegasItem.bodega,
                                      listBodegasItem.codcc,
                                      listBodegasItem.codlote,
                                      listBodegasItem.codigo,
                                      FFAppState()
                                          .shoppingCart
                                          .toList(),
                                    );
                                    FFAppState().shoppingCart = _model
                                        .resultadoEliminarBodega!
                                        .toList()
                                        .cast<DetailProductStruct>();
                                    _model.updatedStore2 = await actions.updateStoreQuantity(
                                      FFAppState().shoppingCart.toList(),
                                    );
                                    FFAppState().store = _model.updatedStore2!.toList().cast<DetailProductStruct>();
                                    FFAppState().update(() {});
                                  } else {
                                    _model.resultadoEliminarBodega2 =
                                        await actions
                                            .eliminarProductoCarrito(
                                      FFAppState()
                                          .infoSeller
                                          .storageDefault,
                                      listBodegasItem.codcc,
                                      listBodegasItem.codlote,
                                      listBodegasItem.codigo,
                                      FFAppState()
                                          .shoppingCart
                                          .toList(),
                                    );
                                    FFAppState().shoppingCart = _model
                                        .resultadoEliminarBodega2!
                                        .toList()
                                        .cast<DetailProductStruct>();
                                    _model.updatedStore3 = await actions.updateStoreQuantity(
                                      FFAppState().shoppingCart.toList(),
                                    );
                                    FFAppState().store = _model.updatedStore3!.toList().cast<DetailProductStruct>();
                                    FFAppState().update(() {});
                                  }


                                  safeSetState(() {});
                                },
                                callbackSeleccionadoBodega:
                                    (state) async {
                                  _model.resultBodega =
                                      await actions.seleccionarProducto(
                                    DataProductStruct(
                                      codproduc: listBodegasItem.codigo,
                                      precio: listBodegasItem.precio,
                                      descripcio:
                                          listBodegasItem.descripcio,
                                      saldo: listBodegasItem.saldo,
                                      unidadmed:
                                          listBodegasItem.unidadmed,
                                      codtariva:
                                          listBodegasItem.codtariva,
                                      iva: listBodegasItem.iva,
                                      selected: true,
                                      codbarras: '',
                                      cantidad:
                                          listBodegasItem.cantidad,
                                    ),
                                    widget.codproduc!,
                                  );
                                  _model.addProduct = await actions
                                      .agregarProductoCarrito(
                                    FFAppState().shoppingCart.toList(),
                                    DataProductStruct(
                                      codproduc: listBodegasItem.codigo,
                                      precio: listBodegasItem.precio,
                                      descripcio:
                                          listBodegasItem.descripcio,
                                      saldo: listBodegasItem.saldo,
                                      unidadmed:
                                          listBodegasItem.unidadmed,
                                      iva: listBodegasItem.iva,
                                      codtariva:
                                          listBodegasItem.codtariva,
                                      selected: true,
                                      cantidad:
                                          listBodegasItem.cantidad,
                                    ),
                                    listBodegasItem.bodega,
                                    listBodegasItem.codcc,
                                    listBodegasItem.codlote,
                                    listBodegasItem.cantidad,
                                  );
                                  FFAppState().shoppingCart = _model
                                      .addProduct!
                                      .toList()
                                      .cast<DetailProductStruct>();
                                  _model.updatedStore4 = await actions.updateStoreQuantity(
                                    FFAppState().shoppingCart.toList(),
                                  );
                                  FFAppState().store = _model.updatedStore4!.toList().cast<DetailProductStruct>();
                                  safeSetState(() {});

                                  safeSetState(() {});
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (_model.listDetail.isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 20.0, 0.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context, _model.updatedQuantityForCallback);
                              },
                              text: 'Cerrar',
                              icon: Icon(
                                Icons.close,
                                size: 15.0,
                              ),
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Manrope',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Color(0x4A161C24),
                                ),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(width: 20.0)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
