// import '../../../../bloc/main__bl.dart';
// import '../../../../bloc/main_bloc.dart';
// import '../../../../versiones/model/versiones_model.dart';
// import '../../model/ficha__ficha_model.dart';
// import '../../model/ficha_reg/reg.dart';

// class CtrlFfichaInicialOficial {
//   final Bl bl;
//   late MainState Function() state;
//   late var emit;
//   late void Function(MainEvent p1) add;
//   late FFicha fficha;

//   CtrlFfichaInicialOficial(this.bl) {
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
//         VersionesSingle oficial = fficha.version.firstWhere(
//           (e) => e.e4e == fichaReg.e4e,
//           orElse: () => VersionesSingle.fromZero(),
//         );
//         fichaReg.oficial.m01 = oficial.m01;
//         fichaReg.oficial.m02 = oficial.m02;
//         fichaReg.oficial.m03 = oficial.m03;
//         fichaReg.oficial.m04 = oficial.m04;
//         fichaReg.oficial.m05 = oficial.m05;
//         fichaReg.oficial.m06 = oficial.m06;
//         fichaReg.oficial.m07 = oficial.m07;
//         fichaReg.oficial.m08 = oficial.m08;
//         fichaReg.oficial.m09 = oficial.m09;
//         fichaReg.oficial.m10 = oficial.m10;
//         fichaReg.oficial.m11 = oficial.m11;
//         fichaReg.oficial.m12 = oficial.m12;
//       }
//     }
//   }
// }
