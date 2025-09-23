// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DataProductStruct>> modificarCantidad(
  DataProductStruct product,
  List<DataProductStruct> listProductCache,
  double? countValue,
) async {
  // Add your function code here!
  if (listProductCache.isEmpty) {
    product.cantidad = countValue;
    return [
      ...listProductCache,
      product
    ]; // Devuelve una nueva lista con el producto agregado
  }

  // Buscar el producto en la lista
  int index =
      listProductCache.indexWhere((p) => p.codproduc == product.codproduc);

  if (index != -1) {
    // Si el producto ya existe en la lista, actualizar su cantidad
    listProductCache[index] = DataProductStruct(
      codproduc: listProductCache[index].codproduc,
      cantidad: countValue,
      precio: listProductCache[index].precio,
      descripcio: listProductCache[index].descripcio,
      saldo: listProductCache[index].saldo,
      unidadmed: listProductCache[index].unidadmed,
      codtariva: listProductCache[index].codtariva,
      iva: listProductCache[index].iva,
    );
  } else {
    // Si no existe, agregarlo
    product.cantidad = countValue;
    listProductCache.add(product);
  }

  return List.from(listProductCache);
}
