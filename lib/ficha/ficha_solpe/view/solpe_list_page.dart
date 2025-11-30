import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/view/solpe_doc/solpe_doc_page.dart';
import 'package:v_al_sam_v02/resources/titulo.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/field_pre/field_pre_texto.dart';
import '../../../resources/transicion_pagina.dart';
import '../../../user/user_model.dart';
import '../model/solpe_reg.dart';

class SolPeListPage extends StatefulWidget {
  const SolPeListPage({Key? key}) : super(key: key);

  @override
  State<SolPeListPage> createState() => _SolPeListPageState();
}

class _SolPeListPageState extends State<SolPeListPage> {
  String filter = '';
  String filterCircuito = '';
  List<SolPeReg> solPeList = [];
  int endList = 70;
  final ScrollController _controller = ScrollController();
  bool firstTimeLoading = true;
  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 70;
      });
    }
  }

  void initState() {
    // if (context.read<MainBloc>().state.ficha!.fficha.editar) {
    solPeList = context.read<MainBloc>().state.solPeList!.list;
    // } else {
    //   ficha = context.read<MainBloc>().state.ficha!.fficha.ficha;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        firstTimeLoading = false;
      });
    });
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.solPeList == null || firstTimeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        User user = state.user!;
        if (!user.permisos.contains('tratar_solpe')) {
          return const Center(child: Text('No tiene permisos para ver este elemento'));
        }

        String proyecto = state.ficha?.fficha.ficha.first.proyecto ?? "";
        solPeList = solPeList.where((e) => e.proyecto == proyecto).toList();
        List<SolPeReg> solPeListOriginal =
            state.solPeList!.list.where((e) => e.proyecto == proyecto).toList();
        List<String> circuitos = state.solPeList!.list
            .map((e) => e.circuito)
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList();
        List<SolPeReg> solPeListShow = [];
        if (solPeList.length > endList) {
          solPeListShow = solPeList.sublist(0, endList);
        } else {
          solPeListShow = solPeList;
        }

        return Column(
          children: [
            const Gap(10),
            Row(
              children: [
                const Gap(10),
                FieldTexto(
                  flex: 1,
                  label: 'Búsqueda',
                  edit: true,
                  initialValue: filter,
                  asignarValor: (value) {
                    setState(() {
                      filter = value;
                      solPeList = solPeListOriginal
                          .where((e) => e.toList().any((e) =>
                              e.toLowerCase().contains(filter.toLowerCase())))
                          .toList();
                    });
                  },
                ),
                const Gap(10),
                FieldTexto(
                  flex: 1,
                  label: 'Circuito',
                  edit: true,
                  opciones: circuitos,
                  initialValue: filterCircuito,
                  asignarValor: (value) {
                    if (circuitos.contains(value)) {
                      setState(() {
                        filterCircuito = value;
                        solPeList = solPeListOriginal
                            .where(
                              (e) => e.toList().any(
                                    (e) => e
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()),
                                  ),
                            )
                            .where(
                              (e) =>
                                  e.circuito.toUpperCase() ==
                                  filterCircuito.toUpperCase(),
                            )
                            .toList();
                      });
                    } else {
                      setState(() {
                        filterCircuito = '';
                        solPeList = solPeListOriginal
                            .where((e) => e.toList().any((e) =>
                                e.toLowerCase().contains(filter.toLowerCase())))
                            .toList();
                      });
                    }
                  },
                ),
                const Gap(10),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                for (ToCelda celda in state.solPeList?.celdas ?? [])
                  Expanded(
                    flex: celda.flex,
                    child: Text(
                      celda.valor,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(10),
            Expanded(
              child: ListView.builder(
                itemCount: solPeListShow.length,
                itemBuilder: (context, index) {
                  void goTo(Widget page) =>
                      Navigator.push(context, createRoute(page));

                  ir() {
                    context.read<MainBloc>().fichaSolPeListController.setDoc(
                          solPeList
                              .where((e) =>
                                  e.pedidonumber ==
                                  solPeListShow[index].pedidonumber)
                              .map(
                                (e) => e.copyWith(),
                              )
                              .toList(),
                        );
                    goTo(SolpeDocPage(esNuevo: false));
                  }

                  Color? colorFondo;
                  if (solPeListShow[index].estado == "Anulado") {
                    colorFondo = Colors.grey[300];
                  }
                  if (solPeListShow[index].estado == "Aprobado") {
                    colorFondo = Colors.green[300];
                  }
                  if (solPeListShow[index].estado == "Rechazado") {
                    colorFondo = Colors.red[300];
                  }
                  return InkWell(
                    onTap: () => ir(),
                    onDoubleTap: () => ir(),
                    onLongPress: () => ir(),
                    child: Container(
                      color: colorFondo,
                      child: Row(
                        children: [
                          for (ToCelda celda in solPeListShow[index].celdas)
                            Expanded(
                              flex: celda.flex,
                              child: Text(
                                celda.valor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
