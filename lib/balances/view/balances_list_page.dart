import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';
import 'package:v_al_sam_v02/resources/group_by_List.dart';

import '../../chatarra/model/chatarra_list.dart';
import '../../version.dart';
import 'balance_page.dart';

class BalancesListPage extends StatefulWidget {
  const BalancesListPage({Key? key}) : super(key: key);

  @override
  State<BalancesListPage> createState() => _BalancesListPageState();
}

class _BalancesListPageState extends State<BalancesListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _estado = "";

  initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) {
      Navigator.push(context, version.createRoute(page));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Balances"),
        actions: [
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  goTo(
                    BalancePage(
                      user: state.user!,
                      esNuevo: true,
                    ),
                  );
                },
                child: const Text(
                  'Crear\nBalance',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Version.data,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              Version.status('Home', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            List<ResgistroSingle> data = [
              ...state.registrosB?.registrosList ?? []
            ];
            //so filter the data
            data = data.where((e) => e.lm.isNotEmpty).toList();
            List<ChatarraSingle> dataChatarra = [
              ...[...state.chatarraList?.list ?? []]
                  .where((e) => e.estado != 'anulado')
                  .where((e) => e.balance.isNotEmpty)
                  .toList()
            ];
            if (_searchController.text.isNotEmpty) {
              data = data
                  .where((e) =>
                      e.lm
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()) ||
                      e.lcl.contains(_searchController.text.toLowerCase()))
                  .toList();
              dataChatarra = dataChatarra
                  .where((e) =>
                      e.balance
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()) ||
                      e.lcl.contains(_searchController.text.toLowerCase()))
                  .toList();
            }
            if (_estado.isNotEmpty) {
              data = data
                  .where((e) => e.est_contrato
                      .toLowerCase()
                      .contains(_estado.toLowerCase()))
                  .toList();
            }
            List justLclBalanceChatarra = GroupBy.list(
              data: dataChatarra
                  .map((e) => {
                        ...e.toMap(),
                        ...{'items': 1}
                      })
                  .toList(),
              keysToSelect: ['lcl', 'balance'],
              keysToSum: ['items'],
            );
            List justLclLm = GroupBy.list(
              data: data
                  .map((e) => {
                        ...e.toMap(),
                        ...{'items': 1}
                      })
                  .toList(),
              keysToSelect: ['lcl', 'lm'],
              keysToSum: ['items'],
            );
            justLclLm = [...justLclLm, ...justLclBalanceChatarra].toSet().toList();
            justLclLm.sort((a, b) => (b['lm']??b['balance']).compareTo((a['lm']??a['balance'])) );
            print(justLclLm);
            return SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Búsqueda',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: justLclLm.length,
                    itemBuilder: (context, index) {
                      String lcl = justLclLm[index]['lcl'].toString();
                      String lm = justLclLm[index]['lm'] ?? justLclLm[index]['balance'];
                      // String estado = data
                      //     .firstWhere((e) => (e.lcl == lcl && e.lm == lm))
                      //     .est_contrato;
                      void goTo(Widget page) {
                        Navigator.push(context, version.createRoute(page));
                      }
            
                      return InkWell(
                        onTap: () {
                          goTo(
                            BalancePage(
                              lcl: justLclLm[index]['lcl'].toString(),
                              user: state.user!,
                              lm: lm,
                              esNuevo: false,
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            isThreeLine: false,
                            title: Text(lcl),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Balance: $lm'),
                                // Text(estado),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
