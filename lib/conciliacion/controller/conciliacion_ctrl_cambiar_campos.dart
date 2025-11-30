import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../lcl/model/lcl_model.dart';
import '../model/conciliacion_enum.dart';
import '../model/conciliacion_model.dart';

class ConciliacionCtrlCambiarCampos {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ConciliacionCtrlCambiarCampos(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  changeConciliacion({
    required String value,
    required CampoConciliacion campo,
  }) {
    Conciliacion conciliacion = state().conciliacion!;
    final lclList = state().lcl!;
    if (campo == CampoConciliacion.id) {
      conciliacion.id = value;
    }
    if (campo == CampoConciliacion.lcl) {
      conciliacion.lcl = value;
      conciliacion.personaenel =
          lclList.lclList
              .firstWhere(
                (e) => e.lcl == conciliacion.lcl,
                orElse: LclSingle.fromInit,
              )
              .usuario;
    }
    if (campo == CampoConciliacion.conciliacion) {
      conciliacion.conciliacion = value;
    }
    if (campo == CampoConciliacion.nodo) {
      conciliacion.nodo = value;
    }
    if (campo == CampoConciliacion.estado) {
      conciliacion.estado = value;
    }
    if (campo == CampoConciliacion.numero) {
      conciliacion.numero = value;
    }
    if (campo == CampoConciliacion.comentario) {
      conciliacion.comentario = value;
    }
    if (campo == CampoConciliacion.fecha) {
      conciliacion.fecha = value;
    }
    if (campo == CampoConciliacion.persona) {
      conciliacion.persona = value;
    }
    if (campo == CampoConciliacion.lm) {
      conciliacion.lm = value;
    }
    if (campo == CampoConciliacion.lmfecha) {
      conciliacion.lmfecha = value;
    }
    if (campo == CampoConciliacion.personaenel) {
      conciliacion.personaenel = value;
    }
    if (campo == CampoConciliacion.personacontrato) {
      conciliacion.personacontrato = value;
    }
    if (campo == CampoConciliacion.balance) {
      conciliacion.balance = value;
    }
    if (campo == CampoConciliacion.balancesam) {
      conciliacion.balancesam = value;
    }

    if (campo == CampoConciliacion.planillatrabajo) {
      conciliacion.planillatrabajo = value;
    }
    if (campo == CampoConciliacion.descargos) {
      conciliacion.descargos = value;
    }
    if (campo == CampoConciliacion.docseguridad) {
      conciliacion.docseguridad = value;
    }
    if (campo == CampoConciliacion.medidapat) {
      conciliacion.medidapat = value;
    }
    if (campo == CampoConciliacion.formatoarrime) {
      conciliacion.formatoarrime = value;
    }
    if (campo == CampoConciliacion.plano) {
      conciliacion.plano = value;
    }
    if (campo == CampoConciliacion.docsalmacen) {
      conciliacion.docsalmacen = value;
    }
    if (campo == CampoConciliacion.regfotografico) {
      conciliacion.regfotografico = value;
    }
    if (campo == CampoConciliacion.cortesobra) {
      conciliacion.cortesobra = value;
    }
    if (campo == CampoConciliacion.pruebasconcreto) {
      conciliacion.pruebasconcreto = value;
    }
    if (campo == CampoConciliacion.varios1) {
      conciliacion.varios1 = value;
    }
    if (campo == CampoConciliacion.varios2) {
      conciliacion.varios2 = value;
    }
    if (campo == CampoConciliacion.varios3) {
      conciliacion.varios3 = value;
    }
    if (campo == CampoConciliacion.balanceestado) {
      // print('balanceestado: $valor');
      conciliacion.balanceestado = value;
    }
    if (campo == CampoConciliacion.planillatrabajoestado) {
      conciliacion.planillatrabajoestado = value;
    }
    if (campo == CampoConciliacion.descargosestado) {
      conciliacion.descargosestado = value;
    }
    if (campo == CampoConciliacion.docseguridadestado) {
      conciliacion.docseguridadestado = value;
    }
    if (campo == CampoConciliacion.medidapatestado) {
      conciliacion.medidapatestado = value;
    }
    if (campo == CampoConciliacion.formatoarrimeestado) {
      conciliacion.formatoarrimeestado = value;
    }
    if (campo == CampoConciliacion.planoestado) {
      conciliacion.planoestado = value;
    }
    if (campo == CampoConciliacion.docsalmacenestado) {
      conciliacion.docsalmacenestado = value;
    }
    if (campo == CampoConciliacion.regfotograficoestado) {
      conciliacion.regfotograficoestado = value;
    }
    if (campo == CampoConciliacion.cortesobraestado) {
      conciliacion.cortesobraestado = value;
    }
    if (campo == CampoConciliacion.pruebasconcretoestado) {
      conciliacion.pruebasconcretoestado = value;
    }
    if (campo == CampoConciliacion.varios1estado) {
      conciliacion.varios1estado = value;
    }
    if (campo == CampoConciliacion.varios2estado) {
      conciliacion.varios2estado = value;
    }
    if (campo == CampoConciliacion.varios3estado) {
      conciliacion.varios3estado = value;
    }
    if (campo == CampoConciliacion.planillafirmada) {
      conciliacion.planillafirmada = value;
    }
    if (campo == CampoConciliacion.planillafirmadaestado) {
      conciliacion.planillafirmadaestado = value;
    }
    if (campo == CampoConciliacion.esprimeravez) {
      conciliacion.esPrimeravez = value == 'true' ? true : false;
    }
    if (campo == CampoConciliacion.proyecto) {
      conciliacion.proyecto = value;
    }

    emit(state().copyWith(conciliacion: state().conciliacion));
  }
}
