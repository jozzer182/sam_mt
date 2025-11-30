import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

// import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../planilla/model/planilla_model_edit_b.dart';
import '../model/resgistros_b.dart';

class RegistrosCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  RegistrosCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    RegistrosB registrosB = RegistrosB();
    try {
      registrosB.registrosList = [];
      registrosB.registrosListSearch = [];
      var dataSend = {
        'dataReq': {'pdi': state().user?.pdi ?? 'TEST', 'hoja': 'registros'},
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
        registrosB.registrosList.add(ResgistroSingle.fromMap(item));
      }
      // registrosList.sort((a, b) => b.pedido.compareTo(a.pedido));
      registrosB.registrosList = registrosB.registrosList.reversed.toList();
      registrosB.registrosListSearch = [...registrosB.registrosList];
      registrosB.registrosListSearch2 = [...registrosB.registrosList];

      emit(state().copyWith(registrosB: registrosB));
    } catch (e) {
      bl.errorCarga('Registros', e);
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
      // respuesta = await state().registrosB?.anular(
      //   pedido: pedido,
      //   item: item,
      //   user: state().user!,
      // );
      final user = state().user!;
      DateTime date = DateTime.now();
      List rows = [
        {
          'pedido': pedido,
          'item': item,
          'almacenista_r': '${user.nombre} anuló este registro',
          'tel_r': user.telefono,
          'reportado':
              '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
          'est_oficial': 'anulado',
          'est_oficial_pers': user.nombre,
          'est_oficial_fecha':
              '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
        },
      ];

      Map<String, Object> dataSend = {
        'dataReq': {'pdi': user.pdi, 'rows': rows, 'hoja': 'registros'},
        'fname': "updateInfo",
      };
      // print(jsonEncode(dataSend));
      var response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      // print(response);
      respuesta = response.body;
    } catch (e) {
      bl.errorCarga('Registros', e);
    }
    add(LoadData());
    await Future.delayed(Duration(seconds: 2));
    bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
  }

  seleccionarPedido({
    required String pedido,
  }) {
    PlanillaEditB planillaEditB = PlanillaEditB();
    state().registrosB?.pedidoSelected = pedido;
    planillaEditB.crear(state().registrosB!);
    emit(state().copyWith(planillaEditB: planillaEditB));
  }
}
