import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/ingresos_b.dart';

class IngresosCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  IngresosCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    IngresosB ingresosB = IngresosB();
    try {
      var dataSend = {
        'dataReq': {'pdi': state().user?.pdi ?? "TEST", 'hoja': 'INGRESOS'},
        'fname': "getHoja",
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
        ingresosB.ingresosBList.add(IngresosBSingle.fromMap(item));
      }
      ingresosB.ingresosBList = ingresosB.ingresosBList.reversed.toList();
      ingresosB.ingresosBListSearch = [...ingresosB.ingresosBList];
      emit(state().copyWith(ingresosB: ingresosB));
    } catch (e) {
      bl.errorCarga('Ingresos', e);
    }
  }

  anularDato({
    required String pedido,
    required String item,
    required String hoja,
  }) async {
    bl.startLoading;
    
    String? respuesta;
    try {
      final user = state().user!;
      DateTime dateReport = DateTime.now();
      List rows = [
        {
          'pedido': pedido,
          'item': item,
          'almacenista_r': user.nombre,
          'tel_r': user.telefono,
          'reportado':
              '${dateReport.year}/${dateReport.month.toString().padLeft(2, '0')}/${dateReport.day.toString().padLeft(2, '0')}',
          'estado': 'anulado',
        },
      ];

      var dataSend = {
        'dataReq': {'pdi': user.pdi, 'rows': rows, 'hoja': hoja},
        'fname': "updateInfo",
      };
      // print(jsonEncode(dataSend));
      var response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      respuesta = response.body;
    } catch (e) {
      bl.errorCarga('Ingresos', e);
    }
    add(LoadData());
    await Future.delayed(Duration(seconds: 2));
    bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
  }
}
