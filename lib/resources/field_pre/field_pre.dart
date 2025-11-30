// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:flutter/material.dart';

import 'field_pre_desplegable.dart';
import 'field_pre_fecha.dart';
import 'field_pre_file.dart';
import 'field_pre_switcher.dart';
import 'field_pre_texto.dart';

class FieldPre extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  int? flex;
  String label;
  String initialValue;
  Color color;
  Color colorfondo;
  bool edit;
  Iterable<String> opciones;
  bool isNumber;
  TipoCampo tipoCampo;
  String carpeta = 'entregado';
  String pdi = 'TEST';
  bool tachado;
  List<bool> enabledList = [];
  final void Function(String value) asignarValor;

  FieldPre({
    required this.flex,
    required this.initialValue,
    required this.label,
    required this.color,
    required this.edit,
    required this.tipoCampo,
    required this.asignarValor,
    this.opciones = const [],
    this.isNumber = false,
    this.carpeta = 'entregado',
    this.pdi = 'TEST',
    this.colorfondo = Colors.transparent,
    this.tachado = false,
    this.enabledList = const [],
    key,
  });

  @override
  Widget build(BuildContext context) {
    if (tipoCampo == TipoCampo.texto) {
      return FieldTexto(
        flex: flex,
        opciones: opciones,
        // campo: campo,
        label: label,
        color: color,
        isNumber: isNumber,
        initialValue: initialValue,
        colorfondo: colorfondo,
        tachado: tachado,
        edit: edit,
        asignarValor: asignarValor,
      );
    }
    if (tipoCampo == TipoCampo.desplegable) {
      return FieldDesplegable(
        flex: flex,
        opciones: opciones,
        color: color,
        // campo: campo,
        label: label,
        initialValue: initialValue,
        colorfondo: colorfondo,
        tachado: tachado,
        edit: edit,
        enabled: enabledList,
        asignarValor: asignarValor,
      );
    }
    if (tipoCampo == TipoCampo.fecha) {
      return FieldDate(
        flex: flex,
        color: color,
        // campo: campo,
        label: label,
        initialValue: initialValue,
        edit: edit,
        tachado: tachado,
        colorfondo: colorfondo,
      );
    }
    if (tipoCampo == TipoCampo.file) {
      return FieldFile(
        flex: flex,
        color: color,
        // campo: campo,
        label: label,
        file: initialValue,
        carpeta: carpeta,
        pdi: pdi,
        edit: edit,
      );
    }

    if (tipoCampo == TipoCampo.switcher) {
      return FieldSwitch(
        flex: flex,
        edit: edit,
        // campo: campo,
        initialValue: initialValue,
        label: label,
      );
    }
    return FieldTexto(
      flex: flex,
      opciones: opciones,
      // campo: campo,
      label: label,
      color: color,
      isNumber: isNumber,
      initialValue: initialValue,
      colorfondo: colorfondo,
      tachado: tachado,
      edit: edit,
      asignarValor: asignarValor,
    );
  }

  TextField readField() {
    return TextField(
        textAlign: TextAlign.center,
        controller: controller,
        onChanged: (value) {
          controller.text = initialValue;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: colorfondo,
          contentPadding: const EdgeInsets.all(8.0),
          labelText: label,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
        ),
        style: TextStyle(
          fontSize: 12,
          decoration: tachado ? TextDecoration.lineThrough : null,
        ));
  }
}

enum TipoCampo {
  texto,
  desplegable,
  fecha,
  file,
  switcher,
}
