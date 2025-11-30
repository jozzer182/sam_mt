import 'dart:convert';

import 'package:collection/collection.dart';

import '../../resources/titulo.dart';
import '../../resources/toCurrency.dart';

class DeudaOperativaB {
  List<DeudaOperativaBSingle> deudaOperativaB = [];
  List<DeudaOperativaBSingle> deudaOperativaBListSearch = [];
  List<DeudaOperativaBSingle> deudaOperativaBListSearch2 = [];
  List<DeudaOperativaBSingle> deudaOperativaPerson = [];
  List<DeudaOperativaBSingle> deudaOperativaPersonSearch = [];
  int totalValor = 0;
  int totalSobrantes = 0;
  int totalFaltantes = 0;

  List<ToCelda> titles = [
    ToCelda(valor: 'LCL', flex: 2),
    ToCelda(valor: 'Fecha\nSalida', flex: 2),
    ToCelda(valor: 'Fecha\nMb51', flex: 2),
    ToCelda(valor: 'Funcional', flex: 4),
    ToCelda(valor: 'E4E', flex: 1),
    ToCelda(valor: 'Descripción', flex: 6),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'Planillas', flex: 1),
    ToCelda(valor: 'MB51', flex: 1),
    ToCelda(valor: 'Faltante Unidades', flex: 1),
    ToCelda(valor: 'Faltante Valor', flex: 2),
  ];

  Map itemsAndFlex = {
    'lcl': 2,
    'funcional': 4,
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'ctd_total': 1,
    'ctd_con': 1,
    'faltanteUnidades': 1,
    'faltanteValor': 2,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  Map itemsAndFlex2 = {
    // 'lcl': 2,
    'funcional': 4,
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'ctd_total': 1,
    'ctd_con': 1,
    'faltanteUnidades': 1,
    'faltanteValor': 2,
  };
  get keys2 {
    return itemsAndFlex2.keys.toList();
  }

  get listaTitulo2 {
    return [
      for (var key in keys2) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  buscar(String busqueda) {
    deudaOperativaBListSearch = [...deudaOperativaB];
    deudaOperativaBListSearch =
        deudaOperativaB
            .where(
              (element) => element.toList().any(
                (item) => item.toString().toLowerCase().contains(
                  busqueda.toLowerCase(),
                ),
              ),
            )
            .toList();
    deudaOperativaBListSearch2 = [...deudaOperativaBListSearch];
    deudaOperativaBListSearch2.sort(
      (b, a) =>
          int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)),
    );
    deudaOperativaPersonSearch = [...deudaOperativaPerson];
    deudaOperativaPersonSearch =
        deudaOperativaPerson
            .where(
              (element) => element.toList().any(
                (item) => item.toString().toLowerCase().contains(
                  busqueda.toLowerCase(),
                ),
              ),
            )
            .toList();
  }

  busquedaEspecifica(String e4e, String funcional) {
    deudaOperativaBListSearch = [...deudaOperativaB];
    deudaOperativaBListSearch =
        deudaOperativaB
            .where((e) => e.e4e == e4e && e.funcional == funcional)
            .toList();
  }

  List<DeudaActiva> get registrosOperativos {
    List<DeudaActiva> deudaActivaList = [];
    var deudaActiva =
        deudaOperativaB
            .where((e) => int.parse(e.faltanteUnidades) > 0)
            .map(
              (e) => {
                ...e.toMap(),
                ...{'ctd': int.parse(e.faltanteUnidades)},
              },
            )
            .toList();
    // print(deudaActiva);
    var keysToSelect = ['e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd'];
    var registros = groupByList(deudaActiva, keysToSelect, keysToSum);
    registros.sort(
      (a, b) => int.parse('${a['e4e']}').compareTo(int.parse('${b['e4e']}')),
    );
    for (var reg in registros) {
      deudaActivaList.add(
        DeudaActiva(
          ctd: reg['ctd'].toString(),
          e4e: reg['e4e'],
          descripcion: reg['descripcion'],
          um: reg['um'],
        ),
      );
      // print(deudaActivaList.last);
    }

    return deudaActivaList;
  }

  //Agrupar y summar los registros ingresados
  List<Map<String, dynamic>> groupByList(
    List<Map<String, dynamic>> data,
    List<String> keysToSelect,
    List<String> keysToSum,
  ) {
    List<Map<String, dynamic>> dataKeyAsJson =
        data.map((e) {
          e['asJson'] = {};
          for (var key in keysToSelect) {
            e['asJson'].addAll({key: e[key]});
            e.remove(key);
          }
          e['asJson'] = jsonEncode(e['asJson']);
          return e;
        }).toList();
    // print('dataKeyAsJson = $dataKeyAsJson');

    Map<dynamic, Map<String, int>> groupAsMap = groupBy(
      dataKeyAsJson,
      (Map e) => e['asJson'],
    ).map(
      (key, value) => MapEntry(key, {
        for (var keySum in keysToSum)
          keySum: value.fold<int>(0, (p, a) => p + (a[keySum] as int)),
      }),
    );

    List<Map<String, dynamic>> result =
        groupAsMap.entries.map((e) {
          Map<String, dynamic> newMap = jsonDecode(e.key);
          return {...newMap, ...e.value};
        }).toList();
    // print('result = $result');

    return result;
  }

  @override
  String toString() =>
      'DeudaOperativaB(deudaOperativaB=[]: $deudaOperativaB=[], totalValor=0: $totalValor=0)';
}

class DeudaActiva {
  String e4e;
  String descripcion;
  String um;
  String ctd;
  DeudaActiva({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
  });

  DeudaActiva copyWith({
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd,
  }) {
    return DeudaActiva(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd: ctd ?? this.ctd,
    );
  }

  Map<String, dynamic> toMap() {
    return {'e4e': e4e, 'descripcion': descripcion, 'um': um, 'ctd': ctd};
  }

  factory DeudaActiva.fromMap(Map<String, dynamic> map) {
    return DeudaActiva(
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      ctd: map['ctd'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaActiva.fromJson(String source) =>
      DeudaActiva.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaActiva(e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaActiva &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd == ctd;
  }

  @override
  int get hashCode {
    return e4e.hashCode ^ descripcion.hashCode ^ um.hashCode ^ ctd.hashCode;
  }
}

class DeudaOperativaBSingle {
  String lcl;
  String funcional;
  String e4e;
  String descripcion;
  String um;
  String ctd_total;
  String ctd_con;
  String faltanteUnidades;
  String faltanteValor;
  String fecha = "";
  String fechaMb51 = "";
  DeudaOperativaBSingle({
    required this.lcl,
    required this.funcional,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_total,
    required this.ctd_con,
    required this.faltanteUnidades,
    required this.faltanteValor,
    this.fecha = "",
    this.fechaMb51 = "",
  });

  List<String> toList() => [
    lcl,
    fecha,
    fechaMb51,
    funcional,
    e4e,
    descripcion,
    um,
    ctd_total,
    ctd_con,
    faltanteUnidades,
    faltanteValor,
  ];

  DeudaOperativaBSingle copyWith({
    String? lcl,
    String? funcional,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd_total,
    String? ctd_con,
    String? faltanteUnidades,
    String? faltanteValor,
  }) {
    return DeudaOperativaBSingle(
      lcl: lcl ?? this.lcl,
      funcional: funcional ?? this.funcional,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd_total: ctd_total ?? this.ctd_total,
      ctd_con: ctd_con ?? this.ctd_con,
      faltanteUnidades: faltanteUnidades ?? this.faltanteUnidades,
      faltanteValor: faltanteValor ?? this.faltanteValor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lcl': lcl,
      'fecha': fecha,
      'fechaMb51': fechaMb51,
      'funcional': funcional,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd_total': ctd_total,
      'ctd_con': ctd_con,
      'faltanteUnidades': faltanteUnidades,
      'faltanteValor': faltanteValor,
    };
  }

  factory DeudaOperativaBSingle.fromMap(Map<String, dynamic> map) {
    return DeudaOperativaBSingle(
      lcl: map['lcl'] ?? '',
      funcional: map['funcional'] ?? '',
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      ctd_total: map['ctd_total'] ?? '',
      ctd_con: map['ctd_con'] ?? '',
      faltanteUnidades: map['faltanteUnidades'] ?? '',
      faltanteValor: map['faltanteValor'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaOperativaBSingle.fromJson(String source) =>
      DeudaOperativaBSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaOperativaBSingle(lcl: $lcl, funcional: $funcional, e4e: $e4e, descripcion: $descripcion, um: $um, ctd_total: $ctd_total, ctd_con: $ctd_con, faltanteUnidades: $faltanteUnidades, faltanteValor: $faltanteValor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaOperativaBSingle &&
        other.lcl == lcl &&
        other.funcional == funcional &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd_total == ctd_total &&
        other.ctd_con == ctd_con &&
        other.faltanteUnidades == faltanteUnidades &&
        other.faltanteValor == faltanteValor;
  }

  @override
  int get hashCode {
    return lcl.hashCode ^
        funcional.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd_total.hashCode ^
        ctd_con.hashCode ^
        faltanteUnidades.hashCode ^
        faltanteValor.hashCode;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: lcl, flex: 2),
    ToCelda(valor: fecha, flex: 2),
    ToCelda(valor: fechaMb51, flex: 2),
    ToCelda(valor: funcional, flex: 4),
    ToCelda(valor: e4e, flex: 1),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: um, flex: 1),
    ToCelda(valor: ctd_total, flex: 1),
    ToCelda(valor: ctd_con, flex: 1),
    ToCelda(valor: faltanteUnidades, flex: 1),
    ToCelda(valor: toCurrency$(faltanteValor), flex: 2),
  ];
}
