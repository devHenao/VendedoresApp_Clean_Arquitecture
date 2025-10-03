import '../../core/backend/schema/structs/index.dart';

Future<List<DetailProductStruct>> updateStoreQuantity(
  List<DetailProductStruct> shoppingCart,
) async {
  Map<String, double> productQuantities = {};

  // Calculate total quantity for each product in the shopping cart
  for (var item in shoppingCart) {
    if (productQuantities.containsKey(item.codigo)) {
      productQuantities[item.codigo] = productQuantities[item.codigo]! + item.cantidad;
    } else {
      productQuantities[item.codigo] = item.cantidad;
    }
  }

  List<DetailProductStruct> newStore = [];
  productQuantities.forEach((codigo, cantidad) {
    newStore.add(DetailProductStruct(codigo: codigo, cantidad: cantidad));
  });

  return newStore;
}
