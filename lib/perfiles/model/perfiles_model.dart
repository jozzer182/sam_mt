// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Perfiles {
  List<PerfilesSingle> perfilesList = [];
}

class PerfilesSingle {
  String perfil;
  String permiso;
  PerfilesSingle({required this.perfil, required this.permiso});

  PerfilesSingle copyWith({String? perfil, String? permiso}) {
    return PerfilesSingle(
      perfil: perfil ?? this.perfil,
      permiso: permiso ?? this.permiso,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'perfil': perfil, 'permiso': permiso};
  }

  factory PerfilesSingle.fromMap(Map<String, dynamic> map) {
    return PerfilesSingle(
      perfil: map['perfil'].toString(),
      permiso: map['permiso'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PerfilesSingle.fromJson(String source) =>
      PerfilesSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PerfilesSingle(perfil: $perfil, permiso: $permiso)';

  @override
  bool operator ==(covariant PerfilesSingle other) {
    if (identical(this, other)) return true;

    return other.perfil == perfil && other.permiso == permiso;
  }

  @override
  int get hashCode => perfil.hashCode ^ permiso.hashCode;
}
