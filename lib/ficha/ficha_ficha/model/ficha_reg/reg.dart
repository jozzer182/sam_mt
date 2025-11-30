import 'package:flutter/material.dart';

import 'agendado/reg_agendado.dart';
import 'planificado/reg_planificado.dart';
import 'reg_disponible.dart';
import 'reg_enum.dart';
import 'reg_errores.dart';
import 'reg_log.dart';
import 'reg_oficial.dart';
import 'reg_riesgo.dart';
import 'reg_version.dart';

class FichaReg {
  String item;
  String year;
  String id;
  String estado;
  String estdespacho;
  String tipo;
  String fechainicial;
  String fechacambio;
  String fechasolicitud;
  String unidad;
  String iden;
  String codigo;
  String proyecto;
  String circuito;
  String pm;
  String solicitante;
  String pdi;
  String wbe;
  String proyectowbe;
  String comentario1;
  String comentario2;
  String e4e;
  String descripcion;
  String um;
  String m01q1;
  String m01q2;
  String m01qx;
  String m02q1;
  String m02q2;
  String m02qx;
  String m03q1;
  String m03q2;
  String m03qx;
  String m04q1;
  String m04q2;
  String m04qx;
  String m05q1;
  String m05q2;
  String m05qx;
  String m06q1;
  String m06q2;
  String m06qx;
  String m07q1;
  String m07q2;
  String m07qx;
  String m08q1;
  String m08q2;
  String m08qx;
  String m09q1;
  String m09q2;
  String m09qx;
  String m10q1;
  String m10q2;
  String m10qx;
  String m11q1;
  String m11q2;
  String m11qx;
  String m12q1;
  String m12q2;
  String m12qx;
  bool esControlado = false;

  late FichaRegAgendado agendado;

  FichaRegDisponible disponible = FichaRegDisponible();

  late FichaRegErrores error;

  FichaRegOficial oficial = FichaRegOficial();

  late FichaRegPlanificado planificado;

  FichaRegRiesgo riesgo = FichaRegRiesgo();

  FichaRegVersion version = FichaRegVersion();

  late FichaRegLog log;

  FichaReg({
    this.item = '',
    this.year = '',
    required this.id,
    required this.estado,
    required this.estdespacho,
    required this.tipo,
    required this.fechainicial,
    required this.fechacambio,
    required this.fechasolicitud,
    required this.unidad,
    required this.iden,
    required this.codigo,
    required this.proyecto,
    required this.circuito,
    required this.pm,
    required this.solicitante,
    required this.pdi,
    required this.wbe,
    required this.proyectowbe,
    required this.comentario1,
    required this.comentario2,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.m01q1,
    required this.m01q2,
    required this.m01qx,
    required this.m02q1,
    required this.m02q2,
    required this.m02qx,
    required this.m03q1,
    required this.m03q2,
    required this.m03qx,
    required this.m04q1,
    required this.m04q2,
    required this.m04qx,
    required this.m05q1,
    required this.m05q2,
    required this.m05qx,
    required this.m06q1,
    required this.m06q2,
    required this.m06qx,
    required this.m07q1,
    required this.m07q2,
    required this.m07qx,
    required this.m08q1,
    required this.m08q2,
    required this.m08qx,
    required this.m09q1,
    required this.m09q2,
    required this.m09qx,
    required this.m10q1,
    required this.m10q2,
    required this.m10qx,
    required this.m11q1,
    required this.m11q2,
    required this.m11qx,
    required this.m12q1,
    required this.m12q2,
    required this.m12qx,
  }) {
    agendado = FichaRegAgendado(this);
    planificado = FichaRegPlanificado(this);
    error = FichaRegErrores(this);
    log = FichaRegLog(this);
  }

  List<String> toList() {
    return [
      id,
      estado,
      estdespacho,
      tipo,
      fechainicial,
      fechacambio,
      fechasolicitud,
      unidad,
      iden,
      codigo,
      proyecto,
      circuito,
      pm,
      solicitante,
      pdi,
      wbe,
      proyectowbe,
      comentario1,
      comentario2,
      e4e,
      descripcion,
      um,
      m01q1,
      m01q2,
      m01qx,
      m02q1,
      m02q2,
      m02qx,
      m03q1,
      m03q2,
      m03qx,
      m04q1,
      m04q2,
      m04qx,
      m05q1,
      m05q2,
      m05qx,
      m06q1,
      m06q2,
      m06qx,
      m07q1,
      m07q2,
      m07qx,
      m08q1,
      m08q2,
      m08qx,
      m09q1,
      m09q2,
      m09qx,
      m10q1,
      m10q2,
      m10qx,
      m11q1,
      m11q2,
      m11qx,
      m12q1,
      m12q2,
      m12qx,
    ];
  }

  FichaReg copyWith({
    String? item,
    String? year,
    String? id,
    String? estado,
    String? estdespacho,
    String? tipo,
    String? fechainicial,
    String? fechacambio,
    String? fechasolicitud,
    String? unidad,
    String? iden,
    String? codigo,
    String? proyecto,
    String? circuito,
    String? pm,
    String? solicitante,
    String? pdi,
    String? wbe,
    String? proyectowbe,
    String? comentario1,
    String? comentario2,
    String? e4e,
    String? descripcion,
    String? um,
    String? m01q1,
    String? m01q2,
    String? m01qx,
    String? m02q1,
    String? m02q2,
    String? m02qx,
    String? m03q1,
    String? m03q2,
    String? m03qx,
    String? m04q1,
    String? m04q2,
    String? m04qx,
    String? m05q1,
    String? m05q2,
    String? m05qx,
    String? m06q1,
    String? m06q2,
    String? m06qx,
    String? m07q1,
    String? m07q2,
    String? m07qx,
    String? m08q1,
    String? m08q2,
    String? m08qx,
    String? m09q1,
    String? m09q2,
    String? m09qx,
    String? m10q1,
    String? m10q2,
    String? m10qx,
    String? m11q1,
    String? m11q2,
    String? m11qx,
    String? m12q1,
    String? m12q2,
    String? m12qx,
    ValueGetter<Color?>? circuitoColor,
    ValueGetter<Color?>? wbeColor,
    ValueGetter<Color?>? wbeColorFill,
    ValueGetter<Color?>? e4eColor,
    ValueGetter<Color?>? pdiColor,
    ValueGetter<Color?>? comentarioColor,
  }) {
    return FichaReg(
      item: item ?? this.item,
      year: year ?? this.year,
      id: id ?? this.id,
      estado: estado ?? this.estado,
      estdespacho: estdespacho ?? this.estdespacho,
      tipo: tipo ?? this.tipo,
      fechainicial: fechainicial ?? this.fechainicial,
      fechacambio: fechacambio ?? this.fechacambio,
      fechasolicitud: fechasolicitud ?? this.fechasolicitud,
      unidad: unidad ?? this.unidad,
      iden: iden ?? this.iden,
      codigo: codigo ?? this.codigo,
      proyecto: proyecto ?? this.proyecto,
      circuito: circuito ?? this.circuito,
      pm: pm ?? this.pm,
      solicitante: solicitante ?? this.solicitante,
      pdi: pdi ?? this.pdi,
      wbe: wbe ?? this.wbe,
      proyectowbe: proyectowbe ?? this.proyectowbe,
      comentario1: comentario1 ?? this.comentario1,
      comentario2: comentario2 ?? this.comentario2,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      m01q1: m01q1 ?? this.m01q1,
      m01q2: m01q2 ?? this.m01q2,
      m01qx: m01qx ?? this.m01qx,
      m02q1: m02q1 ?? this.m02q1,
      m02q2: m02q2 ?? this.m02q2,
      m02qx: m02qx ?? this.m02qx,
      m03q1: m03q1 ?? this.m03q1,
      m03q2: m03q2 ?? this.m03q2,
      m03qx: m03qx ?? this.m03qx,
      m04q1: m04q1 ?? this.m04q1,
      m04q2: m04q2 ?? this.m04q2,
      m04qx: m04qx ?? this.m04qx,
      m05q1: m05q1 ?? this.m05q1,
      m05q2: m05q2 ?? this.m05q2,
      m05qx: m05qx ?? this.m05qx,
      m06q1: m06q1 ?? this.m06q1,
      m06q2: m06q2 ?? this.m06q2,
      m06qx: m06qx ?? this.m06qx,
      m07q1: m07q1 ?? this.m07q1,
      m07q2: m07q2 ?? this.m07q2,
      m07qx: m07qx ?? this.m07qx,
      m08q1: m08q1 ?? this.m08q1,
      m08q2: m08q2 ?? this.m08q2,
      m08qx: m08qx ?? this.m08qx,
      m09q1: m09q1 ?? this.m09q1,
      m09q2: m09q2 ?? this.m09q2,
      m09qx: m09qx ?? this.m09qx,
      m10q1: m10q1 ?? this.m10q1,
      m10q2: m10q2 ?? this.m10q2,
      m10qx: m10qx ?? this.m10qx,
      m11q1: m11q1 ?? this.m11q1,
      m11q2: m11q2 ?? this.m11q2,
      m11qx: m11qx ?? this.m11qx,
      m12q1: m12q1 ?? this.m12q1,
      m12q2: m12q2 ?? this.m12q2,
      m12qx: m12qx ?? this.m12qx,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'year': year,
      'id': id,
      'estado': estado,
      'estdespacho': estdespacho,
      'tipo': tipo,
      'fechainicial': fechainicial,
      'fechacambio': fechacambio,
      'fechasolicitud': fechasolicitud,
      'unidad': unidad,
      'iden': iden,
      'codigo': codigo,
      'proyecto': proyecto,
      'circuito': circuito,
      'pm': pm,
      'solicitante': solicitante,
      'pdi': pdi,
      'wbe': wbe,
      'proyectowbe': proyectowbe,
      'comentario1': comentario1,
      'comentario2': comentario2,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'm01q1': m01q1,
      'm01q2': m01q2,
      'm01qx': m01qx,
      'm02q1': m02q1,
      'm02q2': m02q2,
      'm02qx': m02qx,
      'm03q1': m03q1,
      'm03q2': m03q2,
      'm03qx': m03qx,
      'm04q1': m04q1,
      'm04q2': m04q2,
      'm04qx': m04qx,
      'm05q1': m05q1,
      'm05q2': m05q2,
      'm05qx': m05qx,
      'm06q1': m06q1,
      'm06q2': m06q2,
      'm06qx': m06qx,
      'm07q1': m07q1,
      'm07q2': m07q2,
      'm07qx': m07qx,
      'm08q1': m08q1,
      'm08q2': m08q2,
      'm08qx': m08qx,
      'm09q1': m09q1,
      'm09q2': m09q2,
      'm09qx': m09qx,
      'm10q1': m10q1,
      'm10q2': m10q2,
      'm10qx': m10qx,
      'm11q1': m11q1,
      'm11q2': m11q2,
      'm11qx': m11qx,
      'm12q1': m12q1,
      'm12q2': m12q2,
      'm12qx': m12qx,
    };
  }

  factory FichaReg.fromInit(int n, String miniyear) {
    var fichaReg = FichaReg(
      item: n.toString().padLeft(2, '0'),
      year: '',
      id: '',
      estado: 'nuevo',
      estdespacho:
          '[{"01|$miniyear-1":"0","01|$miniyear-2":"0","02|$miniyear-1":"0","02|$miniyear-2":"0","03|$miniyear-1":"0","03|$miniyear-2":"0","04|$miniyear-1":"0","04|$miniyear-2":"0","05|$miniyear-1":"0","05|$miniyear-2":"0","06|$miniyear-1":"0","06|$miniyear-2":"0","07|$miniyear-1":"0","07|$miniyear-2":"0","08|$miniyear-1":"0","08|$miniyear-2":"0","09|$miniyear-1":"0","09|$miniyear-2":"0","10|$miniyear-1":"0","10|$miniyear-2":"0","11|$miniyear-1":"0","11|$miniyear-2":"0","12|$miniyear-1":"0","12|$miniyear-2":"0"}]',
      tipo: '',
      fechainicial: '',
      fechacambio: '',
      fechasolicitud: '',
      unidad: '',
      iden: '',
      codigo: '',
      proyecto: '',
      circuito: '',
      pm: '',
      solicitante: '',
      pdi: '',
      wbe: '',
      proyectowbe: '',
      comentario1: '',
      comentario2: '',
      e4e: '',
      descripcion: '',
      um: '',
      m01q1: '',
      m01q2: '',
      m01qx: '',
      m02q1: '',
      m02q2: '',
      m02qx: '',
      m03q1: '',
      m03q2: '',
      m03qx: '',
      m04q1: '',
      m04q2: '',
      m04qx: '',
      m05q1: '',
      m05q2: '',
      m05qx: '',
      m06q1: '',
      m06q2: '',
      m06qx: '',
      m07q1: '',
      m07q2: '',
      m07qx: '',
      m08q1: '',
      m08q2: '',
      m08qx: '',
      m09q1: '',
      m09q2: '',
      m09qx: '',
      m10q1: '',
      m10q2: '',
      m10qx: '',
      m11q1: '',
      m11q2: '',
      m11qx: '',
      m12q1: '',
      m12q2: '',
      m12qx: '',
    );
    fichaReg.error.e4eColor = Colors.red;
    fichaReg.error.e4e = 'Se requiere un código E4E válido';
    return fichaReg;
  }

  factory FichaReg.fromList(List<dynamic> ls) {
    var fichaReg = FichaReg(
      id: ls[0].toString(),
      estado: ls[1].toString(),
      estdespacho: ls[2].toString(),
      tipo: ls[3].toString(),
      fechainicial:
          ls[4].toString().length > 10
              ? ls[4].toString().substring(0, 10)
              : ls[4].toString(),
      fechacambio:
          ls[5].toString().length > 10
              ? ls[5].toString().substring(0, 10)
              : ls[5].toString(),
      fechasolicitud:
          ls[6].toString().length > 10
              ? ls[6].toString().substring(0, 10)
              : ls[6].toString(),
      unidad: ls[7].toString(),
      iden: ls[7].toString(),
      codigo: ls[8].toString(),
      proyecto: ls[9].toString(),
      circuito: ls[10].toString(),
      pm: ls[11].toString(),
      solicitante: ls[12].toString(),
      pdi: ls[13].toString(),
      wbe: ls[14].toString(),
      proyectowbe: ls[15].toString(),
      comentario1: ls[16]
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', '')
          .replaceAll("\n", " "),
      comentario2: ls[17]
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', '')
          .replaceAll("\n", " "),
      e4e: ls[18].toString(),
      descripcion: ls[19]
          .toString()
          .replaceAll('"', '')
          .replaceAll(';', '')
          .replaceAll(',', ''),
      um: ls[20].toString(),
      m01q1: ls[21].toString(),
      m01q2: ls[22].toString(),
      m01qx: ls[23].toString(),
      m02q1: ls[24].toString(),
      m02q2: ls[25].toString(),
      m02qx: ls[26].toString(),
      m03q1: ls[27].toString(),
      m03q2: ls[28].toString(),
      m03qx: ls[29].toString(),
      m04q1: ls[30].toString(),
      m04q2: ls[31].toString(),
      m04qx: ls[32].toString(),
      m05q1: ls[33].toString(),
      m05q2: ls[34].toString(),
      m05qx: ls[35].toString(),
      m06q1: ls[36].toString(),
      m06q2: ls[37].toString(),
      m06qx: ls[38].toString(),
      m07q1: ls[39].toString(),
      m07q2: ls[40].toString(),
      m07qx: ls[41].toString(),
      m08q1: ls[42].toString(),
      m08q2: ls[43].toString(),
      m08qx: ls[44].toString(),
      m09q1: ls[45].toString(),
      m09q2: ls[46].toString(),
      m09qx: ls[47].toString(),
      m10q1: ls[48].toString(),
      m10q2: ls[49].toString(),
      m10qx: ls[50].toString(),
      m11q1: ls[51].toString(),
      m11q2: ls[52].toString(),
      m11qx: ls[53].toString(),
      m12q1: ls[54].toString(),
      m12q2: ls[55].toString(),
      m12qx: ls[56].toString(),
    );
    return fichaReg;
  }

  factory FichaReg.fromMap(Map<String, dynamic> map) {
    var fichaReg = FichaReg(
      id: map['id']?.toString() ?? '',
      estado: map['estado']?.toString() ?? '',
      estdespacho: map['estdespacho']?.toString() ?? '',
      tipo: map['tipo']?.toString() ?? '',
      fechainicial:
          map['fechainicial'].toString().length > 10
              ? map['fechainicial'].toString().substring(0, 10)
              : map['fechainicial']?.toString() ?? '',
      fechacambio:
          map['fechacambio'].toString().length > 10
              ? map['fechacambio'].toString().substring(0, 10)
              : map['fechacambio']?.toString() ?? '',
      fechasolicitud:
          map['fechasolicitud'].toString().length > 10
              ? map['fechasolicitud'].toString().substring(0, 10)
              : map['fechasolicitud']?.toString() ?? '',
      unidad: map['unidad']?.toString() ?? '',
      iden: map['iden']?.toString() ?? '',
      codigo: map['codigo']?.toString() ?? '',
      proyecto: map['proyecto']?.toString() ?? '',
      circuito: map['circuito']?.toString() ?? '',
      pm: map['pm']?.toString() ?? '',
      solicitante: map['solicitante']?.toString() ?? '',
      pdi: map['pdi']?.toString() ?? '',
      wbe: map['wbe']?.toString() ?? '',
      proyectowbe: map['proyecto_wbe']?.toString() ?? '',
      comentario1:
          map['comentario1']
              ?.toString()
              .replaceAll('"', '')
              .replaceAll(';', '')
              .replaceAll(',', '')
              .replaceAll("\n", " ") ??
          '',
      comentario2:
          map['comentario2']
              ?.toString()
              .replaceAll('"', '')
              .replaceAll(';', '')
              .replaceAll(',', '')
              .replaceAll("\n", " ") ??
          '',
      e4e: map['e4e']?.toString() ?? '',
      descripcion:
          map['descripcion']
              ?.toString()
              .replaceAll('"', '')
              .replaceAll(';', '')
              .replaceAll(',', '') ??
          '',
      um: map['um']?.toString() ?? '',
      m01q1: map['m01q1']?.toString() ?? '',
      m01q2: map['m01q2']?.toString() ?? '',
      m01qx: map['m01qx']?.toString() ?? '',
      m02q1: map['m02q1']?.toString() ?? '',
      m02q2: map['m02q2']?.toString() ?? '',
      m02qx: map['m02qx']?.toString() ?? '',
      m03q1: map['m03q1']?.toString() ?? '',
      m03q2: map['m03q2']?.toString() ?? '',
      m03qx: map['m03qx']?.toString() ?? '',
      m04q1: map['m04q1']?.toString() ?? '',
      m04q2: map['m04q2']?.toString() ?? '',
      m04qx: map['m04qx']?.toString() ?? '',
      m05q1: map['m05q1']?.toString() ?? '',
      m05q2: map['m05q2']?.toString() ?? '',
      m05qx: map['m05qx']?.toString() ?? '',
      m06q1: map['m06q1']?.toString() ?? '',
      m06q2: map['m06q2']?.toString() ?? '',
      m06qx: map['m06qx']?.toString() ?? '',
      m07q1: map['m07q1']?.toString() ?? '',
      m07q2: map['m07q2']?.toString() ?? '',
      m07qx: map['m07qx']?.toString() ?? '',
      m08q1: map['m08q1']?.toString() ?? '',
      m08q2: map['m08q2']?.toString() ?? '',
      m08qx: map['m08qx']?.toString() ?? '',
      m09q1: map['m09q1']?.toString() ?? '',
      m09q2: map['m09q2']?.toString() ?? '',
      m09qx: map['m09qx']?.toString() ?? '',
      m10q1: map['m10q1']?.toString() ?? '',
      m10q2: map['m10q2']?.toString() ?? '',
      m10qx: map['m10qx']?.toString() ?? '',
      m11q1: map['m11q1']?.toString() ?? '',
      m11q2: map['m11q2']?.toString() ?? '',
      m11qx: map['m11qx']?.toString() ?? '',
      m12q1: map['m12q1']?.toString() ?? '',
      m12q2: map['m12q2']?.toString() ?? '',
      m12qx: map['m12qx']?.toString() ?? '',
    );
    return fichaReg;
  }

  setWithEnum({required TipoRegFicha tipo, required String value}) {
    if (tipo == TipoRegFicha.item) item = value;
    if (tipo == TipoRegFicha.year) year = value;
    if (tipo == TipoRegFicha.id) id = value;
    if (tipo == TipoRegFicha.estado) estado = value;
    if (tipo == TipoRegFicha.estdespacho) estdespacho = value;
    if (tipo == TipoRegFicha.tipo) this.tipo = value;
    if (tipo == TipoRegFicha.fechainicial) fechainicial = value;
    if (tipo == TipoRegFicha.fechacambio) fechacambio = value;
    if (tipo == TipoRegFicha.fechasolicitud) fechasolicitud = value;
    if (tipo == TipoRegFicha.unidad) unidad = value;
    if (tipo == TipoRegFicha.codigo) codigo = value;
    if (tipo == TipoRegFicha.proyecto) proyecto = value;
    if (tipo == TipoRegFicha.circuito) circuito = value;
    if (tipo == TipoRegFicha.pm) pm = value;
    if (tipo == TipoRegFicha.solicitante) solicitante = value;
    if (tipo == TipoRegFicha.pdi) pdi = value;
    if (tipo == TipoRegFicha.wbe) wbe = value;
    if (tipo == TipoRegFicha.proyectowbe) proyectowbe = value;
    if (tipo == TipoRegFicha.comentario1) comentario1 = value;
    if (tipo == TipoRegFicha.comentario2) comentario2 = value;
    if (tipo == TipoRegFicha.e4e) e4e = value;
    if (tipo == TipoRegFicha.descripcion) descripcion = value;
    if (tipo == TipoRegFicha.um) um = value;
    if (tipo == TipoRegFicha.m01q1) m01q1 = value;
    if (tipo == TipoRegFicha.m01q2) m01q2 = value;
    if (tipo == TipoRegFicha.m01qx) m01qx = value;
    if (tipo == TipoRegFicha.m02q1) m02q1 = value;
    if (tipo == TipoRegFicha.m02q2) m02q2 = value;
    if (tipo == TipoRegFicha.m02qx) m02qx = value;
    if (tipo == TipoRegFicha.m03q1) m03q1 = value;
    if (tipo == TipoRegFicha.m03q2) m03q2 = value;
    if (tipo == TipoRegFicha.m03qx) m03qx = value;
    if (tipo == TipoRegFicha.m04q1) m04q1 = value;
    if (tipo == TipoRegFicha.m04q2) m04q2 = value;
    if (tipo == TipoRegFicha.m04qx) m04qx = value;
    if (tipo == TipoRegFicha.m05q1) m05q1 = value;
    if (tipo == TipoRegFicha.m05q2) m05q2 = value;
    if (tipo == TipoRegFicha.m05qx) m05qx = value;
    if (tipo == TipoRegFicha.m06q1) m06q1 = value;
    if (tipo == TipoRegFicha.m06q2) m06q2 = value;
    if (tipo == TipoRegFicha.m06qx) m06qx = value;
    if (tipo == TipoRegFicha.m07q1) m07q1 = value;
    if (tipo == TipoRegFicha.m07q2) m07q2 = value;
    if (tipo == TipoRegFicha.m07qx) m07qx = value;
    if (tipo == TipoRegFicha.m08q1) m08q1 = value;
    if (tipo == TipoRegFicha.m08q2) m08q2 = value;
    if (tipo == TipoRegFicha.m08qx) m08qx = value;
    if (tipo == TipoRegFicha.m09q1) m09q1 = value;
    if (tipo == TipoRegFicha.m09q2) m09q2 = value;
    if (tipo == TipoRegFicha.m09qx) m09qx = value;
    if (tipo == TipoRegFicha.m10q1) m10q1 = value;
    if (tipo == TipoRegFicha.m10q2) m10q2 = value;
    if (tipo == TipoRegFicha.m10qx) m10qx = value;
    if (tipo == TipoRegFicha.m11q1) m11q1 = value;
    if (tipo == TipoRegFicha.m11q2) m11q2 = value;
    if (tipo == TipoRegFicha.m11qx) m11qx = value;
    if (tipo == TipoRegFicha.m12q1) m12q1 = value;
    if (tipo == TipoRegFicha.m12q2) m12q2 = value;
    if (tipo == TipoRegFicha.m12qx) m12qx = value;
    return this;
  }

  setWithQuincena(String quincena, String value) {
    if (quincena == '01-1') m01q1 = value;
    if (quincena == '01-2') m01q2 = value;
    if (quincena == '02-1') m02q1 = value;
    if (quincena == '02-2') m02q2 = value;
    if (quincena == '03-1') m03q1 = value;
    if (quincena == '03-2') m03q2 = value;
    if (quincena == '04-1') m04q1 = value;
    if (quincena == '04-2') m04q2 = value;
    if (quincena == '05-1') m05q1 = value;
    if (quincena == '05-2') m05q2 = value;
    if (quincena == '06-1') m06q1 = value;
    if (quincena == '06-2') m06q2 = value;
    if (quincena == '07-1') m07q1 = value;
    if (quincena == '07-2') m07q2 = value;
    if (quincena == '08-1') m08q1 = value;
    if (quincena == '08-2') m08q2 = value;
    if (quincena == '09-1') m09q1 = value;
    if (quincena == '09-2') m09q2 = value;
    if (quincena == '10-1') m10q1 = value;
    if (quincena == '10-2') m10q2 = value;
    if (quincena == '11-1') m11q1 = value;
    if (quincena == '11-2') m11q2 = value;
    if (quincena == '12-1') m12q1 = value;
    if (quincena == '12-2') m12q2 = value;
  }

  // //POR COMPATIBILIDAD AL MOMENTO DE TRAER LOS DATOS DE LA BD
  // factory FichaReg.fromSingleFEM(SingleFEM singleFEM) {
  //   return FichaReg(
  //     item: singleFEM.item,
  //     year: singleFEM.year,
  //     id: singleFEM.id,
  //     estado: singleFEM.estado,
  //     estdespacho: singleFEM.estdespacho,
  //     tipo: singleFEM.tipo,
  //     fechainicial: singleFEM.fechainicial,
  //     fechacambio: singleFEM.fechacambio,
  //     fechasolicitud: singleFEM.fechasolicitud,
  //     unidad: singleFEM.unidad,
  //     codigo: singleFEM.codigo,
  //     proyecto: singleFEM.proyecto,
  //     circuito: singleFEM.circuito,
  //     pm: singleFEM.pm,
  //     solicitante: singleFEM.solicitante,
  //     pdi: singleFEM.pdi,
  //     wbe: singleFEM.wbe,
  //     proyectowbe: singleFEM.proyectowbe,
  //     comentario1: singleFEM.comentario1,
  //     comentario2: singleFEM.comentario2,
  //     e4e: singleFEM.e4e,
  //     descripcion: singleFEM.descripcion,
  //     um: singleFEM.um,
  //     m01q1: singleFEM.m01q1,
  //     m01q2: singleFEM.m01q2,
  //     m01qx: singleFEM.m01qx,
  //     m02q1: singleFEM.m02q1,
  //     m02q2: singleFEM.m02q2,
  //     m02qx: singleFEM.m02qx,
  //     m03q1: singleFEM.m03q1,
  //     m03q2: singleFEM.m03q2,
  //     m03qx: singleFEM.m03qx,
  //     m04q1: singleFEM.m04q1,
  //     m04q2: singleFEM.m04q2,
  //     m04qx: singleFEM.m04qx,
  //     m05q1: singleFEM.m05q1,
  //     m05q2: singleFEM.m05q2,
  //     m05qx: singleFEM.m05qx,
  //     m06q1: singleFEM.m06q1,
  //     m06q2: singleFEM.m06q2,
  //     m06qx: singleFEM.m06qx,
  //     m07q1: singleFEM.m07q1,
  //     m07q2: singleFEM.m07q2,
  //     m07qx: singleFEM.m07qx,
  //     m08q1: singleFEM.m08q1,
  //     m08q2: singleFEM.m08q2,
  //     m08qx: singleFEM.m08qx,
  //     m09q1: singleFEM.m09q1,
  //     m09q2: singleFEM.m09q2,
  //     m09qx: singleFEM.m09qx,
  //     m10q1: singleFEM.m10q1,
  //     m10q2: singleFEM.m10q2,
  //     m10qx: singleFEM.m10qx,
  //     m11q1: singleFEM.m11q1,
  //     m11q2: singleFEM.m11q2,
  //     m11qx: singleFEM.m11qx,
  //     m12q1: singleFEM.m12q1,
  //     m12q2: singleFEM.m12q2,
  //     m12qx: singleFEM.m12qx,
  //   );
  // }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FichaReg &&
        other.id == id &&
        other.estado == estado &&
        other.estdespacho == estdespacho &&
        other.tipo == tipo &&
        other.fechainicial == fechainicial &&
        other.fechacambio == fechacambio &&
        other.fechasolicitud == fechasolicitud &&
        other.unidad == unidad &&
        other.codigo == codigo &&
        other.proyecto == proyecto &&
        other.circuito == circuito &&
        other.pm == pm &&
        other.solicitante == solicitante &&
        other.pdi == pdi &&
        other.wbe == wbe &&
        other.proyectowbe == proyectowbe &&
        other.comentario1 == comentario1 &&
        other.comentario2 == comentario2 &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.m01q1 == m01q1 &&
        other.m01q2 == m01q2 &&
        other.m01qx == m01qx &&
        other.m02q1 == m02q1 &&
        other.m02q2 == m02q2 &&
        other.m02qx == m02qx &&
        other.m03q1 == m03q1 &&
        other.m03q2 == m03q2 &&
        other.m03qx == m03qx &&
        other.m04q1 == m04q1 &&
        other.m04q2 == m04q2 &&
        other.m04qx == m04qx &&
        other.m05q1 == m05q1 &&
        other.m05q2 == m05q2 &&
        other.m05qx == m05qx &&
        other.m06q1 == m06q1 &&
        other.m06q2 == m06q2 &&
        other.m06qx == m06qx &&
        other.m07q1 == m07q1 &&
        other.m07q2 == m07q2 &&
        other.m07qx == m07qx &&
        other.m08q1 == m08q1 &&
        other.m08q2 == m08q2 &&
        other.m08qx == m08qx &&
        other.m09q1 == m09q1 &&
        other.m09q2 == m09q2 &&
        other.m09qx == m09qx &&
        other.m10q1 == m10q1 &&
        other.m10q2 == m10q2 &&
        other.m10qx == m10qx &&
        other.m11q1 == m11q1 &&
        other.m11q2 == m11q2 &&
        other.m11qx == m11qx &&
        other.m12q1 == m12q1 &&
        other.m12q2 == m12q2 &&
        other.m12qx == m12qx;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        estado.hashCode ^
        estdespacho.hashCode ^
        tipo.hashCode ^
        fechainicial.hashCode ^
        fechacambio.hashCode ^
        fechasolicitud.hashCode ^
        unidad.hashCode ^
        codigo.hashCode ^
        proyecto.hashCode ^
        circuito.hashCode ^
        pm.hashCode ^
        solicitante.hashCode ^
        pdi.hashCode ^
        wbe.hashCode ^
        proyectowbe.hashCode ^
        comentario1.hashCode ^
        comentario2.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        m01q1.hashCode ^
        m01q2.hashCode ^
        m01qx.hashCode ^
        m02q1.hashCode ^
        m02q2.hashCode ^
        m02qx.hashCode ^
        m03q1.hashCode ^
        m03q2.hashCode ^
        m03qx.hashCode ^
        m04q1.hashCode ^
        m04q2.hashCode ^
        m04qx.hashCode ^
        m05q1.hashCode ^
        m05q2.hashCode ^
        m05qx.hashCode ^
        m06q1.hashCode ^
        m06q2.hashCode ^
        m06qx.hashCode ^
        m07q1.hashCode ^
        m07q2.hashCode ^
        m07qx.hashCode ^
        m08q1.hashCode ^
        m08q2.hashCode ^
        m08qx.hashCode ^
        m09q1.hashCode ^
        m09q2.hashCode ^
        m09qx.hashCode ^
        m10q1.hashCode ^
        m10q2.hashCode ^
        m10qx.hashCode ^
        m11q1.hashCode ^
        m11q2.hashCode ^
        m11qx.hashCode ^
        m12q1.hashCode ^
        m12q2.hashCode ^
        m12qx.hashCode;
  }

  @override
  String toString() {
    return 'FichaReg(razon:${log.razon}  item: $item, year: $year, id: $id, estado: $estado, estdespacho: $estdespacho, tipo: $tipo, fechainicial: $fechainicial, fechacambio: $fechacambio, fechasolicitud: $fechasolicitud, unidad: $unidad, codigo: $codigo, proyecto: $proyecto, circuito: $circuito, pm: $pm, solicitante: $solicitante, pdi: $pdi, wbe: $wbe, proyectowbe: $proyectowbe, comentario1: $comentario1, comentario2: $comentario2, e4e: $e4e, descripcion: $descripcion, um: $um, m01q1: $m01q1, m01q2: $m01q2, m01qx: $m01qx, m02q1: $m02q1, m02q2: $m02q2, m02qx: $m02qx, m03q1: $m03q1, m03q2: $m03q2, m03qx: $m03qx, m04q1: $m04q1, m04q2: $m04q2, m04qx: $m04qx, m05q1: $m05q1, m05q2: $m05q2, m05qx: $m05qx, m06q1: $m06q1, m06q2: $m06q2, m06qx: $m06qx, m07q1: $m07q1, m07q2: $m07q2, m07qx: $m07qx, m08q1: $m08q1, m08q2: $m08q2, m08qx: $m08qx, m09q1: $m09q1, m09q2: $m09q2, m09qx: $m09qx, m10q1: $m10q1, m10q2: $m10q2, m10qx: $m10qx, m11q1: $m11q1, m11q2: $m11q2, m11qx: $m11qx, m12q1: $m12q1, m12q2: $m12q2, m12qx: $m12qx, esControlado: $esControlado, agendado: $agendado, error: $error, planificado: $planificado)';
  }
}
