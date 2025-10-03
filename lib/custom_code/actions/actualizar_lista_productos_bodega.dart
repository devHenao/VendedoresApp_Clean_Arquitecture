// Automatic FlutterFlow imports
import '../../core/backend/schema/structs/index.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DetailProductStruct>> actualizarListaProductosBodega(
  List<DetailProductStruct> newLista,
  List<DetailProductStruct> oldList,
) async {
  // Add your function code here!
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
  return newLista;
}
