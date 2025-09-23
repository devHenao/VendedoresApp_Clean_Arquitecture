// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DetailProductStruct>> actualizarListaProductosBodega(
  List<DetailProductStruct> newLista,
  List<DetailProductStruct> oldList,
) async {
  // Add your function code here!
  print(newLista);
  print(oldList);
  print("==============================--**");
  for (var oldItem in oldList) {
    var index = newLista.indexWhere((newItem) =>
        newItem.codigo == oldItem.codigo &&
        newItem.bodega == oldItem.bodega &&
        newItem.codcc == oldItem.codcc &&
        newItem.codlote == oldItem.codlote);
    if (index != -1) {
      newLista[index].cantidad = oldItem.cantidad;
      //newLista[index] = DetailProductStruct(cantidad: oldItem.cantidad);
    }
  }
  print(newLista);
  print(oldList);
  return newLista;
}
