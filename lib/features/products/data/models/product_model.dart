import 'package:app_vendedores/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String codproduc,
    required double precio,
    required String descripcio,
    required double descuento1,
    required double descuento2,
    required double saldo,
    required String unidadmed,
    required String codbarras,
    required String codtariva,
    required double iva,
    required bool selected,
    required double cantidad,
  }) : super(
          codproduc: codproduc,
          precio: precio,
          descripcio: descripcio,
          descuento1: descuento1,
          descuento2: descuento2,
          saldo: saldo,
          unidadmed: unidadmed,
          codbarras: codbarras,
          codtariva: codtariva,
          iva: iva,
          selected: selected,
          cantidad: cantidad,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      codproduc: json['codproduc'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      descripcio: json['descripcio'] ?? '',
      descuento1: (json['descuento1'] as num?)?.toDouble() ?? 0.0,
      descuento2: (json['descuento2'] as num?)?.toDouble() ?? 0.0,
      saldo: (json['saldo'] as num?)?.toDouble() ?? 0.0,
      unidadmed: json['unidadmed'] ?? '',
      codbarras: json['codbarras'] ?? '',
      codtariva: json['codtariva'] ?? '',
      iva: (json['iva'] as num?)?.toDouble() ?? 0.0,
      selected: json['selected'] ?? false,
      cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codproduc': codproduc,
      'precio': precio,
      'descripcio': descripcio,
      'descuento1': descuento1,
      'descuento2': descuento2,
      'saldo': saldo,
      'unidadmed': unidadmed,
      'codbarras': codbarras,
      'codtariva': codtariva,
      'iva': iva,
      'selected': selected,
      'cantidad': cantidad,
    };
  }
}
