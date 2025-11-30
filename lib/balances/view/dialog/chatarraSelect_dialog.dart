import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/main_bloc.dart';
import '../../../chatarra/model/chatarra_list.dart';

class ChatarraSelectDialog extends StatefulWidget {
  final String lcl;
  final List<String> pedidoList;

  const ChatarraSelectDialog({
    required this.lcl,
    required this.pedidoList,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatarraSelectDialog> createState() => _ChatarraSelectDialogState();
}

class _ChatarraSelectDialogState extends State<ChatarraSelectDialog> {
  final TextEditingController busqueda = TextEditingController();

  @override
  void initState() {
    busqueda.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        List<ChatarraSingle> data = [
          ...[...state.chatarraList?.list ?? []]
              .where((e) => e.estado != 'anulado')
              .toList()
        ];
        print(data);
        // //so filter the data
        data = data
            .where((e) =>
                e.balance.isEmpty &&
                e.lcl == widget.lcl &&
                !widget.pedidoList.contains(e.pedido))
            .where((e) => e.toList().any(
                (a) => a.toLowerCase().contains(busqueda.text.toLowerCase())))
            .toList();
        List<String> pedidos = data.map((e) => e.pedido).toSet().toList();

        return AlertDialog(
          title: const Text('Selecciona un pedido'),
          content: Container(
            height: 360,
            child: Column(
              children: [
                TextFormField(
                  controller: busqueda,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Búsqueda',
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 300,
                  width: 300,
                  child: 
                  // SizedBox(),

                  ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      String acta = data
                          .firstWhere((e) => e.pedido == pedidos[index])
                          .acta;
                      String fecha =
                          data.firstWhere((e) => e.pedido == pedidos[index]).fecha_i;
                      return ListTile(
                        isThreeLine: true,
                        title: Text(pedidos[index]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('$acta, '),
                                Text('fecha: $fecha'),
                              ],
                            ),
                            Text(
                                'items: ${state.chatarraList?.list.where((e) => e.pedido == pedidos[index]).length ?? 'x'}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(
                            context,
                            data.firstWhere((e) => e.pedido == pedidos[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
