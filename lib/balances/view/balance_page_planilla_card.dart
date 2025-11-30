
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/main_bloc.dart';
import '../../chatarra/model/chatarra_list.dart';
import '../../registros/model/resgistros_b.dart';
import '../../resources/descarga_hojas.dart';

class PlanillaCard extends StatelessWidget {
  const PlanillaCard({
    super.key,
    required this.esChatarra,
    required this.odm,
    required this.deleteOdm,
    required this.viewMode,
    required this.editMode,
    required this.deletePedido,
  });

  final String odm;
  final Function deleteOdm;
  final bool viewMode;
  final bool editMode;
  final bool esChatarra;
  final Function deletePedido;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          String nodo = '';
          String items = '';
          String link = '';
          List<Map<String, dynamic>> lista = [];
          if (esChatarra) {
            List<ChatarraSingle> data = [...state.chatarraList?.list ?? []];
            nodo = data.firstWhere((e) => e.pedido == odm).acta;
            lista =
                data
                    .where((e) => e.pedido == odm)
                    .map((e) => e.toMap())
                    .toList();
            items = data.where((e) => e.pedido == odm).length.toString();
            link = data.firstWhere((e) => e.pedido == odm).soporte_i;
          } else {
            List<ResgistroSingle> data = [
              ...state.registrosB?.registrosList ?? [],
            ];
            nodo = data.firstWhere((e) => e.odm == odm).nodo;
            lista =
                data.where((e) => e.odm == odm).map((e) => e.toMap()).toList();
            items = data.where((e) => e.odm == odm).length.toString();
            link = data.firstWhere((e) => e.odm == odm).soporte_d_r;
          }
          return ListTile(
            isThreeLine: true,
            tileColor: esChatarra ? Colors.grey[100] : null,
            title: Text(odm),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Text('$circuito, '),
                    Text('$nodo', style: TextStyle(fontSize: 9)),
                  ],
                ),
                Text('items: $items'),
              ],
            ),
            trailing:
                viewMode
                    ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            splashRadius: 14,
                            visualDensity: VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            iconSize: 20,
                            onPressed: () {
                              launchUrl(Uri.parse(link));
                            },
                            icon: Icon(Icons.picture_as_pdf),
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 20,
                          child: IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.all(0),
                            splashRadius: 14,
                            visualDensity: VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            onPressed: () async {
                              await DescargaHojas.ahoraMap(
                                datos: lista,
                                nombre: 'REMISION $odm',
                                user: context.read<MainBloc>().state.user!,
                              );
                            },
                            icon: Icon(Icons.download),
                          ),
                        ),
                      ],
                    )
                    : IconButton(
                      onPressed: () {
                        if (esChatarra) {
                          deletePedido(odm);
                        } else {
                          deleteOdm(odm);
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
          );
        },
      ),
    );
  }
}
