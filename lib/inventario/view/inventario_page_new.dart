// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';


import '../../../resources/descarga_hojas.dart';
import '../../../resources/titulo.dart';
import '../../bloc/main_bloc.dart';
import '../model/inventario_model.dart';

class InventarioPageNew extends StatefulWidget {
  const InventarioPageNew({
    super.key,
  });

  @override
  State<InventarioPageNew> createState() => _InventarioPageNewState();
}

class _InventarioPageNewState extends State<InventarioPageNew> {
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
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          // BlocBuilder<MainBloc, MainState>(
          //   builder: (context, state) {
          //     if (state.inventarioB == null || firstTimeLoading) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else {
          //       String fechaActualizacion =
          //           state.inventarioB!.inventarioList.first.actualizado;
          //       DateTime fecha = DateTime.parse(fechaActualizacion);
          //       return Center(
          //         child: Text(
          //           'Actualizado:' +
          //               '\n${fecha.day.toStringPadded(2)}/${fecha.month.toStringPadded(2)}/${fecha.year}' +
          //               '\n${fecha.hour.toStringPadded(2)}:${fecha.minute.toStringPadded(2)}',
          //           textAlign: TextAlign.center,
          //         ),
          //       );
          //     }
          //   },
          // ),
          const Gap(5),
        ],
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, InventarioB?>(
        selector: (state) => state.inventarioB,
        builder: (context, state) {
          if (state == null) {
            return const CircularProgressIndicator();
          } else {
            return FloatingActionButton(
              onPressed: () => DescargaHojas().ahora(
                datos: state.inventarioList,
                nombre: 'Inventario',
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
              List<ToCelda> titles = state.inventarioB!.titles;
              return Row(
                children: [
                  for (ToCelda celda in titles)
                    Expanded(
                      flex: celda.flex,
                      child: Text(
                        celda.valor,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
                if (state.inventarioB == null ||
                    firstTimeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<InventarioBSingle> inventarioList = state.inventarioB!.inventarioList;
                inventarioList = inventarioList
                    .where(
                      (e) => e.toList().any(
                            (el) => el.toLowerCase().contains(
                                  filter.toLowerCase(),
                                ),
                          ),
                    )
                    .toList();
                if (inventarioList.length > endList) {
                  inventarioList = inventarioList.sublist(0, endList);
                }
                return SingleChildScrollView(
                  controller: _controller,
                  child: SelectableRegion(
                    focusNode: FocusNode(),
                    selectionControls: emptyTextSelectionControls,
                    child: Column(
                      children: [
                        for (InventarioBSingle inventario in inventarioList)
                          Builder(builder: (context) {
                            return Row(
                              children: [
                                for (ToCelda celda in inventario.celdas)
                                  Expanded(
                                    flex: celda.flex,
                                    child: Text(
                                      celda.valor,
                                      textAlign: TextAlign.center,
                                      // style: TextStyle(
                                      //   fontSize: 11,
                                      //   // color: esHabilitado
                                      //   //     ? null
                                      //   //     : Colors.red[900],
                                      // ),
                                    ),
                                  ),
                              ],
                            );
                          }),
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
