import 'package:app_vendedores/modules/clients/domain/entities/client.dart';
import 'package:json_annotation/json_annotation.dart';
part 'client_model.g.dart';

@JsonSerializable()
class ClientModel extends Client {
  const ClientModel({
    required String tipoCar,
    required String codigoCta,
    required String nit,
    required String vendedor,
    required String nombre,
    String? direccion,
    String? cdciiu,
    String? contacto,
    String? tel1,
    String? email,
    required String codprecio,
    required String nomciud,
    required String nomdpto,
  }) : super(
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

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  // Convertir de entidad a modelo
  factory ClientModel.fromEntity(Client entity) {
    return ClientModel(
      tipoCar: entity.tipoCar,
      codigoCta: entity.codigoCta,
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

  // Convertir de modelo a entidad
  Client toEntity() {
    return Client(
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
  }

  Map<String, dynamic> toJson() => _$ClientModelToJson(this);
}
