// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:v_al_sam_v02/chatarra/model/chatarra_enum.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import 'chatarra_list.dart';
import 'chatarra_registros.dart';

class Chatarra {
  String id;
  String pedido;
  String acta;
  String fecha_i;
  String almacenista_i;
  String tel_i;
  String soporte_i;
  List<ChatarraReg> items;
  String lcl;
  String comentario_i;
  String balance;
  String reportado;
  String estadopersona;
  String estado;
  Chatarra({
    required this.id,
    required this.pedido,
    required this.acta,
    required this.fecha_i,
    required this.almacenista_i,
    required this.tel_i,
    required this.soporte_i,
    required this.items,
    required this.lcl,
    required this.comentario_i,
    required this.balance,
    required this.reportado,
    required this.estadopersona,
    required this.estado,
  });

  getCampo(CampoChatarra campo) {
    if (campo == CampoChatarra.id) return id;
    if (campo == CampoChatarra.pedido) return pedido;
    if (campo == CampoChatarra.acta) return acta;
    if (campo == CampoChatarra.fecha_i) return fecha_i;
    if (campo == CampoChatarra.almacenista_i) return almacenista_i;
    if (campo == CampoChatarra.tel_i) return tel_i;
    if (campo == CampoChatarra.soporte_i) return soporte_i;
    if (campo == CampoChatarra.items) return items;
    if (campo == CampoChatarra.lcl) return lcl;
    if (campo == CampoChatarra.comentario_i) return comentario_i;
    if (campo == CampoChatarra.reportado) return reportado;
    if (campo == CampoChatarra.estadopersona) return estadopersona;
    if (campo == CampoChatarra.estado) return estado;
  }

  Chatarra copyWith({
    String? id,
    String? pedido,
    String? acta,
    String? fecha_i,
    String? almacenista_i,
    String? tel_i,
    String? soporte_i,
    List<ChatarraReg>? items,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd,
    String? lcl,
    String? comentario_i,
    String? balance,
    String? reportado,
    String? estadopersona,
    String? estado,
  }) {
    return Chatarra(
      id: id ?? this.id,
      pedido: pedido ?? this.pedido,
      acta: acta ?? this.acta,
      fecha_i: fecha_i ?? this.fecha_i,
      almacenista_i: almacenista_i ?? this.almacenista_i,
      tel_i: tel_i ?? this.tel_i,
      soporte_i: soporte_i ?? this.soporte_i,
      items: items ?? this.items,
      lcl: lcl ?? this.lcl,
      comentario_i: comentario_i ?? this.comentario_i,
      balance: balance ?? this.balance,
      reportado: reportado ?? this.reportado,
      estadopersona: estadopersona ?? this.estadopersona,
      estado: estado ?? this.estado,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pedido': pedido,
      'acta': acta,
      'fecha_i': fecha_i,
      'almacenista_i': almacenista_i,
      'tel_i': tel_i,
      'soporte_i': soporte_i,
      'items': items,
      'lcl': lcl,
      'comentario_i': comentario_i,
      'balance': balance,
      'reportado': reportado,
      'estadopersona': estadopersona,
      'estado': estado,
    };
  }

  List<Map<String, dynamic>> toListMap() {
    List<Map<String, dynamic>> result = [];
    for (ChatarraReg item in items) {
      result.add({
        'id': item.id,
        'pedido': pedido,
        'acta': acta,
        'fecha_i': fecha_i,
        'almacenista_i': almacenista_i,
        'tel_i': tel_i,
        'soporte_i': soporte_i,
        'item': item.item,
        'e4e': item.e4e,
        'descripcion': item.descripcion,
        'um': item.um,
        'ctd': item.ctd,
        'lcl': lcl,
        'comentario_i': comentario_i,
        'balance': balance,
        'reportado': reportado,
        'estadopersona': estadopersona,
        'estado': estado,
      });
    }
    return result;
  }

  factory Chatarra.fromMap(Map<String, dynamic> map) {
    return Chatarra(
      id: map['id'].toString(),
      pedido: map['pedido'].toString(),
      acta: map['acta'].toString(),
      fecha_i: map['fecha_i'].toString(),
      almacenista_i: map['almacenista_i'].toString(),
      tel_i: map['tel_i'].toString(),
      soporte_i: map['soporte_i'].toString(),
      items: [],
      lcl: map['lcl'].toString(),
      comentario_i: map['comentario_i'].toString(),
      balance: map['balance'].toString(),
      reportado: map['reportado'].toString(),
      estadopersona: map['estadopersona'].toString(),
      estado: map['estado'].toString(),
    );
  }

  factory Chatarra.fromNuevo({required User user}) {
    return Chatarra(
      id: '',
      pedido: '',
      acta: '',
      fecha_i: '',
      almacenista_i: user.correo,
      tel_i: user.telefono,
      soporte_i: '',
      items: List.generate(3, (index) => ChatarraReg.fromNuevo('${index + 1}')),
      lcl: '',
      comentario_i: '',
      balance: '',
      reportado: '',
      estadopersona: '',
      estado: 'ingresado',
    );
  }

  factory Chatarra.fromList({required List<ChatarraSingle> list}) {
    List<ChatarraReg> items = [];
    for (ChatarraSingle el in list) {
      items.add(
        ChatarraReg(
          id: el.id,
          item: el.item,
          e4e: el.e4e,
          descripcion: el.descripcion,
          um: el.um,
          ctd: el.ctd,
        ),
      );
    }
    return Chatarra(
      id: list.first.id,
      pedido: list.first.pedido,
      acta: list.first.acta,
      fecha_i: list.first.fecha_i,
      almacenista_i: list.first.almacenista_i,
      tel_i: list.first.tel_i,
      soporte_i: list.first.soporte_i,
      items: items,
      lcl: list.first.lcl,
      comentario_i: list.first.comentario_i,
      balance: list.first.balance,
      reportado: list.first.reportado,
      estadopersona: list.first.estadopersona,
      estado: list.first.estado,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Chatarra(id: $id, pedido: $pedido, acta: $acta, fecha_i: $fecha_i, almacenista_i: $almacenista_i, tel_i: $tel_i, soporte_i: $soporte_i, items: $items, lcl: $lcl, comentario_i: $comentario_i, balance: $balance,reportado: $reportado, estadopersona: $estadopersona, estado: $estado)';
  }

  @override
  bool operator ==(covariant Chatarra other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.pedido == pedido &&
        other.acta == acta &&
        other.fecha_i == fecha_i &&
        other.almacenista_i == almacenista_i &&
        other.tel_i == tel_i &&
        other.soporte_i == soporte_i &&
        other.items == items &&
        other.lcl == lcl &&
        other.comentario_i == comentario_i &&
        other.reportado == reportado &&
        other.estadopersona == estadopersona &&
        other.estado == estado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pedido.hashCode ^
        acta.hashCode ^
        fecha_i.hashCode ^
        almacenista_i.hashCode ^
        tel_i.hashCode ^
        soporte_i.hashCode ^
        items.hashCode ^
        lcl.hashCode ^
        comentario_i.hashCode ^
        reportado.hashCode ^
        estadopersona.hashCode ^
        estado.hashCode;
  }
}
