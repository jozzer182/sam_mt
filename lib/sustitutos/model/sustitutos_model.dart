import 'dart:convert';
import 'package:http/http.dart';

import '../../resources/constant/apis.dart';
import '../../resources/titulo.dart';

class Sustitutos {
  List<SustitutosSingle> sustitutosList = [];
  List<SustitutosSingle> sustitutosListSearch = [];
  int view = 70;
  Map itemsAndFlex = {
    'e4eV': [2, 'e4eV'],
    'descripcionV': [6, 'descripcion Cod Viejo'],
    'e4eN': [2, 'e4eN'],
    'descripcionN': [6, 'descripcion Cod Nuevo'],
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
    ToCelda(valor: 'e4eV', flex: 2),
    ToCelda(valor: 'Descripción Cod Viejo', flex: 6),
    ToCelda(valor: 'e4eN', flex: 2),
    ToCelda(valor: 'Descripción Cod Nuevo', flex: 6),
  ];

  obtener() async {
    Map<String, Object> dataSend = {
      'dataReq': {'libro': 'SUSTITUTOS', 'hoja': 'reg'},
      'fname': "getHojaList"
    };
    final Response response = await post(
      Uri.parse(Api.femString),
      body: jsonEncode(dataSend),
    );
    // print(response.body);
    List dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await get(Uri.parse(
          response.headers["location"].toString().replaceAll(',', '')));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }

    for (var item in dataAsListMap.sublist(1)) {
      // print(item);
      sustitutosList.add(SustitutosSingle.fromList(item));
    }
    // print(sustitutosList);
    sustitutosListSearch = [...sustitutosList];
  }

  buscar(String busqueda) {
    sustitutosListSearch = sustitutosList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }
}

class SustitutosSingle {
  String e4eV;
  String descripcionV;
  String e4eN;
  String descripcionN;
  SustitutosSingle({
    required this.e4eV,
    required this.descripcionV,
    required this.e4eN,
    required this.descripcionN,
  });

  List<String> toList() {
    return [
      e4eV,
      descripcionV,
      e4eN,
      descripcionN,
    ];
  }

  List<ToCelda> get celdas => [
        ToCelda(valor: e4eV, flex: 2),
        ToCelda(valor: descripcionV, flex: 6),
        ToCelda(valor: e4eN, flex: 2),
        ToCelda(valor: descripcionN, flex: 6),
      ];

  SustitutosSingle copyWith({
    String? e4eV,
    String? descripcionV,
    String? e4eN,
    String? descripcionN,
  }) {
    return SustitutosSingle(
      e4eV: e4eV ?? this.e4eV,
      descripcionV: descripcionV ?? this.descripcionV,
      e4eN: e4eN ?? this.e4eN,
      descripcionN: descripcionN ?? this.descripcionN,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4eV': e4eV,
      'descripcionV': descripcionV,
      'e4eN': e4eN,
      'descripcionN': descripcionN,
    };
  }

  factory SustitutosSingle.fromList(List l) {
    return SustitutosSingle(
      e4eV: l[0].toString(),
      descripcionV: l[1]
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', '')
          .replaceAll("\n", " "),
      e4eN: l[2].toString(),
      descripcionN: l[3]
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', '')
          .replaceAll("\n", " "),
    );
  }

  factory SustitutosSingle.fromMap(Map<String, dynamic> map) {
    return SustitutosSingle(
      e4eV: map['CODIGO_VIEJO'].toString(),
      descripcionV: map['DESCRIPCION'].toString(),
      e4eN: map['CODIGO_NUEVO'].toString(),
      descripcionN: map['DESCRIPCION_NUEVA'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SustitutosSingle.fromJson(String source) =>
      SustitutosSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SustitutosSingle(e4eV: $e4eV, descripcionV: $descripcionV, e4eN: $e4eN, descripcionN: $descripcionN)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SustitutosSingle &&
        other.e4eV == e4eV &&
        other.descripcionV == descripcionV &&
        other.e4eN == e4eN &&
        other.descripcionN == descripcionN;
  }

  @override
  int get hashCode {
    return e4eV.hashCode ^
        descripcionV.hashCode ^
        e4eN.hashCode ^
        descripcionN.hashCode;
  }
}
