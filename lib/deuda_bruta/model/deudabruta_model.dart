import 'dart:convert';

class DeudaBrutaB {
  List<DeudaBrutaBSingle> deudaList = [];
  List<DeudaBrutaBSingle> deudaListSearch = [];
  int totalValor = 0;
  Map itemsAndFlex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'mb52': 2,
    'inv': 2,
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
    deudaListSearch = [...deudaList];
    deudaListSearch =
        deudaList
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
  String toString() =>
      'DeudaBrutaB(deudaList: $deudaList, totalValor: $totalValor)';
}

class DeudaBrutaBSingle {
  String e4e;
  String descripcion;
  String um;
  String mb52;
  String inv;
  String faltanteUnidades;
  String faltanteValor;
  DeudaBrutaBSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.mb52,
    required this.inv,
    required this.faltanteUnidades,
    required this.faltanteValor,
  });

  DeudaBrutaBSingle copyWith({
    String? e4e,
    String? descripcion,
    String? um,
    String? mb52,
    String? inv,
    String? faltanteUnidades,
    String? faltanteValor,
  }) {
    return DeudaBrutaBSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      mb52: mb52 ?? this.mb52,
      inv: inv ?? this.inv,
      faltanteUnidades: faltanteUnidades ?? this.faltanteUnidades,
      faltanteValor: faltanteValor ?? this.faltanteValor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'mb52': mb52,
      'inv': inv,
      'faltanteUnidades': faltanteUnidades,
      'faltanteValor': faltanteValor,
    };
  }

  factory DeudaBrutaBSingle.fromMap(Map<String, dynamic> map) {
    return DeudaBrutaBSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      mb52: map['mb52'].toString(),
      inv: map['inv'].toString(),
      faltanteUnidades: map['faltanteUnidades'].toString(),
      faltanteValor: map['faltanteValor'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaBrutaBSingle.fromJson(String source) =>
      DeudaBrutaBSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaBrutaBSingle(e4e: $e4e, descripcion: $descripcion, um: $um, mb52: $mb52, inv: $inv, faltanteUnidades: $faltanteUnidades, faltanteValor: $faltanteValor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaBrutaBSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.mb52 == mb52 &&
        other.inv == inv &&
        other.faltanteUnidades == faltanteUnidades &&
        other.faltanteValor == faltanteValor;
  }

  @override
  int get hashCode {
    return e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        mb52.hashCode ^
        inv.hashCode ^
        faltanteUnidades.hashCode ^
        faltanteValor.hashCode;
  }

  List<String> toList() {
    return [e4e, descripcion, um, mb52, inv, faltanteUnidades, faltanteValor];
  }
}
