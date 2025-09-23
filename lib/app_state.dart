import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';

class FFAppState extends ChangeNotifier {
  // Singleton pattern
  static FFAppState _instance = FFAppState._internal();
  factory FFAppState() => _instance;
  FFAppState._internal();

  // Reset the singleton instance
  static void reset() => _instance = FFAppState._internal();

  // Update state and notify listeners
  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  // User session data
  String nit = '';
  String email = '';
  bool remember = false;
  DataSellerStruct infoSeller = DataSellerStruct();
  int itemId = -1; // -1 indicates no client selected
  
  // Client data
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

  // Collections
  List<DataProductStruct> productList = [];
  List<DataProductStruct> dataProductList = [];
  List<DetailProductStruct> shoppingCart = [];
  List<DetailProductStruct> store = [];
  String password = '';

  /// Resets all app state when user logs out
  void resetAppState() {
    // Reset user session
    nit = '';
    email = '';
    remember = false;
    // Reset infoSeller to default values
    infoSeller = DataSellerStruct();
    itemId = -1;
    
    // Reset client data
    dataCliente = DataClienteStruct.fromSerializableMap({
      'nombre': '',
      'nit': '',
      // ... resto de campos ...
    });
    
    // Clear collections
    productList.clear();
    dataProductList.clear();
    shoppingCart.clear();
    store.clear();
    password = '';
    
    notifyListeners();
  }

  // Helper method for updating cliente data
  void updateDataCliente(void Function(DataClienteStruct) updateFn) {
    updateFn(dataCliente);
    notifyListeners();
  }

  // Product list operations
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

  // Shopping cart operations
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

  // Store operations
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