// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../../bloc/main_bloc.dart';
// import '../../../../../ficha_solicitados/model/ficha_solicitados_single_model.dart';
// import '../../../../model/ficha_reg/reg.dart';

// class BoxSolicitado extends StatefulWidget {
//   final FichaReg fichaReg;
//   final String mes;
//   final double fontSize;

//   const BoxSolicitado({
//     required this.fichaReg,
//     required this.mes,
//     this.fontSize = 9,
//     super.key,
//   });

//   @override
//   State<BoxSolicitado> createState() => _BoxSolicitadoState();
// }

// class _BoxSolicitadoState extends State<BoxSolicitado> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MainBloc, MainState>(
//       builder: (context, state) {
//         List<SolicitadoSingle> solicitadosList =
//             state.ficha!.solicitados.solicitadosList;
//         bool isSolicitado = solicitadosList.any((e) =>
//             e.e4e == widget.fichaReg.e4e &&
//             e.circuito == widget.fichaReg.circuito);
//         return Text(
//           isSolicitado ? 'si' : 'no',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: widget.fontSize,
//             color: isSolicitado ? Colors.red : null,
//           ),
//         );
//       },
//     );
//   }
// }
