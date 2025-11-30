import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';
import '../../../model/ficha__ficha_model.dart';
import '../../../model/ficha_reg/reg.dart';

class CtoWbe extends StatefulWidget {
  final FichaReg fichaReg;
  const CtoWbe({
    required this.fichaReg,
    key,
  });

  @override
  State<CtoWbe> createState() => _CtoWbeState();
}

class _CtoWbeState extends State<CtoWbe> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        FFicha ficha = state.ficha!.fficha;
        // bool edit = ficha.editar;
        bool verCto = ficha.verCto;
        // if (edit) {
        //   List<String> ctos = state.fem!
        //       .obtenerAno(aEntero(state.year!))
        //       .map((e) => e.circuito.toUpperCase().trim())
        //       .where((e) => e.isNotEmpty)
        //       .toSet()
        //       .toList();
        //   ctos.sort();
        //   List<PlataformaSingle> plataformaList = state
        //       .plataforma!.plataformaList
        //       .where((e) =>
        //           e.material == widget.fichaReg.e4e && !e.status.contains('CTEC'))
        //       .toList();
        //   List<String> wbes = plataformaList
        //       .map((e) => '${e.wbe} - ${e.ctd} - ${e.proyecto}')
        //       .toSet()
        //       .toList();
        //   return Expanded(
        //     flex: 2,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         Tooltip(
        //           message: widget.fichaReg.error.circuito,
        //           child: FieldTexto(
        //             flex: null,
        //             size: 14,
        //             edit: true,
        //             opciones: ctos,
        //             label: 'Cto',
        //             color: widget.fichaReg.error.circuitoColor,
        //             initialValue: widget.fichaReg.circuito,
        //             asignarValor: (valor) {
        //               context
        //                   .read<MainBloc>()
        //                   .fichaFichaController()
        //                   .campoDescripcion(
        //                     item: widget.fichaReg.item,
        //                   )
        //                   .cambiar(
        //                     tipo: TipoRegFicha.circuito,
        //                     value: valor.toUpperCase(),
        //                   );
        //             },
        //           ),
        //         ),
        //         Tooltip(
        //           message: widget.fichaReg.error.wbe,
        //           child: Row(
        //             children: [
        //               FieldTexto(
        //                 flex: 1,
        //                 size: 14,
        //                 edit: true,
        //                 opciones: wbes,
        //                 label: 'Wbe',
        //                 color: widget.fichaReg.error.wbeColor,
        //                 colorfondo: widget.fichaReg.error.wbeColorFill,
        //                 initialValue: widget.fichaReg.wbe,
        //                 asignarValor: (valor) {
        //                   String wbe = valor.split(' - ')[0];
        //                   context
        //                       .read<MainBloc>()
        //                       .fichaFichaController()
        //                       .campoDescripcion(
        //                         item: widget.fichaReg.item,
        //                       )
        //                       .cambiar(
        //                         tipo: TipoRegFicha.wbe,
        //                         value: wbe,
        //                       );
        //                 },
        //               ),
        //               SizedBox(
        //                 width: 14, // Ancho deseado
        //                 height: 14, // Alto deseado
        //                 child: ElevatedButton(
        //                   onPressed: () {
        //                     showDialog(
        //                       context: context,
        //                       builder: (context) {
        //                         return WbeDescripcionDialog(
        //                           fichaReg: widget.fichaReg,
        //                         );
        //                       },
        //                     );
        //                   },
        //                   style: ElevatedButton.styleFrom(
        //                     padding: const EdgeInsets.all(0),
        //                     fixedSize: const Size(14, 14),
        //                     backgroundColor: widget.fichaReg.error.wbeColorFill,
        //                   ),
        //                   child: const Icon(
        //                     Icons.search,
        //                     size: 14,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   );
        // }

        // if (verCto) {
          return Expanded(
            flex: 2,
            child: Text(
              widget.fichaReg.circuito,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        // } else {
        //   return Expanded(
        //     flex: 2,
        //     child: Text(
        //       widget.fichaReg.wbe,
        //       style: const TextStyle(fontSize: 12),
        //       textAlign: TextAlign.center,
        //     ),
        //   );
        // }
      },
    );
  }
}
