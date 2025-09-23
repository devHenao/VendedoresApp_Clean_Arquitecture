// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DetailProductStruct>> agregarProductoCarrito(
  List<DetailProductStruct> listaCarrito,
  DataProductStruct producto,
  String bodega,
  String codcc,
  String codlote,
  double? cantidad,
) async {
  // Add your function code here!
  List<DetailProductStruct> nuevaLista = List.from(listaCarrito);

  // Buscar si el producto ya está en el carrito
  int index = nuevaLista.indexWhere((a) =>
      a.bodega == bodega &&
      a.codcc == codcc &&
      a.codlote == codlote &&
      a.codigo == producto.codproduc);

  if (index != -1) {
    // Si ya existe, actualizar la cantidad
    nuevaLista[index] = DetailProductStruct(
      precio: nuevaLista[index].precio,
      codigo: nuevaLista[index].codigo,
      descripcio: nuevaLista[index].descripcio,
      bodega: nuevaLista[index].bodega,
      codcc: nuevaLista[index].codcc,
      codlote: nuevaLista[index].codlote,
      saldo: nuevaLista[index].saldo,
      cantidad: cantidad, // Se actualiza la cantidad
      unidadmed: nuevaLista[index].unidadmed,
      codtariva: nuevaLista[index].codtariva,
      iva: nuevaLista[index].iva,
    );
  } else {
    // Si no existe, agregarlo a la lista
    nuevaLista.add(DetailProductStruct(
      precio: producto.precio,
      codigo: producto.codproduc,
      descripcio: producto.descripcio,
      bodega: bodega,
      codcc: codcc,
      codlote: codlote,
      saldo: producto.saldo,
      cantidad: cantidad,
      unidadmed: producto.unidadmed,
      codtariva: producto.codtariva,
      iva: producto.iva,
    ));
  }

  return nuevaLista;
}
