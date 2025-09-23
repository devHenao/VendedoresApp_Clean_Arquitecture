// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DataProductStruct>> agregarProducto(
  List<DataProductStruct> listaProductos,
  DataProductStruct producto,
  bool tipo,
) async {
  // Add your function code here!
  producto.selected = tipo;
  if (tipo == true) {
    listaProductos.add(producto);
  } else {
    listaProductos.removeWhere((p) => p.codproduc == producto.codproduc);
  }
  return listaProductos.toList();
}
