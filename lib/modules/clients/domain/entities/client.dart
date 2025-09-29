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
}
