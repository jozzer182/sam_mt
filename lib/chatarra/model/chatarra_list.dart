// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../resources/titulo.dart';

class ChatarraList {
  List<ChatarraSingle> list = [];
  List<ChatarraSingle> listSearch = [];

  buscar(String busqueda) {
    listSearch = [...list];
    listSearch =
        list
            .toList()
            .where(
              (item) => item.toString().toLowerCase().contains(
                busqueda.toLowerCase(),
              ),
            )
            .toList();
  }

  Map itemsAndFlex = {
    'pedido': [1, 'pedido'],
    'lcl': [3, 'lcl'],
    'acta': [2, 'acta'],
    'balance': [2, 'balance'],
    'item': [1, 'item'],
    'e4e': [2, 'e4e'],
    'descripcion': [6, 'descripción'],
    'um': [1, 'um'],
    'ctd': [1, 'ctd'],
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
    ToCelda(valor: 'Pedido', flex: 1),
    ToCelda(valor: 'LCL', flex: 3),
    ToCelda(valor: 'Acta', flex: 2),
    ToCelda(valor: 'Balance', flex: 2),
    ToCelda(valor: 'Item', flex: 1),
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'Descripción', flex: 6),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'CTD', flex: 1),
  ];
}

class ChatarraSingle {
  String id;
  String pedido;
  String acta;
  String fecha_i;
  String almacenista_i;
  String tel_i;
  String soporte_i;
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd;
  String lcl;
  String comentario_i;
  String balance;
  String reportado;
  String estadopersona;
  String estado;
  ChatarraSingle({
    required this.id,
    required this.pedido,
    required this.acta,
    required this.fecha_i,
    required this.almacenista_i,
    required this.tel_i,
    required this.soporte_i,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
    required this.lcl,
    required this.comentario_i,
    required this.balance,
    required this.reportado,
    required this.estadopersona,
    required this.estado,
  });

  ChatarraSingle copyWith({
    String? id,
    String? pedido,
    String? acta,
    String? fecha_i,
    String? almacenista_i,
    String? tel_i,
    String? soporte_i,
    String? item,
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
    return ChatarraSingle(
      id: id ?? this.id,
      pedido: pedido ?? this.pedido,
      acta: acta ?? this.acta,
      fecha_i: fecha_i ?? this.fecha_i,
      almacenista_i: almacenista_i ?? this.almacenista_i,
      tel_i: tel_i ?? this.tel_i,
      soporte_i: soporte_i ?? this.soporte_i,
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd: ctd ?? this.ctd,
      lcl: lcl ?? this.lcl,
      comentario_i: comentario_i ?? this.comentario_i,
      balance: balance ?? this.balance,
      reportado: reportado ?? this.reportado,
      estadopersona: estadopersona ?? this.estadopersona,
      estado: estado ?? this.estado,
    );
  }

  List<String> toList() {
    return [
      id,
      pedido,
      acta,
      fecha_i,
      almacenista_i,
      tel_i,
      soporte_i,
      item,
      e4e,
      descripcion,
      um,
      ctd,
      lcl,
      comentario_i,
      balance,
      reportado,
      estadopersona,
      estado,
    ];
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
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
      'lcl': lcl,
      'comentario_i': comentario_i,
      'balance': balance,
      'reportado': reportado,
      'estadopersona': estadopersona,
      'estado': estado,
    };
  }

  factory ChatarraSingle.fromMap(Map<String, dynamic> map) {
    return ChatarraSingle(
      id: map['id'].toString(),
      pedido: map['pedido'].toString(),
      acta: map['acta'].toString(),
      fecha_i:
          map['fecha_i'].toString().length > 10
              ? map['fecha_i'].toString().substring(0, 10)
              : map['fecha_i'].toString(),
      almacenista_i: map['almacenista_i'].toString(),
      tel_i: map['tel_i'].toString(),
      soporte_i: map['soporte_i'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd: map['ctd'].toString(),
      lcl: map['lcl'].toString(),
      comentario_i: map['comentario_i'].toString(),
      balance: map['balance'].toString(),
      reportado:
          map['reportado'].toString().length > 16
              ? map['reportado'].toString().substring(0, 16)
              : map['reportado'].toString(),
      estadopersona: map['estadopersona'].toString(),
      estado: map['estado'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatarraSingle.fromJson(String source) =>
      ChatarraSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatarraSingle(id: $id, pedido: $pedido, acta: $acta, fecha_i: $fecha_i, almacenista_i: $almacenista_i, tel_i: $tel_i, soporte_i: $soporte_i, item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd, lcl: $lcl, comentario_i: $comentario_i, balance: $balance ,reportado: $reportado, estadopersona: $estadopersona, estado: $estado)';
  }

  @override
  bool operator ==(covariant ChatarraSingle other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.pedido == pedido &&
        other.acta == acta &&
        other.fecha_i == fecha_i &&
        other.almacenista_i == almacenista_i &&
        other.tel_i == tel_i &&
        other.soporte_i == soporte_i &&
        other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd == ctd &&
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
        item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd.hashCode ^
        lcl.hashCode ^
        comentario_i.hashCode ^
        reportado.hashCode ^
        estadopersona.hashCode ^
        estado.hashCode;
  }

    List<ToCelda> get celdas => [
      ToCelda(valor: pedido, flex: 1),
      ToCelda(valor: lcl, flex: 3),
      ToCelda(valor: acta, flex: 2),
      ToCelda(valor: balance, flex: 2),
      ToCelda(valor: item, flex: 1),
      ToCelda(valor: e4e, flex: 2),
      ToCelda(valor: descripcion, flex: 6),
      ToCelda(valor: um, flex: 1),
      ToCelda(valor: ctd, flex: 1),
    ];
}
