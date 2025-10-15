import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final String codprecio;
  final String codproduc;
  final double? cantidad;

  const LoadProductDetail({
    required this.codprecio,
    required this.codproduc,
    this.cantidad,
  });

  @override
  List<Object?> get props => [codprecio, codproduc, cantidad];
}

class UpdateQuantity extends ProductDetailEvent {
  final String item;
  final double quantity;

  const UpdateQuantity({
    required this.item,
    required this.quantity,
  });

  @override
  List<Object?> get props => [item, quantity];
}

class RemoveFromWarehouse extends ProductDetailEvent {
  final String item;

  const RemoveFromWarehouse({
    required this.item,
  });

  @override
  List<Object?> get props => [item];
}

class SelectFromWarehouse extends ProductDetailEvent {
  final String item;
  final bool selected;

  const SelectFromWarehouse({
    required this.item,
    required this.selected,
  });

  @override
  List<Object?> get props => [item, selected];
}
