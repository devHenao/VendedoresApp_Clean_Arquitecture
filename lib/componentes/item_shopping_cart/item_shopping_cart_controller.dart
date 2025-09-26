import 'package:flutter/material.dart';
import 'package:app_vendedores/modules/cart/domain/entities/cart_item.dart';

class ItemShoppingCartController extends ChangeNotifier {
  ItemShoppingCartController({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) {
    _quantity = item.cantidad;
  }

  // Dependencies & Initial State
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  // Internal State
  late int _quantity;

  // Getters
  int get quantity => _quantity;

  void increment() {
    _quantity++;
    onQuantityChanged(_quantity);
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      onQuantityChanged(_quantity);
      notifyListeners();
    } else {
      // If quantity becomes 0 or less, trigger remove
      remove();
    }
  }

  void updateQuantityFromText(String text) {
    int newQuantity = int.tryParse(text) ?? 0;

    if (newQuantity < 0) {
      newQuantity = 0;
    }

    if (newQuantity == 0) {
      remove();
    } else {
      _quantity = newQuantity;
      onQuantityChanged(_quantity);
      notifyListeners();
    }
  }

  void remove() {
    onRemove();
    // No need to notifyListeners here as the parent will remove the widget
  }
}
