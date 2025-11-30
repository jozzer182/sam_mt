// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Libreto {}

class LibretoSingle {
  String lcl;
  String lm;
  String fecha_conciliacion;
  String comentario_op;
  String est_contrato;
  String responsable_contrato;
  String odm;
  LibretoSingle({
    required this.lcl,
    required this.lm,
    required this.fecha_conciliacion,
    required this.comentario_op,
    required this.est_contrato,
    required this.responsable_contrato,
    required this.odm,
  });


  LibretoSingle copyWith({
    String? lcl,
    String? lm,
    String? fecha_conciliacion,
    String? comentario_op,
    String? est_contrato,
    String? responsable_contrato,
    String? odm,
  }) {
    return LibretoSingle(
      lcl: lcl ?? this.lcl,
      lm: lm ?? this.lm,
      fecha_conciliacion: fecha_conciliacion ?? this.fecha_conciliacion,
      comentario_op: comentario_op ?? this.comentario_op,
      est_contrato: est_contrato ?? this.est_contrato,
      responsable_contrato: responsable_contrato ?? this.responsable_contrato,
      odm: odm ?? this.odm,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lcl': lcl,
      'lm': lm,
      'fecha_conciliacion': fecha_conciliacion,
      'comentario_op': comentario_op,
      'est_contrato': est_contrato,
      'responsable_contrato': responsable_contrato,
      'odm': odm,
    };
  }

  factory LibretoSingle.fromMap(Map<String, dynamic> map) {
    return LibretoSingle(
      lcl: map['lcl'] as String,
      lm: map['lm'] as String,
      fecha_conciliacion: map['fecha_conciliacion'] as String,
      comentario_op: map['comentario_op'] as String,
      est_contrato: map['est_contrato'] as String,
      responsable_contrato: map['responsable_contrato'] as String,
      odm: map['odm'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LibretoSingle.fromJson(String source) => LibretoSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LibretoSingle(lcl: $lcl, lm: $lm, fecha_conciliacion: $fecha_conciliacion, comentario_op: $comentario_op, est_contrato: $est_contrato, responsable_contrato: $responsable_contrato, odm: $odm)';
  }

  @override
  bool operator ==(covariant LibretoSingle other) {
    if (identical(this, other)) return true;
  
    return 
      other.lcl == lcl &&
      other.lm == lm &&
      other.fecha_conciliacion == fecha_conciliacion &&
      other.comentario_op == comentario_op &&
      other.est_contrato == est_contrato &&
      other.responsable_contrato == responsable_contrato &&
      other.odm == odm;
  }

  @override
  int get hashCode {
    return lcl.hashCode ^
      lm.hashCode ^
      fecha_conciliacion.hashCode ^
      comentario_op.hashCode ^
      est_contrato.hashCode ^
      responsable_contrato.hashCode ^
      odm.hashCode;
  }
}
