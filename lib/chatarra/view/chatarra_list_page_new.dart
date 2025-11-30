// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_list.dart';

import '../../../resources/descarga_hojas.dart';
import '../../../resources/titulo.dart';
import '../../bloc/main_bloc.dart';
import '../../resources/transicion_pagina.dart';
import '../../user/user_model.dart';
import '../model/chatarra_model.dart';
import 'chatarra_page.dart';

class ChatarraListPageNew extends StatefulWidget {
  const ChatarraListPageNew({super.key});

  @override
  State<ChatarraListPageNew> createState() => _ChatarraListPageNewState();
}

class _ChatarraListPageNewState extends State<ChatarraListPageNew> {
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
        title: const Text('CHATARRA'),
        actions: [
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.user == null) {
                return SizedBox();
              }
              User user = state.user!;
              return ElevatedButton(
                onPressed:
                    !user.permisos.contains("nueva_chatarra")
                        ? null
                        : () {
                          context
                              .read<MainBloc>()
                              .chatarraCtrl
                              .seleccionarChatarra(
                                chatarra: Chatarra.fromNuevo(user: user),
                              );
                          Navigator.push(
                            context,
                            createRoute(
                              ChatarraPage(esNuevo: true, pdi: user.pdi),
                            ),
                          );
                        },
                child: const Text(
                  'Crear\nRemisión\nChatarra',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          const Gap(5),
        ],
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, ChatarraList?>(
        selector: (state) => state.chatarraList,
        builder: (context, state) {
          if (state == null) {
            return const CircularProgressIndicator();
          } else {
            return FloatingActionButton(
              onPressed:
                  () => DescargaHojas().ahora(
                    datos: state.list,
                    nombre: 'Chatarra',
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
              List<ToCelda> titles = state.chatarraList!.titles;
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
                if (state.chatarraList == null || firstTimeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<ChatarraSingle> chatarraList = state.chatarraList!.list;
                chatarraList =
                    chatarraList
                        .where(
                          (e) => e.toList().any(
                            (el) =>
                                el.toLowerCase().contains(filter.toLowerCase()),
                          ),
                        )
                        .toList();
                if (chatarraList.length > endList) {
                  chatarraList = chatarraList.sublist(0, endList);
                }
                return SingleChildScrollView(
                  controller: _controller,
                  child: SelectableRegion(
                    focusNode: FocusNode(),
                    selectionControls: emptyTextSelectionControls,
                    child: Column(
                      children: [
                        for (ChatarraSingle chatarra in chatarraList)
                          Builder(
                            builder: (context) {
                              return InkWell(
                                onTap: () {
                                  List<ChatarraSingle> chatarraPedido =
                                      chatarraList
                                          .where(
                                            (e) => e.pedido == chatarra.pedido,
                                          )
                                          .toList();

                                  context
                                      .read<MainBloc>()
                                      .chatarraCtrl
                                      .seleccionarChatarra(
                                        chatarra: Chatarra.fromList(
                                          list: chatarraPedido,
                                        ),
                                      );

                                  Navigator.push(
                                    context,
                                    createRoute(
                                      ChatarraPage(
                                        esNuevo: false,
                                        pdi:
                                            context
                                                .read<MainBloc>()
                                                .state
                                                .user!
                                                .pdi,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    for (ToCelda celda in chatarra.celdas)
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
