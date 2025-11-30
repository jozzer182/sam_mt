// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:statistics/statistics.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/descarga_hojas.dart';
import '../../../resources/titulo.dart';
import '../../../resources/transicion_pagina.dart';
import '../model/entregas_mc_list_model.dart';
import '../model/entregas_mc_reg_model.dart';
import 'entregas_mc_page_edit.dart';

class EntregasMcPage extends StatefulWidget {
  const EntregasMcPage({super.key});

  @override
  State<EntregasMcPage> createState() => _EntregasMcPageState();
}

class _EntregasMcPageState extends State<EntregasMcPage> {
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
    void goTo(Widget page) {
      Navigator.push(context, createRoute(page));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ENTREGAS REINTEGROS'),
        actions: [
          ElevatedButton(
            onPressed: () => goTo(EntregasMcPageEdit()),
            child: const Text('Agregar'),
          ),
          const Gap(5),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.entregasMcList == null || firstTimeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<EntregaMc> list = state.entregasMcList!.list;
                if (list.isEmpty) {
                  return const Center(child: Text('No hay datos disponibles'));
                }
                String fechaActualizacion = list.first.actualizado;
                DateTime fecha = DateTime.parse(fechaActualizacion);
                return Center(
                  child: Text(
                    'Actualizado:' +
                        '\n${fecha.day.toStringPadded(2)}/${fecha.month.toStringPadded(2)}/${fecha.year}' +
                        '\n${fecha.hour.toStringPadded(2)}:${fecha.minute.toStringPadded(2)}',
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
          const Gap(5),
        ],
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, EntregasMcList?>(
        selector: (state) => state.entregasMcList,
        builder: (context, state) {
          if (state == null) {
            return const CircularProgressIndicator();
          } else {
            return FloatingActionButton(
              onPressed:
                  () => DescargaHojas().ahora(
                    datos: state.list,
                    nombre: 'ENTREGAS REINTEGROS',
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
              if (state.entregasMcList == null || firstTimeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              List<ToCelda> titles = state.entregasMcList!.titles;
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
                if (state.entregasMcList == null || firstTimeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<EntregaMc> list = state.entregasMcList!.list;
                if (list.isEmpty) {
                  return const Center(child: Text('No hay datos disponibles'));
                }
                list =
                    list
                        .where(
                          (e) => e.toList().any(
                            (el) =>
                                el.toLowerCase().contains(filter.toLowerCase()),
                          ),
                        )
                        .toList();
                if (list.length > endList) {
                  list = list.sublist(0, endList);
                }
                return SingleChildScrollView(
                  controller: _controller,
                  child: SelectableRegion(
                    focusNode: FocusNode(),
                    selectionControls: emptyTextSelectionControls,
                    child: Column(
                      children: [
                        for (EntregaMc carga in list)
                          Builder(
                            builder: (context) {
                              return Container(
                                color:
                                    carga.estado == 'anulado'
                                        ? Colors.grey
                                        : null,
                                child: InkWell(
                                  onTap:
                                      carga.estado == 'anulado'
                                          ? null
                                          : () {
                                            goTo(
                                              EntregasMcPageEdit(
                                                esNuevo: false,
                                                pedido: carga.pedido,
                                              ),
                                            );
                                          },
                                  child: Row(
                                    children: [
                                      for (ToCelda celda in carga.celdas)
                                        Expanded(
                                          flex: celda.flex,
                                          child: Builder(
                                            builder: (context) {
                                              if (celda.valor.startsWith(
                                                'http',
                                              )) {
                                                return InkWell(
                                                  onTap: () {
                                                    launchUrl(
                                                      Uri.parse(celda.valor),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.link,
                                                    color: Colors.blue,
                                                  ),
                                                );
                                              }
                                              return Text(
                                                celda.valor,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  // color: esHabilitado
                                                  //     ? null
                                                  //     : Colors.red[900],
                                                ),
                                              );
                                            },
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
