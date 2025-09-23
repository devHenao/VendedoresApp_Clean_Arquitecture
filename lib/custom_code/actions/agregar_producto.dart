// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DataProductStruct>> agregarProducto(
  List<DataProductStruct> listaProductos,
  DataProductStruct producto,
  bool tipo,
) async {
  // Add your function code here!
  print(tipo);
  producto.selected = tipo;
  if (tipo == true) {
    listaProductos.add(producto);
  } else {
    listaProductos.removeWhere((p) => p.codproduc == producto.codproduc);
  }
  print(listaProductos);
  return listaProductos.toList();
}
