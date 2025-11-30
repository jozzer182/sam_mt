import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/informe_saldos_model.dart';

class InformeSaldosCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  InformeSaldosCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear async {
    try {
      Saldos saldos = Saldos();
      // saldos.crear(deudaAlmacenB: state().deudaAlmacenB!);
      final deudaAlmacenB = state().deudaAlmacenB!;
      saldos.saldosList = [...deudaAlmacenB.deudaAlmacenB];
      saldos.saldosListSearch = [...deudaAlmacenB.deudaAlmacenB];
      emit(state().copyWith(saldos: saldos));
      await Future.delayed(Duration(milliseconds: 50));
      // print('saldos: ${state().saldos}');
    } catch (e) {
      bl.errorCarga('Informe Saldos', e);
    }
  }

  cambioSaldos({required String inv, required int index}) async {
    final saldos = state().saldos!;
    // state().saldos?.recalcularFaltante(index: index, inv: inv);
    double faltanteUnidades =
        double.parse(saldos.saldosList[index].mb52) -
        double.parse(inv) -
        double.parse(saldos.saldosList[index].sal);
    double faltanteValor =
        double.parse(saldos.saldosList[index].valorUnitario) * faltanteUnidades;
    saldos.saldosList[index].inv = inv;
    saldos.saldosList[index].faltanteUnidades = faltanteUnidades.toString();
    saldos.saldosList[index].faltanteValor = faltanteValor.toString();

    emit(state().copyWith(saldos: state().saldos));
  }

  calcularSaldos() async {
    final saldos = state().saldos!;
    bl.startLoading;
    // ignore: unused_local_variable
    String? respuesta ;
    final deudaOperativaB = state().deudaOperativaB!;
    final user = state().user!;
    List<Map> vals =
        saldos.saldosList.map((e) => e.toSaldos(pdi: user.pdi)).toList();
    List<Map> deuda =
        deudaOperativaB.deudaOperativaB.map((e) => e.toMap()).toList();
    // print('vals: $vals');
    String rutaArchivo =
        "https://docs.google.com/spreadsheets/d/1rlVfmyvkevI4EzwF79OhUz5R4DCbDL_TQOHNMCQ01q8/edit#gid=2106076515";
    try {
      var dataSend = {
        'dataReq': {'pdi': user.pdi, 'vals': vals, 'deuda': deuda},
        'fname': "addSaldos",
      };
      // print(jsonEncode(dataSend));
      var response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      // print(response.body);
      var responseDecoded;
      responseDecoded = jsonDecode(response.body);
      rutaArchivo = responseDecoded;
    } catch (e) {
      bl.errorCarga('Informe Saldos', e);
    }
    Uri url = Uri.parse(rutaArchivo);
    bl.stopLoading;
    await launchUrl(url);
    respuesta = rutaArchivo;

    // print(respuesta);
    emit(state().copyWith());
    // bl.stopLoading;
  }
}
