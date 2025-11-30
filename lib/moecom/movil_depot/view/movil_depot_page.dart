import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/toCurrency.dart';
import '../../../resources/transicion_pagina.dart';
import '../../../version.dart';
import '../../consumos_mc/view/consumos_mc_page_edit.dart';
import '../../entregas_mc/view/entregas_mc_page.dart';
import '../../consumos_mc/view/consumos_mc_page.dart';
import '../../entregas_mc/view/entregas_mc_page_edit.dart';
import '../model/movil_depot_model.dart';
import 'movil_depot_page_movs.dart';

class MovilDepotPage extends StatefulWidget {
  const MovilDepotPage({super.key});

  @override
  State<MovilDepotPage> createState() => _MovilDepotPageState();
}

class _MovilDepotPageState extends State<MovilDepotPage> {
  String filter = '';
  @override
  void initState() {
    context.read<MainBloc>().movilDepotCtrl.crear;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) {
      Navigator.push(context, createRoute(page));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MOE - COM (Movil Depot)'),
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
          // ElevatedButton(
          //   onPressed: () {},
          //   child: const Text('Ver\nMovimientos', textAlign: TextAlign.center),
          // ),
          // const Gap(5),
          ElevatedButton(
            onPressed: () => goTo(EntregasMcPageEdit()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            child: Text(
              'NUEVA\nENTREGA',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
          const Gap(5),
          ElevatedButton(
            onPressed: () => goTo(EntregasMcPage()),
            child: const Text(
              'Entregas\nReintegros',
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(5),
          ElevatedButton(
            onPressed: () => goTo(ConsumosMcPage()),

            child: const Text(
              'Consumos\nTDC-TICKET',
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            onPressed: () => goTo(ConsumoMcPageEdit()),
            child: Text(
              'NUEVO\nCONSUMO',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
          const Gap(5),
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
          if (state.movilDepotList == null) {
            return const Center(child: CircularProgressIndicator());
          }
          List<MovilDepot> list = state.movilDepotList!.list;
          if (filter.isNotEmpty) {
            list =
                list
                    .where(
                      (e) => e.toList().any(
                        (element) => element.toLowerCase().contains(
                          filter.toLowerCase(),
                        ),
                      ),
                    )
                    .toList();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          childAspectRatio: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          mainAxisExtent: 115,
                        ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return MdCard(
                        tecnicoid: list[index].tecnicoid,
                        tecnico: list[index].tecnico,
                        valor: list[index].valor,
                        tecnicotype: list[index].tecnicotype,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MdCard extends StatefulWidget {
  final String tecnicoid;
  final String tecnico;
  final int valor;
  final String tecnicotype;
  const MdCard({
    super.key,
    required this.tecnicoid,
    required this.tecnico,
    required this.valor,
    required this.tecnicotype,
  });

  @override
  State<MdCard> createState() => _MdCardState();
}

class _MdCardState extends State<MdCard> {
  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) {
      Navigator.push(context, createRoute(page));
    }

    return InkWell(
      onTap: () {
        goTo(
          MovilDepotPageMovs(
            tecnicoid: widget.tecnicoid,
            tecnico: widget.tecnico,
            tecnicotype: widget.tecnicotype,
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(widget.tecnicotype), Text(widget.tecnicoid)],
              ),
              Text(
                widget.tecnico,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Tooltip(
                message: toCurrencyCOP(widget.valor.toString()),
                child: Text(
                  '${enMillon1(widget.valor)} MCOP',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
