import 'package:app_vendedores/features/clients/domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.tipoCar,
    required super.codigoCta,
    required super.nit,
    required super.vendedor,
    required super.nombre,
    required super.direccion,
    required super.cdciiu,
    required super.contacto,
    required super.tel1,
    required super.email,
    required super.codprecio,
    required super.nomciud,
    required super.nomdpto,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      tipoCar: json['tipoCar'] ?? '',
      codigoCta: json['codigoCta'] ?? '',
      nit: json['nit'] ?? '',
      vendedor: json['vendedor'] ?? '',
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      cdciiu: json['cdciiu'] ?? '',
      contacto: json['contacto'] ?? '',
      tel1: json['TEL1'] ?? '',
      email: json['email'] ?? '',
      codprecio: json['codprecio'] ?? '',
      nomciud: json['nomciud'] ?? '',
      nomdpto: json['nomdpto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipoCar': tipoCar,
      'codigoCta': codigoCta,
      'nit': nit,
      'vendedor': vendedor,
      'nombre': nombre,
      'direccion': direccion,
      'cdciiu': cdciiu,
      'contacto': contacto,
      'TEL1': tel1,
      'email': email,
      'codprecio': codprecio,
      'nomciud': nomciud,
      'nomdpto': nomdpto,
    };
  }
}
