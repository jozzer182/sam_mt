import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../resources/titulo.dart';
import '../../entregas_mc/model/entregas_mc_reg_model.dart';
import '../../consumos_mc/model/consumos_mc_reg.dart';

class MDMovs {
  String id;
  String pedido;
  String consecutivo;
  String tecnico;
  String tecnicoid;
  String tecnicotype;
  String fecha;
  String almacenista;
  String tel;
  String soporte;
  String ticket;
  String tdc;
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd;
  String reportado;
  String comentario;
  String anuladonombre;
  String anuladocorreo;
  String estado;
  String tipo;
  String actualizado;
  String tipomov = '';
  int index = 0;
  int lcl = 0;
  MDMovs({
    required this.id,
    required this.pedido,
    required this.consecutivo,
    required this.tecnico,
    required this.tecnicoid,
    required this.tecnicotype,
    required this.fecha,
    required this.almacenista,
    required this.tel,
    required this.soporte,
    required this.ticket,
    required this.tdc,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
    required this.reportado,
    required this.comentario,
    required this.anuladonombre,
    required this.anuladocorreo,
    required this.estado,
    required this.tipo,
    required this.actualizado,
  });

  Color pedidoError = Colors.green;
  Color consecutivoError = Colors.green;
  Color tecnicoError = Colors.green;
  Color tecnicoidError = Colors.green;
  Color tecnicotypeError = Colors.green;
  Color almacenistaError = Colors.green;
  Color soporteError = Colors.green;
  Color fechaError = Colors.green;
  Color telError = Colors.green;
  Color ticketError = Colors.green;
  Color tdcError = Colors.green;
  Color itemError = Colors.green;
  Color e4eError = Colors.green;
  Color descripcionError = Colors.green;
  Color umError = Colors.green;
  Color ctdError = Colors.green;
  Color reportadoError = Colors.green;
  Color comentarioError = Colors.green;
  Color anuladonombreError = Colors.green;
  Color anuladocorreoError = Colors.green;
  Color estadoError = Colors.green;
  Color tipoError = Colors.green;
  Color actualizadoError = Colors.green;
  String e4eInfo = '';

  List<String> toList() {
    return [
      id,
      pedido,
      consecutivo,
      tecnico,
      tecnicoid,
      tecnicotype,
      fecha,
      almacenista,
      tel,
      soporte,
      ticket,
      tdc,
      item,
      e4e,
      descripcion,
      um,
      ctd,
      reportado,
      comentario,
      anuladonombre,
      anuladocorreo,
      estado,
      tipo,
      actualizado,
    ];
  }

  MDMovs copyWith({
    String? id,
    String? pedido,
    String? consecutivo,
    String? tecnico,
    String? tecnicoid,
    String? tecnicotype,
    String? fecha,
    String? almacenista,
    String? tel,
    String? soporte,
    String? ticket,
    String? tdc,
    String? item,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd,
    String? reportado,
    String? comentario,
    String? anuladonombre,
    String? anuladocorreo,
    String? estado,
    String? tipo,
    String? actualizado,
  }) {
    return MDMovs(
      id: id ?? this.id,
      pedido: pedido ?? this.pedido,
      consecutivo: consecutivo ?? this.consecutivo,
      tecnico: tecnico ?? this.tecnico,
      tecnicoid: tecnicoid ?? this.tecnicoid,
      tecnicotype: tecnicotype ?? this.tecnicotype,
      fecha: fecha ?? this.fecha,
      almacenista: almacenista ?? this.almacenista,
      tel: tel ?? this.tel,
      soporte: soporte ?? this.soporte,
      ticket: ticket ?? this.ticket,
      tdc: tdc ?? this.tdc,
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd: ctd ?? this.ctd,
      reportado: reportado ?? this.reportado,
      comentario: comentario ?? this.comentario,
      anuladonombre: anuladonombre ?? this.anuladonombre,
      anuladocorreo: anuladocorreo ?? this.anuladocorreo,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipomov': tipomov,
      'id': id,
      'pedido': pedido,
      'consecutivo': consecutivo,
      'tecnico': tecnico,
      'tecnicoid': tecnicoid,
      'tecnicotype': tecnicotype,
      'fecha': fecha,
      'almacenista': almacenista,
      'tel': tel,
      'soporte': soporte,
      'ticket': ticket,
      'tdc': tdc,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
      'reportado': reportado,
      'comentario': comentario,
      'anuladonombre': anuladonombre,
      'anuladocorreo': anuladocorreo,
      'estado': estado,
      'tipo': tipo,
      'actualizado': actualizado,
    };
  }

  factory MDMovs.fromMap(Map<String, dynamic> map) {
    return MDMovs(
      id: map['id'].toString(),
      pedido: map['pedido'].toString(),
      consecutivo: map['consecutivo'].toString(),
      tecnico: map['tecnico'].toString(),
      tecnicoid: map['tecnicoid'].toString(),
      tecnicotype: map['tecnicotype'].toString(),
      fecha: map['fecha'].toString(),
      almacenista: map['almacenista'].toString(),
      tel: map['tel'].toString(),
      soporte: map['soporte'].toString(),
      ticket: map['ticket'].toString(),
      tdc: map['tdc'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd: map['ctd'].toString(),
      reportado: map['reportado'].toString(),
      comentario: map['comentario'].toString(),
      anuladonombre: map['anuladonombre'].toString(),
      anuladocorreo: map['anuladocorreo'].toString(),
      estado: map['estado'].toString(),
      tipo: map['tipo'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  factory MDMovs.fromCargas(EntregaMc carga) {
    return MDMovs(
      id: carga.id,
      pedido: carga.pedido,
      consecutivo: carga.consecutivo,
      tecnico: carga.tecnico,
      tecnicoid: carga.tecnicoid,
      tecnicotype: carga.tecnicotype,
      fecha: carga.fecha,
      almacenista: carga.almacenista,
      tel: carga.tel,
      soporte: carga.soporte,
      ticket: '',
      tdc: '',
      item: carga.item,
      e4e: carga.e4e,
      descripcion: carga.descripcion,
      um: carga.um,
      ctd: carga.ctd,
      reportado: '',
      comentario: carga.comentario,
      anuladonombre: '',
      anuladocorreo: '',
      estado: 'correcto',
      tipo: 'CARGA',
      actualizado: DateTime.now().toIso8601String(),
    );
  }

  factory MDMovs.fromPlanilla(ConsumoMc planilla) {
    return MDMovs(
      id: planilla.id,
      pedido: planilla.pedido,
      consecutivo: planilla.consecutivo,
      tecnico: planilla.tecnico,
      tecnicoid: planilla.tecnicoid,
      tecnicotype: planilla.tecnicotype,
      fecha: planilla.fecha,
      almacenista: planilla.almacenista,
      tel: planilla.tel,
      soporte: planilla.soporte,
      ticket: planilla.ticket,
      tdc: planilla.tdc,
      item: planilla.item,
      e4e: planilla.e4e,
      descripcion: planilla.descripcion,
      um: planilla.um,
      ctd: '-${planilla.ctd}',
      reportado: '',
      comentario: planilla.comentario,
      anuladonombre: '',
      anuladocorreo: '',
      estado: 'correcto',
      tipo: 'CARGA',
      actualizado: DateTime.now().toIso8601String(),
    );
  }

  factory MDMovs.fromInit(int index) {
    DateTime date = DateTime.now();
    String fechaInit =
        '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

    return MDMovs(
      id: '',
      pedido: '',
      consecutivo: '',
      tecnico: '',
      tecnicoid: '',
      tecnicotype: '',
      fecha: fechaInit,
      almacenista: '',
      tel: '',
      soporte: '',
      ticket: '',
      tdc: '',
      item: '',
      e4e: '',
      descripcion: '',
      um: '',
      ctd: '',
      reportado: '',
      comentario: '',
      anuladonombre: '',
      anuladocorreo: '',
      estado: 'correcto',
      tipo: 'DESCARGA',
      actualizado: DateTime.now().toIso8601String(),
    )..index = index;
  }

  String toJson() => json.encode(toMap());

  factory MDMovs.fromJson(String source) => MDMovs.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlanillasMc(id: $id, pedido: $pedido, consecutivo: $consecutivo, tecnico: $tecnico, tecnicoid: $tecnicoid, tecnicotype: $tecnicotype, fecha: $fecha, almacenista: $almacenista, tel: $tel, soporte: $soporte, ticket: $ticket, tdc: $tdc, item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd, reportado: $reportado, comentario: $comentario, anuladonombre: $anuladonombre, anuladocorreo: $anuladocorreo, estado: $estado, tipo: $tipo, actualizado: $actualizado, index: $index)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MDMovs &&
        other.id == id &&
        other.pedido == pedido &&
        other.consecutivo == consecutivo &&
        other.tecnico == tecnico &&
        other.tecnicoid == tecnicoid &&
        other.tecnicotype == tecnicotype &&
        other.fecha == fecha &&
        other.almacenista == almacenista &&
        other.tel == tel &&
        other.soporte == soporte &&
        other.ticket == ticket &&
        other.tdc == tdc &&
        other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd == ctd &&
        other.reportado == reportado &&
        other.comentario == comentario &&
        other.anuladonombre == anuladonombre &&
        other.anuladocorreo == anuladocorreo &&
        other.estado == estado &&
        other.tipo == tipo &&
        other.actualizado == actualizado &&
        other.index == index;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pedido.hashCode ^
        consecutivo.hashCode ^
        tecnico.hashCode ^
        tecnicoid.hashCode ^
        tecnicotype.hashCode ^
        fecha.hashCode ^
        almacenista.hashCode ^
        tel.hashCode ^
        soporte.hashCode ^
        ticket.hashCode ^
        tdc.hashCode ^
        item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd.hashCode ^
        reportado.hashCode ^
        comentario.hashCode ^
        anuladonombre.hashCode ^
        anuladocorreo.hashCode ^
        estado.hashCode ^
        tipo.hashCode ^
        actualizado.hashCode ^
        index.hashCode;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: tipomov, flex: 2),
    ToCelda(valor: pedido, flex: 2),
    ToCelda(valor: consecutivo, flex: 2),
    ToCelda(valor: fecha, flex: 2),
    ToCelda(valor: soporte, flex: 2),
    ToCelda(valor: item, flex: 1),
    ToCelda(valor: tdc, flex: 2),
    ToCelda(valor: ticket, flex: 2),
    ToCelda(valor: e4e, flex: 2),
    ToCelda(valor: descripcion, flex: 4),
    ToCelda(valor: um, flex: 1),
    ToCelda(valor: ctd, flex: 2),
    ToCelda(valor: comentario, flex: 2),
    // ToCelda(valor: tipo, flex: 2),
  ];
}
