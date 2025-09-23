import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  // Reset all app state when user logs out
  void resetAppState() {
    // Reset all the state variables to their initial values
    _Nit = '';
    _Email = '';
    _Remember = false;
    _infoSeller = DataSellerStruct();
    _itemId = -1; // Set to -1 to indicate no client selected
    
    // Create a completely empty client structure
    _dataCliente = DataClienteStruct.fromSerializableMap({
      'nombre': '',
      'nit': '',
      'email': '',
      'telefono': '',
      'direccion': '',
      'codprecio': '',
      'limitecredito': 0.0,
      'saldo': 0.0,
      'diascredito': 0,
      'cupo_disponible': 0.0,
      'tipo_cliente': '',
      'ciudad': '',
      'departamento': '',
      'pais': '',
      'vendedor': '',
      'ruta': '',
      'bloqueado': false,
      'fecha_ingreso': '',
      'ultima_compra': '',
      'comentarios': '',
    });
    
    _productList = [];
    _dataProductList = [];
    _shoppingCart = [];
    
    // Notify listeners to update the UI
    notifyListeners();
  }

  String _Nit = '';
  String get Nit => _Nit;
  set Nit(String value) {
    _Nit = value;
  }

  String _Email = '';
  String get Email => _Email;
  set Email(String value) {
    _Email = value;
  }

  bool _Remember = false;
  bool get Remember => _Remember;
  set Remember(bool value) {
    _Remember = value;
  }

  DataSellerStruct _infoSeller = DataSellerStruct();
  DataSellerStruct get infoSeller => _infoSeller;
  set infoSeller(DataSellerStruct value) {
    _infoSeller = value;
  }

  void updateInfoSellerStruct(Function(DataSellerStruct) updateFn) {
    updateFn(_infoSeller);
  }

  int _itemId = -1;
  int get itemId => _itemId;
  set itemId(int value) {
    _itemId = value;
  }

  late DataClienteStruct _dataCliente;
  DataClienteStruct get dataCliente => _dataCliente;
  set dataCliente(DataClienteStruct value) {
    _dataCliente = value;
  }

  void updateDataClienteStruct(Function(DataClienteStruct) updateFn) {
    updateFn(_dataCliente);
  }

  List<DataProductStruct> _productList = [];
  List<DataProductStruct> get productList => _productList;
  set productList(List<DataProductStruct> value) {
    _productList = value;
  }

  void addToProductList(DataProductStruct value) {
    _productList.add(value);
  }

  void removeFromProductList(DataProductStruct value) {
    _productList.remove(value);
  }

  void removeAtIndexFromProductList(int index) {
    _productList.removeAt(index);
  }

  void updateProductListAtIndex(
    int index,
    DataProductStruct Function(DataProductStruct) updateFn,
  ) {
    _productList[index] = updateFn(_productList[index]);
  }

  void insertAtIndexInProductList(int index, DataProductStruct value) {
    _productList.insert(index, value);
  }

  List<DataProductStruct> _dataProductList = [];
  List<DataProductStruct> get dataProductList => _dataProductList;
  set dataProductList(List<DataProductStruct> value) {
    _dataProductList = value;
  }

  void addToDataProductList(DataProductStruct value) {
    _dataProductList.add(value);
  }

  void removeFromDataProductList(DataProductStruct value) {
    _dataProductList.remove(value);
  }

  void removeAtIndexFromDataProductList(int index) {
    _dataProductList.removeAt(index);
  }

  void updateDataProductListAtIndex(
    int index,
    DataProductStruct Function(DataProductStruct) updateFn,
  ) {
    _dataProductList[index] = updateFn(_dataProductList[index]);
  }

  void insertAtIndexInDataProductList(int index, DataProductStruct value) {
    _dataProductList.insert(index, value);
  }

  List<DetailProductStruct> _shoppingCart = [];
  List<DetailProductStruct> get shoppingCart => _shoppingCart;
  set shoppingCart(List<DetailProductStruct> value) {
    _shoppingCart = value;
  }

  void addToShoppingCart(DetailProductStruct value) {
    _shoppingCart.add(value);
  }

  void removeFromShoppingCart(DetailProductStruct value) {
    _shoppingCart.remove(value);
  }

  void removeAtIndexFromShoppingCart(int index) {
    _shoppingCart.removeAt(index);
  }

  void updateShoppingCartAtIndex(
    int index,
    DetailProductStruct Function(DetailProductStruct) updateFn,
  ) {
    _shoppingCart[index] = updateFn(_shoppingCart[index]);
  }

  void insertAtIndexInShoppingCart(int index, DetailProductStruct value) {
    _shoppingCart.insert(index, value);
  }

  bool _product = false;
  bool get product => _product;
  set product(bool value) {
    _product = value;
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    _password = value;
  }
  List<DetailProductStruct> _store = [];
  List<DetailProductStruct> get store => _store;
  set store(List<DetailProductStruct> value) {
    _store = value;
  }

  void addToStore(DetailProductStruct value) {
    _store.add(value);
  }

  void removeFromStore(DetailProductStruct value) {
    _store.remove(value);
  }

  void removeAtIndexFromStore(int index) {
    _store.removeAt(index);
  }

  void updateStoreAtIndex(
    int index,
    DetailProductStruct Function(DetailProductStruct) updateFn,
  ) {
    _store[index] = updateFn(_store[index]);
  }

  void insertAtIndexInStore(int index, DetailProductStruct value) {
    _store.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
