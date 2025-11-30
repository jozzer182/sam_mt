// import 'package:flutter/material.dart';

// import '../../../../bloc/main__bl.dart';
// import '../../../../bloc/main_bloc.dart';
// import '../../../../disponibilidad/model/disponibilidad_ano_list.dart';
// import '../../../../disponibilidad/model/disponibilidad_only_month.dart';
// import '../../../../resources/a_entero_2.dart';
// import '../../../../resources/constant/meses.dart';
// import '../../model/ficha__ficha_model.dart';
// import '../../model/ficha_reg/reg.dart';

// class CtrlFfichaInicialDisponibilidad {
//   final Bl bl;
//   late MainState Function() state;
//   late var emit;
//   late void Function(MainEvent p1) add;
//   late FFicha fficha;

//   CtrlFfichaInicialDisponibilidad(this.bl) {
//     emit = bl.emit;
//     state = bl.state;
//     add = bl.add;
//     fficha = state().ficha!.fficha;
//   }

//   void get calcular {
//     _asignar;
//     _correcionDisponibilidad;
//   }

//   void get _asignar {
//     List<FichaReg> fichaReal = fficha.ficha;
//     List<FichaReg> fichaModificada = fficha.fichaModificada;
//     for (List<FichaReg> ficha in [fichaReal, fichaModificada]) {
//       for (FichaReg fichaReg in ficha) {
//         _setDispMes('01', fichaReg);
//         _setDispMes('02', fichaReg);
//         _setDispMes('03', fichaReg);
//         _setDispMes('04', fichaReg);
//         _setDispMes('05', fichaReg);
//         _setDispMes('06', fichaReg);
//         _setDispMes('07', fichaReg);
//         _setDispMes('08', fichaReg);
//         _setDispMes('09', fichaReg);
//         _setDispMes('10', fichaReg);
//         _setDispMes('11', fichaReg);
//         _setDispMes('12', fichaReg);
//       }
//     }
//   }

//   void _setDispMes(String mes, FichaReg fichaReg) {
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
//     fichaReg.disponible.set(mes, disponibilidad);
//   }

//   void get _correcionDisponibilidad {
//     List<FichaReg> fichaReal = fficha.ficha;
//     List<FichaReg> fichaModificada = fficha.fichaModificada;

//     List<String> e4eList = fichaModificada
//         // .where((e) => e.estado == "nuevo")
//         .map((e) => e.e4e)
//         .toSet()
//         .toList();

//     for (String e4e in e4eList) {
//       int totalPlanificadoViejo = fichaReal
//           .where((e) => e.estado != 'nuevo' && e.e4e == e4e)
//           .map((e) =>
//               fichaModificada
//                   .where((el) => el.id == e.id)
//                   .first
//                   .planificado
//                   .mes
//                   .total -
//               e.planificado.mes.total)
//           .fold(0, (a, b) => a + b);
//       for (FichaReg fichaRegMod in fichaModificada) {
//         if (e4e != fichaRegMod.e4e) continue;

//         int totalPlanificadoNuevo = fichaModificada
//             .where((e) => e.e4e == e4e && e.estado == 'nuevo')
//             .map((e) => e.planificado.mes.total)
//             .fold(0, (a, b) => a + b);

//         int totalPlanificado = totalPlanificadoNuevo + totalPlanificadoViejo;

//         for (String mes in meses) {
//           bool agendadoActivo = fichaRegMod.agendado.activoMes.get(mes);
//           if (agendadoActivo) {
//             List<Mes> mesList = state()
//                 .disponibilidad!
//                 .anoList
//                 .firstWhere(
//                   (e) => e.e4e == fichaRegMod.e4e,
//                   orElse: () => AnoList.zero(),
//                 )
//                 .mesList;
//             String disponibilidad = mesList
//                 .firstWhere(
//                   (e) =>
//                       e.mes == aEntero(mes) && e.ano == aEntero(state().year!),
//                   orElse: () => Mes.zero(),
//                 )
//                 .proyectado
//                 .toString();

//             int disponibilidadNew = aEntero(disponibilidad) - totalPlanificado;
//             fichaRegMod.disponible.set(mes, "$disponibilidadNew");
//             _evaluarColorCeldaNuevo(fichaRegMod, mes, disponibilidadNew);
//             _evaluarColorCeldaViejo(fichaRegMod, mes, disponibilidadNew);
//           }
//         }
//       }
//     }
//   }

//   void _evaluarColorCeldaNuevo(
//     FichaReg fichaRegMod,
//     String mes,
//     int disponibilidadNew,
//   ) {
//     bool versionActiva = fichaRegMod.version.get(mes);
//     bool agendadoActivo = fichaRegMod.agendado.activoMes.get(mes);
//     bool esNuevo = fichaRegMod.estado == 'nuevo';
//     if (!versionActiva && agendadoActivo && esNuevo) {
//       if (disponibilidadNew < 0) {
//         fichaRegMod.error.setError(
//             mes: mes, error: 'Se ha superado el límite de disponibilidad');
//         fichaRegMod.error.setColor(mes: mes, color: Colors.red);
//       } else {
//         fichaRegMod.error.setError(mes: mes, error: '');
//         fichaRegMod.error.setColor(mes: mes, color: null);
//       }
//     }
//   }

//   void _evaluarColorCeldaViejo(
//     FichaReg fichaRegMod,
//     String mes,
//     int disponibilidadNew,
//   ) {
//     bool versionActiva = fichaRegMod.version.get(mes);
//     bool agendadoActivo = fichaRegMod.agendado.activoMes.get(mes);
//     bool esNuevo = fichaRegMod.estado == 'nuevo';
//     if (!versionActiva && agendadoActivo && !esNuevo) {
//       int planificacionVieja = state()
//           .ficha!
//           .fficha
//           .ficha
//           .firstWhere((e) => e.id == fichaRegMod.id)
//           .planificado
//           .quincenaActivo
//           .total;
//       int planificacionNueva = fichaRegMod.planificado.quincenaActivo.total;

//       if (disponibilidadNew < 0 && planificacionNueva > planificacionVieja) {
//         fichaRegMod.error.setError(
//             mes: mes, error: 'Se ha superado el límite de disponibilidad');
//         fichaRegMod.error.setColor(mes: mes, color: Colors.red);
//       } else {
//         fichaRegMod.error.setError(mes: mes, error: '');
//         fichaRegMod.error.setColor(mes: mes, color: null);
//       }
//     }
//   }
// }
