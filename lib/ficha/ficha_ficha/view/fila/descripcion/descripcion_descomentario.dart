import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';
import '../../../../../mm60/model/mm60_model.dart';
import '../../../../../resources/a_entero_2.dart';
import '../../../model/ficha_reg/reg.dart';
import '../../methods/to_mcop.dart';

class DesComentario extends StatefulWidget {
  final FichaReg fem;
  const DesComentario({
    required this.fem,
    key,
  });

  @override
  State<DesComentario> createState() => _DesComentarioState();
}

class _DesComentarioState extends State<DesComentario> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // FFicha ficha = state.ficha!.fficha;
        // bool edit = ficha.editar;
        Mm60Single mm60Find = state.mm60!.mm60List.firstWhere(
          (e) => e.material == widget.fem.e4e,
          orElse: () => Mm60Single.fromInit(),
        );
        int precio = aEntero(mm60Find.precio);
        // if (edit) {
        //   return Expanded(
        //     flex: 4,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         Text(
        //           widget.fem.descripcion,
        //           style: const TextStyle(fontSize: 9),
        //         ),
        //         FieldTexto(
        //           flex: null,
        //           size: 14,
        //           edit: true,
        //           label: 'Comentario',
        //           initialValue: widget.fem.comentario2,
        //           asignarValor: (valor) {
        //             context
        //                 .read<MainBloc>()
        //                 .fichaFichaController()
        //                 .campoDescripcion(
        //                   item: widget.fem.item,
        //                 )
        //                 .cambiar(
        //                   tipo: TipoRegFicha.comentario2,
        //                   value: valor,
        //                 );
        //           },
        //         ),
        //       ],
        //     ),
        //   );
        // }
        return Expanded(
          flex: 4,
          child: RichText(
            text: TextSpan(
              text: '',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: widget.fem.descripcion,
                  style: const TextStyle(fontSize: 12),
                ),
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(fontSize: 12),
                ),
                TextSpan(
                  text: "${toMCOP(precio, 1)} MCOP",
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
