import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/chatarra_list.dart';
import '../model/chatarra_model.dart';
import '../model/chatarra_registros.dart';
import 'chatarra_ctrl_cambiar_campos.dart';

class ChatarraCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ChatarraCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  ChatarraCtrlCambiarCampos get cambiarCampos => ChatarraCtrlCambiarCampos(bl);

  get obtener async {
    ChatarraList chatarraList = ChatarraList();
    try {
      chatarraList.list.clear();
      chatarraList.listSearch.clear();
      // print('obtener ChatarraList');
      var dataSend = {
        'dataReq': {'pdi': state().user?.pdi ?? 'TEST', 'hoja': 'chatarra'},
        'fname': "getHoja",
      };
      // print(jsonEncode(dataSend));
      final response = await post(Api.sam, body: jsonEncode(dataSend));
      // print(response.body);
      var dataAsListMap = jsonDecode(response.body);
      for (var item in dataAsListMap) {
        // print(item);
        if (item['estado'] != 'anulado') {
          chatarraList.list.add(ChatarraSingle.fromMap(item));
          chatarraList.listSearch.add(ChatarraSingle.fromMap(item));
        }
      }
      emit(state().copyWith(chatarraList: chatarraList));
      // print('onLoadConciliaciones: ${state().conciliaciones!.conciliacionesList.length}');
    } catch (e) {
      bl.errorCarga('Chatarra', e);
    }
  }

  deleteToDBChatarra() async {
    Chatarra chatarra = state().chatarra!;
    bl.startLoading;
    // ignore: unused_local_variable
    String? respuesta;
    try {
      // respuesta = await state().chatarra?.deleteToDB(user: state().user!);
      final user = state().user!;

      chatarra.estadopersona = user.correo;
      chatarra.reportado = DateTime.now().toString().substring(0, 16);
      chatarra.estado = 'anulado';
      Map dataSend = {
        "info": {
          "libro": user.pdi,
          "hoja": "chatarra",
          "data": chatarra.toListMap(),
        },
        "fname": "update",
      };

      // print(jsonEncode(dataSend));
      Response response = await post(
        Api.chatarraUrl,
        body: jsonEncode(dataSend),
      );
      respuesta = jsonDecode(response.body) ?? 'error en el envio';

      add(LoadData());
    } catch (e) {
      bl.errorCarga('Chatarra', e);
    }
    bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
    bl.stopLoading;
  }

  addToDbChatarra() async {
    Chatarra chatarra = state().chatarra!;
    bl.startLoading;
    List<dynamic>? validar = this.validar;
    if (validar != null) {
      bl.mensajeFlotante(message: validar.join('\n'));
    } else {
      // ignore: unused_local_variable
      String? respuesta;
      try {
        final user = state().user!;
        // respuesta = await state().chatarra?.addToDb(user: state().user!);
        chatarra.estadopersona = user.correo;
        chatarra.reportado = DateTime.now().toString().substring(0, 16);
        Map dataSend = {
          "info": {
            "libro": user.pdi,
            "hoja": "chatarra",
            "data": chatarra.toListMap(),
          },
          "fname": "update",
        };
        // print(jsonEncode(dataSend));
        Response response = await post(
          Api.chatarraUrl,
          body: jsonEncode(dataSend),
        );
        respuesta = jsonDecode(response.body) ?? 'error en el envio';
        add(LoadData());
      } catch (e) {
        bl.errorCarga('Enviando Chatarra', e);
      }
      bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
    }
    bl.stopLoading;
  }


  seleccionarChatarra({Chatarra? chatarra}) {
    emit(state().copyWith(chatarra: chatarra));
  }

  List? get validar {
    Chatarra chatarra = state().chatarra!;
    Color r = Colors.red;
    var faltantes = <String>[];
    if (chatarra.fecha_i.isEmpty) faltantes.add('Fecha Ingreso');
    if (chatarra.acta.isEmpty) faltantes.add('Acta');
    if (chatarra.soporte_i.isEmpty) faltantes.add('Soporte Ingreso');
    if (chatarra.lcl.isEmpty) faltantes.add('LCL');
    for (ChatarraReg reg in chatarra.items) {
      String f = 'Item: ${reg.item} =>';
      if (reg.e4eError == r) f += ' E4e,';
      if (reg.ctdError == r) f += ' Ctd,';
      if (f != 'Item: ${reg.item} =>') faltantes.add(f);
    }

    if (faltantes.isNotEmpty) {
      faltantes.insert(
        0,
        'Por favor revise los siguientes campos para poder realizar el guardado:',
      );
      return faltantes;
    } else {
      return null;
    }
  }

  Future<String> lastNumberPed(String pdi) async {
    // print('lastNumberReg Called');
    Map dataSend = {
      'info': {'libro': pdi, 'hoja': 'chatarra'},
      'fname': "lastNumberPed",
    };
    // print(jsonEncode(dataSend));
    String respuesta = 'Error';
    try {
      Response response = await post(
        Api.chatarraUrl,
        body: jsonEncode(dataSend),
      );
      respuesta = jsonDecode(response.body) ?? 'error';
    } catch (e) {
      bl.errorCarga('Chatarra Último Pedido', e);
    }
    // print(response.body);
    // localidcode = respuesta;
    return respuesta;
  }
}
