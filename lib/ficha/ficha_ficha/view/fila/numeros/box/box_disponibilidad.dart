// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../../bloc/main_bloc.dart';
// import '../../../../../../resources/a_entero_2.dart';
// import '../../../../model/ficha_reg/reg.dart';

// class BoxDisponibilidad extends StatefulWidget {
//   final FichaReg fichaReg;
//   final String mes;
//   final double fontSize;
//   const BoxDisponibilidad({
//     super.key,
//     required this.fichaReg,
//     required this.mes,
//     this.fontSize = 9,
//   });

//   @override
//   State<BoxDisponibilidad> createState() => _BoxDisponibilidadState();
// }

// class _BoxDisponibilidadState extends State<BoxDisponibilidad> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MainBloc, MainState>(
//       builder: (context, state) {
//         String disponibilidad = widget.fichaReg.disponible.get(widget.mes);
//         Color? colorDisponibilidad;
//         bool hayDisponibilidad = aEntero(disponibilidad) >= 0;
//         if (!hayDisponibilidad) {
//           colorDisponibilidad = Theme.of(context).colorScheme.error;
//         }
//         return Text(
//           disponibilidad,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: widget.fontSize,
//             color: colorDisponibilidad,
//           ),
//         );
//       },
//     );
//   }
// }
