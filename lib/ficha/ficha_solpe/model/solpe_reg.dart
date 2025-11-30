import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:v_al_sam_v02/resources/a_entero_2.dart';

import '../../../resources/titulo.dart';
import 'solpe_reg_enum.dart';

class SolPeReg {
  String id;
  String pedidonumber;
  String pos;
  String e4e;
  String descripcion;
  String um;
  int ctds;
  int ctdp;
  String pedido;
  String pdi;
  String proyecto;
  String unidad;
  String circuito;
  String ecpersona;
  String ecfecha;
  String eccomentario;
  String enelpersona;
  String enelfecha;
  String enelcomentario;
  String estado;
  String estadofecha;
  String iden;
  SolPeReg({
    required this.id,
    required this.pedidonumber,
    required this.pos,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctds,
    required this.ctdp,
    required this.pedido,
    required this.pdi,
    required this.proyecto,
    required this.unidad,
    required this.circuito,
    required this.ecpersona,
    required this.ecfecha,
    required this.eccomentario,
    required this.enelpersona,
    required this.enelfecha,
    required this.enelcomentario,
    required this.estado,
    required this.estadofecha,
    required this.iden,
  });

  List<String> toList() {
    return [
      id,
      pedidonumber,
      pos,
      e4e,
      descripcion,
      um,
      '$ctds',
      '$ctdp',
      pedido,
      pdi,
      proyecto,
      unidad,
      circuito,
      ecpersona,
      ecfecha,
      eccomentario,
      enelpersona,
      enelfecha,
      enelcomentario,
      estado,
      estadofecha,
      iden,
    ];
  }

  SolPeReg copyWith({
    String? id,
    String? pedidonumber,
    String? pos,
    String? e4e,
    String? descripcion,
    String? um,
    int? ctds,
    int? ctdp,
    String? pedido,
    String? pdi,
    String? proyecto,
    String? unidad,
    String? circuito,
    String? ecpersona,
    String? ecfecha,
    String? eccomentario,
    String? enelpersona,
    String? enelfecha,
    String? enelcomentario,
    String? estado,
    String? estadofecha,
    String? iden,
  }) {
    return SolPeReg(
      id: id ?? this.id,
      pedidonumber: pedidonumber ?? this.pedidonumber,
      pos: pos ?? this.pos,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctds: ctds ?? this.ctds,
      ctdp: ctdp ?? this.ctdp,
      pedido: pedido ?? this.pedido,
      pdi: pdi ?? this.pdi,
      proyecto: proyecto ?? this.proyecto,
      unidad: unidad ?? this.unidad,
      circuito: circuito ?? this.circuito,
      ecpersona: ecpersona ?? this.ecpersona,
      ecfecha: ecfecha ?? this.ecfecha,
      eccomentario: eccomentario ?? this.eccomentario,
      enelpersona: enelpersona ?? this.enelpersona,
      enelfecha: enelfecha ?? this.enelfecha,
      enelcomentario: enelcomentario ?? this.enelcomentario,
      estado: estado ?? this.estado,
      estadofecha: estadofecha ?? this.estadofecha,
      iden: iden ?? this.iden,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pedidonumber': pedidonumber,
      'pos': pos,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctds': ctds,
      'ctdp': ctdp,
      'pedido': pedido,
      'pdi': pdi,
      'proyecto': proyecto,
      'unidad': unidad,
      'circuito': circuito,
      'ecpersona': ecpersona,
      'ecfecha': ecfecha,
      'eccomentario': eccomentario,
      'enelpersona': enelpersona,
      'enelfecha': enelfecha,
      'enelcomentario': enelcomentario,
      'estado': estado,
      'estadofecha': estadofecha,
      'iden': iden,
    };
  }

  factory SolPeReg.fromMap(Map<String, dynamic> map) {
    return SolPeReg(
      id: map['id'].toString(),
      pedidonumber: map['pedidonumber'].toString(),
      pos: map['pos'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctds: aEntero(map['ctds'].toString()),
      ctdp: aEntero(map['ctdp'].toString()),
      pedido: map['pedido'].toString(),
      pdi: map['pdi'].toString(),
      proyecto: map['proyecto'].toString(),
      unidad: map['unidad'].toString(),
      circuito: map['circuito'].toString(),
      ecpersona: map['ecpersona'].toString(),
      ecfecha: map['ecfecha'].toString(),
      eccomentario: map['eccomentario'].toString(),
      enelpersona: map['enelpersona'].toString(),
      enelfecha: map['enelfecha'].toString(),
      enelcomentario: map['enelcomentario'].toString(),
      estado: map['estado'].toString(),
      estadofecha: map['estadofecha'].toString(),
      iden: map['iden']?.toString() ?? "",
    );
  }

  factory SolPeReg.fromInit() {
    return SolPeReg(
      id: "",
      pedidonumber: "",
      pos: "",
      e4e: "",
      descripcion: "Sin valor en la BD",
      um: "",
      ctds: aEntero(""),
      ctdp: aEntero(""),
      pedido: "",
      pdi: "",
      proyecto: "",
      unidad: "",
      circuito: "",
      ecpersona: "",
      ecfecha: "",
      eccomentario: "",
      enelpersona: "",
      enelfecha: "",
      enelcomentario: "",
      estado: "",
      estadofecha: "",
      iden: "",
    );
  }
  factory SolPeReg.fromIndex(int index) {
    return SolPeReg(
      id: "",
      pedidonumber: "",
      pos: '${index + 1}',
      e4e: "",
      descripcion: "Por favor ingrese un código E4E",
      um: "",
      ctds: aEntero(""),
      ctdp: aEntero(""),
      pedido: "",
      pdi: "",
      proyecto: "",
      unidad: "",
      circuito: "",
      ecpersona: "",
      ecfecha: "",
      eccomentario: "",
      enelpersona: "",
      enelfecha: "",
      enelcomentario: "",
      estado: "",
      estadofecha: "",
      iden: "",
    );
  }

  String toJson() => json.encode(toMap());

  factory SolPeReg.fromJson(String source) =>
      SolPeReg.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SolPeReg(id: $id, pedidonumber: $pedidonumber, pos: $pos, e4e: $e4e, descripcion: $descripcion, um: $um, ctds: $ctds, ctdp: $ctdp, pedido: $pedido, pdi: $pdi, proyecto: $proyecto, circuito: $circuito, ecpersona: $ecpersona, ecfecha: $ecfecha, eccomentario: $eccomentario, enelpersona: $enelpersona, enelfecha: $enelfecha, enelcomentario: $enelcomentario, estado: $estado, estadofecha: $estadofecha)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SolPeReg &&
        other.id == id &&
        other.pedidonumber == pedidonumber &&
        other.pos == pos &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.ctds == ctds &&
        other.ctdp == ctdp &&
        other.pedido == pedido &&
        other.pdi == pdi &&
        other.proyecto == proyecto &&
        other.circuito == circuito &&
        other.ecpersona == ecpersona &&
        other.ecfecha == ecfecha &&
        other.eccomentario == eccomentario &&
        other.enelpersona == enelpersona &&
        other.enelfecha == enelfecha &&
        other.enelcomentario == enelcomentario &&
        other.estado == estado &&
        other.estadofecha == estadofecha;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pedidonumber.hashCode ^
        pos.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        ctds.hashCode ^
        ctdp.hashCode ^
        pedido.hashCode ^
        pdi.hashCode ^
        proyecto.hashCode ^
        circuito.hashCode ^
        ecpersona.hashCode ^
        ecfecha.hashCode ^
        eccomentario.hashCode ^
        enelpersona.hashCode ^
        enelfecha.hashCode ^
        enelcomentario.hashCode ^
        estado.hashCode ^
        
        estadofecha.hashCode;
  }

  String get ecfechaCell {
    if (ecfecha.length > 10) {
      return ecfecha.substring(0, 10);
    }
    return ecfecha;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: pedidonumber, flex: 2),
    ToCelda(valor: pos, flex: 1),
    ToCelda(valor: e4e, flex: 1),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: um, flex: 1),
    ToCelda(valor: ctds.toString(), flex: 1),
    ToCelda(valor: ctdp.toString(), flex: 1),
    ToCelda(valor: pedido, flex: 1),
    // ToCelda(valor: pdi, flex: 1),
    // ToCelda(valor: proyecto, flex: 1),
    ToCelda(valor: circuito, flex: 2),
    ToCelda(valor: ecpersona, flex: 4),
    ToCelda(valor: ecfechaCell, flex: 2),
  ];

  Color e4eColor = Colors.black;
  Color descripcionColor = Colors.black;
  Color ctdsColor = Colors.black;
  Color ctdpColor = Colors.black;
  Color circuitoColor = Colors.black;

  String e4eError = '';
  String descripcionError = '';
  String ctdsError = '';
  String ctdpError = '';
  String circuitoError = '';

  String get errors {
    String errors = '';
    if (e4eError.isNotEmpty) errors += 'E4E: $e4eError, ';
    if (descripcionError.isNotEmpty) {
      errors += 'DESCRIPCIÓN: $descripcionError, ';
    }
    if (ctdsError.isNotEmpty) errors += 'CTD S: $ctdsError, ';
    if (ctdpError.isNotEmpty) errors += 'CTD P: $ctdpError, ';
    if (circuitoError.isNotEmpty) errors += 'CIRCUITO: $circuitoError, ';
    return errors;
  }

  Color get errorColor {
    Color errorColor = Colors.black;
    if (e4eColor != Colors.black && errorColor != Colors.red) {
      errorColor = e4eColor;
    }
    if (descripcionColor != Colors.black && errorColor != Colors.red) {
      errorColor = descripcionColor;
    }
    if (ctdsColor != Colors.black && errorColor != Colors.red) {
      errorColor = ctdsColor;
    }
    if (ctdpColor != Colors.black && errorColor != Colors.red) {
      errorColor = ctdpColor;
    }
    if (circuitoColor != Colors.black && errorColor != Colors.red) {
      errorColor = circuitoColor;
    }
    return errorColor;
  }

  setWithEnum({required CampoSolpe tipo, required String value}) {
    if (tipo == CampoSolpe.e4e) e4e = value;
    if (tipo == CampoSolpe.ctds) ctds = aEntero(value);
    if (tipo == CampoSolpe.circuito) circuito = value;
    if (tipo == CampoSolpe.eccomentario) eccomentario = value;
    if (tipo == CampoSolpe.pedido) pedido = value;
  }
}
