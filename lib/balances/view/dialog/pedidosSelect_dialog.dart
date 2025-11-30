import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';

import '../../../bloc/main_bloc.dart';

class PedidosSelectDialog extends StatefulWidget {
  final String lcl;
  final List<String> odmList;

  PedidosSelectDialog({
    required this.lcl,
    required this.odmList,
    Key? key,
  }) : super(key: key);

  @override
  State<PedidosSelectDialog> createState() => _PedidosSelectDialogState();
}

class _PedidosSelectDialogState extends State<PedidosSelectDialog> {
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
        List<ResgistroSingle> data = [
          ...[...state.registrosB?.registrosList ?? []]
              .where((e) => e.est_oficial != 'anulado')
              .toList()
        ];
        //so filter the data
        data = data
            .where((e) =>
                e.lm.isEmpty &&
                e.lcl == widget.lcl &&
                !widget.odmList.contains(e.odm))
            .where((e) => e.toList().any(
                (a) => a.toLowerCase().contains(busqueda.text.toLowerCase())))
            .toList();
        List<String> pedidos = data.map((e) => e.odm).toSet().toList();

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
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      String circuito = data
                          .firstWhere((e) => e.odm == pedidos[index])
                          .circuito;
                      String nodo =
                          data.firstWhere((e) => e.odm == pedidos[index]).nodo;
                      return ListTile(
                        isThreeLine: true,
                        title: Text(pedidos[index]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('$circuito, '),
                                Text('nodo: $nodo'),
                              ],
                            ),
                            Text(
                                'items: ${state.registrosB?.registrosList.where((e) => e.odm == pedidos[index]).length ?? 'x'}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(
                            context,
                            data.firstWhere((e) => e.odm == pedidos[index]),
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
