import '../../../../../core/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'item_product_detail_widget.dart' show ItemProductDetailWidget;
import 'package:flutter/material.dart';

class ItemProductDetailModel extends FlutterFlowModel<ItemProductDetailWidget> {
  ///  Local state fields for this component.

  DetailProductStruct? dataBodega;
  void updateDataBodegaStruct(Function(DetailProductStruct) updateFn) {
    updateFn(dataBodega ??= DetailProductStruct());
  }

  double? contador = 0.0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for amount widget.
  FocusNode? amountFocusNode;
  TextEditingController? amountTextController;
  String? Function(BuildContext, String?)? amountTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    amountFocusNode?.dispose();
    amountTextController?.dispose();
  }
}
