import 'package:equatable/equatable.dart';
import 'package:app_vendedores/features/cart/domain/entities/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;

  const CartLoaded({required this.items, required this.total});

  @override
  List<Object> get props => [items, total];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}

class OrderPlacementSuccess extends CartState {}

class OrderPlacementFailure extends CartState {
  final String message;

  const OrderPlacementFailure({required this.message});

  @override
  List<Object> get props => [message];
}
