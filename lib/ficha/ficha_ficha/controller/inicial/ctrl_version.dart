// import '../../../../bloc/main__bl.dart';
// import '../../../../bloc/main_bloc.dart';
// import '../../../../nuevo/model/nuevo_model.dart';
// import '../../model/ficha__ficha_model.dart';
// import '../../model/ficha_reg/reg.dart';

// class CtrlFfichaInicialVersion {
//   final Bl bl;
//   late MainState Function() state;
//   late var emit;
//   late void Function(MainEvent p1) add;
//   late FFicha fficha;

//   CtrlFfichaInicialVersion(this.bl) {
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
//         _setVerActivaMes('01', fichaReg);
//         _setVerActivaMes('02', fichaReg);
//         _setVerActivaMes('03', fichaReg);
//         _setVerActivaMes('04', fichaReg);
//         _setVerActivaMes('05', fichaReg);
//         _setVerActivaMes('06', fichaReg);
//         _setVerActivaMes('07', fichaReg);
//         _setVerActivaMes('08', fichaReg);
//         _setVerActivaMes('09', fichaReg);
//         _setVerActivaMes('10', fichaReg);
//         _setVerActivaMes('11', fichaReg);
//         _setVerActivaMes('12', fichaReg);
//       }
//     }
//   }

//   void _setVerActivaMes(String mes, FichaReg fichaReg) {
//     Map<String, EnableDate> dates =
//         state().fechasFEM!.enableDates(state().year!);
//     bool verActiva = dates[mes]!.versionActivaq2;
//     fichaReg.version.set(mes, verActiva);
//   }
// }
