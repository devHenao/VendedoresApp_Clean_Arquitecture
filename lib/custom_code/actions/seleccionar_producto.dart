// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
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
