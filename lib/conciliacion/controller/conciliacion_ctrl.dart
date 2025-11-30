import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/conciliacion_model.dart';
import '../model/conciliacion_url.dart';
import 'conciliacion_ctrl_add_to_db.dart';
import 'conciliacion_ctrl_cambiar_campos.dart';
import 'conciliacion_ctrl_validar.dart';

class ConciliacionCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ConciliacionCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  ConciliacionCtrlCambiarCampos get cambiarCampos =>
      ConciliacionCtrlCambiarCampos(bl);

  ChatarraCtrlAddToDb get enviarBD => ChatarraCtrlAddToDb(bl);
  ChatarraCtrlValidar get validar => ChatarraCtrlValidar(bl);

  Future agregarConciliacion({
    required BuildContext context,
    required bool sendEmail,
    required List<String> correos,
  }) async {
    bl.startLoading;

    List<dynamic>? validar = this.validar.validar;

    if (validar != null) {
      bl.mensajeFlotante(message: validar.join('\n'));
    } else {
      // ignore: unused_local_variable
      String respuesta = 'No enviado';
      try {
        FutureGroup futureGroup = FutureGroup();
        futureGroup.add(
          Future.delayed(Duration.zero, () => enviarBD.addToDb()),
        );
        if (sendEmail) {
          futureGroup.add(
            Future.delayed(Duration.zero, () => enviarEmail(correos)),
          );
        }
        futureGroup.close();
        await futureGroup.future.then((value) => respuesta = value.toString());
        respuesta = respuesta
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll(',', '\n');
        add(LoadData());
      } catch (e) {
        bl.errorCarga('enviando Conciliación', e);
      }
      bl.mensajeFlotante(message: respuesta);
    }
    bl.stopLoading;
  }

  Future<String> enviarEmail(List<String> correos) async {
    try {
      Conciliacion conciliacion = state().conciliacion!;
      Map dataSend = {
        'info': {
          'data': {
            'registro': conciliacion.toMap(),
            'user': state().user!.toMap(),
            'correos': correos,
          },
        },
        'fname': "sendMail",
      };
      var response = await post(conciliacionUrl, body: jsonEncode(dataSend));
      return response.body;
    } catch (e) {
      return 'Error en el envío de Mail: $e';
    }
  }

  Future<String> lastConciliacion() async {
    Map dataSend = {
      'info': {'libro': state().user!.pdi, 'hoja': 'conciliaciones'},
      'fname': "getConciliacion",
    };
    Response response = await post(conciliacionUrl, body: jsonEncode(dataSend));
    String respuesta = jsonDecode(response.body) ?? 'error';
    return respuesta;
  }
}
