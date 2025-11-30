import 'dart:convert';

import '../../resources/titulo.dart';

class Plataforma {
  List<PlataformaSingle> plataformaList = [];
  List<PlataformaSingle> plataformaListSearch = [];
  int view = 100;
  bool loading = false;

  List<ToCelda> titles = [
    ToCelda(valor: 'E4e', flex: 2),
    ToCelda(valor: 'Descripción', flex: 6),
    ToCelda(valor: 'Um', flex: 2),
    ToCelda(valor: 'Ctd', flex: 2),
    ToCelda(valor: 'Proyecto (WBE)', flex: 6),
  ];

  buscar(String busqueda) {
    plataformaListSearch = [...plataformaList];
    plataformaListSearch =
        plataformaList
            .where(
              (element) => element.toList().any(
                (item) => item.toString().toLowerCase().contains(
                  busqueda.toLowerCase(),
                ),
              ),
            )
            .toList();
  }

  @override
  String toString() => 'Plataforma(plataforma: $plataformaList)';
}

class PlataformaSingle {
  String material;
  String descripcion;
  String umb;
  String ctd;
  String valor;
  String proyecto;
  String parte_proyecto;
  String wbe;
  String status;
  String actualizado;
  PlataformaSingle({
    required this.material,
    required this.descripcion,
    required this.umb,
    required this.ctd,
    required this.valor,
    required this.proyecto,
    required this.parte_proyecto,
    required this.wbe,
    required this.status,
    required this.actualizado,
  });

  PlataformaSingle copyWith({
    String? material,
    String? descripcion,
    String? umb,
    String? ctd,
    String? valor,
    String? proyecto,
    String? parte_proyecto,
    String? wbe,
    String? status,
    String? actualizado,
  }) {
    return PlataformaSingle(
      material: material ?? this.material,
      descripcion: descripcion ?? this.descripcion,
      umb: umb ?? this.umb,
      ctd: ctd ?? this.ctd,
      valor: valor ?? this.valor,
      proyecto: proyecto ?? this.proyecto,
      parte_proyecto: parte_proyecto ?? this.parte_proyecto,
      wbe: wbe ?? this.wbe,
      status: status ?? this.status,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'descripcion': descripcion,
      'umb': umb,
      'ctd': ctd,
      'valor': valor,
      'proyecto': proyecto,
      'parte_proyecto': parte_proyecto,
      'wbe': wbe,
      'status': status,
      'actualizado': actualizado,
    };
  }

  factory PlataformaSingle.fromMap(Map<String, dynamic> map) {
    return PlataformaSingle(
      material: map['material'].toString(),
      descripcion: map['descripcion'].toString(),
      umb: map['umb'].toString(),
      ctd: map['ctd'].toString(),
      valor: map['valor'].toString(),
      proyecto: map['proyecto'].toString(),
      parte_proyecto: map['parte_proyecto'].toString(),
      wbe: map['wbe'].toString(),
      status: map['status'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlataformaSingle.fromJson(String source) =>
      PlataformaSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlataformaSingle(material: $material, descripcion: $descripcion, umb: $umb, ctd: $ctd, valor: $valor, proyecto: $proyecto, parte_proyecto: $parte_proyecto, wbe: $wbe, status: $status, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlataformaSingle &&
        other.material == material &&
        other.descripcion == descripcion &&
        other.umb == umb &&
        other.ctd == ctd &&
        other.valor == valor &&
        other.proyecto == proyecto &&
        other.parte_proyecto == parte_proyecto &&
        other.wbe == wbe &&
        other.status == status &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return material.hashCode ^
        descripcion.hashCode ^
        umb.hashCode ^
        ctd.hashCode ^
        valor.hashCode ^
        proyecto.hashCode ^
        parte_proyecto.hashCode ^
        wbe.hashCode ^
        status.hashCode ^
        actualizado.hashCode;
  }

  List<String> toList() {
    return [
      material,
      descripcion,
      umb,
      ctd,
      valor,
      proyecto,
      parte_proyecto,
      wbe,
      status,
      actualizado,
    ];
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: material, flex: 2),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: umb, flex: 2),
    ToCelda(valor: ctd, flex: 2),
    ToCelda(valor: proyecto, flex: 6),
  ];
}
