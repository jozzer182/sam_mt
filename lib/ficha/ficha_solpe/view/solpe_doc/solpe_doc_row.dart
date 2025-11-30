import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_reg_enum.dart';
import 'package:v_al_sam_v02/resources/field_pre/field_pre.dart';

import '../../../../bloc/main_bloc.dart';
import '../../model/solpe_reg.dart';

class SolPeRow extends StatefulWidget {
  final int index;
  const SolPeRow(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  State<SolPeRow> createState() => _SolPeRowState();
}

class _SolPeRowState extends State<SolPeRow> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.solPeDoc == null || state.mm60 == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        SolPeReg reg =
            state.solPeDoc?.list[widget.index] ?? SolPeReg.fromInit();
        List<String> e4es =
            state.mm60?.mm60List.map((e) => e.material).toList() ?? [];
        bool editar = state.solPeDoc?.editar ?? false;
        bool esNuevo = state.solPeDoc?.esNuevo ?? false;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      reg.pos,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FieldPre(
                    flex: 3,
                    initialValue: reg.e4e,
                    opciones: e4es,
                    label: '',
                    color: reg.e4eColor,
                    edit: editar || esNuevo,
                    tipoCampo: TipoCampo.texto,
                    isNumber: true,
                    asignarValor: (value) {
                      context.read<MainBloc>().solPeDocController.campo.cambiar(
                            tipo: CampoSolpe.e4e,
                            value: value,
                            index: widget.index,
                          );
                    },
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      reg.descripcion,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      reg.um,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FieldPre(
                    flex: 3,
                    initialValue: reg.ctds == 0 ? '' : '${reg.ctds}',
                    label: '',
                    color: reg.ctdsColor,
                    edit: editar || esNuevo,
                    tipoCampo: TipoCampo.texto,
                    isNumber: true,
                    asignarValor: (value) {
                      context.read<MainBloc>().solPeDocController.campo.cambiar(
                            tipo: CampoSolpe.ctds,
                            value: value,
                            index: widget.index,
                          );
                    },
                  ),
                  const Gap(5),
                  FieldPre(
                    flex: 3,
                    initialValue: '${reg.ctdp}',
                    label: '',
                    color: Colors.grey,
                    colorfondo: Colors.grey[300]!,
                    edit: false,
                    tipoCampo: TipoCampo.texto,
                    isNumber: true,
                    asignarValor: (value) {},
                  ),
                ],
              ),
              if (reg.errors.isNotEmpty)
                Text(
                  '*${reg.errors}',
                  style: TextStyle(
                    fontSize: 12,
                    color: reg.errorColor,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
