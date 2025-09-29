import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final String tipoCar;
  final String codigoCta;
  final String nit;
  final String vendedor;
  final String nombre;
  final String? direccion;
  final String? cdciiu;
  final String? contacto;
  final String? tel1;
  final String? email;
  final String codprecio;
  final String nomciud;
  final String nomdpto;

  const Client({
    required this.tipoCar,
    required this.codigoCta,
    required this.nit,
    required this.vendedor,
    required this.nombre,
    this.direccion,
    this.cdciiu,
    this.contacto,
    this.tel1,
    this.email,
    required this.codprecio,
    required this.nomciud,
    required this.nomdpto,
  });

  @override
  List<Object?> get props => [
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
        nomdpto,
      ];
}
