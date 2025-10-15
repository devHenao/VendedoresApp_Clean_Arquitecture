import '../../../../../core/backend/api_requests/_/api_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'product_widget.dart' show ProductWidget;

class ProductModel extends FlutterFlowModel<ProductWidget> {
  double? cantidad = 0.0;
  double? contador = 0.0;
  double? saldoBodegaVendedor;
  FocusNode? amountFocusNode;
  TextEditingController? amountTextController;
  String? Function(BuildContext, String?)? amountTextControllerValidator;
  ApiCallResponse? apiResultDetailProduct;

  @override
  void initState(BuildContext context) {
    amountFocusNode ??= FocusNode();
    amountTextController ??= TextEditingController();
  }

  @override
  void dispose() {
    amountFocusNode?.dispose();
    amountTextController?.dispose();
  }
}
