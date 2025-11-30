import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:v_al_sam_v02/pdis/model/pdis_d.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../mb52/mb52_b.dart';
import '../../user/user_model.dart' as user_pack;
import '../model/matnocnt_model.dart';

class MatnoController {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  MatnoController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  Future obtener() async {
    try {
      user_pack.User user = state().user!;
      Mb52B mb52 = state().mb52B!;
      List<Pdis> pdis = state().pdisB!.pdis;
      Matno matno = Matno();
      String pdi =
          pdis.firstWhere((element) => element.pdi == user.pdi).empresa;
      var dataAsListMap;

      final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

      // Primero intentar obtener datos de Supabase
      try {
        // final supabase = Supabase.instance.client;
        final response = await supabase.from('${user.pdi}_matnocnt').select();

        if (response.isNotEmpty) {
          dataAsListMap = response;
          // print('tipo de datos: ${dataAsListMap.runtimeType}');
        } else {
          bl.mensaje(
            message:
                'No se encontraron datos en Supabase para MATNOCNT, intentando con Google Script...',
            messageColor: Colors.teal,
          );
          // Si no hay datos en Supabase, intentar con Google Script
          dataAsListMap = await _obtenerDesdeGoogleScript(user.pdi);
        }
      } catch (e) {
        bl.mensaje(
          message: 'No se encontraron datos en Supabase para MATNOCNT',
          messageColor: Colors.teal,
        );
        // bl.errorCarga('MATNOCNT', e);
        // Si hay error en Supabase, intentar con Google Script
        // dataAsListMap = await _obtenerDesdeGoogleScript(user.pdi);
      }

      if (dataAsListMap is! List || dataAsListMap.isEmpty) {
        bl.mensaje(
          message:
              '🤕 No se encontraron datos en ninguna fuente para MATNOCNT ⚠️, intente recargar la página🔄',
          messageColor: Colors.teal,
        );
        return;
      }

      for (var item in dataAsListMap) {
        matno.matnoList.add(MatnoSingle.fromMap(item));
      }
      matno.matnoListSearch = [...matno.matnoList];

      // Actualizar MB52 para cada registro
      for (MatnoSingle reg in matno.matnoList) {
        if (reg.lote == pdi) {
          reg.mb52 =
              mb52.mb52BList
                  .firstWhere(
                    (e) => e.material == reg.e4e,
                    orElse: Mb52BSingle.fromInit,
                  )
                  .ctd;
        } else {
          reg.mb52 = "0";
        }
      }

      emit(state().copyWith(matno: matno));
    } catch (e) {
      bl.errorCarga('MATNOCNT', e);
    }
  }

  // Método auxiliar para obtener datos desde Google Script
  Future<dynamic> _obtenerDesdeGoogleScript(String pdi) async {
    var dataSend = {
      'dataReq': {'pdi': pdi, 'tx': 'matnocnt'},
      'fname': "getSAP",
    };

    final response = await post(
      Api.sam,
      body: jsonEncode(dataSend),
    );

    return jsonDecode(response.body)['dataObject'];
  }
}
