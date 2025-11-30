import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/main_bloc.dart';
import '../../../../model/ficha_reg/reg.dart';
import '../numeros_dialogo.dart';
import 'box_number_show.dart';
import 'box_agendado.dart';

class BoxNumber extends StatefulWidget {
  final String mes;
  final FichaReg fichaReg;
  const BoxNumber({
    required this.mes,
    required this.fichaReg,
    key,
  });

  @override
  State<BoxNumber> createState() => _BoxNumberState();
}

class _BoxNumberState extends State<BoxNumber> {
  double largoTexto = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        bool versionActiva = widget.fichaReg.version.get(widget.mes);
        return Expanded(
          flex: 1,
          child: InkWell(
            onDoubleTap: () {
              showDialog(
                context: context,
                builder: (context) => NumerosDialogo(
                  mes: widget.mes,
                  fichaReg: widget.fichaReg,
                ),
              );
            },
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => NumerosDialogo(
                  mes: widget.mes,
                  fichaReg: widget.fichaReg,
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: versionActiva
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  BoxNumberShow(
                    mes: widget.mes,
                    fichaReg: widget.fichaReg,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BoxAgendado(
                        fichaReg: widget.fichaReg,
                        mes: widget.mes,
                      ),
                      SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
