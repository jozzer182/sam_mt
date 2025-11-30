import '../../../bloc/main__bl.dart';
import '../../../bloc/main_bloc.dart';
import '../../main/ficha/model/ficha_model.dart';
import '../model/ficha__ficha_model.dart';
import '../model/ficha_reg/reg.dart';
import 'inicial/ctrl_inicial.dart';

class CtrlFfichaLista {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  late Ficha ficha;
  late FFicha fficha;

  CtrlFfichaLista(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
    ficha = state().ficha!;
    fficha = state().ficha!.fficha;
  }

  get agregar {
    List<FichaReg> fichaModificada = fficha.fichaModificada;
    String year = state().year!;
    FichaReg fichaReg =
        FichaReg.fromInit(fichaModificada.length + 1, year.substring(2));
    if (fficha.ficha.isNotEmpty) {
      fichaReg.unidad = fficha.ficha.first.unidad;
      fichaReg.codigo = fficha.ficha.first.codigo;
      fichaReg.proyecto = fficha.ficha.first.proyecto;
      fichaReg.pm = fficha.ficha.first.pm;
    }
    fichaModificada.add(fichaReg);
    emit(state().copyWith(ficha: ficha));
  }

  get eliminar {
    List<FichaReg> fichaModificada = fficha.fichaModificada;
    List<FichaReg> fichaOriginal = fficha.ficha;
    if (fichaModificada.length > fichaOriginal.length) {
      fichaModificada.removeLast();
    }
    emit(state().copyWith(ficha: ficha));
  }

  get reset async {
    // fficha.editar = !fficha.editar;
    // fficha.fichaModificada.clear();
    // fficha.fichaModificada = [];
    // emit(state().copyWith(ficha: ficha));

    // await Future.delayed(const Duration(milliseconds: 100));
    // fficha.editar = !fficha.editar;

    fficha.fichaModificada = fficha.ficha.map((e) => e.copyWith()).toList();
    inicial.calculo;
    emit(state().copyWith(ficha: ficha));
  }

  void get clearLibresControlados {
    fficha.libres.clear();
    fficha.controlados.clear();
    emit(state().copyWith(ficha: ficha));
  }

  void agregarRazon(String razon) {
    String persona = state().user!.correo;
    String fecha = DateTime.now().toString();

    void actualizarFichaReg(List<FichaReg> fichas) {
      for (FichaReg fichaReg in fichas) {
        fichaReg.log.razon = razon;
        fichaReg.log.persona = persona;
        fichaReg.log.fecha = fecha;
        fichaReg.fechacambio = fecha;
        fichaReg.solicitante = persona;
      }
    }

    actualizarFichaReg(fficha.controlados);
    actualizarFichaReg(fficha.libres);
    actualizarFichaReg(fficha.eliminados);

    emit(state().copyWith(ficha: ficha));
  }

  CtrlFfichaInicial get inicial => CtrlFfichaInicial(bl);
}
