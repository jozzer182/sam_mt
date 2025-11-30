// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_enum.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_model.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_registros.dart';
import 'package:v_al_sam_v02/chatarra/view/chatarra_fields_v2.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../../bloc/main_bloc.dart';
import '../../models/mm60_b.dart';
import '../../version.dart';
import 'chatarra_action_buttons.dart';
import 'chatarra_row_material.dart';

class ChatarraPage extends StatefulWidget {
  final bool esNuevo;
  final String pdi;

  const ChatarraPage({required this.esNuevo, required this.pdi, super.key});

  @override
  State<ChatarraPage> createState() => _ChatarraPageState();
}

class _ChatarraPageState extends State<ChatarraPage> {
  late bool esNuevo;

  Future<String> _futurelastNumberPed() async {
    String lastnumber = await context
        .read<MainBloc>()
        .chatarraCtrl
        .lastNumberPed(widget.pdi);
    context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
      value: lastnumber,
      campo: CampoChatarra.pedido,
    );
    return lastnumber;
  }

  @override
  void initState() {
    esNuevo = widget.esNuevo;
    if (widget.esNuevo) {
      _futurelastNumberPed();
    }
    super.initState();
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
              Version.status('Chatarra', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
      appBar: AppBar(
        title: const Text('REMISION CHATARRA'),
        automaticallyImplyLeading: false, // Disable the default back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Your custom logic here
            if (esNuevo) {
              Navigator.of(context).pop();
            }
            Navigator.of(context).pop(); // Navigate back
          },
        ),
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
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (widget.esNuevo) {
                return SizedBox();
              }
              User user = state.user!;
              bool anular = user.permisos.contains("anular_chatarra");
              if (!anular) {
                return SizedBox();
              }
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("ANULAR"),
                        content: Text("Seguro que desea anular?"),
                        actions: [
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Sí"),
                            onPressed: () {
                              context
                                  .read<MainBloc>()
                                  .chatarraCtrl
                                  .deleteToDBChatarra();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Anular', textAlign: TextAlign.center),
              );
            },
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              // User user = state.user!;
              return ElevatedButton(
                onPressed: () {
                  List<dynamic>? validar =
                      context.read<MainBloc>().chatarraCtrl.validar;
                  if (validar != null) {
                    context.read<MainBloc>().add(
                      Message(message: validar.join('\n')),
                    );
                  } else {
                    context.read<MainBloc>().chatarraCtrl.addToDbChatarra();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar', textAlign: TextAlign.center),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.user == null ||
                  state.lcl == null ||
                  state.chatarra == null) {
                return Center(child: CircularProgressIndicator());
              }
              List<String> lcls =
                  state.registrosB!.registrosList
                      .map((e) => e.lcl.trim())
                      .toSet()
                      .toList();
              Chatarra chatarra = state.chatarra!;
              return Column(
                children: [
                  Row(
                    children: [
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.fecha_i,
                        campo: CampoChatarra.fecha_i,
                        label: "Fecha Ingreso",
                        color:
                            chatarra.fecha_i.isEmpty
                                ? Colors.red
                                : Colors.green,
                        edit: true,
                        tipoCampo: TipoCampo.fecha,
                      ),
                      const SizedBox(width: 10),
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.acta,
                        campo: CampoChatarra.acta,
                        label: "Acta",
                        color:
                            chatarra.acta.isEmpty ? Colors.red : Colors.green,
                        edit: true,
                        tipoCampo: TipoCampo.texto,
                      ),
                      const SizedBox(width: 10),
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.soporte_i,
                        campo: CampoChatarra.soporte_i,
                        label: "Soporte Ingreso",
                        color:
                            chatarra.soporte_i.isEmpty
                                ? Colors.red
                                : Colors.green,
                        edit: true,
                        tipoCampo: TipoCampo.file,
                      ),
                      const SizedBox(width: 10),
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.comentario_i,
                        campo: CampoChatarra.comentario_i,
                        label: "Comentario",
                        color: Colors.grey,
                        edit: true,
                        tipoCampo: TipoCampo.texto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.lcl,
                        campo: CampoChatarra.lcl,
                        label: "LCL",
                        color: chatarra.lcl.isEmpty ? Colors.red : Colors.green,
                        edit: true,
                        tipoCampo: TipoCampo.texto,
                        opciones: lcls,
                      ),
                      const SizedBox(width: 10),
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.pedido,
                        campo: CampoChatarra.pedido,
                        label: "Pedido",
                        color: Colors.grey,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                      ),
                      const SizedBox(width: 10),
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.balance,
                        campo: CampoChatarra.balance,
                        label: "Balance",
                        color: Colors.grey,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                      ),
                      const SizedBox(width: 10),
                      FieldPre(
                        flex: 2,
                        initialValue: chatarra.estado,
                        campo: CampoChatarra.estado,
                        label: "Estado",
                        color: Colors.grey,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ActionButtons(),
                  const SizedBox(height: 10),
                  BlocBuilder<MainBloc, MainState>(
                    builder: (context, state) {
                      // print('rebuild');
                      List<Mm60SingleB>? mm60 = state.mm60B?.mm60List;
                      List<ChatarraReg>? items = state.chatarra?.items;
                      if (items == null || mm60 == null) {
                        return const CircularProgressIndicator();
                      }
                      // print('itemsfronRebuild: $items');
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return RowMaterialChatarra(
                            edit: true,
                            index: index,
                            chatarraReg: items[index],
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
