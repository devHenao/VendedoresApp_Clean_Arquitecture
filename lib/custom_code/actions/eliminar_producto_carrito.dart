// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DetailProductStruct>> eliminarProductoCarrito(
  String bodega,
  String codcc,
  String codlote,
  String codigo,
  List<DetailProductStruct> listaCarrito,
) async {
  // Add your function code here!
  try {
    listaCarrito.removeWhere((item) =>
        item.bodega == bodega &&
        item.codcc == codcc &&
        item.codlote == codlote &&
        item.codigo == codigo);
    return listaCarrito;
  } catch (e) {
    return listaCarrito;
  }
}
