// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'chatarra_reg_enum.dart';

class ChatarraReg {
  String id;
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd;
  String valor;
  ChatarraReg({
    required this.id,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
    this.valor = '0',
  });

  Color get e4eError => e4e.isEmpty ||
          e4e.length != 6 ||
          descripcion == 'No encontrado' ||
          um == 'M' ||
          valor != '0'
      ? Colors.red
      : Colors.green;
  Color get ctdError =>
      ctd.isEmpty || int.parse(ctd) == 0 ? Colors.red : Colors.green;

  cambiar({
    required CampoChatarraReg campo,
    required String valor,
  }) {
    if (campo == CampoChatarraReg.item) {
      item = valor;
    }
    if (campo == CampoChatarraReg.e4e) {
      e4e = valor;
    }
    if (campo == CampoChatarraReg.descripcion) {
      descripcion = valor;
    }
    if (campo == CampoChatarraReg.um) {
      um = valor;
    }
    if (campo == CampoChatarraReg.ctd) {
      ctd = valor;
    }
  }

  get({
    required CampoChatarraReg campo,
  }) {
    if (campo == CampoChatarraReg.item) {
      return item;
    }
    if (campo == CampoChatarraReg.e4e) {
      return e4e;
    }
    if (campo == CampoChatarraReg.descripcion) {
      return descripcion;
    }
    if (campo == CampoChatarraReg.um) {
      return um;
    }
    if (campo == CampoChatarraReg.ctd) {
      return ctd;
    }
  }

  ChatarraReg copyWith({
    String? id,
    String? item,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd,
  }) {
    return ChatarraReg(
      id:id ?? this.id,
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd: ctd ?? this.ctd,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
    };
  }

  factory ChatarraReg.fromMap(Map<String, dynamic> map) {
    return ChatarraReg(
      id: map['id'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd: map['ctd'].toString(),
    );
  }

  factory ChatarraReg.fromNuevo(String index) {
    return ChatarraReg(
      id: '',
      item: index,
      e4e: '',
      descripcion: 'Descripción',
      um: 'um',
      ctd: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatarraReg.fromJson(String source) =>
      ChatarraReg.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatarraReg(item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd)';
  }

  @override
  bool operator ==(covariant ChatarraReg other) {
    if (identical(this, other)) return true;

    return other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd == ctd;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd.hashCode;
  }
}
