import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Future initializePersistedState() async {
  //   prefs = await SharedPreferences.getInstance();
  //   _safeInit(() {
  //     _Nit = prefs.getString('ff_Nit') ?? _Nit;
  //   });
  //   _safeInit(() {
  //     _Email = prefs.getString('ff_Email') ?? _Email;
  //   });
  //   _safeInit(() {
  //     _Remember = prefs.getBool('ff_Remember') ?? _Remember;
  //   });
  //   _safeInit(() {
  //     if (prefs.containsKey('ff_infoSeller')) {
  //       try {
  //         final serializedData = prefs.getString('ff_infoSeller') ?? '{}';
  //         _infoSeller =
  //             DataSellerStruct.fromSerializableMap(jsonDecode(serializedData));
  //       } catch (e) {
  //         print("Can't decode persisted data type. Error: $e.");
  //       }
  //     }
  //   });
  //   _safeInit(() {
  //     _itemId = prefs.getInt('ff_itemId') ?? _itemId;
  //   });
  //   _safeInit(() {
  //     if (prefs.containsKey('ff_dataCliente')) {
  //       try {
  //         final serializedData = prefs.getString('ff_dataCliente') ?? '{}';
  //         _dataCliente =
  //             DataClienteStruct.fromSerializableMap(jsonDecode(serializedData));
  //       } catch (e) {
  //         print("Can't decode persisted data type. Error: $e.");
  //       }
  //     }
  //   });
  //   _safeInit(() {
  //     _productList = prefs
  //             .getStringList('ff_productList')
  //             ?.map((x) {
  //               try {
  //                 return DataProductStruct.fromSerializableMap(jsonDecode(x));
  //               } catch (e) {
  //                 print("Can't decode persisted data type. Error: $e.");
  //                 return null;
  //               }
  //             })
  //             .withoutNulls
  //             .toList() ??
  //         _productList;
  //   });
  //   _safeInit(() {
  //     _dataProductList = prefs
  //             .getStringList('ff_dataProductList')
  //             ?.map((x) {
  //               try {
  //                 return DataProductStruct.fromSerializableMap(jsonDecode(x));
  //               } catch (e) {
  //                 print("Can't decode persisted data type. Error: $e.");
  //                 return null;
  //               }
  //             })
  //             .withoutNulls
  //             .toList() ??
  //         _dataProductList;
  //   });
  //   _safeInit(() {
  //     _shoppingCart = prefs
  //             .getStringList('ff_shoppingCart')
  //             ?.map((x) {
  //               try {
  //                 return DetailProductStruct.fromSerializableMap(jsonDecode(x));
  //               } catch (e) {
  //                 print("Can't decode persisted data type. Error: $e.");
  //                 return null;
  //               }
  //             })
  //             .withoutNulls
  //             .toList() ??
  //         _shoppingCart;
  //   });
  //   _safeInit(() {
  //     _password = prefs.getString('ff_password') ?? _password;
  //   });
  //   _safeInit(() {
  //     _store = prefs
  //             .getStringList('ff_store')
  //             ?.map((x) {
  //               try {
  //                 return DetailProductStruct.fromSerializableMap(jsonDecode(x));
  //               } catch (e) {
  //                 print("Can't decode persisted data type. Error: $e.");
  //                 return null;
  //               }
  //             })
  //             .withoutNulls
  //             .toList() ??
  //         _store;
  //   });
  // }

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
    
    // Clear all persisted data from SharedPreferences
    prefs.remove('ff_Nit');
    prefs.remove('ff_Email');
    prefs.remove('ff_Remember');
    prefs.remove('ff_infoSeller');
    prefs.remove('ff_itemId');
    prefs.remove('ff_dataCliente');
    prefs.remove('ff_productList');
    prefs.remove('ff_dataProductList');
    prefs.remove('ff_shoppingCart');
    
    // Force save the empty client data
    dataCliente = _dataCliente;
    
    // Notify listeners to update the UI
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _Nit = '';
  String get Nit => _Nit;
  set Nit(String value) {
    _Nit = value;
    prefs.setString('ff_Nit', value);
  }

  String _Email = '';
  String get Email => _Email;
  set Email(String value) {
    _Email = value;
    prefs.setString('ff_Email', value);
  }

  bool _Remember = false;
  bool get Remember => _Remember;
  set Remember(bool value) {
    _Remember = value;
    prefs.setBool('ff_Remember', value);
  }

  DataSellerStruct _infoSeller = DataSellerStruct();
  DataSellerStruct get infoSeller => _infoSeller;
  set infoSeller(DataSellerStruct value) {
    _infoSeller = value;
    prefs.setString('ff_infoSeller', value.serialize());
  }

  void updateInfoSellerStruct(Function(DataSellerStruct) updateFn) {
    updateFn(_infoSeller);
    prefs.setString('ff_infoSeller', _infoSeller.serialize());
  }

  int _itemId = -1;
  int get itemId => _itemId;
  set itemId(int value) {
    _itemId = value;
    prefs.setInt('ff_itemId', value);
  }

  DataClienteStruct _dataCliente =
      DataClienteStruct.fromSerializableMap(jsonDecode('{}'));
  DataClienteStruct get dataCliente => _dataCliente;
  set dataCliente(DataClienteStruct value) {
    _dataCliente = value;
    prefs.setString('ff_dataCliente', value.serialize());
  }

  void updateDataClienteStruct(Function(DataClienteStruct) updateFn) {
    updateFn(_dataCliente);
    prefs.setString('ff_dataCliente', _dataCliente.serialize());
  }

  List<DataProductStruct> _productList = [];
  List<DataProductStruct> get productList => _productList;
  set productList(List<DataProductStruct> value) {
    _productList = value;
    prefs.setStringList(
        'ff_productList', value.map((x) => x.serialize()).toList());
  }

  void addToProductList(DataProductStruct value) {
    productList.add(value);
    prefs.setStringList(
        'ff_productList', _productList.map((x) => x.serialize()).toList());
  }

  void removeFromProductList(DataProductStruct value) {
    productList.remove(value);
    prefs.setStringList(
        'ff_productList', _productList.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromProductList(int index) {
    productList.removeAt(index);
    prefs.setStringList(
        'ff_productList', _productList.map((x) => x.serialize()).toList());
  }

  void updateProductListAtIndex(
    int index,
    DataProductStruct Function(DataProductStruct) updateFn,
  ) {
    productList[index] = updateFn(_productList[index]);
    prefs.setStringList(
        'ff_productList', _productList.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInProductList(int index, DataProductStruct value) {
    productList.insert(index, value);
    prefs.setStringList(
        'ff_productList', _productList.map((x) => x.serialize()).toList());
  }

  List<DataProductStruct> _dataProductList = [];
  List<DataProductStruct> get dataProductList => _dataProductList;
  set dataProductList(List<DataProductStruct> value) {
    _dataProductList = value;
    prefs.setStringList(
        'ff_dataProductList', value.map((x) => x.serialize()).toList());
  }

  void addToDataProductList(DataProductStruct value) {
    dataProductList.add(value);
    prefs.setStringList('ff_dataProductList',
        _dataProductList.map((x) => x.serialize()).toList());
  }

  void removeFromDataProductList(DataProductStruct value) {
    dataProductList.remove(value);
    prefs.setStringList('ff_dataProductList',
        _dataProductList.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromDataProductList(int index) {
    dataProductList.removeAt(index);
    prefs.setStringList('ff_dataProductList',
        _dataProductList.map((x) => x.serialize()).toList());
  }

  void updateDataProductListAtIndex(
    int index,
    DataProductStruct Function(DataProductStruct) updateFn,
  ) {
    dataProductList[index] = updateFn(_dataProductList[index]);
    prefs.setStringList('ff_dataProductList',
        _dataProductList.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInDataProductList(int index, DataProductStruct value) {
    dataProductList.insert(index, value);
    prefs.setStringList('ff_dataProductList',
        _dataProductList.map((x) => x.serialize()).toList());
  }

  List<DetailProductStruct> _shoppingCart = [];
  List<DetailProductStruct> get shoppingCart => _shoppingCart;
  set shoppingCart(List<DetailProductStruct> value) {
    _shoppingCart = value;
    prefs.setStringList(
        'ff_shoppingCart', value.map((x) => x.serialize()).toList());
  }

  void addToShoppingCart(DetailProductStruct value) {
    shoppingCart.add(value);
    prefs.setStringList(
        'ff_shoppingCart', _shoppingCart.map((x) => x.serialize()).toList());
  }

  void removeFromShoppingCart(DetailProductStruct value) {
    shoppingCart.remove(value);
    prefs.setStringList(
        'ff_shoppingCart', _shoppingCart.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromShoppingCart(int index) {
    shoppingCart.removeAt(index);
    prefs.setStringList(
        'ff_shoppingCart', _shoppingCart.map((x) => x.serialize()).toList());
  }

  void updateShoppingCartAtIndex(
    int index,
    DetailProductStruct Function(DetailProductStruct) updateFn,
  ) {
    shoppingCart[index] = updateFn(_shoppingCart[index]);
    prefs.setStringList(
        'ff_shoppingCart', _shoppingCart.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInShoppingCart(int index, DetailProductStruct value) {
    shoppingCart.insert(index, value);
    prefs.setStringList(
        'ff_shoppingCart', _shoppingCart.map((x) => x.serialize()).toList());
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
    prefs.setString('ff_password', value);
  }

  List<DetailProductStruct> _store = [];
  List<DetailProductStruct> get store => _store;
  set store(List<DetailProductStruct> value) {
    _store = value;
    prefs.setStringList('ff_store', value.map((x) => x.serialize()).toList());
  }

  void addToStore(DetailProductStruct value) {
    store.add(value);
    prefs.setStringList('ff_store', _store.map((x) => x.serialize()).toList());
  }

  void removeFromStore(DetailProductStruct value) {
    store.remove(value);
    prefs.setStringList('ff_store', _store.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromStore(int index) {
    store.removeAt(index);
    prefs.setStringList('ff_store', _store.map((x) => x.serialize()).toList());
  }

  void updateStoreAtIndex(
    int index,
    DetailProductStruct Function(DetailProductStruct) updateFn,
  ) {
    store[index] = updateFn(_store[index]);
    prefs.setStringList('ff_store', _store.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInStore(int index, DetailProductStruct value) {
    store.insert(index, value);
    prefs.setStringList('ff_store', _store.map((x) => x.serialize()).toList());
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
