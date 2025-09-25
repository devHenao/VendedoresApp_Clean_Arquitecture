import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';

class ItemProductDetailController extends ChangeNotifier {
  ItemProductDetailController({
    required this.item,
    required this.initialQuantity,
    required this.onQuantityChanged,
    required this.onSelected,
    required this.onRemoved,
  }) {
    _quantity = initialQuantity;
  }

  // Dependencies
  final DetailProductStruct item;
  final double initialQuantity;
  final Future Function(double) onQuantityChanged;
  final Future Function(bool) onSelected;
  final Future Function() onRemoved;

  // Internal State
  late double _quantity;

  // Getters
  double get quantity => _quantity;
  bool get isSubtractDisabled => _quantity <= 0;
  bool get isAddDisabled => item.saldo <= 0 || _quantity >= item.saldo;

  Future<void> increment() async {
    if (isAddDisabled) return;
    _quantity++;
    await onQuantityChanged(_quantity);
    notifyListeners();
  }

  Future<void> decrement() async {
    if (isSubtractDisabled) return;
    _quantity--;
    await onQuantityChanged(_quantity);
    notifyListeners();
  }

  Future<void> remove() async {
    _quantity = 0;
    await onSelected(false);
    await onQuantityChanged(0.0);
    await onRemoved();
    notifyListeners();
  }

  Future<void> updateQuantityFromText(String text) async {
    double newQuantity = double.tryParse(text) ?? 0.0;
    final maxStock = item.saldo;

    if (newQuantity > maxStock) {
      newQuantity = maxStock;
    }
    if (newQuantity < 0) {
      newQuantity = 0.0;
    }

    _quantity = newQuantity;
    await onQuantityChanged(_quantity);
    notifyListeners();
  }
}
