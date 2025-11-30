import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/ingresos/model/ingresos_b.dart';
import 'package:v_al_sam_v02/mb51/model/mb51_model.dart';
import 'package:intl/intl.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';

class PorCodigoPage extends StatefulWidget {
  const PorCodigoPage({super.key});

  @override
  State<PorCodigoPage> createState() => _PorCodigoPageState();
}

class _PorCodigoPageState extends State<PorCodigoPage> {
  String filter = '';
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Análisis por código')),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        searchField(),
        Divider(),
        Text('MB51', style: TextStyle(fontWeight: FontWeight.bold)),
        titleMB51(),
        tableMB51(),
        Divider(),
        Text('INGRESOS', style: TextStyle(fontWeight: FontWeight.bold)),
        titleIngresos(),
        tableIngresos(),
        Divider(),
        Text('SALIDAS', style: TextStyle(fontWeight: FontWeight.bold)),
        titleSalidas(),
        tableSalidas(),
        // Expanded(child: Text('some text')),
      ],
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
                // No action needed since filtering is done via setState
              },
            ),
            border: OutlineInputBorder(),
            labelText: 'Búsqueda',
          ),
          onChanged: (value) {
            if (value.length == 6) {
              setState(() {
                filter = value;
              });
            }
          },
        ),
      ),
    );
  }

  // MB51 table --------------------------------------------------
  Widget tableMB51() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // titleMB51(),
            futureMgtMB51(),
          ],
        ),
      ),
    );
  }

  Widget titleMB51() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.mb51B?.listaTitulo2 ?? [];
        return Row(
          children: [
            for (var titulo in listaTitulo)
              Expanded(
                flex: titulo['flex'],
                child: Text(
                  titulo['texto'].toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget futureMgtMB51() {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 800)),
      builder: (context, s) {
        if (s.connectionState == ConnectionState.done) {
          return BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              List<Mb51BSingle> lista = state.mb51B?.mb51BListSearch ?? [];

              // Aplicar filtrado local si hay un filtro
              if (filter.isNotEmpty) {
                lista =
                    lista
                        .where(
                          (e) => e.toMap().values.any(
                            (value) =>
                                value != null &&
                                value.toString().toLowerCase().contains(
                                  filter.toLowerCase(),
                                ),
                          ),
                        )
                        .toList();
              }

              int endList =
                  (state.mb51B?.view ?? 0) > lista.length
                      ? lista.length
                      : state.mb51B?.view2 ?? 0;

              return tableDataMb51(
                datos: lista.sublist(0, endList),
                itemsAndFlex: state.mb51B?.itemsAndFlex2 ?? {},
                keys: state.mb51B?.keys2 ?? [],
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget tableDataMb51({
    required List<Mb51BSingle> datos,
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
            {
              'texto': datoSing[key],
              'flex': itemsAndFlex[key][0],
              'index': key,
            },
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
                        color:
                            esIngreso
                                ? Theme.of(context).colorScheme.onErrorContainer
                                : Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // INGRESOS table --------------------------------------------------
  Widget tableIngresos() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // titleMB51(),
            futureMgtIngresos(),
          ],
        ),
      ),
    );
  }

  Widget titleIngresos() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.ingresosB?.listaTitulo ?? [];
        return Row(
          children: [
            for (var titulo in listaTitulo)
              Expanded(
                flex: titulo['flex'],
                child: Text(
                  titulo['texto'].toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget futureMgtIngresos() {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 300)),
      builder: (context, s) {
        if (s.connectionState != ConnectionState.done)
          return Center(child: CircularProgressIndicator());
        return BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            List<IngresosBSingle>? data = state.ingresosB?.ingresosBListSearch;
            if (data == null) return Center(child: CircularProgressIndicator());

            // Aplicar filtrado local si hay un filtro
            if (filter.isNotEmpty) {
              data =
                  data
                      .where(
                        (e) => e.toMap().values.any(
                          (value) =>
                              value != null &&
                              value.toString().toLowerCase().contains(
                                filter.toLowerCase(),
                              ),
                        ),
                      )
                      .toList();
            }

            int endList =
                (state.ingresosB?.view ?? 0) > data.length
                    ? data.length
                    : state.ingresosB?.view ?? 0;

            return tableDataIngresos(
              datos: data.sublist(0, endList),
              itemsAndFlex: state.ingresosB?.itemsAndFlex ?? {},
              keys: state.ingresosB?.keys ?? [],
            );
          },
        );
      },
    );
  }

  Widget tableDataIngresos({
    required List<IngresosBSingle> datos,
    required Map itemsAndFlex,
    required List keys,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        // print('ingresosBSingle: ${datos[index]}');
        var datoSing = datos[index].toMap();
        // print('datoSing: $datoSing');
        List listaDato = [
          for (var key in keys)
            {
              'texto': key == 'X' ? 'X' : datoSing[key],
              'flex': itemsAndFlex[key],
              'index': key,
            },
        ];
        return Center(
          child: Container(
            color: datos[index].estado == 'anulado' ? Colors.grey : null,
            child: Row(
              children: [
                for (var dato in listaDato)
                  Expanded(
                    flex: dato['flex'],
                    child:
                        dato['index'] == 'soporte_r'
                            ? SizedBox(
                              height: 16,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                iconSize: 16,
                                visualDensity: VisualDensity(
                                  horizontal: -4,
                                  vertical: -4,
                                ),
                                onPressed: () {
                                  String url =
                                      datos[index].soporte_r.isEmpty
                                          ? datos[index].soporte_i
                                          : datos[index].soporte_r;
                                  launchUrl(Uri.parse(url));
                                },
                                icon: Icon(Icons.download),
                              ),
                            )
                            : dato['index'] == 'X'
                            ? Container()
                            : SelectableText(
                              dato['texto'],
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // SALIDAS -----------------------------------------------------
  Widget tableSalidas() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // titleMB51(),
            futureMgtSalidas(),
          ],
        ),
      ),
    );
  }

  Widget titleSalidas() {
    List listaTitulo = [
      {'texto': 'Pedido', 'flex': 2},
      {'texto': 'Lcl', 'flex': 2},
      {'texto': 'Circuito', 'flex': 2},
      {'texto': 'Con', 'flex': 1},
      {'texto': 'Adj', 'flex': 1},
      {'texto': 'Item', 'flex': 1},
      {'texto': 'E4e', 'flex': 2},
      {'texto': 'Descripción', 'flex': 6},
      {'texto': 'Um', 'flex': 1},
      {'texto': 'Ctd total', 'flex': 1},
      {'texto': 'Fecha', 'flex': 2},
      {'texto': 'Usuario', 'flex': 4},
      // {'texto': 'x', 'flex': 1},
    ];
    return Row(
      children: [
        for (var titulo in listaTitulo)
          Expanded(
            flex: titulo['flex'],
            child: Text(
              titulo['texto'],
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget futureMgtSalidas() {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 400)),
      builder: (context, s) {
        if (s.connectionState != ConnectionState.done)
          return Center(child: CircularProgressIndicator());
        return BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            var data = state.registrosB?.registrosListSearch2;
            if (data == null) return Center(child: CircularProgressIndicator());

            // Aplicar filtrado local si hay un filtro
            if (filter.isNotEmpty) {
              data =
                  data
                      .where(
                        (e) => e.toMap().values.any(
                          (value) =>
                              value != null &&
                              value.toString().toLowerCase().contains(
                                filter.toLowerCase(),
                              ),
                        ),
                      )
                      .toList();
            }

            int endList =
                (state.registrosB?.view ?? 0) > data.length
                    ? data.length
                    : state.registrosB?.view ?? 0;
            return tableDataSalidas(datos: data.sublist(0, endList));
          },
        );
      },
    );
  }

  Widget tableDataSalidas({required List<ResgistroSingle> datos}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: datos.length,
      itemBuilder: (context, index) {
        ResgistroSingle datoSing = datos[index];
        List listaDato = [
          {'texto': datoSing.pedido, 'flex': 2, 'index': 'pedido'},
          {'texto': datoSing.lcl, 'flex': 2, 'index': 'lcl'},
          {'texto': datoSing.circuito, 'flex': 2, 'index': 'proyecto'},
          {'texto': datoSing.odm, 'flex': 1, 'index': 'proyecto'},
          {'texto': datoSing.soporte_d_e, 'flex': 1, 'index': 'soporte_i'},
          {'texto': datoSing.item, 'flex': 1, 'index': 'item'},
          {'texto': datoSing.e4e, 'flex': 2, 'index': 'e4e'},
          {'texto': datoSing.descripcion, 'flex': 6, 'index': 'descripcion'},
          {'texto': datoSing.um, 'flex': 1, 'index': 'um'},
          {'texto': datoSing.ctd_total, 'flex': 1, 'index': 'ctd'},
          {'texto': datoSing.fecha_e, 'flex': 2, 'index': 'fecha_i'},
          {'texto': datoSing.ingeniero_enel, 'flex': 4, 'index': 'fecha_i'},
          // {'texto': datoSing.est_oficial, 'flex': 2, 'index': 'est_oficial'},
          // {'texto': null, 'flex': 1, 'index': 'estado'},
        ];
        // print(datos[index].toMap());
        return Center(
          child: Container(
            color: datoSing.est_oficial == 'anulado' ? Colors.grey : null,
            child: Row(
              children: [
                for (var dato in listaDato)
                  Expanded(
                    flex: dato['flex'],
                    child:
                        dato['index'] == 'soporte_i'
                            ? downloadButton(dato)
                            : SelectableText(
                              dato['texto'],
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                    // ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget downloadButton(dato) {
    return SizedBox(
      height: 16,
      child: IconButton(
        padding: EdgeInsets.all(0),
        iconSize: 12,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        onPressed: () {
          launchUrl(Uri.parse(dato['texto']));
        },
        icon: Icon(Icons.download),
      ),
    );
  }
}
