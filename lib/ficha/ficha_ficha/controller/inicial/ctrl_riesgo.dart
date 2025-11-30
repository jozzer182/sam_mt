// import '../../../../bloc/main__bl.dart';
// import '../../../../bloc/main_bloc.dart';
// import '../../../../disponibilidad/model/disponibilidad_ano_list.dart';
// import '../../../../disponibilidad/model/disponibilidad_only_month.dart';
// import '../../../../nuevo/model/nuevo_model.dart';
// import '../../../../resources/a_entero_2.dart';
// import '../../model/ficha__ficha_model.dart';
// import '../../model/ficha_reg/reg.dart';

// class CtrlFfichaInicialRiesgo {
//   final Bl bl;
//   late MainState Function() state;
//   late var emit;
//   late void Function(MainEvent p1) add;
//   late FFicha fficha;

//   CtrlFfichaInicialRiesgo(this.bl) {
//     emit = bl.emit;
//     state = bl.state;
//     add = bl.add;
//     fficha = state().ficha!.fficha;
//   }

//   void get asignar {
//     List<FichaReg> fichaReal = fficha.ficha;
//     List<FichaReg> fichaModificada = fficha.fichaModificada;
//     for (List<FichaReg> ficha in [fichaReal, fichaModificada]) {
//       for (FichaReg fichaReg in ficha) {
//         _setRiesgoMes('01', fichaReg);
//         _setRiesgoMes('02', fichaReg);
//         _setRiesgoMes('03', fichaReg);
//         _setRiesgoMes('04', fichaReg);
//         _setRiesgoMes('05', fichaReg);
//         _setRiesgoMes('06', fichaReg);
//         _setRiesgoMes('07', fichaReg);
//         _setRiesgoMes('08', fichaReg);
//         _setRiesgoMes('09', fichaReg);
//         _setRiesgoMes('10', fichaReg);
//         _setRiesgoMes('11', fichaReg);
//         _setRiesgoMes('12', fichaReg);
//       }
//     }
//   }

//   void _setRiesgoMes(String mes, FichaReg fichaReg) {
//     bool esOficial = fichaReg.oficial.mesOficial(mes) != fichaReg.planificado.mes.get(mes);
//     bool esMayorAOficial =
//         aEntero(fichaReg.planificado.mes.get(mes)) > aEntero(fichaReg.oficial.mesOficial(mes));
//     if (!esOficial && esMayorAOficial) {
//       fichaReg.riesgo.setRiesgo(mes,
//           aEntero(fichaReg.planificado.mes.get(mes)) - aEntero(fichaReg.oficial.mesOficial(mes)));
//     }
//     bool hayUnidades = fichaReg.planificado.mes.get(mes) != '0';
//     List<Mes> mesList = state()
//         .disponibilidad!
//         .anoList
//         .firstWhere(
//           (e) => e.e4e == fichaReg.e4e,
//           orElse: () => AnoList.zero(),
//         )
//         .mesList;
//     String disponibilidad = mesList
//         .firstWhere(
//           (e) => e.mes == aEntero(mes) && e.ano == aEntero(state().year!),
//           orElse: () => Mes.zero(),
//         )
//         .proyectado
//         .toString();
//     bool hayDisponibilidad = aEntero(disponibilidad) >= 0;
//     Map<String, EnableDate> dates =
//         state().fechasFEM!.enableDates(state().year!);
//     bool pedidoActivo = dates[mes]!.pedidoActivoq2;

//     if (hayUnidades && !hayDisponibilidad && pedidoActivo) {
//       if (aEntero(disponibilidad) + aEntero(fichaReg.planificado.mes.get(mes)) < 0) {
//         fichaReg.riesgo.setRiesgo(mes, aEntero(fichaReg.planificado.mes.get(mes)));
//       }
//     }
//     if (fichaReg.oficial.mesOficial(mes) != fichaReg.planificado.mes.get(mes) &&
//         aEntero(fichaReg.planificado.mes.get(mes)) > aEntero(fichaReg.oficial.mesOficial(mes))) {
//       fichaReg.riesgo.setRiesgo(mes,
//           aEntero(fichaReg.planificado.mes.get(mes)) - aEntero(fichaReg.oficial.mesOficial(mes)));
//     }
//   }
// }
