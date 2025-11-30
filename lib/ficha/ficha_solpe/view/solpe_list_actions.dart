import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_reg.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/view/solpe_doc/solpe_doc_page.dart';
import 'package:v_al_sam_v02/resources/transicion_pagina.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/descarga_hojas.dart';
import '../../../user/user_model.dart';

class ActionsSolPe extends StatefulWidget {
  final ValueNotifier<int> selectedTabIndex;
  final TabController tabController;
  const ActionsSolPe({
    required this.selectedTabIndex,
    required this.tabController,
    key,
  });

  @override
  State<ActionsSolPe> createState() => _ActionsSolPeState();
}

class _ActionsSolPeState extends State<ActionsSolPe> {
  bool verDinero = false;
  // bool editar = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // bool edit = state.ficha!.fficha.editar;
        User user = state.user!;
        if (!user.permisos.contains('tratar_solpe')) {
          return const SizedBox();
        }

        return ValueListenableBuilder<int>(
          valueListenable: widget.selectedTabIndex,
          builder: (c, value, child) {
            // bool editar = context.watch<MainBloc>().state.ficha!.fficha.editar;
            bool esFichaTab = widget.tabController.index == 2;
            if (esFichaTab) {
              return Row(
                children: [
                  ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Theme.of(context).colorScheme.secondary,
                    // ),
                    onPressed: () {
                      List<Map<String, dynamic>> datos = state.solPeList?.list
                              .map((e) => e.toMap())
                              .toList() ??
                          [];
                      DescargaHojas.ahoraMap(
                        datos: datos,
                        nombre:
                            'Solicitud Pedidos de ${state.solPeList?.list.first.pdi}',
                        user: context.read<MainBloc>().state.user!,
                      );
                    },
                    child: const Text('Descargar'),
                  ),
                  const Gap(5),
                  ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Theme.of(context).colorScheme.secondary,
                    // ),
                    onPressed: () {
                      context.read<MainBloc>().fichaSolPeListController.setDoc(
                            List.generate(
                              3,
                              (index) => SolPeReg.fromIndex(index)
                                ..proyecto =
                                    state.ficha!.fficha.ficha.first.proyecto
                                ..unidad = state.ficha!.fficha.ficha.last.unidad
                                ..iden = state.ficha!.fficha.ficha.first.iden
                                ..pdi = state.user!.pdi
                                ..e4eColor = Colors.red
                                ..e4eError = 'Falta código'
                                ..ctdsColor = Colors.red
                                ..ctdsError = 'Debe ser mayor a 0'
                                ..pedidonumber = "Pendiente.."
                                ..estado = "Borrador"
                                ..ecpersona = state.user!.correo,
                            ),
                          );
                      context.read<MainBloc>().solPeDocController.setNuevo;
                      goTo(
                        context,
                        SolpeDocPage(esNuevo: true),
                      );
                    },
                    child: const Text('Nuevo Pedido'),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
