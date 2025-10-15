import 'package:flutter/material.dart';
import '../../../../../core/backend/api_requests/api_calls.dart';
import '../../../../../core/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;

class UiMessage {
  final String message;
  final bool isError;
  UiMessage(this.message, {this.isError = false});
}

class ProductController extends ChangeNotifier {
  ProductController({
    required this.productItem,
    required this.initialCantidad,
    required this.isInitiallySelected,
    required this.infoSeller,
    required this.dataCliente,
    required this.onProductSelected,
    required this.onQuantityUpdated,
    required this.onProductRemoved,
  }) {
    init();
  }

  // Dependencies
  final DataProductStruct? productItem;
  final double initialCantidad;
  final bool isInitiallySelected;
  final DataSellerStruct infoSeller;
  final DataClienteStruct dataCliente;
  final Future Function(bool) onProductSelected;
  final Future Function(double) onQuantityUpdated;
  final Future Function() onProductRemoved;

  // Internal State
  double _contador = 0;
  double? _saldoBodegaVendedor;
  bool _isLoading = false;
  UiMessage? _uiMessage;

  // Getters
  double get contador => _contador;
  double? get saldoBodegaVendedor => _saldoBodegaVendedor;
  bool get isLoading => _isLoading;
  UiMessage? get uiMessage => _uiMessage;

  void init() {
    _contador = initialCantidad > 0 ? initialCantidad : (isInitiallySelected ? 0.0 : 1.0);
    if (isInitiallySelected) {
      _fetchStockDetails();
    }
  }

  Future<void> _fetchStockDetails() async {
    _setLoading(true);
    try {
      final apiResult = await ProductsGroup.getListStorageByProductCall.call(
        token: infoSeller.token,
        codprecio: dataCliente.codprecio,
        codproduc: productItem?.codproduc,
      );
      if (apiResult.succeeded) {
        final bodegas = (getJsonField(apiResult.jsonBody, r'''$.data''', true) as List?)
            ?.map((e) => DetailProductStruct.maybeFromMap(e)!)
            .toList() ?? [];
        _saldoBodegaVendedor = functions.getSaldoPorBodega(infoSeller.storageDefault, bodegas);
      } else {
        _setMessage('No se pudo verificar el stock.', isError: true);
      }
    } catch (e) {
      _setMessage('Error al verificar el stock: $e', isError: true);
    }
    _setLoading(false);
  }

  Future<void> addToCart() async {
    _setLoading(true);
    await _fetchStockDetails();
    if (_saldoBodegaVendedor != null && _saldoBodegaVendedor! > 0) {
      _contador = 1.0;
      await onProductSelected(true);
      await onQuantityUpdated(1.0);
      _setMessage('¡Producto agregado al carrito!');
    } else {
      _setMessage('La bodega ${infoSeller.storageDefault} no tiene saldo.', isError: true);
    }
    _setLoading(false);
  }

  Future<void> removeFromCart() async {
    _contador = 0.0;
    await onProductSelected(false);
    await onQuantityUpdated(0.0);
    await onProductRemoved();
    _setMessage('Producto eliminado del carrito.', isError: true);
    notifyListeners();
  }

  Future<void> increment() async {
    if ((_contador + 1) <= (_saldoBodegaVendedor ?? double.infinity)) {
      _contador++;
      await onQuantityUpdated(_contador);
      notifyListeners();
    } else {
      _setMessage('No se puede superar el saldo de la bodega.', isError: true);
    }
  }

  Future<void> decrement() async {
    if (_contador > 1) {
      _contador--;
      await onQuantityUpdated(_contador);
      notifyListeners();
    } else {
      await removeFromCart();
    }
  }

  Future<void> updateQuantityFromText(String text) async {
    final enteredAmount = double.tryParse(text) ?? 0.0;
    final maxStock = _saldoBodegaVendedor ?? double.infinity;
    if (enteredAmount > maxStock) {
      _setMessage('No se puede superar el saldo de la bodega.', isError: true);
      _contador = maxStock;
    } else {
      _contador = enteredAmount >= 0 ? enteredAmount : 0;
    }
    await onQuantityUpdated(_contador);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    if (_isLoading == loading) return;
    _isLoading = loading;
    notifyListeners();
  }

  void _setMessage(String message, {bool isError = false}) {
    _uiMessage = UiMessage(message, isError: isError);
    notifyListeners();
  }

  void clearMessage() {
    if (_uiMessage == null) return;
    _uiMessage = null;
    notifyListeners();
  }
}

