
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/mb52/mb52_b.dart';
import 'package:intl/intl.dart';
import 'package:v_al_sam_v02/resources/descarga_hojas.dart';

class Mb52Screen extends StatefulWidget {
  Mb52Screen({Key? key}) : super(key: key);

  @override
  State<Mb52Screen> createState() => _Mb52ScreenState();
}

class _Mb52ScreenState extends State<Mb52Screen> {
  String filter = '';
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.mb52B == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        String fechaActualizado =
            state.mb52B?.mb52BList.first.actualizado ?? '';
        if (fechaActualizado.isNotEmpty) {
          fechaActualizado =
              fechaActualizado.substring(0, 16).replaceAll("T", "\n");
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('MB52'),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Actualizado:\n$fechaActualizado',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Gap(10),
            ],
          ),
          floatingActionButton: BlocSelector<MainBloc, MainState, Mb52B?>(
            selector: (state) => state.mb52B,
            builder: (context, state) {
              return state == null
                  ? SizedBox()
                  : FloatingActionButton(
                      onPressed: () => DescargaHojas().ahora(
                          user: context.read<MainBloc>().state.user!,
                          datos: state.mb52BList,
                          nombre: 'MB52'),
                      child: Icon(Icons.download),
                    );
            },
          ),
          body: body(),
        );
      },
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            searchField(),
            titleRow(),
            futureMng(),
          ],
        ),
      ),
    );
  }
  Widget searchField() {
    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          // controller: busqueda,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // No action needed as filtering is done via setState
              },
            ),
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
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.mb52B?.listaTitulo ?? [];
        return Row(
          children: [
            for (var titulo in listaTitulo)
              Expanded(
                flex: titulo['flex'],
                child: Text(
                  titulo['texto'].toString().toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }
  Widget futureMng() {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 800)),
      builder: (context, s) {
        if (s.connectionState == ConnectionState.done) {
          return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
            List<Mb52BSingle> lista = state.mb52B?.mb52BListSearch ?? [];
            
            // Aplicar filtrado local si hay un filtro
            if (filter.isNotEmpty) {
              lista = lista
                .where(
                  (e) => e.toMap().values.any(
                    (value) => value != null && 
                      value.toString().toLowerCase().contains(filter.toLowerCase()),
                  ),
                )
                .toList();
            }
            
            return tableData(
              datos: lista,
              itemsAndFlex: state.mb52B?.itemsAndFlex ?? {},
              keys: state.mb52B?.keys ?? [],
            );
          });
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget tableData({
    required List<Mb52BSingle> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        Map datoSing = datos[index].toMap();
        List listaDato = [
          for (var key in keys)
            {'texto': datoSing[key], 'flex': itemsAndFlex[key], 'index': key},
        ];
        bool esIngreso = false;
        return Center(
          child: Container(
            color:
                esIngreso ? Theme.of(context).colorScheme.errorContainer : null,
            child: Row(
              children: [
                for (var dato in listaDato)
                  Expanded(
                    flex: dato['flex'],
                    child: SelectableText(
                      dato['index'] != 'valor'
                          ? dato['texto']
                          : uSFormat.format(int.parse(dato['texto'])),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: esIngreso
                              ? Theme.of(context).colorScheme.onErrorContainer
                              : Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
