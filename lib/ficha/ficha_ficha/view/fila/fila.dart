import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../bloc/main_bloc.dart';
import '../../model/ficha__ficha_model.dart';
import '../../model/ficha_reg/reg.dart';
import 'descripcion/descripcion.dart';
import '../widgets/sizedrow.dart';
import 'numeros/numeros.dart';

class Fila extends StatefulWidget {
  final FichaReg fem;
  const Fila({
    required this.fem,
    key,
  });

  @override
  State<Fila> createState() => _FilaState();
}

class _FilaState extends State<Fila> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        FFicha fficha = state.ficha!.fficha;
        bool verDinero = fficha.verDinero;
        return SizedRow(
          height: verDinero ? 25 : 50,
          children: [
            Expanded(
              flex: 8,
              child: Descripcion(
                fichaReg: widget.fem,
              ),
            ),
            const Gap(2),
            Expanded(
              flex: 12,
              child: Numeros(
                fichaReg: widget.fem,
              ),
            ),
          ],
        );
      },
    );
  }
}
