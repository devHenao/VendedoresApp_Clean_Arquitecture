import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/menu/menu_widget.dart';
import '/componentes/product/product_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'productos_model.dart';
export 'productos_model.dart';

class ProductosWidget extends StatefulWidget {
  const ProductosWidget({super.key});

  static String routeName = 'Productos';
  static String routePath = '/productos';

  @override
  State<ProductosWidget> createState() => _ProductosWidgetState();
}

class _ProductosWidgetState extends State<ProductosWidget> with WidgetsBindingObserver {
  late ProductosModel _model;
  bool _isLoadingNextPage = false;
  bool _isLoadingPrevPage = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductosModel());
    WidgetsBinding.instance.addObserver(this);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().product = true;
      FFAppState().update(() {});
      await _refreshProductList();
    });

    _model.txtBuscarTextController ??= TextEditingController();
    _model.txtBuscarFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When returning to the page, refresh the product list to update quantities.
      _refreshProductList();
    }
  }

  Future<void> _refreshProductList() async {
    // Load products
    _model.buscar = _model.txtBuscarTextController.text;
    _model.apiResultaListProductsSubmit =
        await ProductsGroup.postListProductByCodPrecioCall.call(
      token: FFAppState().infoSeller.token,
      codprecio: FFAppState().dataCliente.codprecio,
      pageNumber: _model.pages?.currentPage ?? 1,
      pageSize: 10,
      filter: _model.buscar,
    );

    if ((_model.apiResultaListProductsSubmit?.succeeded ?? true)) {
      final currentCart = FFAppState().shoppingCart.toList();
      final apiProducts = (getJsonField(
        (_model.apiResultaListProductsSubmit?.jsonBody ?? ''),
        r'''$.data.data''',
        true,
      )!
              .toList()
              .map<DataProductStruct?>(DataProductStruct.maybeFromMap)
              .toList() as Iterable<DataProductStruct?>)
          .withoutNulls
          .toList();

      // Calculate total quantities for each product across ALL warehouses in the cart.
      final totalCartQuantities = <String, double>{};
      for (final item in currentCart) {
        if (item.codigo.isNotEmpty) {
          totalCartQuantities.update(item.codigo, (value) => value + item.cantidad, ifAbsent: () => item.cantidad);
        }
      }

      // This map is for the quantity of the default warehouse, used for the individual counter.
      final cartQuantities = <String, double>{};
      for (final item in currentCart) {
        if (item.codigo.isNotEmpty && item.bodega == FFAppState().infoSeller.storageDefault) {
          cartQuantities[item.codigo] = item.cantidad;
        }
      }

      final updatedProducts = <DataProductStruct>[];
      for (final product in apiProducts) {
        final totalQuantity = totalCartQuantities[product.codproduc] ?? 0.0;
        final defaultWarehouseQuantity = cartQuantities[product.codproduc] ?? 0.0;

        updatedProducts.add(DataProductStruct(
          codproduc: product.codproduc,
          descripcio: product.descripcio,
          precio: product.precio,
          saldo: product.saldo,
          unidadmed: product.unidadmed,
          iva: product.iva,
          codtariva: product.codtariva,
          // The 'selected' state should depend on the total quantity in the cart.
          selected: totalQuantity > 0,
          // The 'cantidad' for the individual counter should be from the default warehouse.
          cantidad: defaultWarehouseQuantity,
          codbarras: product.codbarras,
        ));
      }

      FFAppState().productList = updatedProducts;

      // Update the store with the total quantities for the general counter.
      final updatedStore = <DetailProductStruct>[];
      totalCartQuantities.forEach((codproduc, cantidad) {
        final productInCart = currentCart.firstWhere((item) => item.codigo == codproduc, orElse: () => DetailProductStruct());
        updatedStore.add(DetailProductStruct(
          codigo: codproduc,
          cantidad: cantidad,
          // Add other necessary fields from productInCart if needed
          descripcio: productInCart.descripcio,
          precio: productInCart.precio,
          saldo: productInCart.saldo,
          unidadmed: productInCart.unidadmed,
          iva: productInCart.iva,
          codtariva: productInCart.codtariva,
          bodega: '', // Not relevant for the general counter
          codcc: '',
          codlote: '',
        ));
      });
      FFAppState().store = updatedStore;

      _model.hasProduct = false;
      FFAppState().update(() {});
      _model.pages = DataPageStruct.maybeFromMap(
        getJsonField(
          (_model.apiResultaListProductsSubmit?.jsonBody ?? ''),
          r'''$.data''',
        ),
      );
      safeSetState(() {});
    } else {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              getJsonField(
                (_model.apiResultaListProductsSubmit?.jsonBody ?? ''),
                r'''$.data''',
              ).toString(),
            ),
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
  }


  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        drawer: Drawer(
          elevation: 16.0,
          child: wrapWithModel(
            model: _model.menuModel,
            updateCallback: () => safeSetState(() {}),
            child: MenuWidget(),
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Cliente:',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                              ),
                    ),
                  ),
                ].divide(SizedBox(width: 5.0)),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      FFAppState().dataCliente != null
                          ? valueOrDefault<String>(
                              FFAppState().dataCliente.nombre,
                              'Cliente',
                            )
                          : 'Cliente',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                              ),
                    ),
                  ),
                ].divide(SizedBox(width: 5.0)),
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Productos',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 30.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed('Carrito');
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.shoppingCart,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 30.0,
                                  ),
                                ),
                              ].divide(SizedBox(width: 5.0)),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 200.0,
                                      child: TextFormField(
                                        controller:
                                            _model.txtBuscarTextController,
                                        focusNode: _model.txtBuscarFocusNode,
                                        onFieldSubmitted: (_) async {
                                          _model.buscar = _model
                                              .txtBuscarTextController.text;
                                          _model.hasProduct = true;
                                          safeSetState(() {});
                                          _model.apiResultaListProductsSubmit =
                                              await ProductsGroup
                                                  .postListProductByCodPrecioCall
                                                  .call(
                                            token:
                                                FFAppState().infoSeller.token,
                                            codprecio: FFAppState()
                                                .dataCliente
                                                .codprecio,
                                            pageNumber: 1,
                                            pageSize: 10,
                                            filter: _model.buscar,
                                          );

                                          if ((_model
                                                  .apiResultaListProductsSubmit
                                                  ?.succeeded ??
                                              true)) {
                                            _model.resultadoProductoCacheSubmit =
                                                await actions
                                                    .actualizarListaProductosCache(
                                              (getJsonField(
                                                (_model.apiResultaListProductsSubmit
                                                        ?.jsonBody ??
                                                    ''),
                                                r'''$.data.data''',
                                                true,
                                              )!
                                                          .toList()
                                                          .map<DataProductStruct?>(
                                                              DataProductStruct
                                                                  .maybeFromMap)
                                                          .toList()
                                                      as Iterable<
                                                          DataProductStruct?>)
                                                  .withoutNulls
                                                  .toList(),
                                              FFAppState()
                                                  .shoppingCart
                                                  .toList(),
                                              _model.buscar,
                                            );
                                            FFAppState().productList = _model
                                                .resultadoProductoCacheSubmit!
                                                .toList()
                                                .cast<DataProductStruct>();
                                            _model.hasProduct = false;
                                            FFAppState().update(() {});
                                            safeSetState(() {});
                                            _model.pages =
                                                DataPageStruct.maybeFromMap(
                                                    getJsonField(
                                              (_model.apiResultaListProductsSubmit
                                                      ?.jsonBody ??
                                                  ''),
                                              r'''$.data''',
                                            ));
                                            safeSetState(() {});
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text(getJsonField(
                                                    (_model.apiResultaListProductsSubmit
                                                            ?.jsonBody ??
                                                        ''),
                                                    r'''$.data''',
                                                  ).toString()),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }

                                          safeSetState(() {});
                                        },
                                        onTap: () {
                                          // Forzar la actualización del estado cuando se hace tap en el campo
                                          safeSetState(() {});
                                        },
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Manrope',
                                                    letterSpacing: 0.0,
                                                  ),
                                          hintText:
                                              'Buscar por nombre o código',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Manrope',
                                                    letterSpacing: 0.0,
                                                  ),
                                          suffixIcon: _model
                                                      .txtBuscarTextController
                                                      .text
                                                      .isNotEmpty &&
                                                  _model.txtBuscarFocusNode
                                                          ?.hasFocus ==
                                                      true
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.clear,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 20.0,
                                                  ),
                                                  onPressed: () async {
                                                    _model
                                                        .txtBuscarTextController
                                                        ?.clear();
                                                    safeSetState(() {});

                                                    // Realizar la búsqueda con el campo vacío
                                                    _model.hasProduct = true;
                                                    safeSetState(() {});

                                                    _model.apiResultaListProductsSubmit =
                                                        await ProductsGroup
                                                            .postListProductByCodPrecioCall
                                                            .call(
                                                      token: FFAppState()
                                                          .infoSeller
                                                          .token,
                                                      codprecio: FFAppState()
                                                          .dataCliente
                                                          .codprecio,
                                                      pageNumber: 1,
                                                      pageSize: 10,
                                                      filter: _model.buscar,
                                                    );

                                                    if ((_model
                                                            .apiResultaListProductsSubmit
                                                            ?.succeeded ??
                                                        true)) {
                                                      _model.resultadoProductoCacheSubmit =
                                                          await actions
                                                              .actualizarListaProductosCache(
                                                        (getJsonField(
                                                          (_model.apiResultaListProductsSubmit
                                                                  ?.jsonBody ??
                                                              ''),
                                                          r'''$.data.data''',
                                                          true,
                                                        )!
                                                                    .toList()
                                                                    .map<DataProductStruct?>(
                                                                        DataProductStruct
                                                                            .maybeFromMap)
                                                                    .toList()
                                                                as Iterable<
                                                                    DataProductStruct?>)
                                                            .withoutNulls
                                                            .toList(),
                                                        FFAppState()
                                                            .shoppingCart
                                                            .toList(),
                                                        _model.buscar,
                                                      );
                                                      FFAppState().productList = _model
                                                          .resultadoProductoCacheSubmit!
                                                          .toList()
                                                          .cast<
                                                              DataProductStruct>();
                                                      _model.hasProduct = false;
                                                      FFAppState()
                                                          .update(() {});
                                                      _model.pages =
                                                          DataPageStruct
                                                              .maybeFromMap(
                                                        getJsonField(
                                                          (_model.apiResultaListProductsSubmit
                                                                  ?.jsonBody ??
                                                              ''),
                                                          r'''$.data''',
                                                        ),
                                                      );
                                                    }

                                                    // Mover el foco al campo después de limpiar
                                                    _model.txtBuscarFocusNode
                                                        ?.requestFocus();
                                                    safeSetState(() {});
                                                  },
                                                )
                                              : null,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Manrope',
                                              letterSpacing: 0.0,
                                            ),
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        validator: _model
                                            .txtBuscarTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 8.0,
                                    buttonSize: 40.0,
                                    fillColor:
                                        FlutterFlowTheme.of(context).primary,
                                    icon: Icon(
                                      Icons.search_rounded,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 30.0,
                                    ),
                                    showLoadingIndicator: true,
                                    onPressed: () async {
                                      if (_model.txtBuscarTextController.text !=
                                              null &&
                                          _model.txtBuscarTextController.text !=
                                              '') {
                                        _model.buscar =
                                            _model.txtBuscarTextController.text;
                                        _model.hasProduct = true;
                                        safeSetState(() {});
                                        _model.apiResultaListProductsBoton =
                                            await ProductsGroup
                                                .postListProductByCodPrecioCall
                                                .call(
                                          token: FFAppState().infoSeller.token,
                                          codprecio: FFAppState()
                                              .dataCliente
                                              .codprecio,
                                          pageSize: 10,
                                          pageNumber: 1,
                                          filter: _model.buscar,
                                        );

                                        if ((_model.apiResultaListProductsBoton
                                                ?.succeeded ??
                                            true)) {
                                          _model.resultadoProductoCacheBoton =
                                              await actions
                                                  .actualizarListaProductosCache(
                                            (getJsonField(
                                              (_model.apiResultaListProductsBoton
                                                      ?.jsonBody ??
                                                  ''),
                                              r'''$.data.data''',
                                              true,
                                            )!
                                                        .toList()
                                                        .map<DataProductStruct?>(
                                                            DataProductStruct
                                                                .maybeFromMap)
                                                        .toList()
                                                    as Iterable<
                                                        DataProductStruct?>)
                                                .withoutNulls
                                                .toList(),
                                            FFAppState().shoppingCart.toList(),
                                            _model.buscar,
                                          );
                                          FFAppState().productList = _model
                                              .resultadoProductoCacheBoton!
                                              .toList()
                                              .cast<DataProductStruct>();
                                          _model.hasProduct = false;
                                          safeSetState(() {});
                                          FFAppState().update(() {});
                                          _model.pages =
                                              DataPageStruct.maybeFromMap(
                                                  getJsonField(
                                            (_model.apiResultaListProductsBoton
                                                    ?.jsonBody ??
                                                ''),
                                            r'''$.data''',
                                          ));
                                          safeSetState(() {});
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Error'),
                                                content: Text(getJsonField(
                                                  (_model.apiResultaListProductsBoton
                                                          ?.jsonBody ??
                                                      ''),
                                                  r'''$.success''',
                                                ).toString()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        _model.buscar =
                                            _model.txtBuscarTextController.text;
                                        safeSetState(() {});
                                        _model.apiResultaListProductsBotonVacio =
                                            await ProductsGroup
                                                .postListProductByCodPrecioCall
                                                .call(
                                          token: FFAppState().infoSeller.token,
                                          codprecio: FFAppState()
                                              .dataCliente
                                              .codprecio,
                                          pageSize: 10,
                                          pageNumber: 1,
                                          filter: _model.buscar,
                                        );

                                        if ((_model
                                                .apiResultaListProductsBotonVacio
                                                ?.succeeded ??
                                            true)) {
                                          _model.resultadoProductoCacheBotonVacio =
                                              await actions
                                                  .actualizarListaProductosCache(
                                            (getJsonField(
                                              (_model.apiResultaListProductsBotonVacio
                                                      ?.jsonBody ??
                                                  ''),
                                              r'''$.data.data''',
                                              true,
                                            )!
                                                        .toList()
                                                        .map<DataProductStruct?>(
                                                            DataProductStruct
                                                                .maybeFromMap)
                                                        .toList()
                                                    as Iterable<
                                                        DataProductStruct?>)
                                                .withoutNulls
                                                .toList(),
                                            FFAppState().shoppingCart.toList(),
                                            _model.buscar,
                                          );
                                          FFAppState().productList = _model
                                              .resultadoProductoCacheBotonVacio!
                                              .toList()
                                              .cast<DataProductStruct>();
                                          _model.hasProduct = false;
                                          safeSetState(() {});
                                          FFAppState().update(() {});
                                          _model.pages =
                                              DataPageStruct.maybeFromMap(
                                                  getJsonField(
                                            (_model.apiResultaListProductsBotonVacio
                                                    ?.jsonBody ??
                                                ''),
                                            r'''$.data''',
                                          ));
                                          safeSetState(() {});
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Error'),
                                                content: Text(getJsonField(
                                                  (_model.apiResultaListProductsBotonVacio
                                                          ?.jsonBody ??
                                                      ''),
                                                  r'''$.success''',
                                                ).toString()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }

                                      _model.hasProduct = false;
                                      safeSetState(() {});
                                    },
                                  ),
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 8.0,
                                    buttonSize: 40.0,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    icon: Icon(
                                      Icons.qr_code_scanner_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      _model.codigoBarras =
                                          await FlutterBarcodeScanner
                                              .scanBarcode(
                                        '#C62828', // scanning line color
                                        'Cancel', // cancel button text
                                        true, // whether to show the flash icon
                                        ScanMode.BARCODE,
                                      );

                                      _model.buscar = _model.codigoBarras;
                                      safeSetState(() {});
                                      if (_model.codigoBarras != '-1') {
                                        _model.apiResultCodeScan =
                                            await ProductsGroup
                                                .postListProductByCodPrecioCall
                                                .call(
                                          token: FFAppState().infoSeller.token,
                                          codprecio: FFAppState()
                                              .dataCliente
                                              .codprecio,
                                          pageNumber: 1,
                                          pageSize: 10,
                                          filter: _model.buscar,
                                        );

                                        if ((_model.apiResultCodeScan?.succeeded ??
                                            true)) {
                                          _model.resultadoProductoCacheScan =
                                              await actions
                                                  .actualizarListaProductosCache(
                                            (getJsonField(
                                              (_model.apiResultCodeScan
                                                      ?.jsonBody ??
                                                  ''),
                                              r'''$.data.data''',
                                              true,
                                            )!
                                                        .toList()
                                                        .map<DataProductStruct?>(
                                                            DataProductStruct
                                                                .maybeFromMap)
                                                        .toList()
                                                    as Iterable<
                                                        DataProductStruct?>)
                                                .withoutNulls
                                                .toList(),
                                            FFAppState().shoppingCart.toList(),
                                            _model.buscar,
                                          );
                                          FFAppState().productList = _model
                                              .resultadoProductoCacheScan!
                                              .toList()
                                              .cast<DataProductStruct>();
                                          _model.hasProduct = false;
                                          safeSetState(() {});
                                          FFAppState().update(() {});
                                          if ((FFAppState()
                                                  .productList
                                                  .isNotEmpty) ==
                                              true) {
                                            FFAppState().product = true;
                                            FFAppState().update(() {});
                                          } else {
                                            FFAppState().product = false;
                                            FFAppState().update(() {});
                                          }

                                          _model.pages =
                                              DataPageStruct.maybeFromMap(
                                                  getJsonField(
                                            (_model.apiResultCodeScan
                                                    ?.jsonBody ??
                                                ''),
                                            r'''$.data''',
                                          ));
                                          safeSetState(() {});
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('ERROR'),
                                                content: Text(getJsonField(
                                                  (_model.apiResultCodeScan
                                                          ?.jsonBody ??
                                                      ''),
                                                  r'''$.data''',
                                                ).toString()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        FFAppState().product = false;
                                        safeSetState(() {});
                                      }

                                      _model.hasProduct = false;
                                      safeSetState(() {});
                                    },
                                  ),
                                ].divide(SizedBox(width: 20.0)),
                              ),
                            ),
                            Divider(
                              thickness: 2.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                          ].divide(SizedBox(height: 5.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                if ((_model.pages != null) &&
                    (FFAppState().productList.isNotEmpty))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Productos:',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '${((_model.pages?.currentPage ?? 1) - 1) * 10 + 1}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          'al',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '${((_model.pages?.currentPage ?? 1) * 10 < (_model.pages?.totalCount ?? 0)) ? ((_model.pages?.currentPage ?? 1) * 10) : (_model.pages?.totalCount ?? 0)}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          'de:',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          '${_model.pages?.totalCount ?? 0}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ].divide(SizedBox(width: 5.0)),
                    ),
                  ),
                if (_model.hasProduct == true ||
                    _isLoadingNextPage ||
                    _isLoadingPrevPage)
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          _isLoadingNextPage
                              ? 'Cargando más productos...'
                              : 'Buscando productos...',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Manrope',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      ],
                    ),
                  ),
                if ((FFAppState().product == false) &&
                    !(FFAppState().productList.isNotEmpty))
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/Empty_Box.png',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            'No hay productos',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Manrope',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(width: 2.0)),
                  ),
                if ((FFAppState().productList.isNotEmpty) &&
                    (_model.pages != null))
                  Expanded(
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).height * 0.6,
                            decoration: BoxDecoration(),
                            child: Builder(
                              builder: (context) {
                                final childs = FFAppState()
                                    .productList
                                    .sortedList(
                                        keyOf: (e) => e.descripcio, desc: false)
                                    .toList();

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount: childs.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 5.0),
                                  itemBuilder: (context, childsIndex) {
                                    final childsItem = childs[childsIndex];
                                    return SingleChildScrollView(
                                      primary: false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          wrapWithModel(
                                            model:
                                                _model.productModels.getModel(
                                              childsIndex.toString(),
                                              childsIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            updateOnChange: true,
                                            child: Hero(
                                              tag: 'Products',
                                              transitionOnUserGestures: true,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: ProductWidget(
                                                  key: Key(
                                                    'Keyp9r_${childsIndex.toString()}',
                                                  ),
                                                  selecionado:
                                                      childsItem.selected,
                                                  cantidad: childsItem.cantidad,
                                                  productItem: childsItem,
                                                  precio: childsItem.precio,
                                                  saldo: childsItem.saldo,
                                                  callBackSeleccionado:
                                                      (state) async {
                                                    _model.result = await actions
                                                        .seleccionarProducto(
                                                      childsItem,
                                                      childsItem.codproduc,
                                                    );
                                                    _model.addProducto =
                                                        await actions
                                                            .agregarProducto(
                                                      FFAppState()
                                                          .dataProductList
                                                          .toList(),
                                                      childsItem,
                                                      state!,
                                                    );
                                                    FFAppState()
                                                            .dataProductList =
                                                        _model.addProducto!
                                                            .toList()
                                                            .cast<
                                                                DataProductStruct>();
                                                    FFAppState().update(() {});
                                                    _model.listaAgregarProducto =
                                                        await actions
                                                            .agregarProductoCarrito(
                                                      FFAppState()
                                                          .shoppingCart
                                                          .toList(),
                                                      childsItem,
                                                      FFAppState()
                                                          .infoSeller
                                                          .storageDefault,
                                                      '0',
                                                      '0',
                                                      childsItem.cantidad,
                                                    );
                                                    FFAppState().shoppingCart = _model
                                                        .listaAgregarProducto!
                                                        .toList()
                                                        .cast<
                                                            DetailProductStruct>();
                                                    _model.updatedStore =
                                                        await actions
                                                            .updateStoreQuantity(
                                                      FFAppState()
                                                          .shoppingCart
                                                          .toList(),
                                                    );
                                                    FFAppState().store = _model
                                                        .updatedStore!
                                                        .toList()
                                                        .cast<
                                                            DetailProductStruct>();
                                                    FFAppState().update(() {});

                                                    safeSetState(() {});
                                                  },
                                                  callbackCantidad:
                                                      (pCantidad) async {
                                                    _model.resultCache =
                                                        await actions
                                                            .modificarCantidad(
                                                      childsItem,
                                                      FFAppState()
                                                          .productList
                                                          .toList(),
                                                      pCantidad,
                                                    );
                                                    FFAppState()
                                                            .dataProductList =
                                                        _model.resultCache!
                                                            .toList()
                                                            .cast<
                                                                DataProductStruct>();
                                                    FFAppState().update(() {});
                                                    _model.listaCarrito =
                                                        await actions
                                                            .agregarProductoCarrito(
                                                      FFAppState()
                                                          .shoppingCart
                                                          .toList(),
                                                      childsItem,
                                                      FFAppState()
                                                          .infoSeller
                                                          .storageDefault,
                                                      '0',
                                                      '0',
                                                      pCantidad,
                                                    );
                                                    FFAppState().shoppingCart =
                                                        _model.listaCarrito!
                                                            .toList()
                                                            .cast<
                                                                DetailProductStruct>();
                                                    _model.updatedStore2 =
                                                        await actions
                                                            .updateStoreQuantity(
                                                      FFAppState()
                                                          .shoppingCart
                                                          .toList(),
                                                    );
                                                    FFAppState().store = _model
                                                        .updatedStore2!
                                                        .toList()
                                                        .cast<
                                                            DetailProductStruct>();
                                                    FFAppState().update(() {});

                                                    safeSetState(() {});
                                                  },
                                                  callbackEliminar: () async {
                                                    _model.resultadoEliminarProducto =
                                                        await actions
                                                            .eliminarProductoCarrito(
                                                      FFAppState()
                                                          .infoSeller
                                                          .storageDefault,
                                                      '0',
                                                      '0',
                                                      childsItem.codproduc,
                                                      FFAppState()
                                                          .shoppingCart
                                                          .toList(),
                                                    );
                                                    FFAppState().shoppingCart = _model
                                                        .resultadoEliminarProducto!
                                                        .toList()
                                                        .cast<
                                                            DetailProductStruct>();
                                                    _model.updatedStore3 =
                                                        await actions
                                                            .updateStoreQuantity(
                                                      FFAppState()
                                                          .shoppingCart
                                                          .toList(),
                                                    );
                                                    FFAppState().store = _model
                                                        .updatedStore3!
                                                        .toList()
                                                        .cast<
                                                            DetailProductStruct>();
                                                    FFAppState().update(() {});

                                                    safeSetState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if ((FFAppState().productList.isNotEmpty) &&
                    (_model.pages != null))
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 35.0,
                                fillColor: FlutterFlowTheme.of(context).primary,
                                disabledColor:
                                    FlutterFlowTheme.of(context).alternate,
                                icon: Icon(
                                  Icons.navigate_before_rounded,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 20.0,
                                ),
                                onPressed: () async {
                                  if (_isLoadingPrevPage ||
                                      _model.pages?.currentPage == 1) {
                                    return;
                                  }
                                  setState(() => _isLoadingPrevPage = true);
                                  try {
                                    _model.apiResultaListProductsSubmit =
                                        await ProductsGroup
                                            .postListProductByCodPrecioCall
                                            .call(
                                      token: FFAppState().infoSeller.token,
                                      codprecio:
                                          FFAppState().dataCliente.codprecio,
                                      pageNumber:
                                          (_model.pages?.currentPage ?? 1) - 1,
                                      pageSize: 10,
                                      filter: _model.buscar,
                                    );

                                    if ((_model.apiResultaListProductsSubmit
                                            ?.succeeded ??
                                        true)) {
                                      _model.resultadoProductoCacheSubmit =
                                          await actions
                                              .actualizarListaProductosCache(
                                        (getJsonField(
                                          (_model.apiResultaListProductsSubmit
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.data.data''',
                                          true,
                                        )! as List)
                                            .map<DataProductStruct?>((e) =>
                                                DataProductStruct.maybeFromMap(
                                                    e))
                                            .withoutNulls
                                            .toList(),
                                        FFAppState().shoppingCart.toList(),
                                        _model.buscar,
                                      );
                                      FFAppState().productList = _model
                                          .resultadoProductoCacheSubmit!
                                          .toList()
                                          .cast<DataProductStruct>();
                                      _model.pages = DataPageStruct.maybeFromMap(
                                        getJsonField(
                                          (_model.apiResultaListProductsSubmit
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.data''',
                                        ),
                                      );
                                      safeSetState(() {});
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                              'No se pudo cargar la página anterior.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        alertDialogContext),
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } catch (e) {
                                    print('Error loading previous page: $e');
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isLoadingPrevPage = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).accent2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      3.0, 3.0, 3.0, 3.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Página:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Manrope',
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          _model.pages?.currentPage.toString(),
                                          '#',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Manrope',
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Text(
                                        '-',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Manrope',
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          _model.pages?.totalPages.toString(),
                                          '#',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Manrope',
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 2.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 35.0,
                                fillColor: FlutterFlowTheme.of(context).primary,
                                disabledColor:
                                    FlutterFlowTheme.of(context).alternate,
                                icon: Icon(
                                  Icons.navigate_next_rounded,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 20.0,
                                ),
                                onPressed: (_model.pages?.hasNextPage ==
                                            false ||
                                        _isLoadingNextPage)
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isLoadingNextPage = true;
                                        });

                                        try {
                                          _model.apiResultNextPages =
                                              await ProductsGroup
                                                  .postListProductByCodPrecioCall
                                                  .call(
                                            token:
                                                FFAppState().infoSeller.token,
                                            pageNumber:
                                                _model.pages!.currentPage + 1,
                                            pageSize: 10,
                                            filter: _model
                                                .txtBuscarTextController.text,
                                            codprecio: FFAppState()
                                                .dataCliente
                                                .codprecio,
                                          );
                                        } catch (e) {
                                          print('Error loading next page: $e');
                                        } finally {
                                          if (mounted) {
                                            setState(() {
                                              _isLoadingNextPage = false;
                                            });
                                          }
                                        }

                                        if ((_model.apiResultNextPages
                                                ?.succeeded ??
                                            true)) {
                                          _model.resultadoNextPage =
                                              await actions
                                                  .actualizarListaProductosCache(
                                            (getJsonField(
                                              (_model.apiResultNextPages
                                                      ?.jsonBody ??
                                                  ''),
                                              r'''$.data.data''',
                                              true,
                                            )!
                                                        .toList()
                                                        .map<DataProductStruct?>(
                                                            DataProductStruct
                                                                .maybeFromMap)
                                                        .toList()
                                                    as Iterable<
                                                        DataProductStruct?>)
                                                .withoutNulls
                                                .toList(),
                                            FFAppState().shoppingCart.toList(),
                                            _model.buscar,
                                          );
                                          FFAppState().productList = _model
                                              .resultadoNextPage!
                                              .toList()
                                              .cast<DataProductStruct>();
                                          safeSetState(() {});
                                          _model.pages =
                                              DataPageStruct.maybeFromMap(
                                                  getJsonField(
                                            (_model.apiResultNextPages
                                                    ?.jsonBody ??
                                                ''),
                                            r'''$.data''',
                                          ));
                                          safeSetState(() {});
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Error'),
                                                content: Text(getJsonField(
                                                  (_model.apiResultNextPages
                                                          ?.jsonBody ??
                                                      ''),
                                                  r'''$.data''',
                                                ).toString()),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        safeSetState(() {});
                                      },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
