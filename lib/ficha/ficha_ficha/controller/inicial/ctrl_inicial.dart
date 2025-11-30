
import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../../main/ficha/model/ficha_model.dart';
import 'ctrl_number_color.dart';
import 'ctrl_agendado.dart';

class CtrlFfichaInicial {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late Ficha ficha;

  CtrlFfichaInicial(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    ficha = state().ficha!;
  }

  get calculo {
    pedido.asignarEstado;
    // oficial.asignar;
    // riesgo.asignar;
    // disponibilidad.calcular;
    colorNumber.asignar;
    pedido.asignarActivo;
    // version.asignar;
    // controlado.asignar;
    emit(state().copyWith(ficha: ficha));
  }

  CtrlFfichaInicialPedido get pedido => CtrlFfichaInicialPedido(bl);

  // CtrlFfichaInicialOficial get oficial => CtrlFfichaInicialOficial(bl);

  // CtrlFfichaInicialRiesgo get riesgo => CtrlFfichaInicialRiesgo(bl);

  // CtrlFfichaInicialDisponibilidad get disponibilidad =>
  //     CtrlFfichaInicialDisponibilidad(bl);

  CtrFfichaInicialNumberColor get colorNumber => CtrFfichaInicialNumberColor(bl);

  // CtrlFfichaInicialVersion get version =>
  //     CtrlFfichaInicialVersion(bl);
  
  // CtrlFfichaInicialControlado get controlado =>
  //     CtrlFfichaInicialControlado(bl);
}
