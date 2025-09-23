// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DataProductStruct> seleccionarProducto(
  DataProductStruct lista,
  String codigo,
) async {
  // Add your function code here!
  if (lista == null || codigo == null) return lista;
  lista = DataProductStruct(
    selected: !lista.selected,
    codproduc: lista.codproduc,
  );
  return lista;
}
