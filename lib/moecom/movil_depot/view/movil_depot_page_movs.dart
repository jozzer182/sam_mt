import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_al_sam_v02/moecom/movil_depot/model/moveil_depot_inv_model.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/descarga_hojas.dart';
import '../../../resources/titulo.dart';
import '../../../resources/transicion_pagina.dart';
import '../../../version.dart';
import '../../entregas_mc/view/entregas_mc_page_edit.dart';
import '../../consumos_mc/view/consumos_mc_page_edit.dart';
import '../model/movil_depot_movs_model.dart';

class MovilDepotPageMovs extends StatefulWidget {
  final String tecnicoid;
  final String tecnico;
  final String tecnicotype;
  const MovilDepotPageMovs({
    super.key,
    required this.tecnicoid,
    required this.tecnico,
    required this.tecnicotype,
  });

  @override
  State<MovilDepotPageMovs> createState() => _MovilDepotPageMovsState();
}

class _MovilDepotPageMovsState extends State<MovilDepotPageMovs> {
  String filter = '';
  final ScrollController _controller = ScrollController();
  int endList = 70;

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
    context.read<MainBloc>().movilDepotController.crearMovs(widget.tecnicoid);
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
        title: Text('${widget.tecnicotype} | ${widget.tecnico.toUpperCase()}'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? LinearProgressIndicator() : SizedBox();
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              var data = context.read<MainBloc>().state.movilDepotList!.movs;
              DescargaHojas.ahoraMap(
                datos: data.map((e) => e.toMap()).toList(),
                nombre: 'MOVIMIENTOS DESCARGAS',
                user: context.read<MainBloc>().state.user!,
              );
            },
            child: const Text('Descargar Movmientos'),
          ),
          ElevatedButton(
            onPressed: () {
              var data = context.read<MainBloc>().state.movilDepotList!.inv;
              DescargaHojas.ahoraMap(
                datos: data.map((e) => e.toMap()).toList(),
                nombre: 'INVENTARIO MOECOM',
                user: context.read<MainBloc>().state.user!,
              );
            },
            child: const Text('Descargar Inventario'),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Version.data, style: Theme.of(context).textTheme.labelSmall),
            Text(
              Version.status('Home', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],

      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Contenedor con ancho completo para mantener la distribución de botones
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Primer botón con ancho fijo
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            onPressed:
                                () => goTo(
                                  EntregasMcPageEdit(
                                    tecnicoid: widget.tecnicoid,
                                  ),
                                ),
                            child: Text(
                              'NUEVA\nENTREGA/REINTEGRO',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      // Segundo botón con ancho fijo
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            onPressed:
                                () => goTo(
                                  ConsumoMcPageEdit(
                                    tecnicoid: widget.tecnicoid,
                                  ),
                                ),
                            child: Text(
                              'NUEVO\nCONSUMO',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(5),
                // Lista de movimientos
                Text(
                  'MOVIMIENTOS',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(5),
                Row(
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
                const Gap(5),
                BlocBuilder<MainBloc, MainState>(
                  builder: (context, state) {
                    if (state.movilDepotList == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<ToCelda> titles = state.movilDepotList!.titlesInv;
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
                Expanded(
                  child: BlocBuilder<MainBloc, MainState>(
                    builder: (context, state) {
                      if (state.movilDepotList == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      List<MDInv> list = state.movilDepotList!.inv;
                      if (list.isEmpty) {
                        return const Center(
                          child: Text('No hay datos disponibles'),
                        );
                      }
                      list =
                          list
                              .where((e) => e.id == widget.tecnicoid)
                              .where(
                                (e) => e.toList().any(
                                  (el) => el.toLowerCase().contains(
                                    filter.toLowerCase(),
                                  ),
                                ),
                              )
                              .toList();
                      list.sort((a, b) => a.e4e.compareTo(b.e4e));
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
                              for (MDInv mov in list)
                                Builder(
                                  builder: (context) {
                                    return Container(
                                      child: InkWell(
                                        child: Row(
                                          children: [
                                            for (ToCelda celda in mov.celdas)
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
                                                            Uri.parse(
                                                              celda.valor,
                                                            ),
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
                                                      textAlign:
                                                          TextAlign.center,
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
        },
      ),
    );
  }
}
