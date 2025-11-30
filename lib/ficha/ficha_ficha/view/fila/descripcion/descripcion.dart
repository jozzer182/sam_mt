import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../bloc/main_bloc.dart';
import '../../../model/ficha_reg/reg.dart';
import 'descripcion_ctowbe.dart';
import 'descripcion_descomentario.dart';
import 'descripcion_e4e.dart';

class Descripcion extends StatefulWidget {
  final FichaReg fichaReg;
  const Descripcion({
    required this.fichaReg,
    key,
  });

  @override
  State<Descripcion> createState() => _DescripcionState();
}

class _DescripcionState extends State<Descripcion> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Row(
          children: [
            Tooltip(
              message: widget.fichaReg.esControlado ? "Controlado" : "",
              child: Text(
                widget.fichaReg.item,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.fichaReg.esControlado ? Colors.grey[500] : null,
                ),
              ),
            ),
            const Gap(1),
            CtoWbe(fichaReg: widget.fichaReg),
            const Gap(1),
            E4eSpace(fichaReg: widget.fichaReg),
            const Gap(1),
            DesComentario(fem: widget.fichaReg),
            const Gap(2),
            SizedBox(
              width: 25,
              child: Text(
                widget.fichaReg.um,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
