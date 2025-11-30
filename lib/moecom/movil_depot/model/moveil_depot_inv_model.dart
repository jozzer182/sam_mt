import 'dart:convert';

import '../../../resources/titulo.dart';

class MDInv {
  String id;
  String tecnico;
  String tecnicotype;
  String e4e;
  String descripcion;
  String um;
  int movs;
  int entregas;
  int consumos;
  int cantidad;
  MDInv({
    required this.id,
    required this.tecnico,
    required this.tecnicotype,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.movs,
    required this.entregas,
    required this.consumos,
    required this.cantidad,
  });

  List<String> toList() {
    return [
      id,
      tecnico,
      tecnicotype,
      e4e,
      descripcion,
      um,
      movs.toString(),
      entregas.toString(),
      consumos.toString(),
      cantidad.toString(),
    ];
  }

  MDInv copyWith({
    String? id,
    String? tecnico,
    String? tecnicotype,
    String? e4e,
    String? descripcion,
    String? um,
    int? movs,
    int? entregas,
    int? consumos,
    int? cantidad,
  }) {
    return MDInv(
      id: id ?? this.id,
      tecnico: tecnico ?? this.tecnico,
      tecnicotype: tecnicotype ?? this.tecnicotype,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      movs: movs ?? this.movs,
      entregas: entregas ?? this.entregas,
      consumos: consumos ?? this.consumos,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tecnico': tecnico,
      'tecnicotype': tecnicotype,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'movs': movs,
      'entregas': entregas,
      'consumos': consumos,
      'cantidad': cantidad,
    };
  }

  factory MDInv.fromMap(Map<String, dynamic> map) {
    return MDInv(
      id: map['id'] ?? '',
      tecnico: map['tecnico'] ?? '',
      tecnicotype: map['tecnicotype'] ?? '',
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      movs: map['movs']?.toInt() ?? 0,
      entregas: map['entregas']?.toInt() ?? 0,
      consumos: map['consumos']?.toInt() ?? 0,
      cantidad: map['cantidad']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MDInv.fromJson(String source) => MDInv.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MDInv(id: $id, tecnico: $tecnico, tecnicotype: $tecnicotype, e4e: $e4e, descripcion: $descripcion, um: $um, movs: $movs, entregas: $entregas, consumos: $consumos, cantidad: $cantidad)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MDInv &&
        other.id == id &&
        other.tecnico == tecnico &&
        other.tecnicotype == tecnicotype &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.movs == movs &&
        other.entregas == entregas &&
        other.consumos == consumos &&
        other.cantidad == cantidad;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tecnico.hashCode ^
        tecnicotype.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        movs.hashCode ^
        entregas.hashCode ^
        consumos.hashCode ^
        cantidad.hashCode;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e, flex: 2),
    ToCelda(valor: descripcion, flex: 4),
    ToCelda(valor: um, flex: 1),
    ToCelda(valor: movs.toString(), flex: 2),
    ToCelda(valor: entregas.toString(), flex: 2),
    ToCelda(valor: consumos.toString(), flex: 2),
    ToCelda(valor: cantidad.toString(), flex: 2),
  ];
}
