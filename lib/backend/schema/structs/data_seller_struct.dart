// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DataSellerStruct extends BaseStruct {
  DataSellerStruct({
    String? nameVenden,
    String? codVen,
    String? emailVenden,
    String? storageDefault,
    String? idEnterprise,
    String? token,
  })  : _nameVenden = nameVenden,
        _codVen = codVen,
        _emailVenden = emailVenden,
        _storageDefault = storageDefault,
        _idEnterprise = idEnterprise,
        _token = token;

  // "nameVenden" field.
  String? _nameVenden;
  String get nameVenden => _nameVenden ?? '';
  set nameVenden(String? val) => _nameVenden = val;

  bool hasNameVenden() => _nameVenden != null;

  // "codVen" field.
  String? _codVen;
  String get codVen => _codVen ?? '';
  set codVen(String? val) => _codVen = val;

  bool hasCodVen() => _codVen != null;

  // "emailVenden" field.
  String? _emailVenden;
  String get emailVenden => _emailVenden ?? '';
  set emailVenden(String? val) => _emailVenden = val;

  bool hasEmailVenden() => _emailVenden != null;

  // "storageDefault" field.
  String? _storageDefault;
  String get storageDefault => _storageDefault ?? '';
  set storageDefault(String? val) => _storageDefault = val;

  bool hasStorageDefault() => _storageDefault != null;

  // "idEnterprise" field.
  String? _idEnterprise;
  String get idEnterprise => _idEnterprise ?? '';
  set idEnterprise(String? val) => _idEnterprise = val;

  bool hasIdEnterprise() => _idEnterprise != null;

  // "token" field.
  String? _token;
  String get token => _token ?? '';
  set token(String? val) => _token = val;

  bool hasToken() => _token != null;

  static DataSellerStruct fromMap(Map<String, dynamic> data) =>
      DataSellerStruct(
        nameVenden: data['nameVenden'] as String?,
        codVen: data['codVen'] as String?,
        emailVenden: data['emailVenden'] as String?,
        storageDefault: data['storageDefault'] as String?,
        idEnterprise: data['idEnterprise'] as String?,
        token: data['token'] as String?,
      );

  static DataSellerStruct? maybeFromMap(dynamic data) => data is Map
      ? DataSellerStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nameVenden': _nameVenden,
        'codVen': _codVen,
        'emailVenden': _emailVenden,
        'storageDefault': _storageDefault,
        'idEnterprise': _idEnterprise,
        'token': _token,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nameVenden': serializeParam(
          _nameVenden,
          ParamType.String,
        ),
        'codVen': serializeParam(
          _codVen,
          ParamType.String,
        ),
        'emailVenden': serializeParam(
          _emailVenden,
          ParamType.String,
        ),
        'storageDefault': serializeParam(
          _storageDefault,
          ParamType.String,
        ),
        'idEnterprise': serializeParam(
          _idEnterprise,
          ParamType.String,
        ),
        'token': serializeParam(
          _token,
          ParamType.String,
        ),
      }.withoutNulls;

  static DataSellerStruct fromSerializableMap(Map<String, dynamic> data) =>
      DataSellerStruct(
        nameVenden: deserializeParam(
          data['nameVenden'],
          ParamType.String,
          false,
        ),
        codVen: deserializeParam(
          data['codVen'],
          ParamType.String,
          false,
        ),
        emailVenden: deserializeParam(
          data['emailVenden'],
          ParamType.String,
          false,
        ),
        storageDefault: deserializeParam(
          data['storageDefault'],
          ParamType.String,
          false,
        ),
        idEnterprise: deserializeParam(
          data['idEnterprise'],
          ParamType.String,
          false,
        ),
        token: deserializeParam(
          data['token'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DataSellerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DataSellerStruct &&
        nameVenden == other.nameVenden &&
        codVen == other.codVen &&
        emailVenden == other.emailVenden &&
        storageDefault == other.storageDefault &&
        idEnterprise == other.idEnterprise &&
        token == other.token;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [nameVenden, codVen, emailVenden, storageDefault, idEnterprise, token]);
}

DataSellerStruct createDataSellerStruct({
  String? nameVenden,
  String? codVen,
  String? emailVenden,
  String? storageDefault,
  String? idEnterprise,
  String? token,
}) =>
    DataSellerStruct(
      nameVenden: nameVenden,
      codVen: codVen,
      emailVenden: emailVenden,
      storageDefault: storageDefault,
      idEnterprise: idEnterprise,
      token: token,
    );
