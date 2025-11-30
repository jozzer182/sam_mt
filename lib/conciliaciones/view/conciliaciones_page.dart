import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/conciliacion/model/conciliacion_model.dart';
import 'package:v_al_sam_v02/resources/descarga_hojas.dart';
import 'package:v_al_sam_v02/resources/transicion_pagina.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../../bloc/main_bloc.dart';
import '../../conciliacion/view/conciliacion_page.dart';
import '../../resources/titulo.dart';
import '../../version.dart';
import '../model/conciliaciones_model.dart';

class ConciliacionesPage extends StatefulWidget {
  const ConciliacionesPage({super.key});

  @override
  State<ConciliacionesPage> createState() => _ConciliacionesPageState();
}

class _ConciliacionesPageState extends State<ConciliacionesPage> {
  bool isSearching = false;
  String enel = "";
  String estado = "";
  String filter = '';
  int endList = 70;
  bool firstTimeLoading = true;

  final ScrollController _controller = ScrollController();
  // int view = 60;

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

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 70;
      });
    }
  }

  setEnel(String ingeniero) {
    setState(() {
      enel = ingeniero;
    });
  }

  setEstado(String nuevoEstado) {
    setState(() {
      estado = nuevoEstado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Version.data, style: Theme.of(context).textTheme.labelSmall),
            Text(
              Version.status('Conciliaciones', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
      appBar: AppBar(
        title: const Text('CONCILIACIONES'),
        actions: [
          ElevatedButton(
            onPressed: () {
              setEnel("");
              setEstado("");
              setState(() {
                filter = "";
                // endList = 15;
              });
              // context.read<MainBloc>().add(ConciliacionesSearch(value: ""));
            },
            child: Text("Reset\nFiltros"),
          ),
          SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.user == null) {
                return SizedBox();
              }
              User user = state.user!;
              return ElevatedButton(
                onPressed:
                    !user.permisos.contains("nueva_conciliacion")
                        ? null
                        : () {
                          context
                              .read<MainBloc>()
                              .conciliacionesCtrl
                              .seleccionarConciliacion(
                                Conciliacion.fromNuevo(persona: user.correo),
                              );
                          Navigator.push(
                            context,
                            createRoute(
                              ConciliacionPage(
                                esPrimeraVez: true,
                                esNuevo: true,
                                pdi: user.pdi,
                              ),
                            ),
                          );
                        },
                child: const Text(
                  'Crear\nConciliación',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? LinearProgressIndicator() : SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List? data = state.conciliaciones?.conciliacionesList;
          if (data == null) return Center(child: CircularProgressIndicator());
          return FloatingActionButton(
            onPressed:
                () => DescargaHojas().ahora(
                  user: context.read<MainBloc>().state.user!,
                  datos: data,
                  nombre: 'Conciliaciones',
                ),
            child: Icon(Icons.download),
          );
        },
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Listado de conciliaciones de trabajos',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
              SizedBox(height: 20),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  List<Conciliacion> lista =
                      state.conciliaciones?.conciliacionesListSearch ?? [];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          // controller: busqueda,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Búsqueda',
                          ),
                          onChanged: (value) {
                            setState(() {
                              filter = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          value: enel,
                          items:
                              ["", ...lista.map((e) => e.personaenel).toSet()]
                                  .toSet()
                                  .map(
                                    (e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setEnel(value.toString());
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enel',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField(
                          value: estado,
                          items:
                              ["", ...lista.map((e) => e.estado).toSet()]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setEstado(value.toString());
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Estado',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  List<ToCelda> titles = state.mb51B!.titles;
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
              SizedBox(height: 20),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state.conciliaciones == null || firstTimeLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<ConciliacionEstado> lista =
                      state.conciliaciones?.conciliacionesEstadoListSearch ??
                      [];
                  List<ConciliacionEstado> datos = lista;
                  Map itemsAndFlex = state.conciliaciones?.itemsAndFlex ?? {};
                  List keys = state.conciliaciones?.keys ?? [];
                  datos =
                      datos
                          .where((e) => e.personaenel.toString().contains(enel))
                          .toList();

                  datos =
                      datos
                          .where((e) => e.estado.toString().contains(estado))
                          .toList();
                  datos.sort(
                    (a, b) => b.conciliacion.compareTo(a.conciliacion),
                  );
                  List<Map> unique = datos.map((e) => e.toMap()).toList();
                  unique =
                      unique
                          .where(
                            (e) => e.values.toList().any(
                              (el) => el.toLowerCase().contains(
                                filter.toLowerCase(),
                              ),
                            ),
                          )
                          .toList();
                  // endList = endList > unique.length ? unique.length : endList;
                  if (unique.length > endList) {
                    unique = unique.sublist(0, endList);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: unique.length,
                    itemBuilder: (context, index) {
                      List listaDato = [];
                      for (var key in keys) {
                        listaDato.add({
                          'texto': unique[index][key],
                          'flex': itemsAndFlex[key][0],
                          'index': key,
                        });
                      }
                      Color? fondo = Colors.transparent;
                      if (unique[index]['estado'] == 'revisar')
                        fondo = Colors.red[100];
                      if (unique[index]['estado'] == 'revisar enel')
                        fondo = Colors.orange[100];
                      if (unique[index]['estado'] ==
                          'aprobado (pendiente carga scm)')
                        fondo = Colors.yellow[100];
                      if (unique[index]['estado'] == 'carga scm')
                        fondo = Colors.green[100];
                      return BlocBuilder<MainBloc, MainState>(
                        builder: (context, state) {
                          if (state.user == null) {
                            return SizedBox();
                          }
                          User user = state.user!;
                          return InkWell(
                            onTap: () {
                              List<Conciliacion> listaConciliaciones =
                                  context
                                      .read<MainBloc>()
                                      .state
                                      .conciliaciones!
                                      .conciliacionesList
                                      .where(
                                        (e) =>
                                            e.lcl == unique[index]['lcl'] &&
                                            e.conciliacion ==
                                                unique[index]['conciliacion'],
                                      )
                                      .toList();
                              Conciliacion conciliacionSeleccionada =
                                  listaConciliaciones.last;
                              context
                                  .read<MainBloc>()
                                  .conciliacionesCtrl
                                  .seleccionarConciliacion(
                                    conciliacionSeleccionada,
                                  );
                              Navigator.push(
                                context,
                                createRoute(
                                  ConciliacionPage(
                                    esPrimeraVez: false,
                                    esNuevo: false,
                                    pdi: user.pdi,
                                  ),
                                ),
                              );
                            },
                            onDoubleTap: () {
                              List<Conciliacion> listaConciliaciones =
                                  context
                                      .read<MainBloc>()
                                      .state
                                      .conciliaciones!
                                      .conciliacionesList
                                      .where(
                                        (e) =>
                                            e.lcl == unique[index]['lcl'] &&
                                            e.conciliacion ==
                                                unique[index]['conciliacion'],
                                      )
                                      .toList();
                              Conciliacion conciliacionSeleccionada =
                                  listaConciliaciones.last;
                              context
                                  .read<MainBloc>()
                                  .conciliacionesCtrl
                                  .seleccionarConciliacion(
                                    conciliacionSeleccionada,
                                  );

                              Navigator.push(
                                context,
                                createRoute(
                                  ConciliacionPage(
                                    esPrimeraVez: false,
                                    esNuevo: false,
                                    pdi: user.pdi,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              List<Conciliacion> listaConciliaciones =
                                  context
                                      .read<MainBloc>()
                                      .state
                                      .conciliaciones!
                                      .conciliacionesList
                                      .where(
                                        (e) =>
                                            e.lcl == unique[index]['lcl'] &&
                                            e.conciliacion ==
                                                unique[index]['conciliacion'],
                                      )
                                      .toList();
                              Conciliacion conciliacionSeleccionada =
                                  listaConciliaciones.last;
                              context
                                  .read<MainBloc>()
                                  .conciliacionesCtrl
                                  .seleccionarConciliacion(
                                    conciliacionSeleccionada,
                                  );

                              Navigator.push(
                                context,
                                createRoute(
                                  ConciliacionPage(
                                    esPrimeraVez: false,
                                    esNuevo: false,
                                    pdi: user.pdi,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              color: fondo,
                              child: Row(
                                children: [
                                  for (var dato in listaDato)
                                    Expanded(
                                      flex: dato['flex'],
                                      child: SelectableText(
                                        dato['texto'].toString(),
                                        textAlign: TextAlign.center,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
