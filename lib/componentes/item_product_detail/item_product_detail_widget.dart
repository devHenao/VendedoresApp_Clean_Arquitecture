import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'item_product_detail_model.dart';
export 'item_product_detail_model.dart';

class ItemProductDetailWidget extends StatefulWidget {
  const ItemProductDetailWidget({
    super.key,
    required this.itemList,
    required this.callbackCantidad,
    double? pCantidad,
    this.callbackEliminarBodega,
    required this.callbackSeleccionadoBodega,
  }) : this.pCantidad = pCantidad ?? 0.0;

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
      _model.dataBodega = widget!.itemList;
      _model.contador = widget!.pCantidad;
      safeSetState(() {});
      safeSetState(() {
        _model.amountTextController?.text = widget!.pCantidad.toString();
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
        padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
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
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Bodega:',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      widget!.itemList?.bodega,
                                      'bodega',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 5.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Lote:',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      widget!.itemList?.codlote,
                                      'lote',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 5.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'C. costo:',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      widget!.itemList?.codcc,
                                      'codccc',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 5.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Saldo:',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      widget!.itemList?.saldo.toString(),
                                      'saldo',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Manrope',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 5.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.contador = 0.0;
                          safeSetState(() {});
                          await widget.callbackSeleccionadoBodega?.call(
                            false,
                          );
                          await widget.callbackCantidad?.call(
                            0.0,
                          );
                          safeSetState(() {
                            _model.amountTextController?.text = '0';
                          });
                          await widget.callbackEliminarBodega?.call();
                        },
                        child: FaIcon(
                          FontAwesomeIcons.solidTrashAlt,
                          color: FlutterFlowTheme.of(context).error,
                          size: 20.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowIconButton(
                              borderRadius: 15.0,
                              buttonSize: 30.0,
                              fillColor: FlutterFlowTheme.of(context).primary,
                              disabledColor:
                                  FlutterFlowTheme.of(context).alternate,
                              icon: Icon(
                                Icons.remove_rounded,
                                color: FlutterFlowTheme.of(context).info,
                                size: 15.0,
                              ),
                              onPressed: (_model.contador! <= 0.0)
                                  ? null
                                  : () async {
                                      _model.contador = (_model.contador!) - 1;
                                      safeSetState(() {});
                                      safeSetState(() {
                                        _model.amountTextController?.text =
                                            _model.contador!.toString();
                                      });
                                      await widget.callbackCantidad?.call(
                                        double.tryParse(
                                            _model.amountTextController.text),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 100.0,
                              child: TextFormField(
                                controller: _model.amountTextController,
                                focusNode: _model.amountFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.amountTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.contador = valueOrDefault<double>(
                                      _model.amountTextController.text ==
                                                  null ||
                                              _model.amountTextController
                                                      .text ==
                                                  ''
                                          ? 0.0
                                          : double.tryParse(
                                              _model.amountTextController.text),
                                      1.0,
                                    );
                                    safeSetState(() {});
                                    safeSetState(() {
                                      _model.amountTextController?.text =
                                          _model.contador!.toString();
                                    });
                                    await widget.callbackCantidad?.call(
                                      _model.contador,
                                    );
                                  },
                                ),
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Manrope',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Manrope',
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Manrope',
                                      letterSpacing: 0.0,
                                    ),
                                textAlign: TextAlign.center,
                                maxLength: 6,
                                buildCounter: (context,
                                        {required currentLength,
                                        required isFocused,
                                        maxLength}) =>
                                    null,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                validator: _model.amountTextControllerValidator
                                    .asValidator(context),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9-.]'))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowIconButton(
                              borderRadius: 15.0,
                              buttonSize: 30.0,
                              fillColor: FlutterFlowTheme.of(context).primary,
                              disabledColor: FlutterFlowTheme.of(context).alternate,
                              onPressed: (widget.itemList?.saldo ?? 0) <= 0 ||
                                      (_model.contador ?? 0) >= (widget.itemList?.saldo ?? 0)
                                  ? null
                                  : () async {
                                      _model.contador = (_model.contador ?? 0) + 1;
                                      safeSetState(() {
                                        _model.amountTextController?.text =
                                            _model.contador!.toString();
                                      });
                                      await widget.callbackCantidad?.call(
                                        _model.contador,
                                      );
                                    },
                              icon: Icon(
                                Icons.add_rounded,
                                color: FlutterFlowTheme.of(context).info,
                                size: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}
