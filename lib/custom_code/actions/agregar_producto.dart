// Automatic FlutterFlow imports
import '../../core/backend/schema/structs/index.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DataProductStruct>> agregarProducto(
  List<DataProductStruct> listaProductos,
  DataProductStruct producto,
  bool tipo,
) async {
  // Toggle selection in the working list, ensuring uniqueness by codproduc
  final List<DataProductStruct> nuevaLista = List.from(listaProductos);

  final index = nuevaLista.indexWhere((p) => p.codproduc == producto.codproduc);
  final updated = DataProductStruct(
    codproduc: producto.codproduc,
    descripcio: producto.descripcio,
    precio: producto.precio,
    cantidad: producto.cantidad,
    selected: tipo,
    unidadmed: producto.unidadmed,
    codtariva: producto.codtariva,
    iva: producto.iva,
    codbarras: producto.codbarras,
    descuento1: producto.descuento1,
    descuento2: producto.descuento2,
    saldo: producto.saldo,
  );

  if (tipo) {
    if (index >= 0) {
      nuevaLista[index] = updated;
    } else {
      nuevaLista.add(updated);
    }
  } else {
    if (index >= 0) {
      nuevaLista.removeAt(index);
    }
  }

  return nuevaLista;
}
