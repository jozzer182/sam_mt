import 'package:flutter/material.dart';

import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../../../fechas_fem/model/fechasfem_enabledate.dart';
import '../../model/ficha__ficha_model.dart';
import '../../model/ficha_reg/reg.dart';

class CtrFfichaInicialNumberColor {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late FFicha fficha;

  CtrFfichaInicialNumberColor(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    fficha = state().ficha!.fficha;
  }

  void get asignar {
    List<FichaReg> fichaReal = fficha.ficha;
    List<FichaReg> fichaModificada = fficha.fichaModificada;
    for (List<FichaReg> ficha in [fichaReal, fichaModificada]) {
      for (FichaReg fichaReg in ficha) {
        _getColorNumberMes('01', fichaReg);
        _getColorNumberMes('02', fichaReg);
        _getColorNumberMes('03', fichaReg);
        _getColorNumberMes('04', fichaReg);
        _getColorNumberMes('05', fichaReg);
        _getColorNumberMes('06', fichaReg);
        _getColorNumberMes('07', fichaReg);
        _getColorNumberMes('08', fichaReg);
        _getColorNumberMes('09', fichaReg);
        _getColorNumberMes('10', fichaReg);
        _getColorNumberMes('11', fichaReg);
        _getColorNumberMes('12', fichaReg);
      }
    }
  }

  void _getColorNumberMes(String mes, FichaReg fichaReg) {
    Map<String, EnableDate> dates =
        state().fechasFEM!.enableDates(state().year!);
    bool pedidoActivo = dates[mes]!.pedidoActivoq2;
    bool hayUnidades = fichaReg.planificado.mes.get(mes) != '0';
    // List<Mes> mesList = state()
    //     .disponibilidad!
    //     .anoList
    //     .firstWhere(
    //       (e) => e.e4e == fichaReg.e4e,
    //       orElse: () => AnoList.zero(),
    //     )
    //     .mesList;
    // String disponibilidad = mesList
    //     .firstWhere(
    //       (e) => e.mes == aEntero(mes) && e.ano == aEntero(state().year!),
    //       orElse: () => Mes.zero(),
    //     )
    //     .proyectado
    //     .toString();
    // bool hayDisponibilidad = aEntero(disponibilidad) >= 0;
    Color? colorPrincipal;
    if (!pedidoActivo || !hayUnidades) {
      colorPrincipal = Colors.grey;
    }
    // if (hayUnidades && !hayDisponibilidad && pedidoActivo) {
    //   colorPrincipal = lightenColor(Colors.red, 0.5);
    // }
    fichaReg.planificado.color.set(mes, colorPrincipal);
  }
}
