import 'dart:convert';

import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/plataforma.dart';

class PlataformaController {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  PlataformaController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Plataforma plataforma = Plataforma();
    try {
      var dataAsListMap;
      final supabase = SupabaseClient(Api.femSamSupUrlNew, Api.femSamSupKeyNew);

      // Primero intentar obtener datos de Supabase
      try {
        // final supabase = Supabase.instance.client;
        final response =
            await supabase
                .from('plataforma') // Tabla para plataforma
                .select();

        if (response.isNotEmpty) {
          dataAsListMap = response;
          // print('tipo de datos Plataforma: ${dataAsListMap.runtimeType}');
        } else {
          bl.mensaje(
            message: 'No se encontraron datos en Supabase para PLATAFORMA',
          );
          // Si no hay datos en Supabase, intentar con Google Script
          dataAsListMap = await _obtenerDesdeGoogleScript();
        }
      } catch (e) {
        bl.errorCarga('Plataforma', e);
        // Si hay error en Supabase, intentar con Google Script
        dataAsListMap = await _obtenerDesdeGoogleScript();
      }

      if (dataAsListMap == null ||
          dataAsListMap is! List ||
          dataAsListMap.isEmpty) {
        bl.mensaje(
          message: 'No se encontraron datos en ninguna fuente para PLATAFORMA',
        );
        return;
      }

      for (var item in dataAsListMap) {
        plataforma.plataformaList.add(PlataformaSingle.fromMap(item));
      }

      // Ordenar por material como en el método original
      plataforma.plataformaList.sort(
        (a, b) => a.material.compareTo(b.material),
      );
      plataforma.plataformaListSearch = [...plataforma.plataformaList];

      emit(state().copyWith(plataforma: plataforma));
    } catch (e) {
      bl.errorCarga('Plataforma', e);
    }
  }

  // Método auxiliar para obtener datos desde Google Script
  Future<dynamic> _obtenerDesdeGoogleScript() async {
    var dataSend = {
      'dataReq': {'pdi': 'GENERAL', 'tx': 'PLATAFORMA_MB52'},
      'fname': "getSAP",
    };

    final response = await post(
      Api.sam,
      body: jsonEncode(dataSend),
    );

    var dataAsListMap;
    dataAsListMap = jsonDecode(response.body)['dataObject'];

    return dataAsListMap;
  }
}
