import 'package:flutter/material.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../lcl/model/lcl_model.dart';

class PlanillaCtrlCambiarEncabezado {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  PlanillaCtrlCambiarEncabezado(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }
  cambiarEncabezado({required String valor, required String campo}) {
    var ref = state().planillaB!.encabezadoPlanillaB;
    if (campo == 'lcl') {
      ref.lcl = valor;
      bool isLcl = ref.lcl.startsWith('6300');
      if (isLcl) {
        List<LclSingle> lclList = state().lcl!.lclList;
        LclSingle lclSingle = lclList.firstWhere(
          (e) => e.lcl == valor,
          orElse: () => LclSingle.fromInit(),
        );
        bool inLclList = lclSingle.lcl.isNotEmpty;
        bool correctLength = lclSingle.lcl.length == 10;
        bool isValid = inLclList && correctLength;
        if (isValid) {
          ref.lclError = Colors.green;
          ref.ingeniero_enel = lclSingle.usuario.toUpperCase();
          ref.ingeniero_enelError = Colors.green;
        } else {
          ref.lclError = Colors.red;
        }
      } else {
        bool isValid = ref.lcl.isNotEmpty && ref.lcl.length >= 3;
        if (isValid) {
          ref.lclError = Colors.green;
        } else {
          ref.lclError = Colors.red;
        }
      }
    }
    if (campo == 'odm') {
      ref.odm = valor;
      ref.odmError = ref.odm.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'solicitante') {
      ref.solicitante = valor;
      ref.solicitanteError =
          ref.solicitante.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'proceso') {
      ref.proceso = valor;
      ref.procesoError = ref.proceso.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'pdi') {
      ref.pdi = valor;
      ref.pdiError = ref.pdi.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'placa_cuadrilla_e') {
      ref.placa_cuadrilla_e = valor;
      ref.placa_cuadrilla_eError =
          ref.placa_cuadrilla_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'lider_contrato_e') {
      ref.lider_contrato_e = valor;
      ref.lider_contrato_eError =
          ref.lider_contrato_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'cc_lider_contrato_e') {
      ref.cc_lider_contrato_e = valor;
      ref.cc_lider_contrato_eError =
          ref.cc_lider_contrato_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'tel_lider_e') {
      ref.tel_lider_e = valor;
      ref.tel_lider_eError =
          ref.tel_lider_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'circuito') {
      ref.circuito = valor;
      ref.circuitoError = ref.circuito.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'localidad_municipio') {
      ref.localidad_municipio = valor;
      ref.localidad_municipioError =
          ref.localidad_municipio.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'nodo') {
      ref.nodo = valor;
      ref.nodoError = ref.nodo.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'ingeniero_enel') {
      ref.ingeniero_enel = valor;
      bool isEmailValid = ref.ingeniero_enel.toLowerCase().endsWith(
        '@enel.com',
      );
      bool isValid = ref.ingeniero_enel.isNotEmpty && isEmailValid;
      if (isValid) {
        ref.ingeniero_enelError = Colors.green;
      } else {
        ref.ingeniero_enelError = Colors.red;
      }
    }
    if (campo == 'pdl') {
      ref.pdl = valor;
      ref.pdlError = ref.pdl.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'fecha_e') {
      ref.fecha_e = valor;
      ref.fecha_eError = ref.fecha_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'fecha_r') {
      ref.fecha_r = valor;
      ref.fecha_rError = ref.fecha_r.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'soporte_d_e') {
      ref.soporte_d_e = valor;
      ref.soporte_d_eError =
          ref.soporte_d_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'comentario_e') {
      ref.comentario_e = valor;
      // ref.comentario_eError = ref.comentario_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'almacenista_e') {
      ref.almacenista_e = valor;
      ref.almacenista_eError =
          ref.almacenista_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'tel_alm_e') {
      ref.tel_alm_e = valor;
      ref.tel_alm_eError = ref.tel_alm_e.isEmpty ? Colors.red : Colors.green;
    }
    if (campo == 'lm') {
      ref.lm = valor;
      // ref.lmError = ref.lm.isEmpty ? Colors.red : Colors.green;
    }
    emit(state().copyWith());
  }

  cambiarEncabezadoEdit({required String valor, required String campo}) {
    var ref = state().planillaEditB!.encabezadoPlanillaBParaEnvio;
    if (campo == 'lcl') ref.lcl = valor;
    if (campo == 'odm') ref.odm = valor;
    if (campo == 'solicitante') ref.solicitante = valor;
    if (campo == 'proceso') ref.proceso = valor;
    if (campo == 'pdi') ref.pdi = valor;
    if (campo == 'placa_cuadrilla_e') ref.placa_cuadrilla_e = valor;
    if (campo == 'lider_contrato_e') ref.lider_contrato_e = valor;
    if (campo == 'cc_lider_contrato_e') ref.cc_lider_contrato_e = valor;
    if (campo == 'tel_lider_e') ref.tel_lider_e = valor;
    if (campo == 'circuito') ref.circuito = valor;
    if (campo == 'localidad_municipio') ref.localidad_municipio = valor;
    if (campo == 'nodo') ref.nodo = valor;
    if (campo == 'ingeniero_enel') ref.ingeniero_enel = valor;
    if (campo == 'pdl') ref.pdl = valor;
    if (campo == 'fecha_e') ref.fecha_e = valor;
    if (campo == 'fecha_r') ref.fecha_r = valor;
    if (campo == 'soporte_d_e') ref.soporte_d_e = valor;
    if (campo == 'soporte_d_r') ref.soporte_d_r = valor;
    if (campo == 'comentario_e') ref.comentario_e = valor;
    if (campo == 'almacenista_e') ref.almacenista_e = valor;
    if (campo == 'tel_alm_e') ref.tel_alm_e = valor;
    emit(state().copyWith());
  }
}
