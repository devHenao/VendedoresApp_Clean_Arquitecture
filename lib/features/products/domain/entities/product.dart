import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String codproduc;
  final double precio;
  final String descripcio;
  final double descuento1;
  final double descuento2;
  final double saldo;
  final String unidadmed;
  final String codbarras;
  final String codtariva;
  final double iva;
  final bool selected;
  final double cantidad;

  const Product({
    required this.codproduc,
    required this.precio,
    required this.descripcio,
    required this.descuento1,
    required this.descuento2,
    required this.saldo,
    required this.unidadmed,
    required this.codbarras,
    required this.codtariva,
    required this.iva,
    required this.selected,
    required this.cantidad,
  });

  @override
  List<Object?> get props => [
        codproduc,
        precio,
        descripcio,
        descuento1,
        descuento2,
        saldo,
        unidadmed,
        codbarras,
        codtariva,
        iva,
        selected,
        cantidad,
      ];
}
