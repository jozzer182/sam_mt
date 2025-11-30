// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/field_pre/field_pre_texto.dart';
import '../model/ficha__ficha_model.dart';
import '../model/ficha_reg/reg.dart';
import 'fila/fila.dart';
import 'widgets/titulos/ficha_titulos.dart';
import 'widgets/titulos/ficha_titulos_versiones.dart';

class FichaFichaPage extends StatefulWidget {
  const FichaFichaPage({
    key,
  });

  @override
  State<FichaFichaPage> createState() => _FichaFichaPageState();
}

class _FichaFichaPageState extends State<FichaFichaPage> {
  String filter = '';
  String filterCircuito = '';
  List<FichaReg> ficha = [];
  bool firstTimeLoading = true;
  int endList = 70;
  bool soloNuevos = false;
  final ScrollController _controller = ScrollController();
  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 70;
      });
    }
  }

  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  void initState() {
    if (context.read<MainBloc>().state.ficha!.fficha.editar) {
      ficha = context.read<MainBloc>().state.ficha!.fficha.fichaModificada;
    } else {
      ficha = context.read<MainBloc>().state.ficha!.fficha.ficha;
    }
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
    bool editar = context.watch<MainBloc>().state.ficha!.fficha.editar;
    return BlocListener<MainBloc, MainState>(
      listenWhen: (previous, current) => editar != current.ficha!.fficha.editar,
      listener: (context, state) {
        bool lastEditar = state.ficha!.fficha.editar;
        if (lastEditar) {
          setState(() {
            ficha = state.ficha!.fficha.fichaModificada;
          });
        } else {
          setState(() {
            ficha = state.ficha!.fficha.ficha;
          });
        }
      },
      child: Column(
        children: [
          const Gap(10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              FFicha fficha = state.ficha!.fficha;
              List<FichaReg> fichaOriginal = fficha.ficha;
              bool editar = fficha.editar;
              if (editar) {
                fichaOriginal = fficha.fichaModificada;
              }
              List<String> circuitos = fichaOriginal
                  .map((e) => e.circuito)
                  .where((e) => e.isNotEmpty)
                  .toSet()
                  .toList();

              return Row(
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
                        ficha = fichaOriginal
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
                          ficha = fichaOriginal
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
                          ficha = fichaOriginal
                              .where((e) => e.toList().any((e) => e
                                  .toLowerCase()
                                  .contains(filter.toLowerCase())))
                              .toList();
                        });
                      }
                    },
                  ),
                  const Gap(10),
                ],
              );
            },
          ),
          const Gap(5),
          const FichaTitulosVersiones(),
          const FichaTitulosMeses(),
          const Gap(5),
          if (context.read<MainBloc>().state.ficha!.fficha.editar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<MainBloc>()
                        .fichaFichaController
                        .lista
                        .agregar;
                  },
                  child: const Text('Agregar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<MainBloc>()
                        .fichaFichaController
                        .lista
                        .eliminar;
                  },
                  child: const Text('Eliminar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<MainBloc>().fichaFichaController.lista.reset;
                  },
                  child: const Text('Limpiar'),
                ),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      soloNuevos = !soloNuevos;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: soloNuevos ? Colors.green : Colors.grey,
                  ),
                  child: const Text('Solo Nuevos'),
                ),
              ],
            ),
          const Gap(5),
          Expanded(
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                if (state.ficha == null || firstTimeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                bool lastEditar = state.ficha!.fficha.editar;
                if (lastEditar) {
                  ficha = state.ficha!.fficha.fichaModificada
                      .where(
                        (e) => e.toList().any(
                              (e) => e
                                  .toLowerCase()
                                  .contains(filter.toLowerCase()),
                            ),
                      )
                      .where(
                        (e) => e.circuito
                            .toUpperCase()
                            .contains(filterCircuito.toUpperCase()),
                      )
                      .where((e) => soloNuevos ? (e.estado == "nuevo" && e.id.isEmpty): true)
                      .toList();
                } else {
                  ficha = state.ficha!.fficha.ficha
                      .where(
                        (e) => e.toList().any(
                              (e) => e
                                  .toLowerCase()
                                  .contains(filter.toLowerCase()),
                            ),
                      )
                      .where(
                        (e) => e.circuito
                            .toUpperCase()
                            .contains(filterCircuito.toUpperCase()),
                      )
                      .toList();
                }
                List<FichaReg> fichaToShow = [];
                if (ficha.length > endList) {
                  fichaToShow = ficha.sublist(0, endList);
                } else {
                  fichaToShow = ficha;
                }
                return
                    // SingleChildScrollView(
                    //   controller: _controller,
                    //   padding: const EdgeInsets.all(4),
                    //   child: Column(
                    //     children: [
                    //       for (FichaReg fem in fichaToShow)
                    //         Builder(builder: (context) {
                    //           return Fila(fem: fem);
                    //         })
                    //     ],
                    //   ),
                    // )
                    ListView.builder(
                  controller: _controller,
                  itemCount: fichaToShow.length +
                      1, // Añade uno para el indicador de carga
                  itemBuilder: (context, index) {
                    if (index == fichaToShow.length) {
                      // Último ítem - Muestra un indicador de carga y carga más datos
                      // _cargarMasDatos(); // Asegúrate de que esta función no se llame más de una vez simultáneamente
                      return Container(
                        height: 200,
                        child: Center(
                          child: Text('No hay más datos'),
                        ),
                      );
                    }
                    return Fila(
                        fem: fichaToShow[index]); // Tu widget de fila aquí
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
