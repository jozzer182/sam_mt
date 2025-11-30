import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/fechasfem_asyear_model.dart';
import '../model/fechasfem_model.dart';
import '../model/fehcasfem_datebool_model.dart';

class FechasFemCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  FechasFemCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }
  get obtener async {
    MainState Function() state = bl.state;
    FechasFEM fechasFEM = FechasFEM();
    try {
      Map<String, Object> dataSend = {
        'dataReq': {'libro': 'FECHAS_FEM_', 'hoja': 'reg'},
        'fname': "getHojaList",
      };
      final Response response = await post(
        Api.fem,
        body: jsonEncode(dataSend),
      );
      // print(response.body);
      List dataAsListMap;

      dataAsListMap = jsonDecode(response.body);

      for (var item in dataAsListMap.sublist(1)) {
        fechasFEM.fechasFEMList.add(FechasFEMSingle.fromList(item));
        fechasFEM.fechasFemDateBoolList.add(FechasFEMDateBool.fromList(item));
      }
      for (FechasFEMDateBool fecha in fechasFEM.fechasFemDateBoolList) {
        if (fechasFEM.fechasFEMAsYearList.indexWhere(
              (e) => e.ano == fecha.ano,
            ) ==
            -1) {
          fechasFEM.fechasFEMAsYearList.add(
            FechasFEMAsYear.fromInit(fecha.ano),
          );
        }
        FechasFEMAsYear fechasFEMAsYear = fechasFEM.fechasFEMAsYearList
            .firstWhere((e) => e.ano == fecha.ano);
        fechasFEMAsYear.add(fecha);
      }
      // print('fechasFEMAsYearList ${fechasFEMAsYearList}');
      fechasFEM.fechasFEMListSearch = [...fechasFEM.fechasFEMList];

      emit(state().copyWith(fechasFEM: fechasFEM));
    } catch (e) {
      bl.errorCarga("FechasFEM", e);
    }
  }
}
