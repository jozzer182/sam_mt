import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:http/http.dart';
import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/rastreable_model.dart';

class RastreableCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  RastreableCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Rastreable rastreable = Rastreable();
    try {
      var dataSend = {
        'dataReq': {'hoja': 'rastreable'},
        'fname': "getMainData"
      };
      final response = await post(
        Api.sam,
        body: jsonEncode(dataSend),
      );
      var dataAsListMap = jsonDecode(response.body);
      for (var item in dataAsListMap) {
        rastreable.rastreableList.add(RastreableSingle.fromMap(item));
      }
      
      rastreable.rastreableListSearch = [...rastreable.rastreableList];
      emit(state().copyWith(rastreable: rastreable));
    } catch (e) {
      bl.errorCarga("Rastreable", e);
    }
  }
}
