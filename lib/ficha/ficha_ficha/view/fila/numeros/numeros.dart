import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../bloc/main_bloc.dart';
import '../../../model/ficha_reg/reg.dart';
import 'box/box.dart';
import 'numeros_total.dart';

class Numeros extends StatefulWidget {
  final FichaReg fichaReg;

  const Numeros({
    required this.fichaReg,
    key,
  });

  @override
  State<Numeros> createState() => _NumerosState();
}

class _NumerosState extends State<Numeros> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Row(
          children: [
            BoxNumber(
              mes: '01',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '02',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '03',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '04',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '05',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '06',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '07',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '08',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '09',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '10',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '11',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
            BoxNumber(
              mes: '12',
              fichaReg: widget.fichaReg,
            ),
            const Gap(1),
             Total(
              fichaReg: widget.fichaReg,
            ),
          ],
        );
      },
    );
  }
}


