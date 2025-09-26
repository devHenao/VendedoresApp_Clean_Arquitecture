import 'package:flutter/material.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';

class ProductDetailController extends ChangeNotifier {
  ProductDetailController({
    required this.codprecio,
    required this.codproduc,
    required this.appState,
  }) {
    _loadProductDetails();
  }

  // Dependencies
  final String codprecio;
  final String codproduc;
  final FFAppState appState;

  // Internal State
  List<DetailProductStruct> _warehouses = [];
  bool _isLoading = true;
  String? _errorMessage;
  double? _quantityForCallback;

  // Getters for the UI
  List<DetailProductStruct> get warehouses => _warehouses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double? get quantityForCallback => _quantityForCallback;

  Future<void> _loadProductDetails() async {
    _isLoading = true;
    notifyListeners();

    final apiResult = await ProductsGroup.getListStorageByProductCall.call(
      token: appState.infoSeller.token,
      codprecio: codprecio,
      codproduc: codproduc,
    );

    if (apiResult.succeeded) {
      final apiData = getJsonField(apiResult.jsonBody, r'''$.data''', true);
      final initialList = (apiData as List?)
          ?.map((e) => DetailProductStruct.maybeFromMap(e)!)
          .toList() ??
          [];

      final updatedList = await actions.actualizarListaProductosBodega(
        initialList,
        appState.shoppingCart.toList(),
      );
      _warehouses = updatedList ?? [];
    } else {
      _errorMessage = getJsonField(apiResult.jsonBody, r'''$.message''').toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> handleQuantityChanged(DetailProductStruct item, double? newQuantity) async {
    final updatedList = await actions.modificarCantidadBodega(
      item,
      _warehouses,
      newQuantity,
    );
    _warehouses = updatedList ?? [];

    final updatedCart = await actions.agregarProductoCarrito(
      appState.shoppingCart.toList(),
      _createDataProductStruct(item),
      item.bodega,
      item.codcc,
      item.codlote,
      item.cantidad,
    );
    appState.shoppingCart = updatedCart ?? [];

    final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
    appState.store = updatedStore ?? [];

    if (item.bodega == appState.infoSeller.storageDefault) {
      _quantityForCallback = newQuantity;
    }

    notifyListeners();
  }

  Future<void> handleRemoveFromWarehouse(DetailProductStruct item) async {
    final updatedCart = await actions.eliminarProductoCarrito(
      item.bodega,
      item.codcc,
      item.codlote,
      item.codigo,
      appState.shoppingCart.toList(),
    );
    appState.shoppingCart = updatedCart ?? [];

    final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
    appState.store = updatedStore ?? [];

    notifyListeners();
  }

  Future<void> handleSelectFromWarehouse(DetailProductStruct item, bool state) async {
    if (state) {
      final updatedCart = await actions.agregarProductoCarrito(
        appState.shoppingCart.toList(),
        _createDataProductStruct(item),
        item.bodega,
        item.codcc,
        item.codlote,
        item.cantidad,
      );
      appState.shoppingCart = updatedCart ?? [];

      final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
      appState.store = updatedStore ?? [];
    }
    notifyListeners();
  }

  DataProductStruct _createDataProductStruct(DetailProductStruct item) {
    return DataProductStruct(
      codproduc: item.codigo,
      precio: item.precio,
      descripcio: item.descripcio,
      selected: true,
      saldo: item.saldo,
      cantidad: item.cantidad,
      unidadmed: item.unidadmed,
      codtariva: item.codtariva,
      iva: item.iva,
      codbarras: '',
    );
  }
}