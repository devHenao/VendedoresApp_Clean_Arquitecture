// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DetailProductStruct extends BaseStruct {
  DetailProductStruct({
    double? precio,
    String? codigo,
    String? descripcio,
    String? bodega,
    String? codcc,
    String? codlote,
    String? unidadmed,
    String? codtariva,
    double? iva,
    double? saldo,
    double? cantidad,
    double? cantidadbodega,
  })  : _precio = precio,
        _codigo = codigo,
        _descripcio = descripcio,
        _bodega = bodega,
        _codcc = codcc,
        _codlote = codlote,
        _unidadmed = unidadmed,
        _codtariva = codtariva,
        _iva = iva,
        _saldo = saldo,
        _cantidad = cantidad,
        _cantidadbodega = cantidadbodega;

  // "precio" field.
  double? _precio;
  double get precio => _precio ?? 0.0;
  set precio(double? val) => _precio = val;

  void incrementPrecio(double amount) => precio = precio + amount;

  bool hasPrecio() => _precio != null;

  // "codigo" field.
  String? _codigo;
  String get codigo => _codigo ?? '';
  set codigo(String? val) => _codigo = val;

  bool hasCodigo() => _codigo != null;

  // "descripcio" field.
  String? _descripcio;
  String get descripcio => _descripcio ?? '';
  set descripcio(String? val) => _descripcio = val;

  bool hasDescripcio() => _descripcio != null;

  // "bodega" field.
  String? _bodega;
  String get bodega => _bodega ?? '';
  set bodega(String? val) => _bodega = val;

  bool hasBodega() => _bodega != null;

  // "codcc" field.
  String? _codcc;
  String get codcc => _codcc ?? '';
  set codcc(String? val) => _codcc = val;

  bool hasCodcc() => _codcc != null;

  // "codlote" field.
  String? _codlote;
  String get codlote => _codlote ?? '';
  set codlote(String? val) => _codlote = val;

  bool hasCodlote() => _codlote != null;

  // "unidadmed" field.
  String? _unidadmed;
  String get unidadmed => _unidadmed ?? '';
  set unidadmed(String? val) => _unidadmed = val;

  bool hasUnidadmed() => _unidadmed != null;

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

  // "saldo" field.
  double? _saldo;
  double get saldo => _saldo ?? 0.0;
  set saldo(double? val) => _saldo = val;

  void incrementSaldo(double amount) => saldo = saldo + amount;

  bool hasSaldo() => _saldo != null;

  // "cantidad" field.
  double? _cantidad;
  double get cantidad => _cantidad ?? 0.0;
  set cantidad(double? val) => _cantidad = val;

  void incrementCantidad(double amount) => cantidad = cantidad + amount;

  bool hasCantidad() => _cantidad != null;

  // "cantidadbodega" field.
  double? _cantidadbodega;
  double get cantidadbodega => _cantidadbodega ?? 0.0;
  set cantidadbodega(double? val) => _cantidadbodega = val;

  void incrementCantidadbodega(double amount) =>
      cantidadbodega = cantidadbodega + amount;

  bool hasCantidadbodega() => _cantidadbodega != null;

  static DetailProductStruct fromMap(Map<String, dynamic> data) =>
      DetailProductStruct(
        precio: castToType<double>(data['precio']),
        codigo: data['codigo'] as String?,
        descripcio: data['descripcio'] as String?,
        bodega: data['bodega'] as String?,
        codcc: data['codcc'] as String?,
        codlote: data['codlote'] as String?,
        unidadmed: data['unidadmed'] as String?,
        codtariva: data['codtariva'] as String?,
        iva: castToType<double>(data['iva']),
        saldo: castToType<double>(data['saldo']),
        cantidad: castToType<double>(data['cantidad']),
        cantidadbodega: castToType<double>(data['cantidadbodega']),
      );

  static DetailProductStruct? maybeFromMap(dynamic data) => data is Map
      ? DetailProductStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'precio': _precio,
        'codigo': _codigo,
        'descripcio': _descripcio,
        'bodega': _bodega,
        'codcc': _codcc,
        'codlote': _codlote,
        'unidadmed': _unidadmed,
        'codtariva': _codtariva,
        'iva': _iva,
        'saldo': _saldo,
        'cantidad': _cantidad,
        'cantidadbodega': _cantidadbodega,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'precio': serializeParam(
          _precio,
          ParamType.double,
        ),
        'codigo': serializeParam(
          _codigo,
          ParamType.String,
        ),
        'descripcio': serializeParam(
          _descripcio,
          ParamType.String,
        ),
        'bodega': serializeParam(
          _bodega,
          ParamType.String,
        ),
        'codcc': serializeParam(
          _codcc,
          ParamType.String,
        ),
        'codlote': serializeParam(
          _codlote,
          ParamType.String,
        ),
        'unidadmed': serializeParam(
          _unidadmed,
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
        'saldo': serializeParam(
          _saldo,
          ParamType.double,
        ),
        'cantidad': serializeParam(
          _cantidad,
          ParamType.double,
        ),
        'cantidadbodega': serializeParam(
          _cantidadbodega,
          ParamType.double,
        ),
      }.withoutNulls;

  static DetailProductStruct fromSerializableMap(Map<String, dynamic> data) =>
      DetailProductStruct(
        precio: deserializeParam(
          data['precio'],
          ParamType.double,
          false,
        ),
        codigo: deserializeParam(
          data['codigo'],
          ParamType.String,
          false,
        ),
        descripcio: deserializeParam(
          data['descripcio'],
          ParamType.String,
          false,
        ),
        bodega: deserializeParam(
          data['bodega'],
          ParamType.String,
          false,
        ),
        codcc: deserializeParam(
          data['codcc'],
          ParamType.String,
          false,
        ),
        codlote: deserializeParam(
          data['codlote'],
          ParamType.String,
          false,
        ),
        unidadmed: deserializeParam(
          data['unidadmed'],
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
        saldo: deserializeParam(
          data['saldo'],
          ParamType.double,
          false,
        ),
        cantidad: deserializeParam(
          data['cantidad'],
          ParamType.double,
          false,
        ),
        cantidadbodega: deserializeParam(
          data['cantidadbodega'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DetailProductStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DetailProductStruct &&
        precio == other.precio &&
        codigo == other.codigo &&
        descripcio == other.descripcio &&
        bodega == other.bodega &&
        codcc == other.codcc &&
        codlote == other.codlote &&
        unidadmed == other.unidadmed &&
        codtariva == other.codtariva &&
        iva == other.iva &&
        saldo == other.saldo &&
        cantidad == other.cantidad &&
        cantidadbodega == other.cantidadbodega;
  }

  @override
  int get hashCode => const ListEquality().hash([
        precio,
        codigo,
        descripcio,
        bodega,
        codcc,
        codlote,
        unidadmed,
        codtariva,
        iva,
        saldo,
        cantidad,
        cantidadbodega
      ]);
}

DetailProductStruct createDetailProductStruct({
  double? precio,
  String? codigo,
  String? descripcio,
  String? bodega,
  String? codcc,
  String? codlote,
  String? unidadmed,
  String? codtariva,
  double? iva,
  double? saldo,
  double? cantidad,
  double? cantidadbodega,
}) =>
    DetailProductStruct(
      precio: precio,
      codigo: codigo,
      descripcio: descripcio,
      bodega: bodega,
      codcc: codcc,
      codlote: codlote,
      unidadmed: unidadmed,
      codtariva: codtariva,
      iva: iva,
      saldo: saldo,
      cantidad: cantidad,
      cantidadbodega: cantidadbodega,
    );
