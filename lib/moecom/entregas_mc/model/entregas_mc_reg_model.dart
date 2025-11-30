import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../resources/titulo.dart';

class EntregaMc {
  String id;
  String pedido;
  String consecutivo;
  String fecha;
  String almacenista;
  String tel;
  String soporte;
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
  String tecnico;
  String tecnicoid;
  String tecnicotype;
  int index = 0;
  EntregaMc({
    required this.id,
    required this.pedido,
    required this.consecutivo,
    required this.fecha,
    required this.almacenista,
    required this.tel,
    required this.soporte,
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
    required this.tecnico,
    required this.tecnicoid,
    required this.tecnicotype,
  });

  Color idError = Colors.green;
  Color pedidoError = Colors.green;
  Color consecutivoError = Colors.red;
  Color fechaError = Colors.green;
  Color almacenistaError = Colors.red;
  Color telError = Colors.red;
  Color soporteError = Colors.red;
  Color itemError = Colors.red;
  Color e4eError = Colors.red;
  Color descripcionError = Colors.red;
  Color umError = Colors.red;
  Color ctdError = Colors.red;
  Color reportadoError = Colors.red;
  Color comentarioError = Colors.green;
  Color anuladonombreError = Colors.red;
  Color anuladocorreoError = Colors.red;
  Color estadoError = Colors.red;
  Color tipoError = Colors.red;
  Color actualizadoError = Colors.green;
  Color tecnicoError = Colors.red;
  Color tecnicoidError = Colors.red;
  Color tecnicotypeError = Colors.red;
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

  EntregaMc copyWith({
    String? id,
    String? pedido,
    String? consecutivo,
    String? fecha,
    String? almacenista,
    String? tel,
    String? soporte,
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
    String? tecnico,
    String? tecnicoid,
    String? tecnicotype,
  }) {
    return EntregaMc(
      id: id ?? this.id,
      pedido: pedido ?? this.pedido,
      consecutivo: consecutivo ?? this.consecutivo,
      fecha: fecha ?? this.fecha,
      almacenista: almacenista ?? this.almacenista,
      tel: tel ?? this.tel,
      soporte: soporte ?? this.soporte,
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
      tecnico: tecnico ?? this.tecnico,
      tecnicoid: tecnicoid ?? this.tecnicoid,
      tecnicotype: tecnicotype ?? this.tecnicotype,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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

  factory EntregaMc.fromMap(Map<String, dynamic> map) {
    // if (map['tipo'].toString() == 'CARGA') map['tipo'] = 'ENTREGA';
    String signo = '';
    if (map['tipo'].toString() == 'REINTEGRO') signo = '-';
    return EntregaMc(
      id: map['id'].toString(),
      pedido: map['pedido'].toString(),
      consecutivo: map['consecutivo'].toString(),
      fecha: map['fecha'].toString(),
      almacenista: map['almacenista'].toString(),
      tel: map['tel'].toString(),
      soporte: map['soporte'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd: '$signo${map['ctd'].toString()}',
      reportado: map['reportado'].toString(),
      comentario: map['comentario'].toString(),
      anuladonombre: map['anuladonombre'].toString(),
      anuladocorreo: map['anuladocorreo'].toString(),
      estado: map['estado'].toString(),
      tipo: map['tipo'].toString(),
      actualizado: map['actualizado'].toString(),
      tecnico: map['tecnico'].toString(),
      tecnicoid: map['tecnicoid'].toString(),
      tecnicotype:
          map['tecnicotype'] != null ? map['tecnicotype'].toString() : '',
    );
  }

  factory EntregaMc.fromInit(int index) {
    DateTime date = DateTime.now();
    String fechaInit =
        '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    return EntregaMc(
      id: '',
      pedido: '',
      consecutivo: '',
      fecha: fechaInit,
      almacenista: '',
      tel: '',
      soporte: '',
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
      tipo: 'ENTREGA',
      tecnico: '',
      tecnicoid: '',
      tecnicotype: '',
      actualizado: '',
    )..index = index;
  }

  String toJson() => json.encode(toMap());

  factory EntregaMc.fromJson(String source) =>
      EntregaMc.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CargaMc(id: $id, pedido: $pedido, consecutivo: $consecutivo, fecha: $fecha, almacenista: $almacenista, tel: $tel, soporte: $soporte, item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd, reportado: $reportado, comentario: $comentario, anuladonombre: $anuladonombre, anuladocorreo: $anuladocorreo, estado: $estado, tipo: $tipo, actualizado: $actualizado, tecnico: $tecnico, tecnicoid: $tecnicoid, tecnicotype: $tecnicotype)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EntregaMc &&
        other.id == id &&
        other.pedido == pedido &&
        other.consecutivo == consecutivo &&
        other.fecha == fecha &&
        other.almacenista == almacenista &&
        other.tel == tel &&
        other.soporte == soporte &&
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
        other.tecnico == tecnico &&
        other.tecnicoid == tecnicoid &&
        other.tecnicotype == tecnicotype;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pedido.hashCode ^
        consecutivo.hashCode ^
        fecha.hashCode ^
        almacenista.hashCode ^
        tel.hashCode ^
        soporte.hashCode ^
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
        tecnico.hashCode ^
        tecnicoid.hashCode ^
        tecnicotype.hashCode;
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: pedido, flex: 2),
    ToCelda(valor: consecutivo, flex: 2),
    ToCelda(valor: tecnico, flex: 4),
    // ToCelda(valor: tecnicoid, flex: 2),
    // ToCelda(valor: tecnicotype, flex: 2),
    // ToCelda(valor: fecha, flex: 2),
    // ToCelda(valor: almacenista, flex: 4),
    // ToCelda(valor: tel, flex: 2),
    ToCelda(valor: soporte, flex: 2),
    ToCelda(valor: item, flex: 1),
    ToCelda(valor: e4e, flex: 2),
    ToCelda(valor: descripcion, flex: 4),
    ToCelda(valor: um, flex: 1),
    ToCelda(valor: ctd, flex: 2),
    // ToCelda(valor: reportado, flex: 2),
    ToCelda(valor: comentario, flex: 2),
    // ToCelda(valor: anuladonombre, flex: 2),
    // ToCelda(valor: anuladocorreo, flex: 2),
    // ToCelda(valor: estado, flex: 2),
    ToCelda(valor: tipo, flex: 2),
    // ToCelda(valor: actualizado, flex: 2),
  ];
}
