import 'package:app_vendedores/modules/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.codigo,
    required super.descripcio,
    required super.precio,
    required super.cantidad,
    required super.bodega,
    required super.codcc,
    required super.codlote,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      codigo: json['codigo'],
      descripcio: json['descripcio'],
      precio: json['precio'].toDouble(),
      cantidad: json['cantidad'],
      bodega: json['bodega'],
      codcc: json['codcc'],
      codlote: json['codlote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descripcio': descripcio,
      'precio': precio,
      'cantidad': cantidad,
      'bodega': bodega,
      'codcc': codcc,
      'codlote': codlote,
    };
  }

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      codigo: entity.codigo,
      descripcio: entity.descripcio,
      precio: entity.precio,
      cantidad: entity.cantidad,
      bodega: entity.bodega,
      codcc: entity.codcc,
      codlote: entity.codlote,
    );
  }
}
