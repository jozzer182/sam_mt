import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';
import '../../../model/ficha_reg/reg.dart';

class E4eSpace extends StatefulWidget {
  final FichaReg fichaReg;
  const E4eSpace({
    required this.fichaReg,
    key,
  });

  @override
  State<E4eSpace> createState() => _E4eSpaceState();
}

class _E4eSpaceState extends State<E4eSpace> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // FFicha ficha = state.ficha!.fficha;
        // bool edit = ficha.editar;
        // if (edit) {
        //   // List<PdisSingle> pdisList = state.pdis!.pdisList;
        //   // List<String> pdisListString = pdisList
        //   //     .map((e) => '${e.lote} - ${e.almacen}')
        //   //     .toList()
        //   //     .where((e) => e.isNotEmpty)
        //   //     .toList();
        //   // List<String> habilitados = state
        //   //     .codigosHabilitados!.codigoshabilitados
        //   //     .where((e) => e.e4e != '0')
        //   //     .map((e) => '${e.e4e} - ${e.descripcion}')
        //   //     .toList();
        //   // if (widget.fichaReg.id.length < 2) {
        //   //   return Expanded(
        //   //     flex: 2,
        //   //     child: Column(
        //   //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   //       children: [
        //   //         Tooltip(
        //   //           message: widget.fichaReg.error.e4e,
        //   //           child: FieldTexto(
        //   //             flex: null,
        //   //             size: 14,
        //   //             edit: true,
        //   //             label: 'E4e',
        //   //             color: widget.fichaReg.error.e4eColor,
        //   //             opciones: widget.fichaReg.e4e.length == 6
        //   //                 ? const []
        //   //                 : habilitados,
        //   //             initialValue: widget.fichaReg.e4e,
        //   //             asignarValor: (value) {
        //   //               // if (value.length == 6 || value.isEmpty) {
        //   //               String e4e = value.split(' - ')[0];
        //   //               context
        //   //                   .read<MainBloc>()
        //   //                   .fichaFichaController()
        //   //                   .campoDescripcion(
        //   //                     item: widget.fichaReg.item,
        //   //                   )
        //   //                   .cambiar(
        //   //                     tipo: TipoRegFicha.e4e,
        //   //                     value: e4e,
        //   //                   );
        //   //               // }
        //   //             },
        //   //           ),
        //   //         ),
        //   //         Tooltip(
        //   //           message: widget.fichaReg.error.pdi,
        //   //           child: FieldTexto(
        //   //             flex: null,
        //   //             size: 14,
        //   //             edit: true,
        //   //             label: 'Pdi',
        //   //             color: widget.fichaReg.error.pdiColor,
        //   //             opciones: pdisListString,
        //   //             initialValue: widget.fichaReg.pdi,
        //   //             asignarValor: (valor) {
        //   //               if (valor.isNotEmpty) {
        //   //                 if (pdisListString.contains(valor)) {
        //   //                   String pdi = valor.split(' - ')[0];
        //   //                   context
        //   //                       .read<MainBloc>()
        //   //                       .fichaFichaController()
        //   //                       .campoDescripcion(
        //   //                         item: widget.fichaReg.item,
        //   //                       )
        //   //                       .cambiar(
        //   //                         tipo: TipoRegFicha.pdi,
        //   //                         value: pdi,
        //   //                       );
        //   //                 } else {
        //   //                   context
        //   //                       .read<MainBloc>()
        //   //                       .fichaFichaController()
        //   //                       .campoDescripcion(
        //   //                         item: widget.fichaReg.item,
        //   //                       )
        //   //                       .cambiar(
        //   //                         tipo: TipoRegFicha.pdi,
        //   //                         value: '',
        //   //                       );
        //   //                 }
        //   //               }
        //   //             },
        //   //           ),
        //   //         ),
        //   //       ],
        //   //     ),
        //   //   );
        //   // }
        //   return Expanded(
        //     flex: 2,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         Text(
        //           widget.fichaReg.e4e,
        //           textAlign: TextAlign.center,
        //           style: const TextStyle(fontSize: 12),
        //         ),
        //         FieldTexto(
        //           flex: null,
        //           size: 14,
        //           edit: true,
        //           label: 'Pdi',
        //           color: widget.fichaReg.pdi.isEmpty ? Colors.red : null,
        //           opciones: pdisListString,
        //           initialValue: widget.fichaReg.pdi,
        //           asignarValor: (valor) {
        //             if (valor.isNotEmpty) {
        //               if (pdisListString.contains(valor)) {
        //                 String pdi = valor.split(' - ')[0];
        //                 context
        //                     .read<MainBloc>()
        //                     .fichaFichaController()
        //                     .campoDescripcion(
        //                       item: widget.fichaReg.item,
        //                     )
        //                     .cambiar(
        //                       tipo: TipoRegFicha.pdi,
        //                       value: pdi,
        //                     );
        //               } else {
        //                 context
        //                     .read<MainBloc>()
        //                     .fichaFichaController()
        //                     .campoDescripcion(
        //                       item: widget.fichaReg.item,
        //                     )
        //                     .cambiar(
        //                       tipo: TipoRegFicha.pdi,
        //                       value: '',
        //                     );
        //               }
        //             }
        //           },
        //         ),
        //       ],
        //     ),
        //   );
        // }
        return Expanded(
          flex: 2,
          child: Text(
            widget.fichaReg.e4e,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
