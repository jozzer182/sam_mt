import 'package:flutter/services.dart';

import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../../../resources/a_entero_2.dart';
import '../../model/solpe_doc.dart';
import '../../model/solpe_reg.dart';
import 'solpe_doc_campo_controller.dart';

class CtrlSolPePegarExcel {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late SolPeDoc solPeDoc;

  CtrlSolPePegarExcel(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    solPeDoc = state().solPeDoc!;
  }

  Future<bool> get seLogroPegar async {
    final clipboardData = await Clipboard.getData('text/plain');
    String? data = clipboardData?.text;
    if (data == null) return false;
    if (data.isEmpty) return false;
    bool tieneFormato = data.toLowerCase().startsWith('e4e');
    if (!tieneFormato) return false;
    final rows = data.split('\n').map((e) => e.trim()).toList();
    rows.removeWhere((e) => e.isEmpty);
    if (rows.length < 2) return false;
    int columnas = rows[0].split('\t').length;
    if (columnas != 2) return false;
    solPeDoc.list.clear();
    await Future.delayed(const Duration(milliseconds: 100));
    for (int j = 1; j < rows.length; j++) {
      String row = rows[j];
      final values = row.split('\t').map((e) => e.trim()).toList();
      solPeDoc.list.add(
        SolPeReg.fromIndex(j - 1)
          ..proyecto = state().ficha!.fficha.ficha.first.proyecto
          ..unidad = state().ficha!.fficha.ficha.first.unidad
          ..estado = 'Borrador'
          ..eccomentario = solPeDoc.comentario
          ..circuito = solPeDoc.circuito
          ..pedido = solPeDoc.pedido
          ..pdi = state().user!.pdi
          ..pedidonumber = "Pendiente.."
          ..ecpersona = state().user!.correo
          ..e4e = values[0].toString()
          ..ctds = aEntero(values[1]),
      );
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await Future.delayed(Duration(milliseconds: 100));
    campo.reglas;
    emit(state().copyWith(solPeDoc: solPeDoc));
    return true;
  }

  SolPeDocCampoController get campo => SolPeDocCampoController(bl);
}
