// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DetailProductStruct>> deleteProduct(
  List<DetailProductStruct> list,
  String code,
) async {
  // Add your function code here!
  // Filtra la lista para excluir el producto con el `codproduc` proporcionado
  List<DetailProductStruct> filteredList =
      list.where((product) => product.codigo != code).toList();

  return filteredList;
}
