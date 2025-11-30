import 'dart:convert';

import '../../resources/a_entero_2.dart';
import '../../resources/numero_precio.dart';
import '../../resources/titulo.dart';

class Mm60 {
  List<Mm60Single> mm60List = [];
  List<Mm60Single> mm60ListSearch = [];
  int view = 70;
  Map itemsAndFlex = {
    'material': [2, 'e4e'],
    'descripcion': [6, 'descripcion'],
    'um': [1, 'um'],
    'precio': [2, 'precio'],
    'mon': [1, 'mon'],
    'grupo': [2, 'grupo'],
    'tpmt': [2, 'tpmt'],
    'ultima_m': [2, 'ultima_m'],
    // 'actualizado':[2,'actualizado'],
  };

  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys)
        {'texto': itemsAndFlex[key][1], 'flex': itemsAndFlex[key][0]},
    ];
  }

  List<ToCelda> titles = [
    ToCelda(valor: 'E4e', flex: 2),
    ToCelda(valor: 'Descripción', flex: 6),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'Precio', flex: 2),
    ToCelda(valor: 'Mon', flex: 1),
    ToCelda(valor: 'Grupo', flex: 2),
    ToCelda(valor: 'TPMT', flex: 2),
    ToCelda(valor: 'Ultima M', flex: 2),
    // ToCelda(valor: 'Actualizado', flex: 2),
  ];

  Mm60();

  buscar(String query) {
    mm60ListSearch =
        mm60List
            .where(
              (element) => element.toList().any(
                (item) =>
                    item.toString().toLowerCase().contains(query.toLowerCase()),
              ),
            )
            .toList();
  }

  @override
  String toString() => 'Mm60(mm60List: $mm60List)';

  Map<String, dynamic> toMap() {
    return {'mm60List': mm60List.map((x) => x.toMap()).toList()};
  }

  String toJson() => json.encode(toMap());

  @override
  int get hashCode => mm60List.hashCode;

}

class Mm60Single {
  String material;
  String precio;
  String descripcion;
  String ultima_m;
  String tpmt;
  String grupo;
  String um;
  String mon;
  String actualizado;
  Mm60Single({
    required this.material,
    required this.precio,
    required this.descripcion,
    required this.ultima_m,
    required this.tpmt,
    required this.grupo,
    required this.um,
    required this.mon,
    required this.actualizado,
  });

  Mm60Single copyWith({
    String? material,
    String? precio,
    String? descripcion,
    String? ultima_m,
    String? tpmt,
    String? grupo,
    String? um,
    String? mon,
    String? actualizado,
  }) {
    return Mm60Single(
      material: material ?? this.material,
      precio: precio ?? this.precio,
      descripcion: descripcion ?? this.descripcion,
      ultima_m: ultima_m ?? this.ultima_m,
      tpmt: tpmt ?? this.tpmt,
      grupo: grupo ?? this.grupo,
      um: um ?? this.um,
      mon: mon ?? this.mon,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  List<String> toList() {
    return [
      material,
      precio,
      descripcion,
      ultima_m,
      tpmt,
      grupo,
      um,
      mon,
      actualizado,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'precio': precio,
      'descripcion': descripcion,
      'ultima_m': ultima_m,
      'tpmt': tpmt,
      'grupo': grupo,
      'um': um,
      'mon': mon,
      'actualizado': actualizado,
    };
  }

  factory Mm60Single.fromMap(Map<String, dynamic> map) {
    return Mm60Single(
      material: map['material'].toString(),
      precio: map['precio'].toString(),
      descripcion: map['descripcion']
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', '')
          .replaceAll("\n", " "),
      ultima_m: map['ultima_m'].toString().substring(0, 10),
      tpmt: map['tpmt'].toString(),
      grupo: map['grupo'].toString(),
      um: map['um'].toString(),
      mon: map['mon'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  factory Mm60Single.fromList(List<dynamic> list) {
    return Mm60Single(
      material: list[0].toString(),
      precio: list[1].toString(),
      descripcion: list[2]
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', '')
          .replaceAll("\n", " "),
      ultima_m: list[3].toString().substring(0, 10),
      tpmt: list[4].toString(),
      grupo: list[5].toString(),
      um: list[6].toString(),
      mon: list[7].toString(),
      actualizado: list[8].toString(),
    );
  }

  factory Mm60Single.fromInit() {
    return Mm60Single(
      material: '',
      precio: '0',
      descripcion: 'No existe en BD',
      ultima_m: '',
      tpmt: '',
      grupo: '',
      um: 'N/A',
      mon: '',
      actualizado: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Mm60Single.fromJson(String source) =>
      Mm60Single.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mm60Single(material: $material, precio: $precio, descripcion: $descripcion, ultima_m: $ultima_m, tpmt: $tpmt, grupo: $grupo, um: $um, mon: $mon, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mm60Single &&
        other.material == material &&
        other.precio == precio &&
        other.descripcion == descripcion &&
        other.ultima_m == ultima_m &&
        other.tpmt == tpmt &&
        other.grupo == grupo &&
        other.um == um &&
        other.mon == mon &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return material.hashCode ^
        precio.hashCode ^
        descripcion.hashCode ^
        ultima_m.hashCode ^
        tpmt.hashCode ^
        grupo.hashCode ^
        um.hashCode ^
        mon.hashCode ^
        actualizado.hashCode;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: material, flex: 2),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: um, flex: 1),
    ToCelda(valor: dinero.format(aEntero(precio)), flex: 2),
    ToCelda(valor: mon, flex: 1),
    ToCelda(valor: grupo, flex: 2),
    ToCelda(valor: tpmt, flex: 2),
    ToCelda(valor: ultima_m, flex: 2),
    // ToCelda(valor: actualizado, flex: 2),
  ];
}
