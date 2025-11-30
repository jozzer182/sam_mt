// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/resources/a_entero_2.dart';

import '../../../resources/descarga_hojas.dart';
import '../../../resources/titulo.dart';
import '../../bloc/main_bloc.dart';
import '../../registros/view/registros_page.dart';
import '../../version.dart';
import '../model/deudaoperativa_model.dart';

class DeudaOperativaPageNew extends StatefulWidget {
  const DeudaOperativaPageNew({super.key});

  @override
  State<DeudaOperativaPageNew> createState() => _DeudaOperativaPageNewState();
}

class _DeudaOperativaPageNewState extends State<DeudaOperativaPageNew> {
  String filter = '';
  int endList = 70;
  bool firstTimeLoading = true;
  final ScrollController _controller = ScrollController();
  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 70;
      });
    }
  }

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(title: const Text('DEUDA OPERATIVA')),
      floatingActionButton: BlocSelector<MainBloc, MainState, DeudaOperativaB?>(
        selector: (state) => state.deudaOperativaB,
        builder: (context, state) {
          if (state == null) {
            return const CircularProgressIndicator();
          } else {
            return FloatingActionButton(
              onPressed:
                  () => DescargaHojas().ahora(
                    datos: state.deudaOperativaB,
                    nombre: 'DEUDA OPERATIVA',
                    user: context.read<MainBloc>().state.user!,
                  ),
              child: const Icon(Icons.download),
            );
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        filter = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Búsqueda',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(5),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              List<ToCelda> titles = state.deudaOperativaB!.titles;
              return Row(
                children: [
                  for (ToCelda celda in titles)
                    Expanded(
                      flex: celda.flex,
                      child: Text(
                        celda.valor,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              );
            },
          ),
          const Gap(5),
          Expanded(
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                if (state.deudaOperativaB == null || firstTimeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<DeudaOperativaBSingle> deudaOperativaList =
                    state.deudaOperativaB!.deudaOperativaB;
                deudaOperativaList =
                    deudaOperativaList
                        .where(
                          (e) => e.toList().any(
                            (el) =>
                                el.toLowerCase().contains(filter.toLowerCase()),
                          ),
                        )
                        .toList();
                if (deudaOperativaList.length > endList) {
                  deudaOperativaList = deudaOperativaList.sublist(0, endList);
                }
                void goTo(Widget page) {
                  Navigator.push(context, version.createRoute(page));
                }

                return SingleChildScrollView(
                  controller: _controller,
                  child: SelectableRegion(
                    focusNode: FocusNode(),
                    selectionControls: emptyTextSelectionControls,
                    child: Column(
                      children: [
                        for (DeudaOperativaBSingle deuda in deudaOperativaList)
                          Builder(
                            builder: (context) {
                              Color? color;
                              if (aEntero(deuda.faltanteUnidades) > 0) {
                                color = Colors.red[100];
                              }
                              if (aEntero(deuda.faltanteUnidades) < 0) {
                                color = Colors.orange[100];
                              }
                              return InkWell(
                                onLongPress: () {
                                  goTo(
                                    RegistrosTablaScreen(
                                      e4e: deuda.e4e,
                                      lcl: deuda.lcl,
                                    ),
                                  );
                                },
                                onTap: () {
                                  goTo(
                                    RegistrosTablaScreen(
                                      e4e: deuda.e4e,
                                      lcl: deuda.lcl,
                                    ),
                                  );
                                },
                                onDoubleTap: () {
                                  goTo(
                                    RegistrosTablaScreen(
                                      e4e: deuda.e4e,
                                      lcl: deuda.lcl,
                                    ),
                                  );
                                },
                                child: Container(
                                  color: color,
                                  child: Row(
                                    children: [
                                      for (ToCelda celda in deuda.celdas)
                                        Expanded(
                                          flex: celda.flex,
                                          child: Text(
                                            celda.valor,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11,
                                              // color: esHabilitado
                                              //     ? null
                                              //     : Colors.red[900],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
