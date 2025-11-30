// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../../bloc/main_bloc.dart';
// import '../../../../model/ficha_reg/reg.dart';

// class BoxOficial extends StatefulWidget {
//   final FichaReg fichaReg;
//   final String mes;
//   final double fontSize;
//   const BoxOficial({
//     required this.fichaReg,
//     required this.mes,
//     this.fontSize = 9,
//     super.key,
//   });

//   @override
//   State<BoxOficial> createState() => _BoxOficialState();
// }

// class _BoxOficialState extends State<BoxOficial> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MainBloc, MainState>(
//       builder: (context, state) {
//         String oficial = widget.fichaReg.oficial.mesOficial(widget.mes);
//         return Text(
//           oficial,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: widget.fontSize,
//           ),
//         );
//       },
//     );
//   }
// }
