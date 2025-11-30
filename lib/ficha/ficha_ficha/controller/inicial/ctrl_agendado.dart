
import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../../../fechas_fem/model/fechasfem_enabledate.dart';
import '../../model/ficha__ficha_model.dart';
import '../../model/ficha_reg/reg.dart';

class CtrlFfichaInicialPedido {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late FFicha fficha;

  CtrlFfichaInicialPedido(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    fficha = state().ficha!.fficha;
  }

  void get asignarEstado {
    List<FichaReg> fichaReal = fficha.ficha;
    List<FichaReg> fichaModificada = fficha.fichaModificada;
    for (List<FichaReg> ficha in [fichaReal, fichaModificada]) {
      for (FichaReg fichaReg in ficha) {
        _setColorMes('01', fichaReg);
        _setColorMes('02', fichaReg);
        _setColorMes('03', fichaReg);
        _setColorMes('04', fichaReg);
        _setColorMes('05', fichaReg);
        _setColorMes('06', fichaReg);
        _setColorMes('07', fichaReg);
        _setColorMes('08', fichaReg);
        _setColorMes('09', fichaReg);
        _setColorMes('10', fichaReg);
        _setColorMes('11', fichaReg);
        _setColorMes('12', fichaReg);
      }
    }
  }

  void _setColorMes(String mes, FichaReg fichaReg) {
    Map<String, EnableDate> dates =
        state().fechasFEM!.enableDates(state().year!);
    bool pedidoActivo = dates[mes]!.pedidoActivoq2;
    bool estaPedido = fichaReg.agendado.mes.get(mes) == fichaReg.planificado.mes.get(mes);
    fichaReg.agendado.color.set(mes, !estaPedido && !pedidoActivo);
  }

  void get asignarActivo {
    List<FichaReg> fichaReal = fficha.ficha;
    List<FichaReg> fichaModificada = fficha.fichaModificada;
    for (List<FichaReg> ficha in [fichaReal, fichaModificada]) {
      for (FichaReg fichaReg in ficha) {
        _setActivo('01', fichaReg);
        _setActivo('02', fichaReg);
        _setActivo('03', fichaReg);
        _setActivo('04', fichaReg);
        _setActivo('05', fichaReg);
        _setActivo('06', fichaReg);
        _setActivo('07', fichaReg);
        _setActivo('08', fichaReg);
        _setActivo('09', fichaReg);
        _setActivo('10', fichaReg);
        _setActivo('11', fichaReg);
        _setActivo('12', fichaReg);
      }
    }
  }

  void _setActivo(String mes, FichaReg fichaReg) {
    Map<String, EnableDate> dates =
        state().fechasFEM!.enableDates(state().year!);
    bool pedidoActivoq1 = dates[mes]!.pedidoActivoq1;
    bool pedidoActivoq2 = dates[mes]!.pedidoActivoq2;
    fichaReg.agendado.activoMes.set(mes, pedidoActivoq2);
    fichaReg.agendado.activoQuincena.set('$mes-1', pedidoActivoq1);
    fichaReg.agendado.activoQuincena.set('$mes-2', pedidoActivoq2);
  }
}
