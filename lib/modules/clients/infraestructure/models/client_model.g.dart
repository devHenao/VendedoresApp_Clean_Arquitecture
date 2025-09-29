// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientModel _$ClientModelFromJson(Map<String, dynamic> json) => ClientModel(
      tipoCar: json['tipoCar'] as String,
      codigoCta: json['codigoCta'] as String,
      nit: json['nit'] as String,
      vendedor: json['vendedor'] as String,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String?,
      cdciiu: json['cdciiu'] as String?,
      contacto: json['contacto'] as String?,
      tel1: json['tel1'] as String?,
      email: json['email'] as String?,
      codprecio: json['codprecio'] as String,
      nomciud: json['nomciud'] as String,
      nomdpto: json['nomdpto'] as String,
    );

Map<String, dynamic> _$ClientModelToJson(ClientModel instance) =>
    <String, dynamic>{
      'tipoCar': instance.tipoCar,
      'codigoCta': instance.codigoCta,
      'nit': instance.nit,
      'vendedor': instance.vendedor,
      'nombre': instance.nombre,
      'direccion': instance.direccion,
      'cdciiu': instance.cdciiu,
      'contacto': instance.contacto,
      'tel1': instance.tel1,
      'email': instance.email,
      'codprecio': instance.codprecio,
      'nomciud': instance.nomciud,
      'nomdpto': instance.nomdpto,
    };
