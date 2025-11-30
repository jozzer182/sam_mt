import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/main_bloc.dart';
import '../../../../../../mm60/model/mm60_model.dart';
import '../../../../../../resources/a_entero_2.dart';
import '../../../../model/ficha_reg/reg.dart';
import '../../../methods/to_mcop.dart';

class BoxNumberShow extends StatefulWidget {
  final FichaReg fichaReg;
  final String mes;
  final double fontSize;

  const BoxNumberShow({
    key,
    required this.fichaReg,
    required this.mes,
    this.fontSize = 14,
  });

  @override
  State<BoxNumberShow> createState() => _BoxNumberShowState();
}

class _BoxNumberShowState extends State<BoxNumberShow> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        bool verDinero = state.ficha!.fficha.verDinero;
        String numero = widget.fichaReg.planificado.mes.get(widget.mes);
        Color? colorPrincipal = widget.fichaReg.planificado.color.get(widget.mes);
        bool pedidoActivo = widget.fichaReg.agendado.activoMes.get(widget.mes);
        Mm60Single mm60Find = state.mm60!.mm60List.firstWhere(
          (e) => e.material == widget.fichaReg.e4e,
          orElse: () => Mm60Single.fromInit(),
        );
        int precio = aEntero(mm60Find.precio);
        return Text(
          verDinero ? toMCOP(precio, aEntero(numero)) : numero,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: colorPrincipal,
            decoration: pedidoActivo ? null : TextDecoration.lineThrough,
          ),
        );
      },
    );
  }
}
