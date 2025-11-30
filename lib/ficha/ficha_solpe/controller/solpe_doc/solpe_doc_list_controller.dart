import 'package:flutter/material.dart';

import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../model/solpe_doc.dart';
import '../../model/solpe_reg.dart';
import 'solpe_doc_campo_controller.dart';

class SolPeDocListController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late SolPeDoc solPeDoc;

  SolPeDocListController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    solPeDoc = state().solPeDoc!;
  }

  void get agregar {
    int index = solPeDoc.list.length;
    bool esNuevo = solPeDoc.esNuevo;
    if (esNuevo) {
      solPeDoc.list.add(
        SolPeReg.fromIndex(index)
          ..proyecto = state().ficha!.fficha.ficha.first.proyecto
          ..unidad = state().ficha!.fficha.ficha.first.unidad
          ..iden = state().ficha!.fficha.ficha.first.iden
          ..eccomentario = state().solPeDoc!.comentario
          ..pdi = state().user!.pdi
          ..e4eColor = Colors.red
          ..e4eError = 'Falta código'
          ..ctdsColor = Colors.red
          ..ctdsError = 'Debe ser mayor a 0'
          ..pedidonumber = "Pendiente.."
          ..estado = 'Borrador'
          ..ecpersona = state().user!.correo,
      );
    } else {
      solPeDoc.list.add(
        SolPeReg.fromIndex(index)
          ..proyecto = state().ficha!.fficha.ficha.first.proyecto
          ..unidad = state().ficha!.fficha.ficha.first.unidad
          ..iden = state().ficha!.fficha.ficha.first.iden
          ..pdi = state().user!.pdi
          ..e4eColor = Colors.red
          ..e4eError = 'Falta código'
          ..ctdsColor = Colors.red
          ..ctdsError = 'Debe ser mayor a 0'
          ..pedidonumber = solPeDoc.list.first.pedidonumber
          ..eccomentario = solPeDoc.list.first.eccomentario
          ..circuito = solPeDoc.list.first.circuito
          ..pedido = solPeDoc.list.first.pedido
          ..estado = solPeDoc.list.first.estado
          ..ecpersona = state().user!.correo,
      );
    }
    emit(state().copyWith(solPeDoc: solPeDoc));
  }

  void get eliminar {
    if (solPeDoc.list.length > 1) {
      solPeDoc.list.removeLast();
      campo.reglas;
      emit(state().copyWith(solPeDoc: solPeDoc));
    }
  }

  String get validar {
    String errores = '';
    for (SolPeReg reg in solPeDoc.list) {
      if (reg.errors.isNotEmpty) {
        errores += '${reg.pos} ${reg.errors}\n';
      }
    }
    return errores;
  }

  SolPeDocCampoController get campo => SolPeDocCampoController(bl);
}
