import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_doc.dart';

import '../../../bloc/main__bl.dart';
import '../../../bloc/main_bloc.dart';
import '../model/solpe_list.dart';
import '../model/solpe_reg.dart';

class FichaSolPeListController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;

  FichaSolPeListController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    try {
      SolPeList solPeList = SolPeList();
      Map<String, Object> dataSend = {
        'dataReq': {
          'libro': 'SOLICITUDES_PEDIDOS',
          'hoja': 'SOLICITUDES_PEDIDOS',
        },
        'fname': "getHoja"
      };
      // print(jsonEncode(dataSend));
      final Response response = await post(
        Api.fem,
        body: jsonEncode(dataSend),
      );
      var dataAsListMap = jsonDecode(response.body);
      if (dataAsListMap is List && dataAsListMap.isNotEmpty) {
        solPeList.list
            .addAll(dataAsListMap.map((e) => SolPeReg.fromMap(e)).toList());
      }
      emit(state().copyWith(solPeList: solPeList));
      // print("SolPeList ${solPeList.list.length}");
    } catch (e) {
      bl.errorCarga("SolPeList", e);
    }
  }

  void setDoc(List<SolPeReg> list) {
    SolPeDoc solPeDoc = SolPeDoc(list: list);
    emit(state().copyWith(solPeDoc: solPeDoc));
  }
}
