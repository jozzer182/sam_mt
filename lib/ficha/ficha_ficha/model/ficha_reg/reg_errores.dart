import 'package:flutter/material.dart';

import 'reg.dart';

class FichaRegErrores {
  final FichaReg fichaReg;
  FichaRegErrores(this.fichaReg);
  String circuito = '';
  String wbe = '';
  String e4e = '';
  String pdi = '';
  String comentario = '';
  Color? circuitoColor;
  Color? wbeColor;
  Color? wbeColorFill;
  Color? e4eColor;
  Color? pdiColor;
  Color? comentarioColor;
  String m01 = '';
  String m02 = '';
  String m03 = '';
  String m04 = '';
  String m05 = '';
  String m06 = '';
  String m07 = '';
  String m08 = '';
  String m09 = '';
  String m10 = '';
  String m11 = '';
  String m12 = '';
  Color? m01Color;
  Color? m02Color;
  Color? m03Color;
  Color? m04Color;
  Color? m05Color;
  Color? m06Color;
  Color? m07Color;
  Color? m08Color;
  Color? m09Color;
  Color? m10Color;
  Color? m11Color;
  Color? m12Color;

  bool get hayErrores {
    bool errorCricuito = circuito.isNotEmpty;
    bool errorWbe = wbe.isNotEmpty;
    bool errorE4e = e4e.isNotEmpty;
    bool errorPdi = pdi.isNotEmpty;
    bool errorComentario = comentario.isNotEmpty;
    bool errorM01 = m01.isNotEmpty;
    bool errorM02 = m02.isNotEmpty;
    bool errorM03 = m03.isNotEmpty;
    bool errorM04 = m04.isNotEmpty;
    bool errorM05 = m05.isNotEmpty;
    bool errorM06 = m06.isNotEmpty;
    bool errorM07 = m07.isNotEmpty;
    bool errorM08 = m08.isNotEmpty;
    bool errorM09 = m09.isNotEmpty;
    bool errorM10 = m10.isNotEmpty;
    bool errorM11 = m11.isNotEmpty;
    bool errorM12 = m12.isNotEmpty;

    return errorCricuito ||
        errorWbe ||
        errorE4e ||
        errorPdi ||
        errorComentario ||
        errorM01 ||
        errorM02 ||
        errorM03 ||
        errorM04 ||
        errorM05 ||
        errorM06 ||
        errorM07 ||
        errorM08 ||
        errorM09 ||
        errorM10 ||
        errorM11 ||
        errorM12;
  }

  String get errores {
    String errores = '';
    if (circuito.isNotEmpty) errores += 'item: ${fichaReg.item}, Circuito: $circuito\n';
    if (wbe.isNotEmpty) errores += 'item: ${fichaReg.item}, WBE: $wbe\n';
    if (e4e.isNotEmpty) errores += 'item: ${fichaReg.item}, E4E: $e4e\n';
    if (pdi.isNotEmpty) errores += 'item: ${fichaReg.item}, PDI: $pdi\n';
    if (comentario.isNotEmpty)
      errores += 'item: ${fichaReg.item}, Comentario: $comentario\n';
    if (m01.isNotEmpty) errores += 'item: ${fichaReg.item}, M01: $m01\n';
    if (m02.isNotEmpty) errores += 'item: ${fichaReg.item}, M02: $m02\n';
    if (m03.isNotEmpty) errores += 'item: ${fichaReg.item}, M03: $m03\n';
    if (m04.isNotEmpty) errores += 'item: ${fichaReg.item}, M04: $m04\n';
    if (m05.isNotEmpty) errores += 'item: ${fichaReg.item}, M05: $m05\n';
    if (m06.isNotEmpty) errores += 'item: ${fichaReg.item}, M06: $m06\n';
    if (m07.isNotEmpty) errores += 'item: ${fichaReg.item}, M07: $m07\n';
    if (m08.isNotEmpty) errores += 'item: ${fichaReg.item}, M08: $m08\n';
    if (m09.isNotEmpty) errores += 'item: ${fichaReg.item}, M09: $m09\n';
    if (m10.isNotEmpty) errores += 'item: ${fichaReg.item}, M10: $m10\n';
    if (m11.isNotEmpty) errores += 'item: ${fichaReg.item}, M11: $m11\n';
    if (m12.isNotEmpty) errores += 'item: ${fichaReg.item}, M12: $m12\n';
    return errores;
  }

  void setError({
    required String mes,
    required String error,
  }) {
    if (mes == '01') m01 = error;
    if (mes == '02') m02 = error;
    if (mes == '03') m03 = error;
    if (mes == '04') m04 = error;
    if (mes == '05') m05 = error;
    if (mes == '06') m06 = error;
    if (mes == '07') m07 = error;
    if (mes == '08') m08 = error;
    if (mes == '09') m09 = error;
    if (mes == '10') m10 = error;
    if (mes == '11') m11 = error;
    if (mes == '12') m12 = error;
  }

  void setColor({
    required String mes,
    required Color? color,
  }) {
    if (mes == '01') m01Color = color;
    if (mes == '02') m02Color = color;
    if (mes == '03') m03Color = color;
    if (mes == '04') m04Color = color;
    if (mes == '05') m05Color = color;
    if (mes == '06') m06Color = color;
    if (mes == '07') m07Color = color;
    if (mes == '08') m08Color = color;
    if (mes == '09') m09Color = color;
    if (mes == '10') m10Color = color;
    if (mes == '11') m11Color = color;
    if (mes == '12') m12Color = color;
  }

  String getError(String mes) {
    if (mes == '01') return m01;
    if (mes == '02') return m02;
    if (mes == '03') return m03;
    if (mes == '04') return m04;
    if (mes == '05') return m05;
    if (mes == '06') return m06;
    if (mes == '07') return m07;
    if (mes == '08') return m08;
    if (mes == '09') return m09;
    if (mes == '10') return m10;
    if (mes == '11') return m11;
    if (mes == '12') return m12;
    return '';
  }

  Color? getColor(String mes) {
    if (mes == '01') return m01Color;
    if (mes == '02') return m02Color;
    if (mes == '03') return m03Color;
    if (mes == '04') return m04Color;
    if (mes == '05') return m05Color;
    if (mes == '06') return m06Color;
    if (mes == '07') return m07Color;
    if (mes == '08') return m08Color;
    if (mes == '09') return m09Color;
    if (mes == '10') return m10Color;
    if (mes == '11') return m11Color;
    if (mes == '12') return m12Color;
    return null;
  }
}
