import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/carretes_model.dart';

class CarretesCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  CarretesCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Carretes carretes = Carretes();
    try {
      // print('onLoadLm');
      // await carretes.obtener();
      var dataSend = {
        'dataReq': {'hoja': 'carretes'},
        'fname': "getMainData",
      };
      final response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      var dataAsListMap;
      dataAsListMap = jsonDecode(response.body);
      for (var item in dataAsListMap) {
        carretes.carretesList.add(CarretesSingle.fromMap(item));
      }

      carretes.carretesListSearch = [...carretes.carretesList];
      emit(state().copyWith(carretes: carretes));
      // print('lm: ${state().lm?.lmList}');
    } catch (e) {
      bl.errorCarga("Carretes", e);
    }
  }
}

// onLoadCarretes(event, emit, MainState Function() state) async {
//   Carretes carretes = Carretes();
//   try {
//     // print('onLoadLm');
//     await carretes.obtener();
//     emit(state().copyWith(carretes: carretes));
//     // print('lm: ${state().lm?.lmList}');
//   } catch (e) {
//     emit(
//       state().copyWith(
//         errorCounter: state().errorCounter + 1,
//         message:
//             '🤕Error llamando📞 la tabla de Carretes ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
//       ),
//     );
//   }
// }
