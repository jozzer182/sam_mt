import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';
import '../../../../../mm60/model/mm60_model.dart';
import '../../../../../resources/a_entero_2.dart';
import '../../../model/ficha__ficha_model.dart';
import '../../../model/ficha_reg/reg.dart';
import '../../methods/to_mcop.dart';

class Total extends StatelessWidget {
  final FichaReg fichaReg;
  const Total({
    required this.fichaReg,
    key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        FFicha fficha = state.ficha!.fficha;
        bool verDinero = fficha.verDinero;
        Mm60Single mm60Find = state.mm60!.mm60List.firstWhere(
          (e) => e.material == fichaReg.e4e,
          orElse: () => Mm60Single.fromInit(),
        );
        int precio = aEntero(mm60Find.precio);
        return Expanded(
          flex: 1,
          child: Text(
            verDinero
                ? toMCOP(precio, fichaReg.planificado.mes.total)
                : fichaReg.planificado.mes.total.toString(),
            style: TextStyle(
              fontSize: 10,
              color: fichaReg.planificado.mes.total != 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
