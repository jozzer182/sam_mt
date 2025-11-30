// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../../bloc/main_bloc.dart';
// import '../../../../model/ficha_reg/reg.dart';

// class BoxRiesgo extends StatefulWidget {
//   final FichaReg fichaReg;
//   final String mes;
//   final double fontSize;

//   const BoxRiesgo({
//     super.key,
//     required this.fichaReg,
//     required this.mes,
//     this.fontSize = 9,
//   });

//   @override
//   State<BoxRiesgo> createState() => _BoxRiesgoState();
// }

// class _BoxRiesgoState extends State<BoxRiesgo> {
//   int riesgo = 0;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MainBloc, MainState>(
//       builder: (context, state) {
//         int riesgo = widget.fichaReg.riesgo.mesRiesgo(widget.mes);
//         return Text(
//           riesgo.toString(),
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: widget.fontSize,
//             color: riesgo > 0 ? Colors.red : null,
//           ),
//         );
//       },
//     );
//   }
// }
