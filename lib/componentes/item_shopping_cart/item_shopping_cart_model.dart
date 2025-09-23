import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'item_shopping_cart_widget.dart' show ItemShoppingCartWidget;

class ItemShoppingCartModel extends FlutterFlowModel<ItemShoppingCartWidget> {
  ///  Local state fields for this component.

  double? contador = 1.0;

  ///  State fields for stateful widgets in this component.

  // State field(s) for amountCart widget.
  FocusNode? amountCartFocusNode;
  TextEditingController? amountCartTextController;
  String? Function(BuildContext, String?)? amountCartTextControllerValidator;
  // Stores the stock limit for the specific warehouse of the cart item.
  double? stockLimit;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    amountCartFocusNode?.dispose();
    amountCartTextController?.dispose();
  }
}
