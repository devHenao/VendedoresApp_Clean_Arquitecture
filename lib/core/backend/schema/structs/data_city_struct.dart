// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DataCityStruct extends BaseStruct {
  DataCityStruct({
    String? codigo,
    String? nomciud,
    String? nomdpto,
    bool? stadsincro,
  })  : _codigo = codigo,
        _nomciud = nomciud,
        _nomdpto = nomdpto,
        _stadsincro = stadsincro;

  // "codigo" field.
  String? _codigo;
  String get codigo => _codigo ?? '';
  set codigo(String? val) => _codigo = val;

  bool hasCodigo() => _codigo != null;

  // "nomciud" field.
  String? _nomciud;
  String get nomciud => _nomciud ?? '';
  set nomciud(String? val) => _nomciud = val;

  bool hasNomciud() => _nomciud != null;

  // "nomdpto" field.
  String? _nomdpto;
  String get nomdpto => _nomdpto ?? '';
  set nomdpto(String? val) => _nomdpto = val;

  bool hasNomdpto() => _nomdpto != null;

  // "stadsincro" field.
  bool? _stadsincro;
  bool get stadsincro => _stadsincro ?? false;
  set stadsincro(bool? val) => _stadsincro = val;

  bool hasStadsincro() => _stadsincro != null;

  static DataCityStruct fromMap(Map<String, dynamic> data) => DataCityStruct(
        codigo: data['codigo'] as String?,
        nomciud: data['nomciud'] as String?,
        nomdpto: data['nomdpto'] as String?,
        stadsincro: data['stadsincro'] as bool?,
      );

  static DataCityStruct? maybeFromMap(dynamic data) =>
      data is Map ? DataCityStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'codigo': _codigo,
        'nomciud': _nomciud,
        'nomdpto': _nomdpto,
        'stadsincro': _stadsincro,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'codigo': serializeParam(
          _codigo,
          ParamType.String,
        ),
        'nomciud': serializeParam(
          _nomciud,
          ParamType.String,
        ),
        'nomdpto': serializeParam(
          _nomdpto,
          ParamType.String,
        ),
        'stadsincro': serializeParam(
          _stadsincro,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DataCityStruct fromSerializableMap(Map<String, dynamic> data) =>
      DataCityStruct(
        codigo: deserializeParam(
          data['codigo'],
          ParamType.String,
          false,
        ),
        nomciud: deserializeParam(
          data['nomciud'],
          ParamType.String,
          false,
        ),
        nomdpto: deserializeParam(
          data['nomdpto'],
          ParamType.String,
          false,
        ),
        stadsincro: deserializeParam(
          data['stadsincro'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DataCityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DataCityStruct &&
        codigo == other.codigo &&
        nomciud == other.nomciud &&
        nomdpto == other.nomdpto &&
        stadsincro == other.stadsincro;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([codigo, nomciud, nomdpto, stadsincro]);
}

DataCityStruct createDataCityStruct({
  String? codigo,
  String? nomciud,
  String? nomdpto,
  bool? stadsincro,
}) =>
    DataCityStruct(
      codigo: codigo,
      nomciud: nomciud,
      nomdpto: nomdpto,
      stadsincro: stadsincro,
    );
