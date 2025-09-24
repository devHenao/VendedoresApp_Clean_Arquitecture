// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<DataProductStruct> seleccionarProducto(
  DataProductStruct lista,
  String codigo,
) async {
  // Toggle the selected state of the product
  return DataProductStruct(
    selected: !lista.selected,
    codproduc: lista.codproduc,
    // Make sure to include all other required fields from the original lista
    descripcio: lista.descripcio,
    precio: lista.precio,
    // Add other fields from DataProductStruct as needed
  );
}
