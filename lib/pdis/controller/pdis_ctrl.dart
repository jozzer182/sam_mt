import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/pdis_d.dart';

class PdisCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  PdisCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    PdisB pdisB = PdisB();
    try {
      Map<String, Object> dataSend = {
        'dataReq': {'hoja': 'pdi'},
        'fname': "getMainData",
      };
      // print('dataSend: $dataSend');
      final response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      // print('response: ${response.body}');
      var dataAsListMap;
      if (response.statusCode == 302) {
        var response2 = await get(
          Uri.parse(response.headers["location"] ?? ''),
        );
        dataAsListMap = jsonDecode(response2.body);
      } else {
        dataAsListMap = jsonDecode(response.body);
      }
      for (var item in dataAsListMap) {
        pdisB.pdis.add(Pdis.fromMap(item));
      }
      // print('pdis: ${pdisB.pdis.toString()}');
      pdisB.pdis.sort((a, b) => a.nombreCorto.compareTo(b.nombreCorto));
      pdisB.pdis.sort((a, b) => a.zona.compareTo(b.zona));

      emit(state().copyWith(pdisB: pdisB));
    } catch (e) {
      bl.errorCarga("Pdis", e);
    }
  }
}
