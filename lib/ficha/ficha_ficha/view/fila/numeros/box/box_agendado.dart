import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/main_bloc.dart';
import '../../../../model/ficha_reg/reg.dart';

class BoxAgendado extends StatefulWidget {
  final FichaReg fichaReg;
  final String mes;
  final double fontSize;
  const BoxAgendado({
    key,
    required this.fichaReg,
    required this.mes,
    this.fontSize = 9,
  });

  @override
  State<BoxAgendado> createState() => _BoxAgendadoState();
}

class _BoxAgendadoState extends State<BoxAgendado> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        String pedido =
            widget.fichaReg.agendado.mes.get(widget.mes);
        Color? colorPedido = widget.fichaReg.agendado.color.get(widget.mes)
            ? Theme.of(context).colorScheme.error
            : null;
        return Text(
          pedido,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: colorPedido,
          ),
        );
      },
    );
  }
}
