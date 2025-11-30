import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:async/async.dart';
import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../registros/model/resgistros_b.dart';
import '../../user/user_model.dart';
import '../model/conciliacion_model.dart';
import '../model/conciliacion_url.dart';

class ChatarraCtrlAddToDb {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ChatarraCtrlAddToDb(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  Future<String> addToDb() async {
    try {
      User user = state().user!;
      RegistrosB registrosB = state().registrosB!;
      Conciliacion conciliacion = state().conciliacion!;
      FutureGroup futureGroup = FutureGroup();
      String conciliacionTemp = conciliacion.conciliacion;
      if (conciliacion.esPrimeravez) {
        conciliacion.conciliacion = "";
      }
      conciliacion.persona = user.correo;
      conciliacion.fecha = DateTime.now().toString().substring(0, 16);
      Map dataSend = {
        "info": {
          "libro": user.pdi,
          "hoja": "conciliaciones",
          "data": conciliacion.toMap(),
        },
        "fname": "add",
      };
      if (conciliacion.balancesam.isNotEmpty &&
          conciliacion.balancesam.contains('_')) {
        List<String> parts = conciliacion.balancesam.split('_');
        String balanceNumero = parts.last;
        List<String> odms =
            registrosB.registrosList
                .where((e) => e.lm == balanceNumero)
                .map((e) => e.odm)
                .toSet()
                .toList();
        List<Map<String, dynamic>> toSendList = [];
        DateTime newDate = DateTime.now();
        for (String odm in odms) {
          List<String> perfilContrato = ['operacion', 'almacen', 'contract'];
          List<String> perfilEnel = ['funcional', 'contract'];
          if (conciliacion.estado == 'carga archivos' &&
              perfilContrato.contains(user.perfil)) {
            Map<String, dynamic> toSend = {
              'odm': odm,
              'est_sap_au': conciliacionTemp,
              'fecha_sap_au':
                  '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
            };
            toSendList.add(toSend);
          }
          if (conciliacion.estado == 'aprobado' &&
              perfilEnel.contains(user.perfil)) {
            Map<String, dynamic> toSend = {
              'odm': odm,
              'est_sap_ma': conciliacion,
              'fecha_sap_ma':
                  '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
            };
            toSendList.add(toSend);
          }
          if (conciliacion.estado == 'carga scm' &&
              perfilContrato.contains(user.perfil)) {
            Map<String, dynamic> toSend = {
              'odm': odm,
              'est_sap': conciliacion,
              'sap': conciliacion.lm,
              'fecha_sap': conciliacion.lmfecha,
              'soporte_ma':
                  '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
            };
            toSendList.add(toSend);
          }
        }
        Map dataSend = {
          "dataReq": {
            "libro": user.pdi,
            "hoja": "registros",
            "data": toSendList,
          },
          "fname": "updateLibreto",
        };
        futureGroup.add(
          Future.delayed(
            Duration.zero,
            () => post(
              Uri.parse(
                Api.samString,
              ),
              body: jsonEncode(dataSend),
            ),
          ),
        );
      }
      futureGroup.add(
        Future.delayed(
          Duration.zero,
          () => post(conciliacionUrl, body: jsonEncode(dataSend)),
        ),
      );

      futureGroup.close();
      var respuesta = 'No enviado';
      await futureGroup.future.then(
        (List value) =>
            respuesta =
                value.map((e) => jsonDecode(e.body)).toList().toString(),
      );

      print('response ${respuesta}');
      return respuesta;
    } catch (e) {
      return 'Error en el envío a DB: $e';
    }
  }
}
