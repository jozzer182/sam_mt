import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:http/http.dart';
import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/homologacion_model.dart';

class HomologacionCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  HomologacionCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Homologacion homologacion = Homologacion();
    try {
      var dataSend = {
        'dataReq': {'hoja': 'homologacion'},
        'fname': "getMainData",
      };
      final response = await post(
        Api.sam,
        body: jsonEncode(dataSend),
      );
      var dataAsListMap = jsonDecode(response.body);
      for (var item in dataAsListMap) {
        homologacion.homologacionList.add(HomologacionSingle.fromMap(item));
      }

      homologacion.homologacionListSearch = [...homologacion.homologacionList];
      emit(state().copyWith(homologacion: homologacion));
    } catch (e) {
      bl.errorCarga("Homologacion", e);
    }
  }
}
