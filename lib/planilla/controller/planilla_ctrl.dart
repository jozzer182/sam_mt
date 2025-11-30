import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../user/user_model.dart';
import '../model/planilla_model.dart';
import '../model/planilla_model_edit_b.dart';
import 'planilla_ctrl_cambiar_encabezado.dart';
import 'planilla_ctrl_cambiar_lista.dart';

class PlanillaCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  PlanillaCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  PlanillaCtrlCambiarLista get lista => PlanillaCtrlCambiarLista(bl);
  PlanillaCtrlCambiarEncabezado get encabezado =>
      PlanillaCtrlCambiarEncabezado(bl);

  get crear async {
    try {
      PlanillaB planillaB = PlanillaB();
      // planillaB.crear(state().user!);
      planillaB.planillaBList = List.generate(
        3,
        (index) => PlanillaBSingle.fromInit(index + 1),
      );
      planillaB.encabezadoPlanillaB = EncabezadoPlanillaB.fromInit(
        state().user!,
      );

      emit(state().copyWith(planillaB: planillaB));
      await Future.delayed(Duration(milliseconds: 50));
    } catch (e) {
      bl.errorCarga('Planilla', e);
    }
  }

  anularPedido(BuildContext context) async {
    emit(state().copyWith(isLoading: true));
    String? respuesta;
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    try {
      respuesta = await state().planillaEditB!.anularPedido(state().user!);
      bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
      emit(state().copyWith(planillaEditB: state().planillaEditB));
      //wait 2 seconds
      await Future.delayed(Duration(seconds: 2));
      add(LoadData());
    } catch (e) {
      bl.errorCarga('Anulando una planilla', e);
    }
    emit(state().copyWith(isLoading: false));
  }

  bool validarPlanilla() {
    PlanillaB planillaB = state().planillaB!;
    // List<dynamic>? validar = state().planillaB?.validar;
    List<dynamic>? validar;
    var faltantes = [];
    Color r = Colors.red;
    EncabezadoPlanillaB e = planillaB.encabezadoPlanillaB;
    //validate all fields
    if (e.lclError == r) faltantes.add('LCL/TICKET');
    if (e.odmError == r) faltantes.add('CONSECUTIVO');
    if (e.solicitanteError == r) faltantes.add('INGENIERO A CARGO');
    if (e.procesoError == r) faltantes.add('PROCESO');
    if (e.placa_cuadrilla_eError == r) faltantes.add('PLACA MOVIL');
    if (e.lider_contrato_eError == r) faltantes.add('CUADRILLERO');
    if (e.cc_lider_contrato_eError == r) faltantes.add('CEDULA CUADRILLERO');
    if (e.tel_lider_eError == r) faltantes.add('TEL CUADRILLERO');
    if (e.circuitoError == r) faltantes.add('CIRCUITO');
    if (e.nodoError == r) faltantes.add('NODO');
    if (e.ingeniero_enelError == r) faltantes.add('RESPONSABLE ENEL (@ENEL.COM)');
    if (e.pdlError == r) faltantes.add('PDL');
    if (e.fecha_eError == r) faltantes.add('FECHA ENTREGA');
    if (e.fecha_rError == r) faltantes.add('FECHA REINTEGRO');
    if (e.soporte_d_eError == r) faltantes.add('SOPORTE ADJUNTO');
    if (e.almacenista_eError == r) faltantes.add('ALMACENISTA QUE ENTREGA');
    if (e.tel_alm_eError == r) faltantes.add('TEL ALMACENISTA QUE ENTREGA');
    for (var reg in planillaB.planillaBList) {
      String f = 'Item: ${reg.item} =>';
      if (reg.e4eError == r) f += ' E4e,';
      if (reg.ctdEError == r) f += ' Ctd Entregada,';
      if (f != 'Item: ${reg.item} =>') faltantes.add(f);
    }
    if (faltantes.isNotEmpty) {
      faltantes.insert(
        0,
        'Por favor revise los siguientes campos en la planilla, para poder realizar el guardado:',
      );
      validar = faltantes;
    } else {
      validar = null;
    }

    if (validar != null) {
      bl.mensajeFlotante(message: validar.join('\n'));
      return false;
    } else {
      return true;
    }
  }

  Future enviar() async {
    bl.startLoading;
    PlanillaB planillaB = state().planillaB!;
    User user = state().user!;
    List vals = [];
    DateTime date = DateTime.now();
    for (var row in planillaB.planillaBList) {
      vals.add({
        ...row.toMap(),
        ...planillaB.encabezadoPlanillaB.toMap(),
        'est_contrato':
            planillaB.encabezadoPlanillaB.lm.isEmpty ? '' : 'borrador',
        'placa_cuadrilla_r': planillaB.encabezadoPlanillaB.placa_cuadrilla_e,
        'lider_contrato_r': planillaB.encabezadoPlanillaB.lider_contrato_e,
        'tel_lider_r': planillaB.encabezadoPlanillaB.tel_lider_e,
        'soporte_d_r': planillaB.encabezadoPlanillaB.soporte_d_e,
        'pdi': user.pdi,
        'est_oficial': 'reintegrado',
        'est_oficial_fecha':
            '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
        'est_oficial_pers': user.nombre,
      });
    }

    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'vals': vals, 'hoja': 'registros'},
      'fname': "addRows",
    };
    // print(jsonEncode(dataSend));
    try {
      var response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      // print(response.body);
      var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
      // print(respuesta);
      if (respuesta is List) {
        respuesta =
            'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
      } else {
        print(respuesta);
      }
      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
    } catch (e) {
      bl.errorCarga('Enviando planilla', e);
    }
    bl.stopLoading;
  }

  Future enviarEdit() async {
    bl.startLoading;
    PlanillaEditB planillaB = state().planillaEditB!;
    User user = state().user!;
    List vals = [];
    DateTime date = DateTime.now();
    for (var row in planillaB.planillaBListParaEnvio) {
      vals.add({
        ...row.toMap(),
        ...planillaB.encabezadoPlanillaBParaEnvio.toMap(),
        'pedido': planillaB.pedidoSelected,
        'placa_cuadrilla_r':
            planillaB.encabezadoPlanillaBParaEnvio.placa_cuadrilla_e,
        'lider_contrato_r':
            planillaB.encabezadoPlanillaBParaEnvio.lider_contrato_e,
        'tel_lider_r': planillaB.encabezadoPlanillaBParaEnvio.tel_lider_e,
        'pdi': user.pdi,
        'est_oficial': 'reintegrado',
        'est_oficial_fecha':
            '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
        'est_oficial_pers': user.nombre,
      });
    }

    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'rows': vals, 'hoja': 'registros'},
      'fname': "updateInfo",
    };
    try {
      // print(jsonEncode(dataSend));
      var response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      // print(response.body);
      var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
      // print(respuesta);
      if (respuesta is List) {
        respuesta =
            'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
      } else {
        print(respuesta);
      }
      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
    } catch (e) {
      bl.errorCarga('Enviando planilla', e);
    }
    bl.stopLoading;
  }

  bool validarPlanillaMateriales() {
    final planillaBEdit = state().planillaEditB!;
    List<dynamic>? validar;
    var faltantes = [];
    final e = planillaBEdit.encabezadoPlanillaBParaEnvio;
    //validate all fields
    e.lcl.isEmpty ? faltantes.add('LCL/TICKET') : null;
    e.odm.isEmpty ? faltantes.add('CONSECUTIVO') : null;
    e.solicitante.isEmpty ? faltantes.add('INGENIERO A CARGO') : null;
    e.proceso.isEmpty ? faltantes.add('PROCESO') : null;
    // e.pdi.isEmpty ? faltantes.add('pdi'):null;
    e.placa_cuadrilla_e.isEmpty ? faltantes.add('CUADRILLERO') : null;
    e.lider_contrato_e.isEmpty ? faltantes.add('PLACA MOVIL') : null;
    e.cc_lider_contrato_e.isEmpty ? faltantes.add('CEDULA CUADRILLETO') : null;
    e.tel_lider_e.isEmpty ? faltantes.add('TEL CUADRILLERO') : null;
    e.circuito.isEmpty ? faltantes.add('CIRCUITO') : null;
    // e.localidad_municipio.isEmpty ? faltantes.add('localidad_municipio'):null;
    e.nodo.isEmpty ? faltantes.add('NODO') : null;
    e.ingeniero_enel.isEmpty ? faltantes.add('RESPONSABLE ENEL') : null;
    e.pdl.isEmpty ? faltantes.add('PDL') : null;
    e.fecha_e.isEmpty ? faltantes.add('FECHA ENTREGA') : null;
    // e.fecha_r.isEmpty ? faltantes.add('fecha_r'):null;
    e.soporte_d_e.isEmpty ? faltantes.add('SOPORTE ADJUNTO') : null;
    // e.comentario_e.isEmpty ? faltantes.add('comentario_e'):null;
    e.almacenista_e.isEmpty ? faltantes.add('ALMACENISTA QUE ENTREGA') : null;
    e.tel_alm_e.isEmpty ? faltantes.add('TEL ALAMACENISTA QUE ENTREGA') : null;
    for (var reg in planillaBEdit.planillaBListParaEnvio) {
      String faltante = 'Item: ${reg.item} =>';
      reg.e4e.isEmpty ||
              reg.e4e == 'e4e' ||
              reg.esInv == 'No hay unidades en inventario' ||
              reg.errorValue
          ? faltante += ' E4e,'
          : null;
      reg.ctd_e.isEmpty || reg.ctd_e == '0' || reg.errorValue
          ? faltante += ' Ctd Entregada'
          : null;
      if (faltante != 'Item: ${reg.item} =>') faltantes.add(faltante);
    }
    if (faltantes.isNotEmpty) {
      faltantes.insert(
        0,
        'Por favor revise los siguientes campos en la planilla, para poder realizar el guardado:',
      );
      validar = faltantes;
    } else {
      validar = null;
    }

    if (validar != null) {
      bl.mensajeFlotante(message: validar.join('\n'));
      return false;
    } else {
      return true;
    }
  }

  enviarNuevo() async {
    bl.startLoading;
    User user = state().user!;
    final planillaBEdit = state().planillaEditB!;
    List vals = [];
    DateTime date = DateTime.now();
    List subList = planillaBEdit.planillaBListParaEnvio.sublist(
      planillaBEdit.planillaBList.length,
    );
    for (var row in subList) {
      vals.add({
        ...row.toMap(),
        ...planillaBEdit.encabezadoPlanillaBParaEnvio.toMap(),
        'pedido': planillaBEdit.pedidoSelected,
        'placa_cuadrilla_r':
            planillaBEdit.encabezadoPlanillaBParaEnvio.placa_cuadrilla_e,
        'lider_contrato_r':
            planillaBEdit.encabezadoPlanillaBParaEnvio.lider_contrato_e,
        'tel_lider_r': planillaBEdit.encabezadoPlanillaBParaEnvio.tel_lider_e,
        'soporte_d_r': planillaBEdit.encabezadoPlanillaBParaEnvio.soporte_d_e,
        'pdi': user.pdi,
        'est_oficial': 'reintegrado',
        'est_oficial_fecha':
            '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
        'est_oficial_pers': user.nombre,
      });
    }

    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'vals': vals, 'hoja': 'registros'},
      'fname': "addRowsWithPedido",
    };
    // print(jsonEncode(dataSend));
    try {
      var response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      // print(response.body);
      var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
      // print(respuesta);
      if (respuesta is List) {
        respuesta =
            'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
      } else {
        print(respuesta);
      }
      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
    } catch (e) {
      bl.errorCarga('Error enviando los datos de la planilla materiales', e);
    }
    bl.stopLoading;
  }

  get agregar {
    PlanillaB planillaB = state().planillaB!;
    planillaB.planillaBList.add(
      PlanillaBSingle.fromInit(planillaB.planillaBList.length + 1),
    );
  }

  get eliminar {
    PlanillaB planillaB = state().planillaB!;
    planillaB.planillaBList.removeLast();
  }

  resize(String index) {
    PlanillaB planillaB = state().planillaB!;
    index = index.isEmpty ? '1' : index;
    int size = int.parse(index);
    int len = planillaB.planillaBList.length;
    if (size > len) {
      for (int i = len; i < size; i++) {
        planillaB.planillaBList.add(PlanillaBSingle.fromInit(i + 1));
      }
    } else {
      for (int i = size; i < len; i++) {
        planillaB.planillaBList.removeLast();
      }
    }
  }

  get clear {
    PlanillaB planillaB = state().planillaB!;
    planillaB.planillaBList.clear();
    resize('3');
  }

  modifyList({
    required String index,
    required String method,
    bool isEdit = false,
  }) {
    switch (method) {
      case 'agregar':
        agregar;
        break;
      case 'eliminar':
        eliminar;
        break;
      case 'resize':
        resize(index);
        break;
      case 'clear':
        clear;
        break;
      default:
        break;
    }
    emit(state().copyWith());
  }

  get agregarEdit {
    PlanillaEditB planillaB = state().planillaEditB!;
    planillaB.planillaBListParaEnvio.add(
      PlanillaBEditSingle.fromInit(planillaB.planillaBListParaEnvio.length + 1),
    );
  }

  get eliminarEdit {
    PlanillaEditB planillaB = state().planillaEditB!;
    if (planillaB.planillaBList.length <
        planillaB.planillaBListParaEnvio.length) {
      planillaB.planillaBListParaEnvio.removeLast();
    }
  }

  get resetEdit {
    PlanillaEditB planillaB = state().planillaEditB!;
    planillaB.planillaBListParaEnvio = [...planillaB.planillaBList];
    planillaB.encabezadoPlanillaBParaEnvio = planillaB.encabezadoPlanillaB;
  }

  modifyListEdit({required String index, required String method}) {
    PlanillaEditB planillaB = state().planillaEditB!;
    switch (method) {
      case 'agregar':
        agregarEdit;
        break;
      case 'eliminar':
        eliminarEdit;
        break;
      case 'resize':
        index = index.isEmpty ? '1' : index;
        int size = int.parse(index);
        planillaB.planillaBList.clear();
        planillaB.planillaBList.length = 0;
        planillaB.planillaBList = List.generate(
          size,
          (i) => PlanillaBEditSingle.fromInit(i + 1),
        );

        break;
      case 'clear':
        resetEdit;
        break;
      default:
        break;
    }
    emit(state().copyWith());
  }

  Future<bool> get pegarExcel async {
    final clipboardData = await Clipboard.getData('text/plain');
    String? data = clipboardData?.text;
    RegExp numbersOnly = RegExp(r'^[0-9]+$');
    // print(data);
    // print(data!.isEmpty);
    // Analizar los datos copiados y asignar los valores correspondientes a cada campo
    try {
      if (data != null &&
          data.isNotEmpty &&
          numbersOnly.hasMatch(data.replaceAll(RegExp(r'\s+'), ''))) {
        final rows = data.split('\n').map((e) => e.trim()).toList();
        rows.removeWhere((e) => e.isEmpty);
        // if (rows.length > nuevoIngresoList.length) {
        modifyList(index: rows.length.toString(), method: 'resize');
        await Future.delayed(Duration(milliseconds: 100));
        // }
        for (var i = 0; i < data.length; i++) {
          if (i < rows.length) {
            final values = rows[i].split('\t').map((e) => e.trim()).toList();
            lista.cambiarCampos(index: i, e4e: values[0]);
            await Future.delayed(Duration(milliseconds: 100));
            lista.cambiarCampos(index: i, ctd_e: values[1]);
            await Future.delayed(Duration(milliseconds: 100));
            lista.cambiarCampos(index: i, ctd_r: values[2]);
            await Future.delayed(Duration(milliseconds: 100));
          }
        }
        // print(rows);
        return true;
      } else {
        bl.mensajeFlotante(
          message: 'No se han encontrado datos válidos en el portapapeles.',
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> get pegarExcelEdit async {
    final clipboardData = await Clipboard.getData('text/plain');
    String? data = clipboardData?.text;
    RegExp numbersOnly = RegExp(r'^[0-9]+$');
    // print(data);
    // print(data!.isEmpty);
    // Analizar los datos copiados y asignar los valores correspondientes a cada campo
    try {
      if (data != null &&
          data.isNotEmpty &&
          numbersOnly.hasMatch(data.replaceAll(RegExp(r'\s+'), ''))) {
        final rows = data.split('\n').map((e) => e.trim()).toList();
        rows.removeWhere((e) => e.isEmpty);
        // if (rows.length > nuevoIngresoList.length) {
        // modifyList(index: rows.length.toString(), method: 'resize');
        await Future.delayed(Duration(milliseconds: 100));
        // }
        for (var i = 0; i < data.length; i++) {
          if (i < rows.length) {
            final values = rows[i].split('\t').map((e) => e.trim()).toList();
            lista.cambiarCamposEdit(index: i, ctd_r: values[0]);
            await Future.delayed(Duration(milliseconds: 100));
            // lista.cambiarCampos(index: i, ctd_e: values[1]);
            // await Future.delayed(Duration(milliseconds: 100));
            // lista.cambiarCampos(index: i, ctd_r: values[2]);
            // await Future.delayed(Duration(milliseconds: 100));
          }
        }
        // print(rows);
        return true;
      } else {
        bl.mensajeFlotante(
          message: 'No se han encontrado datos válidos en el portapapeles.',
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
