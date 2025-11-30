import 'dart:convert';

import 'package:http/http.dart';
import 'package:v_al_sam_v02/models/mm60_b.dart';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/mm60_model.dart';

class Mm60Controller {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  Mm60Controller(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }
  get obtener async {
    Mm60 mm60 = Mm60();
    try {
      // String pdi = state().user?.pdi ?? '';
      var dataAsListMap;

      // Primero intentar obtener datos de Supabase
      // try {
      //   final supabase = Supabase.instance.client;
      //   final response = await supabase.from('mm60').select();

      //   if (response != null && response is List && response.isNotEmpty) {
      //     dataAsListMap = response;
      //     print('tipo de datos MM60: ${dataAsListMap.runtimeType}');
      //   } else {
      //     emit(
      //       state().copyWith(
      //         errorCounter: state().errorCounter + 1,
      //         message:
      //             'No se encontraron datos en Supabase para MM60, intentando con Google Script...',
      //       ),
      //     );
      //     // Si no hay datos en Supabase, intentar con Google Script
      //     dataAsListMap = await _obtenerDesdeGoogleScript();
      //   }
      // } catch (e) {
      //   emit(
      //     state().copyWith(
      //       errorCounter: state().errorCounter + 1,
      //       message:
      //           'Error llamando a Supabase para MM60: $e, intentando con Google Script...',
      //     ),
      //   );
      //   // // Si hay error en Supabase, intentar con Google Script
        dataAsListMap = await _obtenerDesdeGoogleScript();
      // }

      if (dataAsListMap == null ||
          dataAsListMap is! List ||
          dataAsListMap.isEmpty) {
        emit(
          state().copyWith(
            errorCounter: state().errorCounter + 1,
            message:
                '🤕 No se encontraron datos en ninguna fuente para MM60 ⚠️, intente recargar la página🔄',
          ),
        );
        return;
      }

      // Si los datos vienen de Supabase, no necesitamos hacer sublist
      if (dataAsListMap[0] is Map) {
        for (var item in dataAsListMap) {
          mm60.mm60List.add(Mm60Single.fromMap(item));
        }
      } else {
        // Si los datos vienen de Google Script, necesitamos hacer sublist para omitir la primera fila (encabezados)
        for (var item in dataAsListMap.sublist(1)) {
          mm60.mm60List.add(Mm60Single.fromList(item));
        }
      }

      mm60.mm60ListSearch = [...mm60.mm60List];
      Mm60B mm60B = Mm60B();
      mm60B.mm60List = mm60.mm60List.map((e) => Mm60SingleB.fromMap(e.toMap()) ).toList();
      emit(state().copyWith(mm60: mm60));
      emit(state().copyWith(mm60B: mm60B));
    } catch (e) {
      emit(
        state().copyWith(
          errorCounter: state().errorCounter + 1,
          message:
              '🤕Error llamando📞 la tabla de datos mm60 ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
        ),
      );
    }
  }
}

// Método auxiliar para obtener datos desde Google Script
Future<dynamic> _obtenerDesdeGoogleScript() async {
  var dataSend = {
    'dataReq': {'hoja': 'MM60'},
    'fname': "getSAPList",
  };

  final response = await post(
    Api.fem,
    body: jsonEncode(dataSend),
  );

  var dataAsListMap;
  if (response.statusCode == 302) {
    var response2 = await get(
      Uri.parse(response.headers["location"].toString()),
    );
    dataAsListMap = jsonDecode(response2.body);
  } else {
    dataAsListMap = jsonDecode(response.body);
  }

  return dataAsListMap;
}
