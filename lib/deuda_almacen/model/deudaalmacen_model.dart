import 'dart:convert';


class DeudaAlmacenB {
  List<DeudaAlmacenBSingle> deudaAlmacenB = [];
  List<DeudaAlmacenBSingle> deudaAlmacenBListSearch = [];
  List<DeudaAlmacenBSingle> deudaAlmacenBListSearch2 = [];
  int view = 60;
  int totalValor = 0;
  int totalSobrantes = 0;
  int totalFaltantes = 0;
  Map itemsAndFlex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'mb52': 2,
    'inv': 2,
    'sal': 2,
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
    deudaAlmacenBListSearch = [...deudaAlmacenB];
    deudaAlmacenBListSearch = deudaAlmacenB
        .where((element) =>
            element.toList().any((item) => item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
    deudaAlmacenBListSearch2 = [...deudaAlmacenBListSearch];
    deudaAlmacenBListSearch2.sort((b, a) => int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));
  }

  @override
  String toString() => 'DeudaAlmacenB(deudaAlmacenB: $deudaAlmacenB)';
}

class DeudaAlmacenBSingle {
  String e4e;
  String descripcion;
  String um;
  String mb52;
  String inv;
  String sal;
  String faltanteUnidades;
  String faltanteValor;
  String valorUnitario;
  // TextEditingController fisico = TextEditingController();
  Map flex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'mb52': 2,
    'inv': 2,
    'sal': 2,
    'faltanteUnidades': 2,
    'faltanteValor': 2,
  };
  DeudaAlmacenBSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.mb52,
    required this.inv,
    required this.sal,
    required this.faltanteUnidades,
    required this.faltanteValor,
    required this.valorUnitario,
  });

  DeudaAlmacenBSingle copyWith({
    String? e4e,
    String? descripcion,
    String? um,
    String? mb52,
    String? inv,
    String? sal,
    String? faltanteUnidades,
    String? faltanteValor,
    String? valorUnitario,
  }) {
    return DeudaAlmacenBSingle(
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      mb52: mb52 ?? this.mb52,
      inv: inv ?? this.inv,
      sal: sal ?? this.sal,
      faltanteUnidades: faltanteUnidades ?? this.faltanteUnidades,
      faltanteValor: faltanteValor ?? this.faltanteValor,
      valorUnitario: valorUnitario ?? this.valorUnitario,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'mb52': mb52,
      'inv': inv,
      'sal': sal,
      'faltanteUnidades': faltanteUnidades,
      'faltanteValor': faltanteValor,
    };
  }

  factory DeudaAlmacenBSingle.fromMap(Map<String, dynamic> map) {
    return DeudaAlmacenBSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      mb52: map['mb52'].toString(),
      inv: map['inv'].toString(),
      sal: map['sal'].toString(),
      faltanteUnidades: map['faltanteUnidades'].toString(),
      faltanteValor: map['faltanteValor'].toString(),
      valorUnitario: map['valorUnitario'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeudaAlmacenBSingle.fromJson(String source) =>
      DeudaAlmacenBSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeudaAlmacenBSingle(e4e: $e4e, descripcion: $descripcion, um: $um, mb52: $mb52, inv: $inv, sal: $sal, faltanteUnidades: $faltanteUnidades, faltanteValor: $faltanteValor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeudaAlmacenBSingle &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.mb52 == mb52 &&
        other.inv == inv &&
        other.sal == sal &&
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
        sal.hashCode ^
        faltanteUnidades.hashCode ^
        faltanteValor.hashCode;
  }

  List<String> toList() {
    return [
      e4e,
      descripcion,
      um,
      mb52,
      inv,
      sal,
      faltanteUnidades,
      faltanteValor,
    ];
  }

  List<Map> toMapListFlex() {
    return [
      {'index': 'e4e', 'texto': e4e, 'flex': flex['e4e']},
      {
        'index': 'descripcion',
        'texto': descripcion,
        'flex': flex['descripcion']
      },
      {'index': 'um', 'texto': um, 'flex': flex['um']},
      {'index': 'mb52', 'texto': mb52, 'flex': flex['mb52']},
      {'index': 'inv', 'texto': inv, 'flex': flex['inv']},
      {'index': 'sal', 'texto': sal, 'flex': flex['sal']},
      {
        'index': 'faltanteUnidades',
        'texto': faltanteUnidades,
        'flex': flex['faltanteUnidades']
      },
      {
        'index': 'faltanteValor',
        'texto': faltanteValor,
        'flex': flex['faltanteValor']
      },
    ];
  }

  void recalcularFaltante({required String inv}) {
    double faltanteUnidades =
        double.parse(mb52) - double.parse(inv) - double.parse(sal);
    double faltanteValor = double.parse(valorUnitario) * faltanteUnidades;
    this.faltanteUnidades = faltanteUnidades.toString();
    this.inv = inv;
    this.faltanteValor = faltanteValor.toString();
  }

  Map toSaldos({required String pdi}) {
    return {
      "Material": e4e,
      "Texto": descripcion,
      "Lote": pdi,
      "SaldoSAP": mb52,
      "SaldoPDI": inv,
    };
  }
}
