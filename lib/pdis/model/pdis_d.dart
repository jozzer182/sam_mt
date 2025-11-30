import 'dart:convert';

class PdisB {
  List<Pdis> pdis = [];

  @override
  String toString() => 'PdisB(pdis: $pdis)';
}

class Pdis {
  String empresa;
  String pdi;
  String nombreCorto;
  String zona;
  String contrato;
  Pdis({
    required this.empresa,
    required this.pdi,
    required this.nombreCorto,
    required this.zona,
    required this.contrato,
  });

  Pdis copyWith({
    String? empresa,
    String? pdi,
    String? nombreCorto,
    String? zona,
    String? contrato,
  }) {
    return Pdis(
      empresa: empresa ?? this.empresa,
      pdi: pdi ?? this.pdi,
      nombreCorto: nombreCorto ?? this.nombreCorto,
      zona: zona ?? this.zona,
      contrato: contrato ?? this.contrato,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'empresa': empresa,
      'pdi': pdi,
      'nombreCorto': nombreCorto,
      'zona': zona,
      'contrato': contrato,
    };
  }

  factory Pdis.fromMap(Map<String, dynamic> map) {
    return Pdis(
      empresa: map['empresa'].toString(),
      pdi: map['pdi'].toString(),
      nombreCorto: map['nombrecorto'].toString(),
      zona: map['zona'].toString(),
      contrato: map['contrato'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Pdis.fromJson(String source) => Pdis.fromMap(json.decode(source));

  @override
  String toString() =>
      'PdisBSingle(empresa: $empresa, pdi: $pdi, nombreCorto: $nombreCorto, zona: $zona, contrato: $contrato)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pdis &&
        other.empresa == empresa &&
        other.pdi == pdi &&
        other.nombreCorto == nombreCorto &&
        other.zona == zona;
  }

  @override
  int get hashCode =>
      empresa.hashCode ^ pdi.hashCode ^ nombreCorto.hashCode ^ zona.hashCode;
}
