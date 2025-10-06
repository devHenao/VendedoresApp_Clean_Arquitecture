import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final String? tipocar;
  final String? codigocta;
  final String nit;
  final String? vendedor;
  final String nombre;
  final String? direccion;
  final String? cdciiu;
  final String? contacto;
  final String? tel1;
  final String? email;
  final String? codprecio;
  final String? nomciud;
  final String? nomdpto;

  const Client({
    this.tipocar,
    this.codigocta,
    required this.nit,
    this.vendedor,
    required this.nombre,
    this.direccion,
    this.cdciiu,
    this.contacto,
    this.tel1,
    this.email,
    this.codprecio,
    this.nomciud,
    this.nomdpto,
  });

  @override
  List<Object?> get props => [
        tipocar,
        codigocta,
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
        nomdpto,
      ];

  Client copyWith({
    String? tipocar,
    String? codigocta,
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
  }) {
    return Client(
      tipocar: tipocar ?? this.tipocar,
      codigocta: codigocta ?? this.codigocta,
      nit: nit ?? this.nit,
      vendedor: vendedor ?? this.vendedor,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      cdciiu: cdciiu ?? this.cdciiu,
      contacto: contacto ?? this.contacto,
      tel1: tel1 ?? this.tel1,
      email: email ?? this.email,
      codprecio: codprecio ?? this.codprecio,
      nomciud: nomciud ?? this.nomciud,
      nomdpto: nomdpto ?? this.nomdpto,
    );
  }
}
