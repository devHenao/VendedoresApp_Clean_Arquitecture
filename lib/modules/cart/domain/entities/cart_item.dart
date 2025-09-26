import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String codigo;
  final String descripcio;
  final double precio;
  final int cantidad;
  final String bodega;
  final String codcc;
  final String codlote;

  const CartItem({
    required this.codigo,
    required this.descripcio,
    required this.precio,
    required this.cantidad,
    required this.bodega,
    required this.codcc,
    required this.codlote,
  });

  @override
  List<Object?> get props => [codigo, descripcio, precio, cantidad, bodega, codcc, codlote];

  CartItem copyWith({
    int? cantidad,
  }) {
    return CartItem(
      codigo: codigo,
      descripcio: descripcio,
      precio: precio,
      cantidad: cantidad ?? this.cantidad,
      bodega: bodega,
      codcc: codcc,
      codlote: codlote,
    );
  }
}
