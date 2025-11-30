import 'dart:convert';
import '../../resources/titulo.dart';

class Colas {
  List<ColasSingle> colasList = [];
  List<ColasSingle> colasListSearch = [];
  int view = 50;
  
  List<ToCelda> titles = [
    ToCelda(valor: 'E4E', flex: 1),
    ToCelda(valor: 'DESCRIPCIÓN', flex: 4),
    ToCelda(valor: 'CANTIDAD', flex: 1),
  ];
}

class ColasSingle {
  String e4e;
  String descripcion;
  String ctd;

  ColasSingle({
    required this.e4e,
    required this.descripcion,
    required this.ctd,
  });

  List<String> toList() {
    return [e4e, descripcion, ctd];
  }

  ColasSingle copyWith({
    String? e4e,
    String? descripcion,
    String? ctd,
  }) {
    return ColasSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      ctd: ctd ?? this.ctd,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'ctd': ctd,
    };
  }

  factory ColasSingle.fromMap(Map<String, dynamic> map) {
    return ColasSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      ctd: map['ctd'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ColasSingle.fromJson(String source) =>
      ColasSingle.fromMap(json.decode(source));

  @override
  String toString() => 'ColasSingle(e4e: $e4e, descripcion: $descripcion, ctd: $ctd)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColasSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion && 
        other.ctd == ctd;
  }

  @override
  int get hashCode => e4e.hashCode ^ descripcion.hashCode ^ ctd.hashCode;

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e, flex: 1),
    ToCelda(valor: descripcion, flex: 4),
    ToCelda(valor: ctd, flex: 1),
  ];
}
