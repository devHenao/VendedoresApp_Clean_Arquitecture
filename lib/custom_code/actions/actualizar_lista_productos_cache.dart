// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';

// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DataProductStruct>> actualizarListaProductosCache(
  List<DataProductStruct> newLista,
  List<DetailProductStruct> oldList,
  String? searched,
) async {
  // Iteramos sobre cada producto en la lista antigua
  for (var oldItem in oldList) {
    // Verificamos si el producto ya existe en la nueva lista considerando solo el código del producto
    var index =
        newLista.indexWhere((newItem) => newItem.codproduc == oldItem.codigo);

    // Evaluamos si la bodega por defecto coincide con la bodega del producto antiguo
    bool isSelected = (oldItem.bodega == "BOUTIQUE");

    if (index != -1) {
      // Si el producto ya existe en la lista, actualizamos sus propiedades
      newLista[index] = DataProductStruct(
        codproduc: oldItem.codigo,
        descripcio: oldItem.descripcio,
        precio: oldItem.precio,
        cantidad: isSelected
            ? oldItem.cantidad
            : newLista[index]
                .cantidad, // Mantener cantidad si no es seleccionado
        selected: isSelected || newLista[index].selected,
        unidadmed: oldItem.unidadmed,
        codtariva: oldItem.codtariva,
        iva: oldItem.iva,
      );
    } else {
      // Si no existe, lo añadimos como un nuevo producto
      newLista.add(DataProductStruct(
        codproduc: oldItem.codigo,
        descripcio: oldItem.descripcio,
        precio: oldItem.precio,
        cantidad: oldItem.cantidad,
        selected: isSelected,
        unidadmed: oldItem.unidadmed,
        codtariva: oldItem.codtariva,
        iva: oldItem.iva,
      ));
    }
  }

  // Filtramos la lista solo si se ingresaron parámetros de búsqueda
  if (searched != null && searched.isNotEmpty) {
    final filteredList = newLista.where((producto) {
      final matchCodigo = producto.codproduc.contains(searched);
      final matchNombre =
          producto.descripcio.toLowerCase().contains(searched.toLowerCase());
      return matchCodigo || matchNombre; // El filtro considera ambos casos
    }).toList();

    // Retornamos la lista filtrada
    return filteredList;
  }

  // Si no hay parámetros de búsqueda, devolvemos todos los productos
  return newLista;
}
