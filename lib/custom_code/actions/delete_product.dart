// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DetailProductStruct>> deleteProduct(
  List<DetailProductStruct> list,
  String code,
) async {
  // Add your function code here!
  // Filtra la lista para excluir el producto con el `codproduc` proporcionado
  List<DetailProductStruct> filteredList =
      list.where((product) => product.codigo != code).toList();

  return filteredList;
}
