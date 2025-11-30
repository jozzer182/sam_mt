import 'dart:convert';

import 'package:intl/intl.dart';

class FechasFEMDateBool {
  String version;
  int ano;
  String name;
  String pedido;
  DateTime fecha;
  bool estado;
  DateTime fechadelivery;
  bool delivered;
  DateTime versionfecha;
  bool versionestado;
  FechasFEMDateBool({
    required this.version,
    required this.ano,
    required this.name,
    required this.pedido,
    required this.fecha,
    required this.estado,
    required this.fechadelivery,
    required this.delivered,
    required this.versionfecha,
    required this.versionestado,
  });

  FechasFEMDateBool copyWith({
    String? version,
    int? ano,
    String? name,
    String? pedido,
    DateTime? fecha,
    bool? estado,
    DateTime? fechadelivery,
    bool? delivered,
    DateTime? versionfecha,
    bool? versionestado,
  }) {
    return FechasFEMDateBool(
      version: version ?? this.version,
      ano: ano ?? this.ano,
      name: name ?? this.name,
      pedido: pedido ?? this.pedido,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
      fechadelivery: fechadelivery ?? this.fechadelivery,
      delivered: delivered ?? this.delivered,
      versionfecha: versionfecha ?? this.versionfecha,
      versionestado: versionestado ?? this.versionestado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'ano': ano,
      'name': name,
      'pedido': pedido,
      'fecha': fecha.millisecondsSinceEpoch,
      'estado': estado,
      'fechadelivery': fechadelivery.millisecondsSinceEpoch,
      'delivered': delivered,
      'versionfecha': versionfecha.millisecondsSinceEpoch,
      'versionestado': versionestado,
    };
  }

  factory FechasFEMDateBool.fromMap(Map<String, dynamic> map) {
    return FechasFEMDateBool(
      version: map['version'] ?? '',
      ano: int.parse(map['ano'] ?? ''),
      name: map['name'] ?? '',
      pedido: map['pedido'] ?? '',
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha']),
      estado: map['estado'] ?? false,
      fechadelivery: DateTime.fromMillisecondsSinceEpoch(map['fechadelivery']),
      delivered: map['delivered'] ?? false,
      versionfecha: DateTime.fromMillisecondsSinceEpoch(map['versionfecha']),
      versionestado: map['versionestado'] ?? false,
    );
  }

  factory FechasFEMDateBool.fromList(List ls) {
    // print('tipo 0: ${ls[0].runtimeType}');
    // print('tipo 1: ${ls[1].runtimeType}');
    // print('tipo 2: ${ls[2].runtimeType}');
    // print('tipo 3: ${ls[3].runtimeType}');
    // print('tipo 4: ${ls[4].runtimeType}');
    // print('tipo 5: ${ls[5].runtimeType}');
    // print('tipo 6: ${ls[6].runtimeType}');
    // print('tipo 7: ${ls[7].runtimeType}');
    // print('tipo 8: ${ls[8].runtimeType}');
    // print('tipo 9: ${ls[9].runtimeType}');
    // print(ls);
    return FechasFEMDateBool(
      version: ls[0] ?? '',
      ano: ls[1]?.toInt() ?? 0,
      name: ls[2] ?? '',
      pedido: ls[3] ?? '',
      fecha: ls[4].length == 10? DateFormat('dd/MM/yyyy').parse(ls[4]):  DateTime.parse(ls[4]),
      estado: ls[5] ?? false,
      fechadelivery: ls[6].length == 10? DateFormat('dd/MM/yyyy').parse(ls[6]):  DateTime.parse(ls[6]),
      delivered: ls[7] ?? false,
      versionfecha: ls[8].length == 10? DateFormat('dd/MM/yyyy').parse(ls[8]):  DateTime.parse(ls[8]),
      versionestado: ls[9] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory FechasFEMDateBool.fromJson(String source) =>
      FechasFEMDateBool.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FechasFEMDateBool(version: $version, ano: $ano, name: $name, pedido: $pedido, fecha: $fecha, estado: $estado, fechadelivery: $fechadelivery, delivered: $delivered, versionfecha: $versionfecha, versionestado: $versionestado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FechasFEMDateBool &&
        other.version == version &&
        other.ano == ano &&
        other.name == name &&
        other.pedido == pedido &&
        other.fecha == fecha &&
        other.estado == estado &&
        other.fechadelivery == fechadelivery &&
        other.delivered == delivered &&
        other.versionfecha == versionfecha &&
        other.versionestado == versionestado;
  }

  @override
  int get hashCode {
    return version.hashCode ^
        ano.hashCode ^
        name.hashCode ^
        pedido.hashCode ^
        fecha.hashCode ^
        estado.hashCode ^
        fechadelivery.hashCode ^
        delivered.hashCode ^
        versionfecha.hashCode ^
        versionestado.hashCode;
  }
}
