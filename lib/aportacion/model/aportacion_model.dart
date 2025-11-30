import 'dart:convert';

import '../../resources/titulo.dart';

class Aportacion {
  List<AportacionSingle> aportacionList = [];
  List<AportacionSingle> aportacionListSearch = [];

  List<ToCelda> titles = [
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'Descripción', flex: 6),
    ToCelda(valor: 'Norma', flex: 1),
    ToCelda(valor: 'SIE', flex: 2),
    ToCelda(valor: 'Familia', flex: 2),
    ToCelda(valor: 'Familia2', flex: 2),
  ];
}

class AportacionSingle {
  String e4e;
  String descripcion;
  String norma;
  String sie;
  String familia;
  String familia2;
  AportacionSingle({
    required this.e4e,
    required this.descripcion,
    required this.norma,
    required this.sie,
    required this.familia,
    required this.familia2,
  });

  List<String> toList() {
    return [e4e, descripcion, norma, sie, familia, familia2];
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e, flex: 2),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: norma, flex: 1),
    ToCelda(valor: sie, flex: 2),
    ToCelda(valor: familia, flex: 2),
    ToCelda(valor: familia2, flex: 2),
  ];

  AportacionSingle copyWith({
    String? e4e,
    String? descripcion,
    String? norma,
    String? sie,
    String? familia,
    String? familia2,
  }) {
    return AportacionSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      norma: norma ?? this.norma,
      sie: sie ?? this.sie,
      familia: familia ?? this.familia,
      familia2: familia2 ?? this.familia2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'norma': norma,
      'sie': sie,
      'familia': familia,
      'familia2': familia2,
    };
  }

  factory AportacionSingle.fromList(List l) {
    return AportacionSingle(
      e4e: l[0].toString(),
      descripcion: l[1]
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', '')
          .replaceAll("\n", " "),
      norma: l[2].toString(),
      sie: l[3].toString(),
      familia: l[4].toString(),
      familia2: l[5].toString(),
    );
  }

  factory AportacionSingle.fromMap(Map<String, dynamic> map) {
    return AportacionSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      norma: map['norma'].toString(),
      sie: map['sie'].toString(),
      familia: map['familia'].toString(),
      familia2: map['familia2'].toString(),
    );
  }

  factory AportacionSingle.fromInit() {
    return AportacionSingle(
      e4e: '',
      descripcion: '',
      norma: '',
      sie: '',
      familia: '',
      familia2: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AportacionSingle.fromJson(String source) =>
      AportacionSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AportacionSingle(e4e: $e4e, descripcion: $descripcion, norma: $norma, sie: $sie, familia: $familia, familia2: $familia2)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AportacionSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.norma == norma &&
        other.sie == sie &&
        other.familia == familia &&
        other.familia2 == familia2;
  }

  @override
  int get hashCode {
    return e4e.hashCode ^
        descripcion.hashCode ^
        norma.hashCode ^
        sie.hashCode ^
        familia.hashCode ^
        familia2.hashCode;
  }
}
