// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class User {
  String id;
  String correo;
  String nombre;
  String telefono;
  String empresa;
  String pdi;
  String perfil;
  List<String> pdisadicionales;
  List<String> permisos = [];
  User({
    required this.id,
    required this.correo,
    required this.nombre,
    required this.telefono,
    required this.empresa,
    required this.pdi,
    required this.perfil,
    required this.pdisadicionales,
  });

  User copyWith({
    String? id,
    String? correo,
    String? nombre,
    String? telefono,
    String? empresa,
    String? pdi,
    String? perfil,
    List<String>? pdisadicionales,
  }) {
    return User(
      id: id ?? this.id,
      correo: correo ?? this.correo,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      empresa: empresa ?? this.empresa,
      pdi: pdi ?? this.pdi,
      perfil: perfil ?? this.perfil,
      pdisadicionales: pdisadicionales ?? this.pdisadicionales,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'correo': correo,
      'nombre': nombre,
      'telefono': telefono,
      'empresa': empresa,
      'pdi': pdi,
      'perfil': perfil,
      'pdisadicionales': pdisadicionales,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    List<String> pdisadicionales = [];
    if (map['pdisadicionales'].toString().isNotEmpty) {
      pdisadicionales =
          map['pdisadicionales']
              .toString()
              .split(',')
              .map((e) => e.trim())
              .toList();
    }
    pdisadicionales.add(map['pdi'].toString());
    pdisadicionales = pdisadicionales.toSet().toList();
    return User(
      id: map['id'].toString(),
      correo: map['correo'].toString(),
      nombre: map['nombre'].toString(),
      telefono: map['telefono'].toString(),
      empresa: map['empresa'].toString(),
      pdi: map['pdi'].toString(),
      perfil: map['perfil'].toString(),
      pdisadicionales: pdisadicionales,
    );
  }

  factory User.fromInit() {
    return User(
      id: '',
      correo: '',
      nombre: '',
      telefono: '',
      empresa: '',
      pdi: '',
      perfil: '',
      pdisadicionales: [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, correo: $correo, nombre: $nombre, telefono: $telefono, empresa: $empresa, pdi: $pdi, perfil: $perfil, permisos: $permisos)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.correo == correo &&
        other.nombre == nombre &&
        other.telefono == telefono &&
        other.empresa == empresa &&
        other.pdi == pdi &&
        other.perfil == perfil;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        correo.hashCode ^
        nombre.hashCode ^
        telefono.hashCode ^
        empresa.hashCode ^
        pdi.hashCode ^
        perfil.hashCode;
  }
}
