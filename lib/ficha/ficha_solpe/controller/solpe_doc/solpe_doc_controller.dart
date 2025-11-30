import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_reg.dart';

import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../model/solpe_doc.dart';
import 'ctrl_ficha_pegar_excel.dart';
import 'email_controller.dart';
import 'solpe_doc_campo_controller.dart';
import 'solpe_doc_list_controller.dart';

class SolPeDocController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late SolPeDoc solPeDoc;

  SolPeDocController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    solPeDoc = state().solPeDoc!;
  }

  void enviar(String estado) async {
    bl.startLoading;
    bl.mensajeFlotante(
        message: 'Por favor espera a que termine de cargar la página.');
    for (SolPeReg reg in solPeDoc.list) {
      reg.estado = estado;
      reg.estadofecha = DateTime.now().toIso8601String();
      reg.ecfecha = DateTime.now().toIso8601String();
    }
    try {
      Map<String, Object> dataSend = {
        'dataReq': {
          'libro': 'SOLICITUDES_PEDIDOS',
          'hoja': 'SOLICITUDES_PEDIDOS',
          'vals': solPeDoc.list.map((e) => e.toMap()).toList(),
        },
        'fname': "updateAndNewPedido"
      };
      // print(jsonEncode(dataSend));
      final Response response = await post(
        Api.fem,
        body: jsonEncode(dataSend),
      );
      var dataAsListMap = jsonDecode(response.body);
      bl.mensajeFlotante(message: dataAsListMap.toString());
      await Future.delayed(const Duration(seconds: 2));
      await email.enviar;
      // emit(state().copyWith(solPeList: solPeList));
      // print("SolPeList ${solPeList.list.length}");
    } catch (e) {
      bl.errorCarga("SolPeList", e);
    }
    // bl.stopLoading;
    add(LoadData());
  }

  get editChanger {
    solPeDoc.editar = !solPeDoc.editar;
    emit(state().copyWith(solPeDoc: solPeDoc));
  }

  get setSecure {
    solPeDoc.listSecure.clear();
    solPeDoc.listSecure = solPeDoc.list.map((e) => e.copyWith()).toList();
    emit(state().copyWith(solPeDoc: solPeDoc));
  }

  get revertSecure {
    solPeDoc.list.clear();
    solPeDoc.list = solPeDoc.listSecure.map((e) => e.copyWith()).toList();
    emit(state().copyWith(solPeDoc: solPeDoc));
  }

  get setNuevo {
    solPeDoc.esNuevo = true;
    emit(state().copyWith(solPeDoc: solPeDoc));
  }

  SolPeDocListController get list => SolPeDocListController(bl);
  SolPeDocCampoController get campo => SolPeDocCampoController(bl);
  CtrlSolPePegarExcel get pegar => CtrlSolPePegarExcel(bl);
  EmailListController get email => EmailListController(bl);
}
