// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:v_al_sam_v02/user/user_model.dart';

class NuevoIngresoB {
  List<NuevoIngresoBSingle> nuevoIngresoList = [];
  NuevoIngresoBEncabezado encabezado = NuevoIngresoBEncabezado.zero();

  @override
  String toString() {
    return 'NuevoIngresoB{encabezado: $encabezado, material: $nuevoIngresoList}';
  }
}

class NuevoIngresoBEncabezado {
  String codigo_massy;
  String fecha_i =
      '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';
  String almacenista_i;
  String soporte_i;
  String tel_i;
  String proyecto;
  String reportado;
  String comentario_i;
  String estado;
  String tipo;
  // NuevoIngresoBEncabezado({
  //   String? fecha_i,
  //   String? almacenista_i,
  //   String? tel_i,
  //   String? reportado,
  //   this.codigo_massy = '',
  //   this.soporte_i = '',
  //   this.proyecto = 'Libre',
  //   this.comentario_i = '',
  //   this.estado = 'correcto',
  //   this.tipo = 'ingreso',
  // })  : this.fecha_i = fecha_i ??
  //           '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
  //       this.reportado = reportado ??
  //           '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
  //       this.almacenista_i = almacenista_i ?? PersonData().nombre,
  //       this.tel_i = tel_i ?? PersonData().telefono;

  Color get codigo_massyError =>
      codigo_massy.isEmpty ? Colors.red : Colors.green;
  NuevoIngresoBEncabezado({
    required this.codigo_massy,
    required this.fecha_i,
    required this.almacenista_i,
    required this.soporte_i,
    required this.tel_i,
    required this.proyecto,
    required this.reportado,
    required this.comentario_i,
    required this.estado,
    required this.tipo,
  });
  Color get soporte_iError => soporte_i.isEmpty ? Colors.red : Colors.green;

  @override
  String toString() {
    return 'NuevoIngresoBEncabezado(codigo_massy: $codigo_massy, fecha_i: $fecha_i, almacenista_i: $almacenista_i, soporte_i: $soporte_i, tel_i: $tel_i, proyecto: $proyecto, reportado: $reportado, comentario_i: $comentario_i, estado: $estado, tipo: $tipo)';
  }

  NuevoIngresoBEncabezado copyWith({
    String? codigo_massy,
    String? fecha_i,
    String? almacenista_i,
    String? soporte_i,
    String? tel_i,
    String? proyecto,
    String? reportado,
    String? comentario_i,
    String? estado,
    String? tipo,
  }) {
    return NuevoIngresoBEncabezado(
      codigo_massy: codigo_massy ?? this.codigo_massy,
      fecha_i: fecha_i ?? this.fecha_i,
      almacenista_i: almacenista_i ?? this.almacenista_i,
      soporte_i: soporte_i ?? this.soporte_i,
      tel_i: tel_i ?? this.tel_i,
      proyecto: proyecto ?? this.proyecto,
      reportado: reportado ?? this.reportado,
      comentario_i: comentario_i ?? this.comentario_i,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo_massy': codigo_massy,
      'fecha_i': fecha_i,
      'almacenista_i': almacenista_i,
      'soporte_i': soporte_i,
      'tel_i': tel_i,
      'proyecto': proyecto,
      'reportado': reportado,
      'comentario_i': comentario_i,
      'estado': estado,
      'tipo': tipo,
    };
  }

  factory NuevoIngresoBEncabezado.fromMap(Map<String, dynamic> map) {
    return NuevoIngresoBEncabezado(
      codigo_massy: map['codigo_massy'] as String,
      fecha_i: map['fecha_i'] as String,
      almacenista_i: map['almacenista_i'] as String,
      soporte_i: map['soporte_i'] as String,
      tel_i: map['tel_i'] as String,
      proyecto: map['proyecto'] as String,
      reportado: map['reportado'] as String,
      comentario_i: map['comentario_i'] as String,
      estado: map['estado'] as String,
      tipo: map['tipo'] as String,
    );
  }

  factory NuevoIngresoBEncabezado.zero() {
    return NuevoIngresoBEncabezado(
      codigo_massy: '',
      fecha_i:
          '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
      almacenista_i: '',
      soporte_i: '',
      tel_i: '',
      proyecto: 'Libre',
      reportado:
          '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
      comentario_i: '',
      estado: 'correcto',
      tipo: 'ingreso',
    );
  }

  factory NuevoIngresoBEncabezado.fromInit(User user) {
    return NuevoIngresoBEncabezado(
      codigo_massy: '',
      fecha_i:
          '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
      almacenista_i: user.nombre,
      soporte_i: '',
      tel_i: user.telefono,
      proyecto: 'Libre',
      reportado:
          '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}',
      comentario_i: '',
      estado: 'correcto',
      tipo: 'ingreso',
    );
  }

  String toJson() => json.encode(toMap());

  factory NuevoIngresoBEncabezado.fromJson(String source) =>
      NuevoIngresoBEncabezado.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  bool operator ==(covariant NuevoIngresoBEncabezado other) {
    if (identical(this, other)) return true;

    return other.codigo_massy == codigo_massy &&
        other.fecha_i == fecha_i &&
        other.almacenista_i == almacenista_i &&
        other.soporte_i == soporte_i &&
        other.tel_i == tel_i &&
        other.proyecto == proyecto &&
        other.reportado == reportado &&
        other.comentario_i == comentario_i &&
        other.estado == estado &&
        other.tipo == tipo;
  }

  @override
  int get hashCode {
    return codigo_massy.hashCode ^
        fecha_i.hashCode ^
        almacenista_i.hashCode ^
        soporte_i.hashCode ^
        tel_i.hashCode ^
        proyecto.hashCode ^
        reportado.hashCode ^
        comentario_i.hashCode ^
        estado.hashCode ^
        tipo.hashCode;
  }
}

class NuevoIngresoBSingle {
  String item;
  String e4e;
  String descripcion;
  String ctd;
  String um;
  // Color e4eError;
  NuevoIngresoBSingle({
    this.item = '',
    this.e4e = '',
    this.descripcion = '',
    this.ctd = '',
    this.um = '',
  });

  Color get e4eError =>
      e4e.isEmpty || e4e.length != 6 || descripcion == 'No encontrado'
          ? Colors.red
          : Colors.green;
  Color get ctdError =>
      ctd.isEmpty || int.parse(ctd) == 0 ? Colors.red : Colors.green;

  factory NuevoIngresoBSingle.fromIndex(int index) {
    return NuevoIngresoBSingle(
      item: '${index}',
      e4e: '',
      descripcion: 'Descripción',
      ctd: '',
      um: 'um',
    );
  }

  NuevoIngresoBSingle copyWith({
    String? item,
    String? e4e,
    String? descripcion,
    String? ctd,
    String? um,
  }) {
    return NuevoIngresoBSingle(
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      ctd: ctd ?? this.ctd,
      um: um ?? this.um,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'ctd': ctd,
      'um': um,
    };
  }

  factory NuevoIngresoBSingle.fromMap(Map<String, dynamic> map) {
    return NuevoIngresoBSingle(
      item: map['item'],
      e4e: map['e4e'],
      descripcion: map['descripcion'],
      ctd: map['ctd'],
      um: map['um'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NuevoIngresoBSingle.fromJson(String source) =>
      NuevoIngresoBSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NuevoIngresoBSingle(item: $item, e4e: $e4e, descripcion: $descripcion, ctd: $ctd, um: $um)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NuevoIngresoBSingle &&
        other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.ctd == ctd &&
        other.um == um;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        ctd.hashCode ^
        um.hashCode;
  }
}
