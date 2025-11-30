import 'dart:convert';

import '../../resources/titulo.dart';

class Carretes {
  List<CarretesSingle> carretesList = [];
  List<CarretesSingle> carretesListSearch = [];

  List<ToCelda> titles = [
    ToCelda(valor: 'E4E', flex: 1),
    ToCelda(valor: 'DESCRIPCIÓN', flex: 4),
  ];
}

class CarretesSingle {
  String e4e;
  String descripcion;
  CarretesSingle({required this.e4e, required this.descripcion});

  List<String> toList() {
    return [e4e, descripcion];
  }

  CarretesSingle copyWith({String? e4e, String? descripcion}) {
    return CarretesSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  Map<String, dynamic> toMap() {
    return {'e4e': e4e, 'descripcion': descripcion};
  }

  factory CarretesSingle.fromList(List l) {
    return CarretesSingle(e4e: l[0].toString(), descripcion: l[1].toString());
  }

  factory CarretesSingle.fromMap(Map<String, dynamic> map) {
    return CarretesSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CarretesSingle.fromJson(String source) =>
      CarretesSingle.fromMap(json.decode(source));

  @override
  String toString() => 'CarretesSingle(e4e: $e4e, descripcion: $descripcion)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarretesSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion;
  }

  @override
  int get hashCode => e4e.hashCode ^ descripcion.hashCode;

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e, flex: 1),
    ToCelda(valor: descripcion, flex: 4),
  ];
}
