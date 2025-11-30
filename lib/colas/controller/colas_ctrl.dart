import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:http/http.dart';
import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/colas_model.dart';

class ColasCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ColasCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Colas colas = Colas();
    try {
      var dataSend = {
        'dataReq': {'hoja': 'colas'},
        'fname': "getMainData",
      };
      final response = await post(
        Api.sam,
        body: jsonEncode(dataSend),
      );
      var dataAsListMap;
      dataAsListMap = jsonDecode(response.body);
      for (var item in dataAsListMap) {
        colas.colasList.add(ColasSingle.fromMap(item));
      }

      colas.colasListSearch = [...colas.colasList];
      emit(state().copyWith(colas: colas));
    } catch (e) {
      bl.errorCarga("Colas", e); 
    }
  }
}
