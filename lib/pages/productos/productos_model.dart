import 'package:app_vendedores/backend/api_requests/_/api_manager.dart';

import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/menu/menu_widget.dart';
import '/componentes/product/product_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'productos_widget.dart' show ProductosWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProductosModel extends FlutterFlowModel<ProductosWidget> {
  ///  Local state fields for this page.

  String? buscar;

  DataPageStruct? pages;
  void updatePagesStruct(Function(DataPageStruct) updateFn) {
    updateFn(pages ??= DataPageStruct());
  }

  bool hasProduct = true;

  ///  State fields for stateful widgets in this page.

  // Model for Menu component.
  late MenuModel menuModel;
  // State field(s) for txtBuscar widget.
  FocusNode? txtBuscarFocusNode;
  TextEditingController? txtBuscarTextController;
  String? Function(BuildContext, String?)? txtBuscarTextControllerValidator;
  // Stores action output result for [Backend Call - API (postListProductByCodPrecio)] action in txtBuscar widget.
  ApiCallResponse? apiResultaListProductsSubmit;
  // Stores action output result for [Custom Action - actualizarListaProductosCache] action in txtBuscar widget.
  List<DataProductStruct>? resultadoProductoCacheSubmit;
  // Stores action output result for [Backend Call - API (postListProductByCodPrecio)] action in IconButton widget.
  ApiCallResponse? apiResultaListProductsBoton;
  // Stores action output result for [Custom Action - actualizarListaProductosCache] action in IconButton widget.
  List<DataProductStruct>? resultadoProductoCacheBoton;
  // Stores action output result for [Backend Call - API (postListProductByCodPrecio)] action in IconButton widget.
  ApiCallResponse? apiResultaListProductsBotonVacio;
  // Stores action output result for [Custom Action - actualizarListaProductosCache] action in IconButton widget.
  List<DataProductStruct>? resultadoProductoCacheBotonVacio;
  var codigoBarras = '';
  // Stores action output result for [Backend Call - API (postListProductByCodPrecio)] action in IconButton widget.
  ApiCallResponse? apiResultCodeScan;
  // Stores action output result for [Custom Action - actualizarListaProductosCache] action in IconButton widget.
  List<DataProductStruct>? resultadoProductoCacheScan;
  // Models for Product dynamic component.
  late FlutterFlowDynamicModels<ProductModel> productModels;
  // Stores action output result for [Custom Action - seleccionarProducto] action in Product widget.
  DataProductStruct? result;
  // Stores action output result for [Custom Action - agregarProducto] action in Product widget.
  List<DataProductStruct>? addProducto;
  // Stores action output result for [Custom Action - agregarProductoCarrito] action in Product widget.
  List<DetailProductStruct>? listaAgregarProducto;
  // Stores action output result for [Custom Action - modificarCantidad] action in Product widget.
  List<DataProductStruct>? resultCache;
  // Stores action output result for [Custom Action - agregarProductoCarrito] action in Product widget.
  List<DetailProductStruct>? listaCarrito;
  // Stores action output result for [Custom Action - eliminarProductoCarrito] action in Product widget.
  List<DetailProductStruct>? resultadoEliminarProducto;
  // Stores action output result for [Backend Call - API (postListProductByCodPrecio)] action in btnBack widget.
  ApiCallResponse? apiResultBackPage;
  // Stores action output result for [Custom Action - actualizarListaProductosCache] action in btnBack widget.
  List<DataProductStruct>? resultadoBackPage;
  // Stores action output result for [Backend Call - API (postListProductByCodPrecio)] action in btnNext widget.
  ApiCallResponse? apiResultNextPages;
  // Stores action output result for [Custom Action - actualizarListaProductosCache] action in btnNext widget.
  List<DataProductStruct>? resultadoNextPage;
  List<DetailProductStruct>? updatedStore;
  List<DetailProductStruct>? updatedStore2;
  List<DetailProductStruct>? updatedStore3;

  PagingController<ApiPagingParams, dynamic> setPagingController(
    BuildContext context,
    Future<ApiCallResponse> Function(ApiPagingParams) apiCall,
  ) {
    final controller = PagingController<ApiPagingParams, dynamic>(
      firstPageKey: ApiPagingParams(
        nextPageNumber: 0,
        numItems: 0,
        lastResponse: null,
      ),
    );
    controller.addPageRequestListener((nextPageMarker) {
      apiCall(nextPageMarker).then((listViewResponse) {
        final responseData = getJsonField(
          (listViewResponse.jsonBody ?? ''),
          r'''$.data''',
        );
        final pageItems = getJsonField(
          responseData,
          r'''$.data''',
          true,
        ) as List;
        final hasNextPage = getJsonField(
          responseData,
          r'''$.hasNextPage''',
        ) as bool;

        if (!hasNextPage) {
          controller.appendLastPage(pageItems);
        } else {
          final nextPage = getJsonField(
            responseData,
            r'''$.nextPage''',
          ) as int;
          controller.appendPage(
              pageItems,
              ApiPagingParams(
                nextPageNumber: nextPage,
                numItems: 0,
                lastResponse: null,
              ));
        }
      }).catchError((error) {
        print('Error fetching page: $error');
        controller.error = error;
      });
    });
    return controller;
  }

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
    productModels = FlutterFlowDynamicModels(() => ProductModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    txtBuscarFocusNode?.dispose();
    txtBuscarTextController?.dispose();

    productModels.dispose();
  }
}
