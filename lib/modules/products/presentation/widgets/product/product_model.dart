import '../../../../../core/backend/api_requests/_/api_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'product_widget.dart' show ProductWidget;

class ProductModel extends FlutterFlowModel<ProductWidget> {
  ///  Local state fields for this component.

  double? cantidad = 0.0;

  double? contador = 0.0;
  // Stores the specific stock for the seller's default bodega.
  double? saldoBodegaVendedor;

  ///  State fields for stateful widgets in this component.

  // State field(s) for amount widget.
  FocusNode? amountFocusNode;
  TextEditingController? amountTextController;
  String? Function(BuildContext, String?)? amountTextControllerValidator;
  // Stores action output result for [Backend Call - API (getListStorageByProduct)] action in Product widget.
  ApiCallResponse? apiResultDetailProduct;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    amountFocusNode?.dispose();
    amountTextController?.dispose();
  }
}
