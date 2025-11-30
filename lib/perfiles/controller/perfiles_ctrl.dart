import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/perfiles_model.dart';

class PerfilesCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  PerfilesCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Perfiles perfiles = Perfiles();
    try {
      perfiles.perfilesList.clear();
      Map<String, Object> dataSend = {
        "dataReq": {"hoja": "perfiles"},
        "fname": "getMainData",
      };
      // print(jsonEncode(dataSend));
      final response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      // print('response ${response.body}');
      var dataAsListMap;

      dataAsListMap = jsonDecode(response.body);

      for (var item in dataAsListMap) {
        perfiles.perfilesList.add(PerfilesSingle.fromMap(item));
      }

      emit(state().copyWith(perfiles: perfiles));
    } catch (e) {
      // print(e);
      bl.errorCarga("Perfiles", e);
    }
  }
}
