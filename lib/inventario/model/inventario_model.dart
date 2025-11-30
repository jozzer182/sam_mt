import 'dart:convert';

import '../../resources/titulo.dart';

class InventarioB {
  List<InventarioBSingle> inventarioList = [];
  List<InventarioBSingle> inventarioListSearch = [];

  List<ToCelda> titles = [
    ToCelda(valor: 'E4e', flex: 2),
    ToCelda(valor: 'Descripción', flex: 8),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'Ctd', flex: 1),
    ToCelda(valor: 'Almacén', flex: 1),
    ToCelda(valor: 'MoeCom', flex: 1),
  ];

  @override
  String toString() => 'InventarioB(inventarioList: $inventarioList)';
}

class InventarioBSingle {
  String e4e;
  String descripcion;
  String um;
  String ctd;
  String almacen = '';
  String moecom = '';

  InventarioBSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
    this.almacen = '',
    this.moecom = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
      'almacen': almacen,
      'moecom': moecom,
    };
  }

  factory InventarioBSingle.fromInit() {
    return InventarioBSingle(
      e4e: 'e4e',
      descripcion: 'No hay unidades en <Inventario> SAM',
      um: 'um',
      ctd: '0',
    );
  }

  factory InventarioBSingle.fromMap(Map<String, dynamic> map) {
    return InventarioBSingle(
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      ctd: map['ctd'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InventarioBSingle.fromJson(String source) =>
      InventarioBSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InventarioBSingle(e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd)';
  }

  List<String> toList() {
    return [e4e, descripcion, um, ctd, almacen, moecom];
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e, flex: 2),
    ToCelda(valor: descripcion, flex: 8),
    ToCelda(valor: um, flex: 1),
    ToCelda(valor: ctd, flex: 1),
    ToCelda(valor: almacen, flex: 1),
    ToCelda(valor: moecom, flex: 1),
  ];
}
