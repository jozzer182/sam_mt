// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:statistics/statistics.dart';

class MedidaAns {
  List<MedidaAnsSingle> medidaAnsList = [];
  List<MedidaAnsSingle> medidaAnsListSearch = [];
  int count = 0;
  double max = 0;
  double min = 0;
  double mean = 0;
  double standardDeviation = 0;
  double sum = 0;
  double center = 0;
  double median = 0;
  double variance = 0;
  double mode = 0;
  DateTime fechaInicio = DateTime.now();
  DateTime fechaFin = DateTime.now();
  List<DistribucionSingle> distribucion = [];

  calcular() {
    distribucion = [];
    List<double> numeros =
        medidaAnsList
            .where(
              (e) =>
                  e.tiempototal != "<--" &&
                  DateTime.parse(
                    e.fechacargascm,
                  ).isAfter(fechaInicio.subtract(Duration(days: 1))) &&
                  DateTime.parse(
                    e.fechacargascm,
                  ).isBefore(fechaFin.add(Duration(days: 1))),
            ) // Para que incluya el último día en el cálculo
            .map((e) => double.parse(e.tiempototal))
            .toList();
    Statistics<double> estadisticasNoCero = numeros.statistics;
    max = estadisticasNoCero.max;
    min = estadisticasNoCero.min;
    mean = estadisticasNoCero.mean;
    standardDeviation = estadisticasNoCero.standardDeviation;
    sum = estadisticasNoCero.sum.toDouble();
    center = estadisticasNoCero.center;
    median = estadisticasNoCero.median.toDouble();
    variance =
        numeros
            .map((numero) => (numero - mean) * (numero - mean))
            .reduce((a, b) => a + b) /
        numeros.length;
    mode = modaCalc(numeros).toDouble();
    count = numeros.length;
    Map<String, int> conteo = {};
    for (double numero in numeros) {
      conteo[numero.toInt().toString()] =
          (conteo[numero.toInt().toString()] ?? 0) + 1;
    }
    conteo.forEach((key, value) {
      distribucion.add(
        DistribucionSingle(dias: int.parse(key), cantidad: value),
      );
    });
    distribucion.sort((a, b) => a.dias.compareTo(b.dias));
    // print(distribucion);
  }
}

int modaCalc(List<double> numeros) {
  Map<int, int> conteo = {};

  // Contar la frecuencia de cada número
  for (double numero in numeros) {
    conteo[numero.toInt()] = (conteo[numero.toInt()] ?? 0) + 1;
  }

  // Encontrar el número con mayor frecuencia (moda)
  int result = 0;
  int maxFrecuencia = 0;

  conteo.forEach((numero, frecuencia) {
    if (frecuencia > maxFrecuencia) {
      result = numero;
      maxFrecuencia = frecuencia;
    }
  });

  return result;
}

class DistribucionSingle {
  int dias;
  int cantidad;
  DistribucionSingle({required this.dias, required this.cantidad});
}

class MedidaAnsSingle {
  String conciliacion;
  String estado;
  String personacontrato;
  String personaenel;
  String balance;
  String fechabalance;
  String planilla;
  String lcl;
  String lm;
  String nodo;
  String cto;
  String e4e;
  String descripcion;
  String ctd;
  String um;
  String valor;
  String fechaentrega;
  String fechacargaarchivos;
  String fechaaprobado;
  String fechacargascm;
  String tiempo1;
  String tiempo2;
  String tiempototal;
  MedidaAnsSingle({
    required this.conciliacion,
    required this.estado,
    required this.personacontrato,
    required this.personaenel,
    required this.balance,
    required this.fechabalance,
    required this.planilla,
    required this.lcl,
    required this.lm,
    required this.nodo,
    required this.cto,
    required this.e4e,
    required this.descripcion,
    required this.ctd,
    required this.um,
    required this.valor,
    required this.fechaentrega,
    required this.fechacargaarchivos,
    required this.fechaaprobado,
    required this.fechacargascm,
    required this.tiempo1,
    required this.tiempo2,
    required this.tiempototal,
  });

  List<String> toList() {
    return [
      conciliacion,
      estado,
      personacontrato,
      personaenel,
      balance,
      fechabalance,
      planilla,
      lcl,
      lm,
      nodo,
      cto,
      e4e,
      descripcion,
      ctd,
      um,
      valor,
      fechaentrega,
      fechacargaarchivos,
      fechaaprobado,
      fechacargascm,
      tiempo1,
      tiempo2,
      tiempototal,
    ];
  }

  MedidaAnsSingle copyWith({
    String? conciliacion,
    String? estado,
    String? personacontrato,
    String? personaenel,
    String? balance,
    String? fechabalance,
    String? planilla,
    String? lcl,
    String? lm,
    String? nodo,
    String? cto,
    String? e4e,
    String? descripcion,
    String? ctd,
    String? um,
    String? valor,
    String? fechaentrega,
    String? fechacargaarchivos,
    String? fechaaprobado,
    String? fechacargascm,
    String? tiempo1,
    String? tiempo2,
    String? tiempototal,
  }) {
    return MedidaAnsSingle(
      conciliacion: conciliacion ?? this.conciliacion,
      estado: estado ?? this.estado,
      personacontrato: personacontrato ?? this.personacontrato,
      personaenel: personaenel ?? this.personaenel,
      balance: balance ?? this.balance,
      fechabalance: fechabalance ?? this.fechabalance,
      planilla: planilla ?? this.planilla,
      lcl: lcl ?? this.lcl,
      lm: lm ?? this.lm,
      nodo: nodo ?? this.nodo,
      cto: cto ?? this.cto,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      ctd: ctd ?? this.ctd,
      um: um ?? this.um,
      valor: valor ?? this.valor,
      fechaentrega: fechaentrega ?? this.fechaentrega,
      fechacargaarchivos: fechacargaarchivos ?? this.fechacargaarchivos,
      fechaaprobado: fechaaprobado ?? this.fechaaprobado,
      fechacargascm: fechacargascm ?? this.fechacargascm,
      tiempo1: tiempo1 ?? this.tiempo1,
      tiempo2: tiempo2 ?? this.tiempo2,
      tiempototal: tiempototal ?? this.tiempototal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'conciliacion': conciliacion,
      'estado': estado,
      'personacontrato': personacontrato,
      'personaenel': personaenel,
      'balance': balance,
      'fechabalance': fechabalance,
      'planilla': planilla,
      'lcl': lcl,
      'lm': lm,
      'nodo': nodo,
      'cto': cto,
      'e4e': e4e,
      'descripcion': descripcion,
      'ctd': ctd,
      'um': um,
      'valor': valor,
      'fechaentrega': fechaentrega,
      'fechacargaarchivos': fechacargaarchivos,
      'fechaaprobado': fechaaprobado,
      'fechacargascm': fechacargascm,
      'tiempo1': tiempo1,
      'tiempo2': tiempo2,
      'tiempototal': tiempototal,
    };
  }

  factory MedidaAnsSingle.fromMap(Map<String, dynamic> map) {
    return MedidaAnsSingle(
      conciliacion: map['conciliacion'] as String,
      estado: map['estado'] as String,
      personacontrato: map['personacontrato'] as String,
      personaenel: map['personaenel'] as String,
      balance: map['balance'] as String,
      fechabalance: map['fechabalance'] as String,
      planilla: map['planilla'] as String,
      lcl: map['lcl'] as String,
      lm: map['lm'] as String,
      nodo: map['nodo'] as String,
      cto: map['cto'] as String,
      e4e: map['e4e'] as String,
      descripcion: map['descripcion'] as String,
      ctd: map['ctd'] as String,
      um: map['um'] as String,
      valor: map['valor'] as String,
      fechaentrega: map['fechaentrega'] as String,
      fechacargaarchivos: map['fechacargaarchivos'] as String,
      fechaaprobado: map['fechaaprobado'] as String,
      fechacargascm: map['fechacargascm'] as String,
      tiempo1: map['tiempo1'] as String,
      tiempo2: map['tiempo2'] as String,
      tiempototal: map['tiempototal'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedidaAnsSingle.fromJson(String source) =>
      MedidaAnsSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MedidaAnsSingle(conciliacion: $conciliacion, estado: $estado, balance: $balance, fechabalance: $fechabalance, planilla: $planilla, lcl: $lcl, lm $lm, cto: $cto, e4e: $e4e, descripcion: $descripcion, ctd: $ctd, um: $um, fechaentrega: $fechaentrega, fechacargaarchivos: $fechacargaarchivos, fechaaprobado: $fechaaprobado, fechacargascm: $fechacargascm, tiempo1: $tiempo1, tiempo2: $tiempo2, tiempototal: $tiempototal)';
  }

  @override
  bool operator ==(covariant MedidaAnsSingle other) {
    if (identical(this, other)) return true;

    return other.conciliacion == conciliacion &&
        other.estado == estado &&
        other.balance == balance &&
        other.fechabalance == fechabalance &&
        other.planilla == planilla &&
        other.lcl == lcl &&
        other.cto == cto &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.ctd == ctd &&
        other.um == um &&
        other.fechaentrega == fechaentrega &&
        other.fechacargaarchivos == fechacargaarchivos &&
        other.fechaaprobado == fechaaprobado &&
        other.fechacargascm == fechacargascm &&
        other.tiempo1 == tiempo1 &&
        other.tiempo2 == tiempo2 &&
        other.tiempototal == tiempototal;
  }

  @override
  int get hashCode {
    return conciliacion.hashCode ^
        estado.hashCode ^
        balance.hashCode ^
        fechabalance.hashCode ^
        planilla.hashCode ^
        lcl.hashCode ^
        cto.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        ctd.hashCode ^
        um.hashCode ^
        fechaentrega.hashCode ^
        fechacargaarchivos.hashCode ^
        fechaaprobado.hashCode ^
        fechacargascm.hashCode ^
        tiempo1.hashCode ^
        tiempo2.hashCode ^
        tiempototal.hashCode;
  }
}
