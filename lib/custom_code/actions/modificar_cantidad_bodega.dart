// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
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
