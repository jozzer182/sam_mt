import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../bloc/main_bloc.dart';
import '../../resources/descarga_hojas.dart';
import '../../resources/transicion_pagina.dart';
import '../model/pedidos_model.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
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
    // context.read<MainBloc>().add(Load());
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
    void goTo(Widget page) => Navigator.push(context, createRoute(page));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const Gap(5),
        ],
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, Pedidos?>(
        selector: (state) => state.pedidos,
        builder: (context, state) {
          if (state == null) {
            return const CircularProgressIndicator();
          } else {
            return FloatingActionButton(
              onPressed: () => DescargaHojas().ahora(
                datos: state.pedidosList,
                nombre: 'Pedidos',
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
              return Row(
                children: [
                  for (String key in state.pedidos!.itemsAndFlex.keys)
                    Expanded(
                      flex: state.pedidos!.itemsAndFlex[key][0],
                      child: Text(
                        state.pedidos!.itemsAndFlex[key][1],
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
                if (state.pedidos == null || firstTimeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<PedidosSingle> pedidos = state.pedidos!.pedidosList;
                pedidos = pedidos
                    .where(
                      (e) => e.toList().any(
                            (el) => el.toLowerCase().contains(
                                  filter.toLowerCase(),
                                ),
                          ),
                    )
                    .toList();
                pedidos.sort((a, b) => b.pedido.compareTo(a.pedido));
                if (pedidos.length > endList) {
                  pedidos = pedidos.sublist(0, endList);
                }
                // return Text('${pedidos.length}');

                return SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: [
                      for (PedidosSingle pedido in pedidos)
                        Builder(builder: (context) {
                          // print(toNum(pedido.pedido));
                          return Row(
                            children: [
                              for (String key in pedido.mapToTitlesPedidos.keys)
                                Expanded(
                                  flex: pedido.mapToTitlesPedidos[key]![0],
                                  child: SelectableText(
                                    pedido.mapToTitlesPedidos[key]![1],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                    ],
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

sortByPedido(PedidosSingle a, PedidosSingle b) {
  return toOrderString2(b).compareTo(toOrderString2(a));
}

String toOrderString2(PedidosSingle input) {
  String cto = input.ref;
  String e4e = input.e4e;
  String proyecto = input.proyecto;
  if (input.pedido.isEmpty) {
    return '00000000';
  }
  List<String> partes = input.pedido.replaceAll('E', '').split('|');
  String mes = partes[0];
  List<String> segundaParte = partes[1].split('-');
  String ano = segundaParte[0];
  String quincena = segundaParte[1];

  return '20$ano$mes$quincena$proyecto$cto$e4e';
}
