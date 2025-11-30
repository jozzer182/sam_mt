import 'dart:convert';

import 'package:v_al_sam_v02/conciliacion/model/conciliacion_model.dart';

import '../../resources/titulo.dart';

class Conciliaciones {
  List<Conciliacion> conciliacionesList = [];
  List<Conciliacion> conciliacionesListSearch = [];

  List<ConciliacionEstado> conciliacionesEstadoList = [];
  List<ConciliacionEstado> conciliacionesEstadoListSearch = [];

  buscar(String busqueda) {
    conciliacionesEstadoListSearch = [...conciliacionesEstadoList];
    conciliacionesEstadoListSearch =
        conciliacionesEstadoList
            .toList()
            .where(
              (item) => item.toString().toLowerCase().contains(
                busqueda.toLowerCase(),
              ),
            )
            .toList();
  }

  Map itemsAndFlex = {
    'proyecto': [3, 'Proyecto'],
    'lcl': [1, 'LCL'],
    'conciliacion': [1, 'Conciliación'],
    'estado': [2, 'Estado'],
    'nodo': [3, 'Nodo'],
    'personaenel': [3, 'ENEL'],
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
    ToCelda(valor: 'Proyecto', flex: 3),
    
  ];
}

class ConciliacionEstado {
  String lcl;
  String conciliacion;
  String estado;
  String nodo;
  String personaenel;
  String proyecto;
  ConciliacionEstado({
    required this.lcl,
    required this.conciliacion,
    required this.estado,
    required this.nodo,
    required this.personaenel,
    required this.proyecto,
  });

  ConciliacionEstado copyWith({
    String? lcl,
    String? conciliacion,
    String? estado,
    String? nodo,
    String? personaenel,
    String? proyecto,
  }) {
    return ConciliacionEstado(
      lcl: lcl ?? this.lcl,
      conciliacion: conciliacion ?? this.conciliacion,
      estado: estado ?? this.estado,
      nodo: nodo ?? this.nodo,
      personaenel: personaenel ?? this.personaenel,
      proyecto: proyecto ?? this.proyecto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lcl': lcl,
      'conciliacion': conciliacion,
      'estado': estado,
      'nodo': nodo,
      'personaenel': personaenel,
      'proyecto': proyecto,
    };
  }

  factory ConciliacionEstado.fromMap(Map<String, dynamic> map) {
    return ConciliacionEstado(
      lcl: map['lcl'].toString(),
      conciliacion: map['conciliacion'].toString(),
      estado: map['estado'].toString(),
      nodo: map['nodo'].toString(),
      personaenel: map['personaenel'].toString(),
      proyecto: map['proyecto'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConciliacionEstado.fromJson(String source) =>
      ConciliacionEstado.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConciliacionEstado(lcl: $lcl, conciliacion: $conciliacion, estado: $estado, nodo: $nodo, personaenel: $personaenel, proyecto: $proyecto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConciliacionEstado &&
        other.lcl == lcl &&
        other.conciliacion == conciliacion &&
        other.estado == estado &&
        other.nodo == nodo &&
        other.personaenel == personaenel &&
        other.proyecto == proyecto;
  }

  @override
  int get hashCode {
    return lcl.hashCode ^
        conciliacion.hashCode ^
        estado.hashCode ^
        nodo.hashCode ^
        personaenel.hashCode ^
        proyecto.hashCode;
  }
}
