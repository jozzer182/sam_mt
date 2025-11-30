import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

class PlanillaB {
  List<PlanillaBSingle> planillaBList = [];
  EncabezadoPlanillaB encabezadoPlanillaB = EncabezadoPlanillaB.zero();

  @override
  String toString() =>
      'PlanillaB(planillaBList: $planillaBList, encabezadoPlanillaB: $encabezadoPlanillaB)';
}

//==============================================================================================
class PlanillaBSingle {
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd_e;
  String ctd_r;
  String ctd_total;
  String? esMb52;
  String? ctdMb52;
  String? esInv;
  String? ctdInv;
  bool errorValue = false;
  PlanillaBSingle({
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_e,
    required this.ctd_r,
    required this.ctd_total,
  });

  Color get e4eError =>
      esInv == 'No hay unidades en <Inventario> SAM' ||
              descripcion == 'No existe en BD' ||
              e4e.length != 6
          ? Colors.red
          : Colors.green;

  Color get ctdEError =>
      errorValue || ctd_e == '0' || ctd_e.isEmpty ? Colors.red : Colors.grey;

  PlanillaBSingle copyWith({
    String? item,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd_e,
    String? ctd_r,
    String? ctd_total,
  }) {
    return PlanillaBSingle(
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd_e: ctd_e ?? this.ctd_e,
      ctd_r: ctd_r ?? this.ctd_r,
      ctd_total: ctd_total ?? this.ctd_total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd_e': ctd_e,
      'ctd_r': ctd_r,
      'ctd_total': ctd_total,
    };
  }

  factory PlanillaBSingle.fromMap(Map<String, dynamic> map) {
    return PlanillaBSingle(
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd_e: map['ctd_e'].toString(),
      ctd_r: map['ctd_r'].toString(),
      ctd_total: map['ctd_total'].toString(),
    );
  }

  factory PlanillaBSingle.fromInit(int item) {
    return PlanillaBSingle(
      item: item.toString(),
      e4e: '',
      descripcion: 'Descripción',
      um: 'um',
      ctd_e: '',
      ctd_r: '',
      ctd_total: '0',
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanillaBSingle.fromJson(String source) =>
      PlanillaBSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlanillaBSingle(item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd_e: $ctd_e, ctd_r: $ctd_r, ctd_total: $ctd_total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlanillaBSingle &&
        other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd_e == ctd_e &&
        other.ctd_r == ctd_r &&
        other.ctd_total == ctd_total;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd_e.hashCode ^
        ctd_r.hashCode ^
        ctd_total.hashCode;
  }
}
//-----------------------------------------------------------------------------------------------

class EncabezadoPlanillaB {
  String lcl;
  String odm;
  String solicitante;
  String proceso;
  String pdi;
  String placa_cuadrilla_e;
  String lider_contrato_e;
  String cc_lider_contrato_e;
  String tel_lider_e;
  String circuito;
  String localidad_municipio;
  String nodo;
  String ingeniero_enel;
  String pdl;
  String fecha_e;
  String fecha_r;
  String soporte_d_e;
  String comentario_e;
  String almacenista_e;
  String tel_alm_e;
  String lm;
  EncabezadoPlanillaB({
    required this.lcl,
    required this.odm,
    required this.solicitante,
    required this.proceso,
    required this.pdi,
    required this.placa_cuadrilla_e,
    required this.lider_contrato_e,
    required this.cc_lider_contrato_e,
    required this.tel_lider_e,
    required this.circuito,
    required this.localidad_municipio,
    required this.nodo,
    required this.ingeniero_enel,
    required this.pdl,
    required this.fecha_e,
    required this.fecha_r,
    required this.soporte_d_e,
    required this.comentario_e,
    required this.almacenista_e,
    required this.tel_alm_e,
    required this.lm,
  });

  Color lclError = Colors.red;
  Color odmError = Colors.red;
  Color solicitanteError = Colors.red;
  Color procesoError = Colors.red;
  Color pdiError = Colors.red;
  Color placa_cuadrilla_eError = Colors.red;
  Color lider_contrato_eError = Colors.red;
  Color cc_lider_contrato_eError = Colors.red;
  Color tel_lider_eError = Colors.red;
  Color circuitoError = Colors.red;
  Color localidad_municipioError = Colors.red;
  Color nodoError = Colors.red;
  Color ingeniero_enelError = Colors.red;
  Color pdlError = Colors.red;
  Color fecha_eError = Colors.red;
  Color fecha_rError = Colors.red;
  Color soporte_d_eError = Colors.red;
  Color almacenista_eError = Colors.green;
  Color tel_alm_eError = Colors.green;

  EncabezadoPlanillaB copyWith({
    String? lcl,
    String? odm,
    String? solicitante,
    String? proceso,
    String? pdi,
    String? placa_cuadrilla_e,
    String? lider_contrato_e,
    String? cc_lider_contrato_e,
    String? tel_lider_e,
    String? circuito,
    String? localidad_municipio,
    String? nodo,
    String? ingeniero_enel,
    String? pdl,
    String? fecha_e,
    String? fecha_r,
    String? soporte_d_e,
    String? comentario_e,
    String? almacenista_e,
    String? tel_alm_e,
    String? lm,
  }) {
    return EncabezadoPlanillaB(
      lcl: lcl ?? this.lcl,
      odm: odm ?? this.odm,
      solicitante: solicitante ?? this.solicitante,
      proceso: proceso ?? this.proceso,
      pdi: pdi ?? this.pdi,
      placa_cuadrilla_e: placa_cuadrilla_e ?? this.placa_cuadrilla_e,
      lider_contrato_e: lider_contrato_e ?? this.lider_contrato_e,
      cc_lider_contrato_e: cc_lider_contrato_e ?? this.cc_lider_contrato_e,
      tel_lider_e: tel_lider_e ?? this.tel_lider_e,
      circuito: circuito ?? this.circuito,
      localidad_municipio: localidad_municipio ?? this.localidad_municipio,
      nodo: nodo ?? this.nodo,
      ingeniero_enel: ingeniero_enel ?? this.ingeniero_enel,
      pdl: pdl ?? this.pdl,
      fecha_e: fecha_e ?? this.fecha_e,
      fecha_r: fecha_r ?? this.fecha_r,
      soporte_d_e: soporte_d_e ?? this.soporte_d_e,
      comentario_e: comentario_e ?? this.comentario_e,
      almacenista_e: almacenista_e ?? this.almacenista_e,
      tel_alm_e: tel_alm_e ?? this.tel_alm_e,
      lm: lm ?? this.lm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lcl': lcl,
      'odm': odm,
      'solicitante': solicitante,
      'proceso': proceso,
      'pdi': pdi,
      'placa_cuadrilla_e': placa_cuadrilla_e,
      'lider_contrato_e': lider_contrato_e,
      'cc_lider_contrato_e': cc_lider_contrato_e,
      'tel_lider_e': tel_lider_e,
      'circuito': circuito,
      'localidad_municipio': localidad_municipio,
      'nodo': nodo,
      'ingeniero_enel': ingeniero_enel,
      'pdl': pdl,
      'fecha_e': fecha_e,
      'fecha_r': fecha_r,
      'soporte_d_e': soporte_d_e,
      'comentario_e': comentario_e,
      'almacenista_e': almacenista_e,
      'tel_alm_e': tel_alm_e,
      'lm': lm,
    };
  }

  factory EncabezadoPlanillaB.fromMap(Map<String, dynamic> map) {
    return EncabezadoPlanillaB(
      lcl: map['lcl'].toString(),
      odm: map['odm'].toString(),
      solicitante: map['solicitante'].toString(),
      proceso: map['proceso'].toString(),
      pdi: map['pdi'].toString(),
      placa_cuadrilla_e: map['placa_cuadrilla_e'].toString(),
      lider_contrato_e: map['lider_contrato_e'].toString(),
      cc_lider_contrato_e: map['cc_lider_contrato_e'].toString(),
      tel_lider_e: map['tel_lider_e'].toString(),
      circuito: map['circuito'].toString(),
      localidad_municipio: map['localidad_municipio'].toString(),
      nodo: map['nodo'].toString(),
      ingeniero_enel: map['ingeniero_enel'].toString(),
      pdl: map['pdl'].toString(),
      fecha_e: map['fecha_e'].toString(),
      fecha_r: map['fecha_r'].toString(),
      soporte_d_e: map['soporte_d_e'].toString(),
      comentario_e: map['comentario_e'].toString(),
      almacenista_e: map['almacenista_e'].toString(),
      tel_alm_e: map['tel_alm_e'].toString(),
      lm: map['lm'].toString(),
    );
  }
  factory EncabezadoPlanillaB.fromInit(User user) {
    return EncabezadoPlanillaB(
      lcl: '',
      odm: '',
      solicitante: '',
      proceso: '',
      pdi: '',
      placa_cuadrilla_e: '',
      lider_contrato_e: '',
      cc_lider_contrato_e: '',
      tel_lider_e: '',
      circuito: '',
      localidad_municipio: '',
      nodo: '',
      ingeniero_enel: '',
      pdl: '',
      fecha_e: '',
      fecha_r: '',
      soporte_d_e: '',
      comentario_e: '',
      almacenista_e: user.nombre,
      tel_alm_e: user.telefono,
      lm: '',
    );
  }

  factory EncabezadoPlanillaB.zero() {
    return EncabezadoPlanillaB(
      lcl: '',
      odm: '',
      solicitante: '',
      proceso: '',
      pdi: '',
      placa_cuadrilla_e: '',
      lider_contrato_e: '',
      cc_lider_contrato_e: '',
      tel_lider_e: '',
      circuito: '',
      localidad_municipio: '',
      nodo: '',
      ingeniero_enel: '',
      pdl: '',
      fecha_e: '',
      fecha_r: '',
      soporte_d_e: '',
      comentario_e: '',
      almacenista_e: '',
      tel_alm_e: ' ',
      lm: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EncabezadoPlanillaB.fromJson(String source) =>
      EncabezadoPlanillaB.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EncabezadoPlanillaB(lcl: $lcl, odm: $odm, solicitante: $solicitante, proceso: $proceso, pdi: $pdi, placa_cuadrilla_e: $placa_cuadrilla_e, lider_contrato_e: $lider_contrato_e, cc_lider_contrato_e: $cc_lider_contrato_e, tel_lider_e: $tel_lider_e, circuito: $circuito, localidad_municipio: $localidad_municipio, nodo: $nodo, ingeniero_enel: $ingeniero_enel, pdl: $pdl, fecha_e: $fecha_e, fecha_r: $fecha_r, soporte_d_e: $soporte_d_e, comentario_e: $comentario_e, almacenista_e: $almacenista_e, tel_alm_e: $tel_alm_e)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EncabezadoPlanillaB &&
        other.lcl == lcl &&
        other.odm == odm &&
        other.solicitante == solicitante &&
        other.proceso == proceso &&
        other.pdi == pdi &&
        other.placa_cuadrilla_e == placa_cuadrilla_e &&
        other.lider_contrato_e == lider_contrato_e &&
        other.cc_lider_contrato_e == cc_lider_contrato_e &&
        other.tel_lider_e == tel_lider_e &&
        other.circuito == circuito &&
        other.localidad_municipio == localidad_municipio &&
        other.nodo == nodo &&
        other.ingeniero_enel == ingeniero_enel &&
        other.pdl == pdl &&
        other.fecha_e == fecha_e &&
        other.fecha_r == fecha_r &&
        other.soporte_d_e == soporte_d_e &&
        other.comentario_e == comentario_e &&
        other.almacenista_e == almacenista_e &&
        other.tel_alm_e == tel_alm_e;
  }

  @override
  int get hashCode {
    return lcl.hashCode ^
        odm.hashCode ^
        solicitante.hashCode ^
        proceso.hashCode ^
        pdi.hashCode ^
        placa_cuadrilla_e.hashCode ^
        lider_contrato_e.hashCode ^
        cc_lider_contrato_e.hashCode ^
        tel_lider_e.hashCode ^
        circuito.hashCode ^
        localidad_municipio.hashCode ^
        nodo.hashCode ^
        ingeniero_enel.hashCode ^
        pdl.hashCode ^
        fecha_e.hashCode ^
        fecha_r.hashCode ^
        soporte_d_e.hashCode ^
        comentario_e.hashCode ^
        almacenista_e.hashCode ^
        tel_alm_e.hashCode;
  }
}
