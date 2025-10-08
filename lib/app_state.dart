import 'package:flutter/material.dart';
import 'core/backend/schema/structs/index.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();
  factory FFAppState() => _instance;
  FFAppState._internal();

  static void reset() => _instance = FFAppState._internal();

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String nit = '';
  String email = '';
  bool remember = false;
  DataSellerStruct infoSeller = DataSellerStruct();
  int itemId = -1;
  
  late DataClienteStruct dataCliente = DataClienteStruct.fromSerializableMap({
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

  List<DataProductStruct> productList = [];
  List<DataProductStruct> dataProductList = [];
  List<DetailProductStruct> shoppingCart = [];
  List<DetailProductStruct> store = [];
  String password = '';

  void resetAppState() {
    nit = '';
    email = '';
    remember = false;
    infoSeller = DataSellerStruct();
    itemId = -1;
    
    dataCliente = DataClienteStruct.fromSerializableMap({
      'nombre': '',
      'nit': '',
    });
    
    productList.clear();
    dataProductList.clear();
    shoppingCart.clear();
    store.clear();
    password = '';
    
    notifyListeners();
  }

  void updateDataCliente(void Function(DataClienteStruct) updateFn) {
    updateFn(dataCliente);
    notifyListeners();
  }

  void addProduct(DataProductStruct product) {
    productList.add(product);
    notifyListeners();
  }

  void removeProduct(DataProductStruct product) {
    productList.remove(product);
    notifyListeners();
  }

  void removeProductAt(int index) {
    if (index >= 0 && index < productList.length) {
      productList.removeAt(index);
      notifyListeners();
    }
  }

  void updateProduct(int index, DataProductStruct Function(DataProductStruct) updateFn) {
    if (index >= 0 && index < productList.length) {
      productList[index] = updateFn(productList[index]);
      notifyListeners();
    }
  }

  void insertProduct(int index, DataProductStruct product) {
    if (index >= 0 && index <= productList.length) {
      productList.insert(index, product);
      notifyListeners();
    }
  }

  void addToCart(DetailProductStruct product) {
    shoppingCart.add(product);
    notifyListeners();
  }

  void removeFromCart(DetailProductStruct product) {
    shoppingCart.remove(product);
    notifyListeners();
  }

  void removeFromCartAt(int index) {
    if (index >= 0 && index < shoppingCart.length) {
      shoppingCart.removeAt(index);
      notifyListeners();
    }
  }

  void updateCartItem(int index, DetailProductStruct Function(DetailProductStruct) updateFn) {
    if (index >= 0 && index < shoppingCart.length) {
      shoppingCart[index] = updateFn(shoppingCart[index]);
      notifyListeners();
    }
  }

  void addStoreItem(DetailProductStruct item) {
    store.add(item);
    notifyListeners();
  }

  void removeStoreItem(DetailProductStruct item) {
    store.remove(item);
    notifyListeners();
  }

  void removeStoreItemAt(int index) {
    if (index >= 0 && index < store.length) {
      store.removeAt(index);
      notifyListeners();
    }
  }
}