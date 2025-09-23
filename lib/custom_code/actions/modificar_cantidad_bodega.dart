// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DetailProductStruct>> modificarCantidadBodega(
  DetailProductStruct producto,
  List<DetailProductStruct> listProductBodegas,
  double? countValue,
) async {
  // Add your function code here!
  if (listProductBodegas.length == 0) {
    producto.cantidad = countValue;
    listProductBodegas.add(producto);
    return listProductBodegas ?? [];
  }
  final productold =
      listProductBodegas.firstWhere((p) => p.codigo == producto.codigo);
  productold.cantidad = countValue;
  producto.cantidad = countValue;

  return listProductBodegas;
}
