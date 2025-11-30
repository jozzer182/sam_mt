import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/aportacion_model.dart';

class AportacionCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  AportacionCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    var emit = this.emit;
    MainState Function() state = this.state;
    Aportacion aportacion = Aportacion();
    try {
          Map<String, Object> dataSend = {
      'dataReq': {'libro': 'APORTACION', 'hoja': 'reg'},
      'fname': "getHojaList"
    };
    final Response response = await post(
      Api.fem,
      body: jsonEncode(dataSend),
    );
    // print(response.body);
    List dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await get(Uri.parse(
          response.headers["location"].toString().replaceAll(',', '')));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }

    for (var item in dataAsListMap.sublist(1)) {
      // print(item);
      aportacion.aportacionList.add(AportacionSingle.fromList(item));
    }
    // print(aportacionList);
    aportacion.aportacionListSearch = [...aportacion.aportacionList];
      emit(state().copyWith(aportacion: aportacion));
    } catch (e) {
      bl.errorCarga("Aportacion", e);
    }
  }
}
