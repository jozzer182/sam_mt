// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../resources/titulo.dart';

class Matno {
  List<MatnoSingle> matnoList = [];
  List<MatnoSingle> matnoListSearch = [];
  int view = 50;
  int totalValor = 0;
  Map itemsAndFlex = {
    'lote': [4, 'lote'],
    'lcl': [4, 'lcl'],
    'lm': [1, 'lm'],
    'pos': [1, 'pos'],
    'e4e': [4, 'e4e'],
    'descripcion': [6, 'descripción'],
    'ctd': [1, 'ctd'],
    'descripcionlm': [6, 'descripción lm'],
    'grafo': [3, 'grafo'],
    'prestacion': [3, 'prest'],
    'lt': [4, 'lt'],
    'ft': [4, 'ft'],
    // 'error': [4, 'error'],
    'usuario': [6, 'usuario'],
    'grupo': [2, 'grupo'],
    // 'actualizado': [4, 'actualizado'],
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
    ToCelda(valor: 'Lote', flex: 4),
    ToCelda(valor: 'LCL', flex: 4),
    ToCelda(valor: 'LM', flex: 1),
    ToCelda(valor: 'Pos', flex: 1),
    ToCelda(valor: 'E4E', flex: 4),
    ToCelda(valor: 'Descripción', flex: 6),
    ToCelda(valor: 'CTD', flex: 1),
    ToCelda(valor: 'Descripción LM', flex: 6),
    ToCelda(valor: 'Grafo', flex: 3),
    ToCelda(valor: 'Prestación', flex: 3),
    ToCelda(valor: 'LT', flex: 4),
    ToCelda(valor: 'FT', flex: 4),
    // ToCelda(valor: 'Error', flex: 4),
    ToCelda(valor: 'Usuario', flex: 6),
    ToCelda(valor: 'Grupo', flex: 2),
  ];

  buscar(String busqueda) {
    matnoListSearch = [...matnoList];
    matnoListSearch =
        matnoList
            .where(
              (element) => element.toList().any(
                (item) => item.toString().toLowerCase().contains(
                  busqueda.toLowerCase(),
                ),
              ),
            )
            .toList();
  }

  // Future obtener(User user, Mb52B mb52) async {
  //   var dataSend = {
  //     'dataReq': {'pdi': user.pdi, 'tx': 'matnocnt'},
  //     'fname': "getSAP",
  //   };

  //   final response = await http.post(
  //     Uri.parse(
  //       "https://script.google.com/macros/s/AKfycbx3CHLQGu7N9euquaTtKgPexhfcQ-F5qHiiBByvSsmuSSvvTjE/exec",
  //     ),
  //     body: jsonEncode(dataSend),
  //   );
  //   var dataAsListMap;
  //   if (response.statusCode == 302) {
  //     var response2 = await http.get(
  //       Uri.parse(response.headers["location"] ?? ''),
  //     );
  //     dataAsListMap = jsonDecode(response2.body)['dataObject'];
  //   } else {
  //     dataAsListMap = jsonDecode(response.body)['dataObject'];
  //   }
  //   for (var item in dataAsListMap) {
  //     matnoList.add(MatnoSingle.fromMap(item));
  //   }
  //   matnoListSearch = [...matnoList];
  //   addMb52(mb52.mb52BList, user.pdi);
  //   return matnoList;
  // }

  // addMb52(List<Mb52BSingle> mb52, String pdi) {
  //   for (MatnoSingle item in matnoList) {
  //     // if (item.lote == pdi) {
  //       item.mb52 =
  //           mb52
  //               .firstWhere(
  //                 (e) => e.material == item.e4e,
  //                 orElse: Mb52BSingle.fromInit,
  //               )
  //               .ctd;
  //     // }
  //   }
  // }

  @override
  String toString() => 'Matno(totalValor $totalValor ,matnoList: $matnoList)';

  Map<String, dynamic> toMap() {
    return {'matnoList': matnoList.map((x) => x.toMap()).toList()};
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Matno && listEquals(other.matnoList, matnoList);
  }

  @override
  int get hashCode => matnoList.hashCode;


}

class MatnoSingle {
  String lote;
  String lcl;
  String lm;
  String pos;
  String e4e;
  String descripcion;
  String ctd;
  String descripcionlm;
  String grafo;
  String prestacion;
  String lt;
  String ft;
  String error;
  String usuario;
  String grupo;
  String actualizado;
  String? mb52;

  List<String> toList() {
    return [
      lote,
      lcl,
      lm,
      pos,
      e4e,
      descripcion,
      ctd,
      mb52 ?? '0',
      descripcionlm,
      grafo,
      prestacion,
      lt,
      ft,
      error,
      usuario,
      grupo,
      actualizado,
    ];
  }

  Color? get isMb52 {
    if (mb52 != null && mb52 != '0') {
      int ctdMb52 = int.parse(mb52!);
      int ctdMatNo = int.parse(ctd);
      if (ctdMb52 > ctdMatNo) {
        return Colors.green;
      } else {
        return Colors.orange[100];
      }
    }
    return null;
  }

  MatnoSingle({
    required this.lote,
    required this.lcl,
    required this.lm,
    required this.pos,
    required this.e4e,
    required this.descripcion,
    required this.ctd,
    required this.descripcionlm,
    required this.grafo,
    required this.prestacion,
    required this.lt,
    required this.ft,
    required this.error,
    required this.usuario,
    required this.grupo,
    required this.actualizado,
  });

  MatnoSingle copyWith({
    String? lote,
    String? lcl,
    String? lm,
    String? pos,
    String? e4e,
    String? descripcion,
    String? ctd,
    String? descripcionlm,
    String? grafo,
    String? prestacion,
    String? lt,
    String? ft,
    String? error,
    String? usuario,
    String? grupo,
    String? actualizado,
  }) {
    return MatnoSingle(
      lote: lote ?? this.lote,
      lcl: lcl ?? this.lcl,
      lm: lm ?? this.lm,
      pos: pos ?? this.pos,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      ctd: ctd ?? this.ctd,
      descripcionlm: descripcionlm ?? this.descripcionlm,
      grafo: grafo ?? this.grafo,
      prestacion: prestacion ?? this.prestacion,
      lt: lt ?? this.lt,
      ft: ft ?? this.ft,
      error: error ?? this.error,
      usuario: usuario ?? this.usuario,
      grupo: grupo ?? this.grupo,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lote': lote,
      'lcl': lcl,
      'lm': lm,
      'pos': pos,
      'e4e': e4e,
      'descripcion': descripcion,
      'ctd': ctd,
      'ctd_pdi': mb52.toString(),
      'descripcionlm': descripcionlm,
      'grafo': grafo,
      'prestacion': prestacion,
      'lt': lt,
      'ft': ft,
      'error': error,
      'usuario': usuario,
      'grupo': grupo,
      'actualizado': actualizado,
    };
  }

  factory MatnoSingle.fromMap(Map<String, dynamic> map) {
    return MatnoSingle(
      lote: map['lote'].toString(),
      lcl: map['lcl'].toString(),
      lm: map['lm'].toString(),
      pos: map['pos'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      ctd: map['ctd'].toString(),
      descripcionlm: map['descripcionlm'].toString(),
      grafo: map['grafo'].toString(),
      prestacion: map['prestacion'].toString(),
      lt:
          map['lt'].toString().length > 10
              ? map['lt'].toString().substring(0, 10)
              : map['lt'].toString(),
      ft:
          map['ft'].toString().length > 10
              ? map['ft'].toString().substring(0, 10)
              : map['ft'].toString(),
      error: map['error'].toString(),
      usuario: map['usuario'].toString(),
      grupo: map['grupo'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MatnoSingle.fromJson(String source) =>
      MatnoSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MatnoSingle(lote: $lote, lcl: $lcl, lm: $lm, pos: $pos, e4e: $e4e, descripcion: $descripcion, ctd: $ctd, descripcionlm: $descripcionlm, grafo: $grafo, prestacion: $prestacion, lt: $lt, ft: $ft, error: $error, usuario: $usuario, grupo: $grupo, actualizado: $actualizado)';
  }

  @override
  bool operator ==(covariant MatnoSingle other) {
    if (identical(this, other)) return true;

    return other.lote == lote &&
        other.lcl == lcl &&
        other.lm == lm &&
        other.pos == pos &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.ctd == ctd &&
        other.descripcionlm == descripcionlm &&
        other.grafo == grafo &&
        other.prestacion == prestacion &&
        other.lt == lt &&
        other.ft == ft &&
        other.error == error &&
        other.usuario == usuario &&
        other.grupo == grupo &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return lote.hashCode ^
        lcl.hashCode ^
        lm.hashCode ^
        pos.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        ctd.hashCode ^
        descripcionlm.hashCode ^
        grafo.hashCode ^
        prestacion.hashCode ^
        lt.hashCode ^
        ft.hashCode ^
        error.hashCode ^
        usuario.hashCode ^
        grupo.hashCode ^
        actualizado.hashCode;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: lote, flex: 4),
    ToCelda(valor: lcl, flex: 4),
    ToCelda(valor: lm, flex: 1),
    ToCelda(valor: pos, flex: 1),
    ToCelda(valor: e4e, flex: 4),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: ctd, flex: 1),
    ToCelda(valor: descripcionlm, flex: 6),
    ToCelda(valor: grafo, flex: 3),
    ToCelda(valor: prestacion, flex: 3),
    ToCelda(valor: lt, flex: 4),
    ToCelda(valor: ft, flex: 4),
    // ToCelda(valor: error, flex: 4),
    ToCelda(valor: usuario, flex: 6),
    ToCelda(valor: grupo, flex: 2),
  ];
}
