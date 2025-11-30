// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../bloc/main_bloc.dart';
import '../../resources/descarga_hojas.dart';
import '../../resources/titulo.dart';
import '../controller/sustitutos_ctrl.dart';
import '../model/sustitutos_model.dart';
import 'sustitutos_dialog.dart';

class SustitutosPage extends StatefulWidget {
  const SustitutosPage({super.key});

  @override
  State<SustitutosPage> createState() => _SustitutosPageState();
}

class _SustitutosPageState extends State<SustitutosPage> {
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

  // Función para mostrar el diálogo de edición
  void _mostrarDialogoEdicion(
    SustitutosSingle sustituto,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SustitutosDialog(sustituto: sustituto, esEdicion: true);
      },
    );
  }

  // Función para mostrar el diálogo de creación
  void _mostrarDialogoCreacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return const SustitutosDialog(esEdicion: false);
      },
    );
  }

  // Función para iniciar la carga masiva
  void _iniciarCargaMasiva(BuildContext context) {
    final controlador = SustitutosController(
      BlocProvider.of<MainBloc>(context).bl,
    );
    controlador.cargaMasiva(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUSTITUTOS'),
        actions: [
          // Botón para agregar un nuevo sustituto
          IconButton(
            onPressed: () => _mostrarDialogoCreacion(context),
            icon: const Icon(Icons.add),
            tooltip: 'Agregar nuevo sustituto',
          ),
          // Botón para carga masiva de sustitutos
          IconButton(
            onPressed: () => _iniciarCargaMasiva(context),
            icon: const Icon(Icons.file_upload),
            tooltip: 'Carga masiva desde CSV',
          ),
        ],
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, Sustitutos?>(
        selector: (state) => state.sustitutos,
        builder: (context, state) {
          if (state == null) {
            return const CircularProgressIndicator();
          } else {
            return FloatingActionButton(
              onPressed:
                  () => DescargaHojas().ahora(
                    datos: state.sustitutosList,
                    nombre: 'Sustitutos',
                    user: BlocProvider.of<MainBloc>(context).state.user!,
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
              List<ToCelda> titles = state.sustitutos!.titles;
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
                if (state.sustitutos == null || firstTimeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<SustitutosSingle> sustitutosList =
                    state.sustitutos!.sustitutosList;
                sustitutosList =
                    sustitutosList
                        .where(
                          (e) => e.toList().any(
                            (el) =>
                                el.toLowerCase().contains(filter.toLowerCase()),
                          ),
                        )
                        .toList();
                if (sustitutosList.length > endList) {
                  sustitutosList = sustitutosList.sublist(0, endList);
                }
                List<String> permisos = state.user!.permisos;
                return SingleChildScrollView(
                  controller: _controller,
                  child: SelectableRegion(
                    focusNode: FocusNode(),
                    selectionControls: emptyTextSelectionControls,
                    child: Column(
                      children: [
                        for (SustitutosSingle sustitutos in sustitutosList)
                          Builder(
                            builder: (context) {
                              return InkWell(
                                onDoubleTap:
                                    !permisos.contains('modificar_listas')
                                        ? null
                                        : () => _mostrarDialogoEdicion(
                                          sustitutos,
                                          context,
                                        ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      for (ToCelda celda in sustitutos.celdas)
                                        Expanded(
                                          flex: celda.flex,
                                          child: Text(
                                            celda.valor,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 11,
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
