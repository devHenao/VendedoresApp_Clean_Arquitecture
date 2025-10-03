// ignore_for_file: unnecessary_getters_setters

import '../util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NameDptoStruct extends BaseStruct {
  NameDptoStruct({
    String? nomdpto,
  }) : _nomdpto = nomdpto;

  // "nomdpto" field.
  String? _nomdpto;
  String get nomdpto => _nomdpto ?? '';
  set nomdpto(String? val) => _nomdpto = val;

  bool hasNomdpto() => _nomdpto != null;

  static NameDptoStruct fromMap(Map<String, dynamic> data) => NameDptoStruct(
        nomdpto: data['nomdpto'] as String?,
      );

  static NameDptoStruct? maybeFromMap(dynamic data) =>
      data is Map ? NameDptoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nomdpto': _nomdpto,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nomdpto': serializeParam(
          _nomdpto,
          ParamType.String,
        ),
      }.withoutNulls;

  static NameDptoStruct fromSerializableMap(Map<String, dynamic> data) =>
      NameDptoStruct(
        nomdpto: deserializeParam(
          data['nomdpto'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'NameDptoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NameDptoStruct && nomdpto == other.nomdpto;
  }

  @override
  int get hashCode => const ListEquality().hash([nomdpto]);
}

NameDptoStruct createNameDptoStruct({
  String? nomdpto,
}) =>
    NameDptoStruct(
      nomdpto: nomdpto,
    );
