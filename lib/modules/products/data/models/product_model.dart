import 'package:app_vendedores/modules/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.codproduc,
    required super.precio,
    required super.descripcio,
    required super.descuento1,
    required super.descuento2,
    required super.saldo,
    required super.unidadmed,
    required super.codbarras,
    required super.codtariva,
    required super.iva,
    required super.selected,
    required super.cantidad,
  });

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
