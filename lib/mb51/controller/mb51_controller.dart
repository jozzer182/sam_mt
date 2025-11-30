import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/mb51_model.dart';

class Mb51Controller {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  Mb51Controller(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Mb51B mb51B = Mb51B();
    try {
      String pdi = state().user?.pdi ?? '';
      var dataAsListMap;

      final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

      // Primero intentar obtener datos de Supabase
      try {
        // final supabase = Supabase.instance.client;
        final response = await supabase.from('${pdi}_mb51').select();

        if (response.isNotEmpty) {
          dataAsListMap = response;
          print('tipo de datos: ${dataAsListMap.runtimeType}');
        } else {
          bl.mensaje(message: 'No se encontraron datos en Supabase para MB51');
          dataAsListMap = await _obtenerDesdeGoogleScript(pdi);
        }
      } catch (e) {
        bl.mensaje(
          message:
              'Error llamando a Supabase para MB51: $e, intentando con Google Script...',
        );
        // Si hay error en Supabase, intentar con Google Script
        dataAsListMap = await _obtenerDesdeGoogleScript(pdi);
      }

      if (dataAsListMap is! List || dataAsListMap.isEmpty) {
        bl.mensaje(
          message:
              '🤕 No se encontraron datos en ninguna fuente para MB51 ⚠️, intente recargar la página🔄',
        );
        return;
      }

      for (var item in dataAsListMap) {
        mb51B.mb51BList.add(Mb51BSingle.fromMap(item));
      }
      mb51B.mb51BList.sort((a, b) {
        return DateTime.parse(a.fecha).microsecondsSinceEpoch.compareTo(
          DateTime.parse(b.fecha).microsecondsSinceEpoch +
              int.parse(a.material).compareTo(int.parse(b.material)),
        );
      });
      mb51B.mb51BList = mb51B.mb51BList.reversed.toList();
      mb51B.mb51BListSearch = [...mb51B.mb51BList];
      emit(state().copyWith(mb51B: mb51B));
    } catch (e) {
      bl.errorCarga("MB51", e);
    }
  }

  // Método auxiliar para obtener datos desde Google Script
  Future<dynamic> _obtenerDesdeGoogleScript(String pdi) async {
    var dataSend = {
      'dataReq': {'pdi': pdi, 'tx': 'MB51'},
      'fname': "getSAP",
    };

    final response = await post(
      Api.sam,
      body: jsonEncode(dataSend),
    );

    return jsonDecode(response.body)['dataObject'];
  }
}
