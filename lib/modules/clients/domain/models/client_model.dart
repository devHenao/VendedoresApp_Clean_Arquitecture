import 'package:app_vendedores/modules/clients/domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    String? tipocar,
    String? codigocta,
    required String nit,
    String? vendedor,
    required String nombre,
    String? direccion,
    String? cdciiu,
    String? contacto,
    String? tel1,
    String? email,
    String? codprecio,
    String? nomciud,
    String? nomdpto,
  }) : super(
          tipocar: tipocar,
          codigocta: codigocta,
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

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      tipocar: json['tipocar'],
      codigocta: json['codigocta'],
      nit: json['nit'] ?? '',
      vendedor: json['vendedor'],
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'],
      cdciiu: json['cdciiu'],
      contacto: json['contacto'],
      tel1: json['tel1'],
      email: json['email'],
      codprecio: json['codprecio'],
      nomciud: json['nomciud'],
      nomdpto: json['nomdpto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipocar': tipocar,
      'codigocta': codigocta,
      'nit': nit,
      'vendedor': vendedor,
      'nombre': nombre,
      'direccion': direccion,
      'cdciiu': cdciiu,
      'contacto': contacto,
      'tel1': tel1,
      'email': email,
      'codprecio': codprecio,
      'nomciud': nomciud,
      'nomdpto': nomdpto,
    };
  }

  factory ClientModel.fromEntity(Client entity) {
    return ClientModel(
      tipocar: entity.tipocar,
      codigocta: entity.codigocta,
      nit: entity.nit,
      vendedor: entity.vendedor,
      nombre: entity.nombre,
      direccion: entity.direccion,
      cdciiu: entity.cdciiu,
      contacto: entity.contacto,
      tel1: entity.tel1,
      email: entity.email,
      codprecio: entity.codprecio,
      nomciud: entity.nomciud,
      nomdpto: entity.nomdpto,
    );
  }
}
