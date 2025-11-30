import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:flutter/material.dart';
import 'package:v_al_sam_v02/inventario/model/inventario_model.dart';
import 'package:v_al_sam_v02/mb52/mb52_b.dart';
import 'package:v_al_sam_v02/models/mm60_b.dart';
import 'package:http/http.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';
import 'package:v_al_sam_v02/user/user_model.dart';


class PlanillaEditB {
  List<PlanillaBEditSingle> planillaBList = [];
  List<PlanillaBEditSingle> planillaBListParaEnvio = [];
  EncabezadoPlanillaBEdit encabezadoPlanillaB = EncabezadoPlanillaBEdit.zero();
  EncabezadoPlanillaBEdit encabezadoPlanillaBParaEnvio =
      EncabezadoPlanillaBEdit.zero();
  String pedidoSelected = '560000';

  crear(RegistrosB registrosB) {
    pedidoSelected = registrosB.pedidoSelected;
    planillaBList.clear();
    List planillaDePedido =
        registrosB.registrosList
            .where((e) => e.pedido == registrosB.pedidoSelected)
            .toList();
    // print('planillaDePedido: ${planillaDePedido}');
    // print('planillaDePedido: ${planillaDePedido.length}');
    // print('planillaDePedido: ${planillaDePedido.last}');
    for (ResgistroSingle dato in planillaDePedido) {
      planillaBList.add(PlanillaBEditSingle.fromReg(dato));
    }
    encabezadoPlanillaB = EncabezadoPlanillaBEdit.fromReg(planillaDePedido[0]);
    encabezadoPlanillaBParaEnvio = EncabezadoPlanillaBEdit.fromReg(
      planillaDePedido[0],
    );
    planillaBListParaEnvio = [...planillaBList];
  }

  enviar(User user) async {
    List vals = [];
    DateTime date = DateTime.now();
    for (var row in planillaBListParaEnvio) {
      vals.add({
        ...row.toMap(),
        ...encabezadoPlanillaBParaEnvio.toMap(),
        'pedido': pedidoSelected,
        'placa_cuadrilla_r': encabezadoPlanillaBParaEnvio.placa_cuadrilla_e,
        'lider_contrato_r': encabezadoPlanillaBParaEnvio.lider_contrato_e,
        'tel_lider_r': encabezadoPlanillaBParaEnvio.tel_lider_e,
        'pdi': user.pdi,
        'est_oficial': 'reintegrado',
        'est_oficial_fecha':
            '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
        'est_oficial_pers': user.nombre,
      });
    }

    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'rows': vals, 'hoja': 'registros'},
      'fname': "updateInfo",
    };
    // print(jsonEncode(dataSend));
    var response = await post(
      Uri.parse(
        Api.samString,
      ),
      body: jsonEncode(dataSend),
    );
    // print(response.body);
    var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
    // print(respuesta);
    if (respuesta is List) {
      respuesta =
          'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
    } else {
      print(respuesta);
    }
    return respuesta;
  }

  Future anularPedido(User user) async {
    List vals = [];
    DateTime date = DateTime.now();
    for (var row in planillaBListParaEnvio) {
      vals.add({
        ...row.toMap(),
        ...encabezadoPlanillaBParaEnvio.toMap(),
        'pedido': pedidoSelected,
        'almacenista_r': '${user.nombre} anuló este registro',
        'tel_r': user.telefono,
        'reportado':
            '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
        'est_oficial': 'anulado',
        'est_oficial_pers': user.nombre,
        'est_oficial_fecha':
            '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
      });
    }

    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'rows': vals, 'hoja': 'registros'},
      'fname': "updateInfo",
    };
    // print(jsonEncode(dataSend));
    var response = await post(
      Uri.parse(
        Api.samString,
      ),
      body: jsonEncode(dataSend),
    );
    // print(response.body);
    var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
    // print(respuesta);
    if (respuesta is List) {
      respuesta =
          'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
    } else {
      print(respuesta);
    }
    return respuesta;
  }

  cambiarLista({
    required Mm60B mm60b,
    required Mb52B mb52b,
    required int index,
    required InventarioB inventarioB,
    String? e4e,
    String? ctd_e,
    String? ctd_r,
  }) {
    var inMb52 = mb52b.mb52BList.firstWhere(
      (e) => e.material.contains(e4e ?? planillaBListParaEnvio[index].e4e),
      orElse: () => Mb52BSingle.fromInit(),
    );
    var inInventario = inventarioB.inventarioList.firstWhere(
      (e) => e.e4e.contains(e4e ?? planillaBListParaEnvio[index].e4e),
      orElse: () => InventarioBSingle.fromInit(),
    );
    if (e4e != null) {
      planillaBListParaEnvio[index].e4e = e4e;
      planillaBListParaEnvio[index].descripcion =
          mm60b.mm60List
              .firstWhere(
                (e) => e.material.contains(e4e),
                orElse: () => Mm60SingleB.fromInit(),
              )
              .descripcion;
      planillaBListParaEnvio[index].um =
          mm60b.mm60List
              .firstWhere(
                (e) => e.material.contains(e4e),
                orElse: () => Mm60SingleB.fromInit(),
              )
              .um;
      planillaBListParaEnvio[index].esInv =
          inMb52.descripcion == 'No está en MB52' ? 'No está en MB52' : null;
      planillaBListParaEnvio[index].ctdMb52 =
          e4e.length == 6 ? inMb52.ctd : null;
    }
    if (ctd_e != null) {
      ctd_e = ctd_e == '' ? '0' : ctd_e;
      planillaBListParaEnvio[index].ctd_e = ctd_e;
      planillaBListParaEnvio[index].ctd_total =
          (int.parse(ctd_e) -
                  int.parse(
                    planillaBListParaEnvio[index].ctd_r == 'ctd'
                        ? '0'
                        : planillaBListParaEnvio[index].ctd_r,
                  ))
              .toString();
      bool esMayorLoReintegrado =
          int.parse(ctd_e) < int.parse(planillaBListParaEnvio[index].ctd_r);
      bool esMayorLoInstaladoQueMb52 =
          int.parse(planillaBListParaEnvio[index].ctd_total) >
          int.parse(inMb52.ctd);
      planillaBListParaEnvio[index].errorValue =
          esMayorLoReintegrado || esMayorLoInstaladoQueMb52;
    }
    if (ctd_r != null) {
      ctd_r = ctd_r == '' ? '0' : ctd_r;
      planillaBListParaEnvio[index].ctd_r = ctd_r;
      planillaBListParaEnvio[index].ctd_total =
          (int.parse(
                    planillaBListParaEnvio[index].ctd_e == 'ctd'
                        ? '0'
                        : planillaBListParaEnvio[index].ctd_e,
                  ) -
                  int.parse(ctd_r))
              .toString();
      bool esMayorLoReintegrado =
          int.parse(planillaBListParaEnvio[index].ctd_e) < int.parse(ctd_r);
      bool esMayorLoInstaladoQueMb52 =
          int.parse(planillaBListParaEnvio[index].ctd_total) >
          int.parse(inMb52.ctd);
      planillaBListParaEnvio[index].errorValue =
          esMayorLoReintegrado || esMayorLoInstaladoQueMb52;
    }
  }

  @override
  String toString() =>
      'PlanillaB(planillaBList: $planillaBList, encabezadoPlanillaB: $encabezadoPlanillaB)';
}

class PlanillaBEditSingle {
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
  PlanillaBEditSingle({
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_e,
    required this.ctd_r,
    required this.ctd_total,
  });

  Color get e4eError =>
      esInv == 'No hay unidades en inventario' ||
              descripcion == 'No existe en BD' ||
              e4e.length != 6
          ? Colors.red
          : Colors.green;

  Color get ctdEError => errorValue || ctd_e == '0' ? Colors.red : Colors.grey;

  PlanillaBEditSingle copyWith({
    String? item,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd_e,
    String? ctd_r,
    String? ctd_total,
  }) {
    return PlanillaBEditSingle(
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

  factory PlanillaBEditSingle.fromMap(Map<String, dynamic> map) {
    return PlanillaBEditSingle(
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd_e: map['ctd_e'].toString(),
      ctd_r: map['ctd_r'].toString(),
      ctd_total: map['ctd_total'].toString(),
    );
  }

  factory PlanillaBEditSingle.fromInit(int item) {
    return PlanillaBEditSingle(
      item: item.toString(),
      e4e: 'e4e',
      descripcion: 'Descripción',
      um: 'um',
      ctd_e: '0',
      ctd_r: '0',
      ctd_total: '0',
    );
  }

  factory PlanillaBEditSingle.fromReg(ResgistroSingle item) {
    return PlanillaBEditSingle(
      item: item.item,
      e4e: item.e4e,
      descripcion: item.descripcion,
      um: item.um,
      ctd_e: item.ctd_e,
      ctd_r: item.ctd_r,
      ctd_total: item.ctd_total,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanillaBEditSingle.fromJson(String source) =>
      PlanillaBEditSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlanillaBSingle(item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd_e: $ctd_e, ctd_r: $ctd_r, ctd_total: $ctd_total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlanillaBEditSingle &&
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

class EncabezadoPlanillaBEdit {
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
  String soporte_d_r;
  String comentario_e;
  String almacenista_e;
  String tel_alm_e;
  EncabezadoPlanillaBEdit({
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
    required this.soporte_d_r,
    required this.comentario_e,
    required this.almacenista_e,
    required this.tel_alm_e,
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
  Color soporte_d_rError = Colors.red;
  Color comentario_eError = Colors.red;
  Color almacenista_eError = Colors.red;
  Color tel_alm_eError = Colors.red;

  EncabezadoPlanillaBEdit copyWith({
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
    String? soporte_d_r,
    String? comentario_e,
    String? almacenista_e,
    String? tel_alm_e,
  }) {
    return EncabezadoPlanillaBEdit(
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
      soporte_d_r: soporte_d_r ?? this.soporte_d_r,
      comentario_e: comentario_e ?? this.comentario_e,
      almacenista_e: almacenista_e ?? this.almacenista_e,
      tel_alm_e: tel_alm_e ?? this.tel_alm_e,
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
      'soporte_d_r': soporte_d_r,
      'comentario_e': comentario_e,
      'almacenista_e': almacenista_e,
      'tel_alm_e': tel_alm_e,
    };
  }

  factory EncabezadoPlanillaBEdit.fromMap(Map<String, dynamic> map) {
    return EncabezadoPlanillaBEdit(
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
      soporte_d_r: map['soporte_d_r'].toString(),
      comentario_e: map['comentario_e'].toString(),
      almacenista_e: map['almacenista_e'].toString(),
      tel_alm_e: map['tel_alm_e'].toString(),
    );
  }
  factory EncabezadoPlanillaBEdit.fromInit(User user) {
    return EncabezadoPlanillaBEdit(
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
      soporte_d_r: '',
      comentario_e: '',
      almacenista_e: user.nombre,
      tel_alm_e: user.telefono,
    );
  }

  factory EncabezadoPlanillaBEdit.zero() {
    return EncabezadoPlanillaBEdit(
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
      soporte_d_r: '',
      comentario_e: '',
      almacenista_e: '',
      tel_alm_e: '',
    );
  }

  factory EncabezadoPlanillaBEdit.fromReg(ResgistroSingle item) {
    return EncabezadoPlanillaBEdit(
      lcl: item.lcl,
      odm: item.odm,
      solicitante: item.solicitante,
      proceso: item.proceso,
      pdi: item.pdi,
      placa_cuadrilla_e: item.placa_cuadrilla_e,
      lider_contrato_e: item.lider_contrato_e,
      cc_lider_contrato_e: item.cc_lider_contrato_e,
      tel_lider_e: item.tel_lider_e,
      circuito: item.circuito,
      localidad_municipio: item.localidad_municipio,
      nodo: item.nodo,
      ingeniero_enel: item.ingeniero_enel,
      pdl: item.pdl,
      fecha_e: item.fecha_e,
      fecha_r: item.fecha_r,
      soporte_d_e: item.soporte_d_e,
      soporte_d_r: item.soporte_d_r,
      comentario_e: item.comentario_e,
      almacenista_e: item.almacenista_e,
      tel_alm_e: item.tel_alm_e,
    );
  }

  String toJson() => json.encode(toMap());

  factory EncabezadoPlanillaBEdit.fromJson(String source) =>
      EncabezadoPlanillaBEdit.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EncabezadoPlanillaB(lcl: $lcl, odm: $odm, solicitante: $solicitante, proceso: $proceso, pdi: $pdi, placa_cuadrilla_e: $placa_cuadrilla_e, lider_contrato_e: $lider_contrato_e, cc_lider_contrato_e: $cc_lider_contrato_e, tel_lider_e: $tel_lider_e, circuito: $circuito, localidad_municipio: $localidad_municipio, nodo: $nodo, ingeniero_enel: $ingeniero_enel, pdl: $pdl, fecha_e: $fecha_e, fecha_r: $fecha_r, soporte_d_e: $soporte_d_e, comentario_e: $comentario_e, almacenista_e: $almacenista_e, tel_alm_e: $tel_alm_e)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EncabezadoPlanillaBEdit &&
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
        other.soporte_d_r == soporte_d_r &&
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
        soporte_d_r.hashCode ^
        comentario_e.hashCode ^
        almacenista_e.hashCode ^
        tel_alm_e.hashCode;
  }
}
