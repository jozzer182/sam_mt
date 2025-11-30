// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../../base/main_bloc.dart';
// import '../../../../model/ficha_reg/reg.dart';

// class BoxCambios extends StatefulWidget {
//   final FichaReg fichaReg;
//   final String mes;
//   final double fontSize;

//   const BoxCambios({
//     key,
//     required this.fichaReg,
//     required this.mes,
//     this.fontSize = 9,
//   });

//   @override
//   State<BoxCambios> createState() => _BoxCambiosState();
// }

// class _BoxCambiosState extends State<BoxCambios> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MainBloc, MainState>(
//       builder: (context, state) {
//         List<EliminadosSingle> cambiosList =
//             state.ficha!.cambios.cambiosList;
//         int cambios = cambiosList
//             .where((e) =>
//                 e.e4e == widget.fichaReg.e4e &&
//                 e.circuito == widget.fichaReg.circuito)
//             .length;
//         return Text(
//           cambios.toString(),
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: widget.fontSize,
//           ),
//         );
//       },
//     );
//   }
// }
