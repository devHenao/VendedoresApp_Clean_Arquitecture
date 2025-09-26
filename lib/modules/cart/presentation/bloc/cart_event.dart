import 'package:equatable/equatable.dart';
import 'package:app_vendedores/modules/cart/domain/entities/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddItem extends CartEvent {
  final CartItem item;

  const AddItem(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveItem extends CartEvent {
  final String itemCode;

  const RemoveItem(this.itemCode);

  @override
  List<Object> get props => [itemCode];
}

class UpdateItemQuantity extends CartEvent {
  final String itemCode;
  final int quantity;

  const UpdateItemQuantity(this.itemCode, this.quantity);

  @override
  List<Object> get props => [itemCode, quantity];
}

class ClearCart extends CartEvent {}

class PlaceOrder extends CartEvent {
  final String nit;

  const PlaceOrder(this.nit);

  @override
  List<Object> get props => [nit];
}
