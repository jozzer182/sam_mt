import 'dart:convert';

class EnableDate {
  String mes;
  bool pedidoActivoq1;
  bool versionActivaq1;
  bool pedidoActivoq2;
  bool versionActivaq2;
  EnableDate({
    required this.mes,
    required this.pedidoActivoq1,
    required this.versionActivaq1,
    required this.pedidoActivoq2,
    required this.versionActivaq2,
  });

  EnableDate copyWith({
    String? mes,
    bool? pedidoActivoq1,
    bool? versionActivaq1,
    bool? pedidoActivoq2,
    bool? versionActivaq2,
  }) {
    return EnableDate(
      mes: mes ?? this.mes,
      pedidoActivoq1: pedidoActivoq1 ?? this.pedidoActivoq1,
      versionActivaq1: versionActivaq1 ?? this.versionActivaq1,
      pedidoActivoq2: pedidoActivoq2 ?? this.pedidoActivoq2,
      versionActivaq2: versionActivaq2 ?? this.versionActivaq2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mes': mes,
      'pedidoActivoq1': pedidoActivoq1,
      'versionActivaq1': versionActivaq1,
      'pedidoActivoq2': pedidoActivoq2,
      'versionActivaq2': versionActivaq2,
    };
  }

  factory EnableDate.fromMap(Map<String, dynamic> map) {
    return EnableDate(
      mes: map['mes'] ?? '',
      pedidoActivoq1: map['pedidoActivoq1'] ?? false,
      versionActivaq1: map['versionActivaq1'] ?? false,
      pedidoActivoq2: map['pedidoActivoq2'] ?? false,
      versionActivaq2: map['versionActivaq2'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnableDate.fromJson(String source) =>
      EnableDate.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EnableDate(mes: $mes, pedidoActivoq1: $pedidoActivoq1, versionActivaq1: $versionActivaq1, pedidoActivoq2: $pedidoActivoq2, versionActivaq2: $versionActivaq2)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnableDate &&
        other.mes == mes &&
        other.pedidoActivoq1 == pedidoActivoq1 &&
        other.versionActivaq1 == versionActivaq1 &&
        other.pedidoActivoq2 == pedidoActivoq2 &&
        other.versionActivaq2 == versionActivaq2;
  }

  @override
  int get hashCode {
    return mes.hashCode ^
        pedidoActivoq1.hashCode ^
        versionActivaq1.hashCode ^
        pedidoActivoq2.hashCode ^
        versionActivaq2.hashCode;
  }
}

class EnableDateInt {
  int mes;
  bool pedidoActivoq1;
  bool versionActivaq1;
  bool pedidoActivoq2;
  bool versionActivaq2;
  bool entredoQ1;
  bool entredoQ2;
  EnableDateInt({
    required this.mes,
    required this.pedidoActivoq1,
    required this.versionActivaq1,
    required this.pedidoActivoq2,
    required this.versionActivaq2,
    required this.entredoQ1,
    required this.entredoQ2,
  });
}