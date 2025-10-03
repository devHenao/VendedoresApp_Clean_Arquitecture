// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DataProductStruct extends BaseStruct {
  DataProductStruct({
    String? codproduc,
    double? precio,
    String? descripcio,
    double? descuento1,
    double? descuento2,
    double? saldo,
    String? unidadmed,
    String? codbarras,
    String? codtariva,
    double? iva,
    bool? selected,
    double? cantidad,
  })  : _codproduc = codproduc,
        _precio = precio,
        _descripcio = descripcio,
        _descuento1 = descuento1,
        _descuento2 = descuento2,
        _saldo = saldo,
        _unidadmed = unidadmed,
        _codbarras = codbarras,
        _codtariva = codtariva,
        _iva = iva,
        _selected = selected,
        _cantidad = cantidad;

  // "codproduc" field.
  String? _codproduc;
  String get codproduc => _codproduc ?? '';
  set codproduc(String? val) => _codproduc = val;

  bool hasCodproduc() => _codproduc != null;

  // "precio" field.
  double? _precio;
  double get precio => _precio ?? 0.0;
  set precio(double? val) => _precio = val;

  void incrementPrecio(double amount) => precio = precio + amount;

  bool hasPrecio() => _precio != null;

  // "descripcio" field.
  String? _descripcio;
  String get descripcio => _descripcio ?? '';
  set descripcio(String? val) => _descripcio = val;

  bool hasDescripcio() => _descripcio != null;

  // "descuento1" field.
  double? _descuento1;
  double get descuento1 => _descuento1 ?? 0.0;
  set descuento1(double? val) => _descuento1 = val;

  void incrementDescuento1(double amount) => descuento1 = descuento1 + amount;

  bool hasDescuento1() => _descuento1 != null;

  // "descuento2" field.
  double? _descuento2;
  double get descuento2 => _descuento2 ?? 0.0;
  set descuento2(double? val) => _descuento2 = val;

  void incrementDescuento2(double amount) => descuento2 = descuento2 + amount;

  bool hasDescuento2() => _descuento2 != null;

  // "saldo" field.
  double? _saldo;
  double get saldo => _saldo ?? 0.0;
  set saldo(double? val) => _saldo = val;

  void incrementSaldo(double amount) => saldo = saldo + amount;

  bool hasSaldo() => _saldo != null;

  // "unidadmed" field.
  String? _unidadmed;
  String get unidadmed => _unidadmed ?? '';
  set unidadmed(String? val) => _unidadmed = val;

  bool hasUnidadmed() => _unidadmed != null;

  // "codbarras" field.
  String? _codbarras;
  String get codbarras => _codbarras ?? '';
  set codbarras(String? val) => _codbarras = val;

  bool hasCodbarras() => _codbarras != null;

  // "codtariva" field.
  String? _codtariva;
  String get codtariva => _codtariva ?? '';
  set codtariva(String? val) => _codtariva = val;

  bool hasCodtariva() => _codtariva != null;

  // "iva" field.
  double? _iva;
  double get iva => _iva ?? 0.0;
  set iva(double? val) => _iva = val;

  void incrementIva(double amount) => iva = iva + amount;

  bool hasIva() => _iva != null;

  // "selected" field.
  bool? _selected;
  bool get selected => _selected ?? false;
  set selected(bool? val) => _selected = val;

  bool hasSelected() => _selected != null;

  // "cantidad" field.
  double? _cantidad;
  double get cantidad => _cantidad ?? 0.0;
  set cantidad(double? val) => _cantidad = val;

  void incrementCantidad(double amount) => cantidad = cantidad + amount;

  bool hasCantidad() => _cantidad != null;

  static DataProductStruct fromMap(Map<String, dynamic> data) =>
      DataProductStruct(
        codproduc: data['codproduc'] as String?,
        precio: castToType<double>(data['precio']),
        descripcio: data['descripcio'] as String?,
        descuento1: castToType<double>(data['descuento1']),
        descuento2: castToType<double>(data['descuento2']),
        saldo: castToType<double>(data['saldo']),
        unidadmed: data['unidadmed'] as String?,
        codbarras: data['codbarras'] as String?,
        codtariva: data['codtariva'] as String?,
        iva: castToType<double>(data['iva']),
        selected: data['selected'] as bool?,
        cantidad: castToType<double>(data['cantidad']),
      );

  static DataProductStruct? maybeFromMap(dynamic data) => data is Map
      ? DataProductStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'codproduc': _codproduc,
        'precio': _precio,
        'descripcio': _descripcio,
        'descuento1': _descuento1,
        'descuento2': _descuento2,
        'saldo': _saldo,
        'unidadmed': _unidadmed,
        'codbarras': _codbarras,
        'codtariva': _codtariva,
        'iva': _iva,
        'selected': _selected,
        'cantidad': _cantidad,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'codproduc': serializeParam(
          _codproduc,
          ParamType.String,
        ),
        'precio': serializeParam(
          _precio,
          ParamType.double,
        ),
        'descripcio': serializeParam(
          _descripcio,
          ParamType.String,
        ),
        'descuento1': serializeParam(
          _descuento1,
          ParamType.double,
        ),
        'descuento2': serializeParam(
          _descuento2,
          ParamType.double,
        ),
        'saldo': serializeParam(
          _saldo,
          ParamType.double,
        ),
        'unidadmed': serializeParam(
          _unidadmed,
          ParamType.String,
        ),
        'codbarras': serializeParam(
          _codbarras,
          ParamType.String,
        ),
        'codtariva': serializeParam(
          _codtariva,
          ParamType.String,
        ),
        'iva': serializeParam(
          _iva,
          ParamType.double,
        ),
        'selected': serializeParam(
          _selected,
          ParamType.bool,
        ),
        'cantidad': serializeParam(
          _cantidad,
          ParamType.double,
        ),
      }.withoutNulls;

  static DataProductStruct fromSerializableMap(Map<String, dynamic> data) =>
      DataProductStruct(
        codproduc: deserializeParam(
          data['codproduc'],
          ParamType.String,
          false,
        ),
        precio: deserializeParam(
          data['precio'],
          ParamType.double,
          false,
        ),
        descripcio: deserializeParam(
          data['descripcio'],
          ParamType.String,
          false,
        ),
        descuento1: deserializeParam(
          data['descuento1'],
          ParamType.double,
          false,
        ),
        descuento2: deserializeParam(
          data['descuento2'],
          ParamType.double,
          false,
        ),
        saldo: deserializeParam(
          data['saldo'],
          ParamType.double,
          false,
        ),
        unidadmed: deserializeParam(
          data['unidadmed'],
          ParamType.String,
          false,
        ),
        codbarras: deserializeParam(
          data['codbarras'],
          ParamType.String,
          false,
        ),
        codtariva: deserializeParam(
          data['codtariva'],
          ParamType.String,
          false,
        ),
        iva: deserializeParam(
          data['iva'],
          ParamType.double,
          false,
        ),
        selected: deserializeParam(
          data['selected'],
          ParamType.bool,
          false,
        ),
        cantidad: deserializeParam(
          data['cantidad'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DataProductStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DataProductStruct &&
        codproduc == other.codproduc &&
        precio == other.precio &&
        descripcio == other.descripcio &&
        descuento1 == other.descuento1 &&
        descuento2 == other.descuento2 &&
        saldo == other.saldo &&
        unidadmed == other.unidadmed &&
        codbarras == other.codbarras &&
        codtariva == other.codtariva &&
        iva == other.iva &&
        selected == other.selected &&
        cantidad == other.cantidad;
  }

  @override
  int get hashCode => const ListEquality().hash([
        codproduc,
        precio,
        descripcio,
        descuento1,
        descuento2,
        saldo,
        unidadmed,
        codbarras,
        codtariva,
        iva,
        selected,
        cantidad
      ]);
}

DataProductStruct createDataProductStruct({
  String? codproduc,
  double? precio,
  String? descripcio,
  double? descuento1,
  double? descuento2,
  double? saldo,
  String? unidadmed,
  String? codbarras,
  String? codtariva,
  double? iva,
  bool? selected,
  double? cantidad,
}) =>
    DataProductStruct(
      codproduc: codproduc,
      precio: precio,
      descripcio: descripcio,
      descuento1: descuento1,
      descuento2: descuento2,
      saldo: saldo,
      unidadmed: unidadmed,
      codbarras: codbarras,
      codtariva: codtariva,
      iva: iva,
      selected: selected,
      cantidad: cantidad,
    );
