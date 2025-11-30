// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../chatarra/model/chatarra_url.dart';
import '../../registros/model/resgistros_b.dart';

class BalancesCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  BalancesCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  updateLibreto(List<Map> map) {
    bl.startLoading;
    if (state().registrosB?.registrosList == null) {
      bl.mensajeFlotante(message: 'Problema con los registros');
      bl.stopLoading;
      return;
    }
    for (int i = 0; i < map.length; i++) {
      Map mapOdm = map[i];
      for (var i = 0; i < state().registrosB!.registrosList.length; i++) {
        ResgistroSingle registro = state().registrosB!.registrosList[i];
        if (registro.odm == mapOdm['odm']) {
          registro.lm = mapOdm['lm'].toString();
          registro.fecha_conciliacion = mapOdm['fecha_conciliacion'].toString();
          registro.comentario_op = mapOdm['comentario_op'].toString();
          registro.est_contrato = mapOdm['est_contrato'].toString();
          registro.responsable_contrato =
              mapOdm['responsable_contrato'].toString();
          registro.fecha_cierre = mapOdm['fecha_cierre'].toString();
        }
      }
    }
    bl.stopLoading;
  }

  guardarBalance({
    required List<String> pedidoList,
    required List<String> pedidoListToClear,
    required String balance,
    required List<String> odmList,
    required List<String> odmListToClear,
    required String lcl,
    required String fecha,
    required bool esNuevo,
    required String comentario,
    required String estado,
    required BuildContext context,
  }) async {
    bl.startLoading;
    DateTime newDate = DateTime.now();
    List<Map<String, dynamic>> toSendList = [];
    List<Map<String, dynamic>> toSendListChatarra = [];
    // ignore: unused_local_variable
    List<Map<String, dynamic>> toSendListEmail = [];
    //Chatarra
    if (pedidoList.isNotEmpty || pedidoListToClear.isNotEmpty) {
      for (String pedido in pedidoList) {
        List<String> ids =
            state().chatarraList!.list
                .where((e) => e.pedido == pedido)
                .map((e) => e.id)
                .toList();
        for (String id in ids) {
          Map<String, dynamic> toSendChatarra = {'id': id, 'balance': balance};
          toSendListChatarra.add(toSendChatarra);
        }
      }
      for (String pedido in pedidoListToClear) {
        List<String> ids =
            state().chatarraList!.list
                .where((e) => e.pedido == pedido)
                .map((e) => e.id)
                .toList();
        for (String id in ids) {
          Map<String, dynamic> toSendChatarra = {'id': id, 'balance': ''};
          toSendListChatarra.add(toSendChatarra);
        }
      }
      Map dataSend = {
        "info": {
          "libro": state().user!.pdi,
          "hoja": "chatarra",
          "data": toSendListChatarra,
        },
        "fname": "update",
      };
      // print(jsonEncode(dataSend));
      Response response = await post(chatarraUrl, body: jsonEncode(dataSend));
      var respuesta = jsonDecode(response.body) ?? 'error en el envio';
      bl.mensajeFlotante(message: respuesta.toString());
      //wait 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      // context.read<MainBloc>().add(Message(message: respuesta));

      // print(respuesta);
    }

    for (String odm in odmList) {
      Map<String, dynamic> toSend = {
        'esnuevo': esNuevo.toString(),
        'lcl': lcl,
        'lm': balance,
        'fecha_conciliacion': fecha,
        'comentario_op': comentario,
        'odm': odm,
        'est_contrato': estado,
        'responsable_contrato': state().user!.nombre,
        'fecha_cierre':
            '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
      };
      toSendList.add(toSend);
    }
    toSendListEmail = [...toSendList];
    if (odmListToClear.isNotEmpty) {
      for (String odm in odmListToClear) {
        Map<String, dynamic> toSend = {
          'esnuevo': esNuevo.toString(),
          'lcl': lcl,
          'lm': '',
          'fecha_conciliacion': '',
          'comentario_op': '',
          'odm': odm,
          'est_contrato': 'Retirado',
          'responsable_contrato': state().user!.nombre,
          'fecha_cierre':
              '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
        };
        toSendList.add(toSend);
      }
    }
    Map dataSend = {
      "dataReq": {
        "libro": state().user!.pdi,
        "hoja": "registros",
        "data": toSendList,
      },
      "fname": "updateLibreto",
    };
    // print(jsonEncode(dataSend));
    final response = await post(
      Uri.parse(
        Api.samString,
      ),
      body: jsonEncode(dataSend),
    );
    // print('response ${response.body}');
    var dataAsListMap;
    dataAsListMap = jsonDecode(response.body);

    // updateLibreto(toSendList);

    Navigator.pop(context);
    Navigator.pop(context);
    add(LoadData());
    await Future.delayed(const Duration(seconds: 2));
    bl.mensajeFlotante(message: dataAsListMap.toString());
  }

  Future<String> lastBalance() async {
    bl.startLoading;
    try {
      Map dataSend = {
        "dataReq": {"libro": state().user!.pdi},
        "fname": "lastBalanceNumber",
      };
      // print(jsonEncode(dataSend));
      final response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      bl.stopLoading;
      return jsonDecode(response.body).toString();
    }  catch (e) {
      bl.stopLoading;
      bl.mensajeFlotante(
        message: 'Error al obtener el último balance: $e',
      );
      return '';
    }
  }
}
