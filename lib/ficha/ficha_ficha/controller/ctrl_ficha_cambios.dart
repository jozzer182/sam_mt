// import '../../../base/main__bl.dart';
// import '../../../base/main_bloc.dart';
// import '../../main/ficha/model/ficha_model.dart';
// import '../model/ficha__ficha_model.dart';
// import '../model/ficha_reg/reg.dart';

// class CtrlFFichaCambios {
//   final Bl bl;
//   late MainState Function() state;
//   late var emit;
//   late void Function(MainEvent p1) add;
//   late Ficha ficha;
//   late FFicha fficha;
//   CtrlFFichaCambios(this.bl) {
//     emit = bl.emit;
//     state = bl.state;
//     add = bl.add;
//     ficha = state().ficha!;
//     fficha = state().ficha!.fficha;
//   }

//   bool get hayCambios {
//     List<FichaReg> fichaModificada = fficha.fichaModificada;
//     List<FichaReg> fichaOriginal = fficha.ficha;
//     if (fichaModificada.length != fichaOriginal.length) {
//       return true;
//     }
//     for (var i = 0; i < fichaModificada.length; i++) {
//       if (fichaModificada[i] != fichaOriginal[i]) {
//         return true;
//       }
//     }
//     return false;
//   }

//   String get cambios {
//     List<FichaReg> fichaModificada = fficha.fichaModificada;
//     List<FichaReg> fichaOriginal = fficha.ficha;
//     String mensaje = '';
//     List<String> codigosPorAprobar =
//         state().codigosPorAprobar!.codigosPorAprobar.map((e) => e.e4e).toList();
//     for (var i = 0; i < fichaOriginal.length; i++) {
//       if (fichaModificada[i] != fichaOriginal[i]) {
//         String cambio = detectorCambiosFicha(
//           newFEM: fichaModificada[i],
//           oldFEM: fichaOriginal[i],
//         );
//         String controlado;
//         if (codigosPorAprobar.contains(fichaModificada[i].e4e)) {
//           controlado = '(Sujeto A Aprobación)';
//         } else {
//           controlado = '';
//         }
//         if (cambio.isNotEmpty) {
//           mensaje +=
//               '${fichaModificada[i].item} - ${fichaModificada[i].e4e} - $cambio | $controlado\n';
//         }
//         _addLibreControlado(fichaModificada[i], cambio);
//         if (controlado.isEmpty) {
//           _addEliminado(fichaOriginal[i], cambio);
//         }
//       }
//     }
//     if (fichaModificada.length > fichaOriginal.length) {
//       for (var i = fichaOriginal.length; i < fichaModificada.length; i++) {
//         String controlado = codigosPorAprobar.contains(fichaModificada[i].e4e)
//             ? '(Sujeto A Aprobación)'
//             : '';
//         mensaje +=
//             '${fichaModificada[i].item} - ${fichaModificada[i].e4e} - Nuevo | $controlado\n';
//         _addLibreControlado(fichaModificada[i], 'Nuevo');
//       }
//     }
//     emit(state().copyWith(ficha: ficha));
//     return mensaje;
//   }

//   void _addLibreControlado(FichaReg fichaReg, String cambio) {
//     fichaReg.log.cambio = cambio;
//     List<String> codigosPorAprobar =
//         state().codigosPorAprobar!.codigosPorAprobar.map((e) => e.e4e).toList();
//     if (codigosPorAprobar.contains(fichaReg.e4e)) {
//       fficha.controlados.add(fichaReg);
//     } else {
//       fficha.libres.add(fichaReg);
//     }
//   }

//   void _addEliminado(FichaReg fichaReg, String cambio) {
//     fichaReg.log.cambio = cambio;
//     fficha.eliminados.add(fichaReg);
//   }
// }
