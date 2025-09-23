// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DataClienteStruct extends BaseStruct {
  DataClienteStruct({
    String? tipoCar,
    String? codigoCta,
    String? nit,
    String? vendedor,
    String? nombre,
    String? direccion,
    String? cdciiu,
    String? contacto,
    String? tel1,
    String? email,
    String? codprecio,
    String? nomciud,
    String? nomdpto,
  })  : _tipoCar = tipoCar,
        _codigoCta = codigoCta,
        _nit = nit,
        _vendedor = vendedor,
        _nombre = nombre,
        _direccion = direccion,
        _cdciiu = cdciiu,
        _contacto = contacto,
        _tel1 = tel1,
        _email = email,
        _codprecio = codprecio,
        _nomciud = nomciud,
        _nomdpto = nomdpto;

  // "tipoCar" field.
  String? _tipoCar;
  String get tipoCar => _tipoCar ?? '';
  set tipoCar(String? val) => _tipoCar = val;

  bool hasTipoCar() => _tipoCar != null;

  // "codigoCta" field.
  String? _codigoCta;
  String get codigoCta => _codigoCta ?? '';
  set codigoCta(String? val) => _codigoCta = val;

  bool hasCodigoCta() => _codigoCta != null;

  // "nit" field.
  String? _nit;
  String get nit => _nit ?? '';
  set nit(String? val) => _nit = val;

  bool hasNit() => _nit != null;

  // "vendedor" field.
  String? _vendedor;
  String get vendedor => _vendedor ?? '';
  set vendedor(String? val) => _vendedor = val;

  bool hasVendedor() => _vendedor != null;

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

  // "direccion" field.
  String? _direccion;
  String get direccion => _direccion ?? '';
  set direccion(String? val) => _direccion = val;

  bool hasDireccion() => _direccion != null;

  // "cdciiu" field.
  String? _cdciiu;
  String get cdciiu => _cdciiu ?? '';
  set cdciiu(String? val) => _cdciiu = val;

  bool hasCdciiu() => _cdciiu != null;

  // "contacto" field.
  String? _contacto;
  String get contacto => _contacto ?? '';
  set contacto(String? val) => _contacto = val;

  bool hasContacto() => _contacto != null;

  // "TEL1" field.
  String? _tel1;
  String get tel1 => _tel1 ?? '';
  set tel1(String? val) => _tel1 = val;

  bool hasTel1() => _tel1 != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "codprecio" field.
  String? _codprecio;
  String get codprecio => _codprecio ?? '';
  set codprecio(String? val) => _codprecio = val;

  bool hasCodprecio() => _codprecio != null;

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

  static DataClienteStruct fromMap(Map<String, dynamic> data) =>
      DataClienteStruct(
        tipoCar: data['tipoCar'] as String?,
        codigoCta: data['codigoCta'] as String?,
        nit: data['nit'] as String?,
        vendedor: data['vendedor'] as String?,
        nombre: data['nombre'] as String?,
        direccion: data['direccion'] as String?,
        cdciiu: data['cdciiu'] as String?,
        contacto: data['contacto'] as String?,
        tel1: data['TEL1'] as String?,
        email: data['email'] as String?,
        codprecio: data['codprecio'] as String?,
        nomciud: data['nomciud'] as String?,
        nomdpto: data['nomdpto'] as String?,
      );

  static DataClienteStruct? maybeFromMap(dynamic data) => data is Map
      ? DataClienteStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'tipoCar': _tipoCar,
        'codigoCta': _codigoCta,
        'nit': _nit,
        'vendedor': _vendedor,
        'nombre': _nombre,
        'direccion': _direccion,
        'cdciiu': _cdciiu,
        'contacto': _contacto,
        'TEL1': _tel1,
        'email': _email,
        'codprecio': _codprecio,
        'nomciud': _nomciud,
        'nomdpto': _nomdpto,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'tipoCar': serializeParam(
          _tipoCar,
          ParamType.String,
        ),
        'codigoCta': serializeParam(
          _codigoCta,
          ParamType.String,
        ),
        'nit': serializeParam(
          _nit,
          ParamType.String,
        ),
        'vendedor': serializeParam(
          _vendedor,
          ParamType.String,
        ),
        'nombre': serializeParam(
          _nombre,
          ParamType.String,
        ),
        'direccion': serializeParam(
          _direccion,
          ParamType.String,
        ),
        'cdciiu': serializeParam(
          _cdciiu,
          ParamType.String,
        ),
        'contacto': serializeParam(
          _contacto,
          ParamType.String,
        ),
        'TEL1': serializeParam(
          _tel1,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'codprecio': serializeParam(
          _codprecio,
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
      }.withoutNulls;

  static DataClienteStruct fromSerializableMap(Map<String, dynamic> data) =>
      DataClienteStruct(
        tipoCar: deserializeParam(
          data['tipoCar'],
          ParamType.String,
          false,
        ),
        codigoCta: deserializeParam(
          data['codigoCta'],
          ParamType.String,
          false,
        ),
        nit: deserializeParam(
          data['nit'],
          ParamType.String,
          false,
        ),
        vendedor: deserializeParam(
          data['vendedor'],
          ParamType.String,
          false,
        ),
        nombre: deserializeParam(
          data['nombre'],
          ParamType.String,
          false,
        ),
        direccion: deserializeParam(
          data['direccion'],
          ParamType.String,
          false,
        ),
        cdciiu: deserializeParam(
          data['cdciiu'],
          ParamType.String,
          false,
        ),
        contacto: deserializeParam(
          data['contacto'],
          ParamType.String,
          false,
        ),
        tel1: deserializeParam(
          data['TEL1'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        codprecio: deserializeParam(
          data['codprecio'],
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
      );

  @override
  String toString() => 'DataClienteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DataClienteStruct &&
        tipoCar == other.tipoCar &&
        codigoCta == other.codigoCta &&
        nit == other.nit &&
        vendedor == other.vendedor &&
        nombre == other.nombre &&
        direccion == other.direccion &&
        cdciiu == other.cdciiu &&
        contacto == other.contacto &&
        tel1 == other.tel1 &&
        email == other.email &&
        codprecio == other.codprecio &&
        nomciud == other.nomciud &&
        nomdpto == other.nomdpto;
  }

  @override
  int get hashCode => const ListEquality().hash([
        tipoCar,
        codigoCta,
        nit,
        vendedor,
        nombre,
        direccion,
        cdciiu,
        contacto,
        tel1,
        email,
        codprecio,
        nomciud,
        nomdpto
      ]);
}

DataClienteStruct createDataClienteStruct({
  String? tipoCar,
  String? codigoCta,
  String? nit,
  String? vendedor,
  String? nombre,
  String? direccion,
  String? cdciiu,
  String? contacto,
  String? tel1,
  String? email,
  String? codprecio,
  String? nomciud,
  String? nomdpto,
}) =>
    DataClienteStruct(
      tipoCar: tipoCar,
      codigoCta: codigoCta,
      nit: nit,
      vendedor: vendedor,
      nombre: nombre,
      direccion: direccion,
      cdciiu: cdciiu,
      contacto: contacto,
      tel1: tel1,
      email: email,
      codprecio: codprecio,
      nomciud: nomciud,
      nomdpto: nomdpto,
    );
