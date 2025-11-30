// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../../bloc/main_bloc.dart';
// import '../../../../../../resources/field_pre/field_pre_texto.dart';
// import '../../../../model/ficha_reg/reg.dart';

// class BoxNumberEdit extends StatefulWidget {
//   final FichaReg fichaReg;
//   final String mes;

//   const BoxNumberEdit({
//     super.key,
//     required this.fichaReg,
//     required this.mes,
//   });

//   @override
//   State<BoxNumberEdit> createState() => _BoxNumberEditState();
// }

// class _BoxNumberEditState extends State<BoxNumberEdit> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MainBloc, MainState>(
//       builder: (context, state) {
//         bool pedidoActivo = widget.fichaReg.agendado.activoMes.get(widget.mes);
//         String error = widget.fichaReg.error.getError(widget.mes);
//         Color? color = widget.fichaReg.error.getColor(widget.mes);
//         return Padding(
//           padding: const EdgeInsets.only(left: 5, right: 5),
//           child: Tooltip(
//             message: error,
//             child: FieldTexto(
//               flex: null,
//               size: 14,
//               edit: pedidoActivo,
//               // opciones: wbes,
//               label: widget.mes,
//               color: color,
//               colorfondo: pedidoActivo ? null : Colors.grey,
//               initialValue: widget.fichaReg.planificado.mes.get(widget.mes),
//               isNumber: true,
//               asignarValor: (value) {
//                 context
//                     .read<MainBloc>()
//                     .fichaFichaController()
//                     .campoNumeros(item: widget.fichaReg.item)
//                     .cambiar(
//                       mes: widget.mes,
//                       value: value,
//                     );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
