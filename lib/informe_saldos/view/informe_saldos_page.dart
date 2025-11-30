import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/deuda_almacen/model/deudaalmacen_model.dart';
import 'package:v_al_sam_v02/informe_saldos/model/informe_saldos_model.dart';
import 'package:intl/intl.dart';

class SaldosScreen extends StatefulWidget {
  const SaldosScreen({super.key});

  @override
  State<SaldosScreen> createState() => _SaldosScreenState();
}

class _SaldosScreenState extends State<SaldosScreen> {
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INFORME DE SALDOS'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? LinearProgressIndicator() : SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          Saldos? saldos = state.saldos;
          if (saldos == null || state.isLoading)
            return CircularProgressIndicator();
          return FloatingActionButton(
            onPressed: () async {
              context.read<MainBloc>().informeSaldosCtrl.calcularSaldos();
            },
            child: Icon(Icons.download),
          );
        },
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // searchField(),
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
          decoration: InputDecoration(
            prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {}),
            border: OutlineInputBorder(),
            labelText: 'Búsqueda',
          ),
        ),
      ),
    );
  }

  Widget titleRow(List<Map> listaTitulo) {
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
  }

  Widget futureMng() {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 600)),
      builder: (context, s) {
        if (s.connectionState != ConnectionState.done)
          return Center(child: CircularProgressIndicator());
        return BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            var listaTitulo = state.saldos?.listaTitulo ?? [];
            List<DeudaAlmacenBSingle>? data = state.saldos?.saldosList;
            if (data == null) return Center(child: CircularProgressIndicator());
            return Column(
              children: [
                titleRow(listaTitulo),
                tableData(
                  datos: data,
                  itemsAndFlex: state.deudaAlmacenB?.itemsAndFlex ?? {},
                  keys: state.deudaAlmacenB?.keys ?? [],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget tableData({
    required List<DeudaAlmacenBSingle> datos,
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
        var datox = datos[index];
        bool esIngreso = int.parse(datos[index].faltanteUnidades) > 0;
        // print('itemBuilder');
        return Center(
          child: Row(
            children: [
              for (var dato in listaDato)
                Expanded(
                  flex: dato['flex'],
                  child:
                      dato['index'] == 'inv'
                          ? SizedBox(
                            height: 30,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: datox.inv,
                                isDense: true,
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                value = value.isEmpty ? '0' : value;
                                context
                                    .read<MainBloc>()
                                    .informeSaldosCtrl
                                    .cambioSaldos(index: index, inv: value);
                              },
                            ),
                          )
                          : SelectableText(
                            dato['index'] == 'faltanteValor'
                                ? uSFormat.format(int.parse(dato['texto']))
                                : dato['texto'],
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color:
                                  esIngreso
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                ),
            ],
          ),
        );
      },
    );
  }
}
