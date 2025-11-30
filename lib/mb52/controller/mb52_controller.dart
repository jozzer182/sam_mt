import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../mb52_b.dart';

class Mb52Controller {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  Mb52Controller(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Mb52B mb52B = Mb52B();
    try {
      String pdi = state().user?.pdi ?? '';
      var dataAsListMap;

      final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);
      // Primero intentar obtener datos de Supabase
      try {
        // final supabase = Supabase.instance.client;
        final response = await supabase
            .from('${pdi}_mb52')
            .select();

        if (response != null && response is List && response.isNotEmpty) {
          dataAsListMap = response;
          print('tipo de datos: ${dataAsListMap.runtimeType}');
        } else {
          emit(state().copyWith(
            errorCounter: state().errorCounter + 1,
            message:
                'No se encontraron datos en Supabase para MB52, intentando con Google Script...',
          ));
          // Si no hay datos en Supabase, intentar con Google Script
          dataAsListMap = await _obtenerDesdeGoogleScript(pdi);
        }
      } catch (e) {
        emit(state().copyWith(
          errorCounter: state().errorCounter + 1,
          message:
              'Error llamando a Supabase para MB52: $e, intentando con Google Script...',
        ));
        // Si hay error en Supabase, intentar con Google Script
        dataAsListMap = await _obtenerDesdeGoogleScript(pdi);
      }
      
      if (dataAsListMap is! List || dataAsListMap.isEmpty) {
        emit(state().copyWith(
          errorCounter: state().errorCounter + 1,
          message:
              '🤕 No se encontraron datos en ninguna fuente para MB52 ⚠️, intente recargar la página🔄',
        ));
        return;
      }
      
      for (var item in dataAsListMap) {
        if (item['material'] != "") {
          mb52B.mb52BList.add(Mb52BSingle.fromMap(item));
        }
      }
      mb52B.mb52BListSearch = [...mb52B.mb52BList];
      mb52B.total();
      emit(state().copyWith(mb52B: mb52B));
    } catch (e) {
      emit(state().copyWith(
        errorCounter: state().errorCounter + 1,
        message:
            '🤕Error llamando📞 la tabla de datos MB52 ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
      ));
    }
  }

  // Método auxiliar para obtener datos desde Google Script
  Future<dynamic> _obtenerDesdeGoogleScript(String pdi) async {
    var dataSend = {
      'dataReq': {'pdi': pdi, 'tx': 'MB52'},
      'fname': "getSAP"
    };

    final response = await post(
      Api.sam,
      body: jsonEncode(dataSend),
    );
    
    return jsonDecode(response.body)['dataObject'];
  }
}