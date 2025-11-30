import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';
import 'package:v_al_sam_v02/dominios/model/dominios_model.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';

class DominiosCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  DominiosCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    DomainList dominios = DomainList();
    try {
      Map<String, Object> dataSend = {
        'dataReq': {'hoja': 'dominios'},
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

      dataAsListMap = jsonDecode(response.body);

      // print('tipo de datos Dominios: ${dataAsListMap.runtimeType}');
      // print('dataAsListMap: $dataAsListMap');
      for (var item in dataAsListMap) {
        // print('item: $item');
        // print('item: ${item['dominios']}');
        dominios.list.add(Domain.fromMap(item));
      }
      // print('dominios.list: ${dominios.list}');

      // dominios.list.sort();

      emit(state().copyWith(dominios: dominios));
    } catch (e) {
      bl.errorCarga("Dominios", e);
    }
  }
}
