import 'dart:convert';

class DeudaEnelB {
  List<DeudaEnelBSingle> deudaEnel = [];
  List<DeudaEnelBSingle> deudaEnelListSearch = [];
  int totalValor = 0;
  Map itemsAndFlex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'ctd_total': 2,
    'ctd_sap': 2,
    'faltanteUnidades': 2,
    'faltanteValor': 2,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  buscar(String busqueda) {
    deudaEnelListSearch = [...deudaEnel];
    deudaEnelListSearch = deudaEnel
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }


  @override
  String toString() => 'DeudaEnelB(deudaEnel: $deudaEnel, totalValor: $totalValor)';
}

class DeudaEnelBSingle {
  String e4e;
  String descripcion;
  String um;
  String ctd_total;
  String ctd_sap;
  String faltanteUnidades;
  String faltanteValor;
  DeudaEnelBSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_total,
    required this.ctd_sap,
    required this.faltanteUnidades,
    required this.faltanteValor,
  });

  DeudaEnelBSingle copyWith({
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd_total,
    String? ctd_sap,
    String? faltanteUnidades,
    String? faltanteValor,
  }) {
    return DeudaEnelBSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd_total: ctd_total ?? this.ctd_total,
      ctd_sap: ctd_sap ?? this.ctd_sap,
      faltanteUnidades: faltanteUnidades ?? this.faltanteUnidades,
      faltanteValor: faltanteValor ?? this.faltanteValor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd_total': ctd_total,
      'ctd_sap': ctd_sap,
      'faltanteUnidades': faltanteUnidades,
      'faltanteValor': faltanteValor,
    };
  }

  factory DeudaEnelBSingle.fromMap(Map<String, dynamic> map) {
    return DeudaEnelBSingle(
      e4e: map['e4e'] ?? '',
      descripcion: map['descripcion'] ?? '',
      um: map['um'] ?? '',
      ctd_total: map['ctd_total'] ?? '',
      ctd_sap: map['ctd_sap'] ?? '',
      faltanteUnidades: map['faltanteUnidades'] ?? '',
      faltanteValor: map['faltanteValor'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaEnelBSingle.fromJson(String source) =>
      DeudaEnelBSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaEnelBSingle(e4e: $e4e, descripcion: $descripcion, um: $um, ctd_total: $ctd_total, ctd_sap: $ctd_sap, faltanteUnidades: $faltanteUnidades, faltanteValor: $faltanteValor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaEnelBSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd_total == ctd_total &&
        other.ctd_sap == ctd_sap &&
        other.faltanteUnidades == faltanteUnidades &&
        other.faltanteValor == faltanteValor;
  }

  @override
  int get hashCode {
    return e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd_total.hashCode ^
        ctd_sap.hashCode ^
        faltanteUnidades.hashCode ^
        faltanteValor.hashCode;
  }

  List<String> toList() {
    return [
      e4e,
      descripcion,
      um,
      ctd_total,
      ctd_sap,
      faltanteUnidades,
      faltanteValor,
    ];
  }
}
