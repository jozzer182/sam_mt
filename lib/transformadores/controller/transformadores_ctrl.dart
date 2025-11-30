import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:http/http.dart';
import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/transformadores_model.dart';

class TransformadoresCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  TransformadoresCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Transformadores transformadores = Transformadores();
    try {
      var dataSend = {
        'dataReq': {'hoja': 'transformadores'},
        'fname': "getMainData",
      };
      final response = await post(
        Api.sam,
        body: jsonEncode(dataSend),
      );
      var dataAsListMap;
      dataAsListMap = jsonDecode(response.body);
      for (var item in dataAsListMap) {
        transformadores.transformadoresList.add(TransformadoresSingle.fromMap(item));
      }

      transformadores.transformadoresListSearch = [...transformadores.transformadoresList];
      emit(state().copyWith(transformadores: transformadores));
    } catch (e) {
      bl.errorCarga("Transformadores", e);
    }
  }
}
