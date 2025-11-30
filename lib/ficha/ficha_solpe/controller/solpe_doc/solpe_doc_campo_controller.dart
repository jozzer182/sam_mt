import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:v_al_sam_v02/aportacion/model/aportacion_model.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_reg.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_reg_enum.dart';
import 'package:v_al_sam_v02/mm60/model/mm60_model.dart';
import 'package:v_al_sam_v02/resources/a_entero_2.dart';

import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../model/solpe_doc.dart';

class SolPeDocCampoController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late SolPeDoc solPeDoc;

  SolPeDocCampoController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    solPeDoc = state().solPeDoc!;
  }

  cambiar({
    required CampoSolpe tipo,
    required String value,
    required int index,
  }) {
    if (index >= 0) {
      solPeDoc.list[index].setWithEnum(tipo: tipo, value: value);
    } else {
      for (SolPeReg reg in solPeDoc.list) {
        reg.setWithEnum(tipo: tipo, value: value);
      }
      if (tipo == CampoSolpe.circuito) solPeDoc.circuito = value;
      if (tipo == CampoSolpe.pedido) solPeDoc.pedido = value;
      if (tipo == CampoSolpe.eccomentario) solPeDoc.comentario = value;
    }
    reglas;
    emit(state().copyWith(solPeDoc: solPeDoc));
  }

  void get reglas {
    //repetido
    Map<String, int> contador = {};
    for (SolPeReg reg in solPeDoc.list) {
      contador[reg.e4e] = (contador[reg.e4e] ?? 0) + 1;
    }

    for (SolPeReg reg in solPeDoc.list) {
      reg.e4eColor = Colors.green;
      reg.ctdsColor = Colors.green;
      reg.e4eError = '';
      reg.ctdsError = '';
      if (reg.e4e.isEmpty) {
        reg.e4eColor = Colors.red;
        reg.e4eError = 'Falta código';
      }
      if (reg.e4e.isNotEmpty && reg.e4e.length != 6) {
        reg.e4eColor = Colors.red;
        reg.e4eError = 'El código debe ser de 6 dígitos';
      }
      if (reg.ctds < 1) {
        reg.ctdsColor = Colors.red;
        reg.ctdsError = 'Debe ser mayor a 0';
      }
      if (reg.e4e.length == 6) {
        Mm60Single mm60Single = state().mm60!.mm60List.firstWhere(
            (e) => e.material == reg.e4e,
            orElse: Mm60Single.fromInit);
        reg.descripcion = mm60Single.descripcion;
        reg.um = mm60Single.um;
        if (reg.descripcion == 'No existe en BD') {
          reg.e4eColor = Colors.red;
          reg.e4eError = 'El código no existe en nuestra base de datos';
        }
        //Aportacion
        AportacionSingle? aportacionCod = state()
            .aportacion!
            .aportacionList
            .firstWhereOrNull((e) => e.e4e == reg.e4e);
        if (aportacionCod != null) {
          reg.e4eColor = Colors.red;
          reg.e4eError = 'El código es de aportación';
        }
        if (contador[reg.e4e]! > 1) {
          reg.e4eColor = Colors.red;
          reg.e4eError = 'Repetido';
        }
      }
      if (reg.ctds > 0 && reg.e4e.length == 6) {
        int ctdPlataforma = state()
            .plataforma!
            .plataformaList
            .where((e) => e.material == reg.e4e)
            .fold(0, (prev, e) => prev + aEntero(e.ctd));
        if (ctdPlataforma < reg.ctds) {
          reg.ctdsColor = Colors.orange;
          reg.ctdsError =
              'No hay unidades suficientes en plataforma: $ctdPlataforma um';
        }
      }
    }
  }
}
