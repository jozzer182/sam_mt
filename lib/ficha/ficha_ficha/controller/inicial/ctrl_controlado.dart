// import 'package:fem_app/codigosporaprobar/model/codigosporaprobar_model.dart';

// import '../../../../bloc/main__bl.dart';
// import '../../../../bloc/main_bloc.dart';
// import '../../../main/ficha/model/ficha_model.dart';
// import '../../model/ficha__ficha_model.dart';
// import '../../model/ficha_reg/reg.dart';

// class CtrlFfichaInicialControlado {
//   final Bl bl;
//   late MainState Function() state;
//   late var emit;
//   late void Function(MainEvent p1) add;
//   late Ficha ficha;
//   late FFicha fficha;

//   CtrlFfichaInicialControlado(this.bl) {
//     emit = bl.emit;
//     state = bl.state;
//     add = bl.add;
//     ficha = state().ficha!;
//     fficha = state().ficha!.fficha;
//   }

//   get asignar {
//     List<FichaReg> fichaReal = fficha.ficha;
//     List<FichaReg> fichaModificada = fficha.fichaModificada;
//     CodigosPorAprobar codigosPorAprobar = state().codigosPorAprobar!;

//     for (List<FichaReg> ficha in [fichaReal, fichaModificada]) {
//       for (FichaReg fichaReg in ficha) {
//         fichaReg.esControlado = codigosPorAprobar.codigosPorAprobar
//             .map((e) => e.e4e)
//             .contains(fichaReg.e4e);
//       }
//     }
//   }
// }
