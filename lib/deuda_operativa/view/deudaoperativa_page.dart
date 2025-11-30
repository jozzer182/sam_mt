import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/deuda_operativa/model/deudaoperativa_model.dart';
import 'package:intl/intl.dart';
import 'package:v_al_sam_v02/registros/view/registros_page.dart';
import 'package:v_al_sam_v02/resources/descarga_hojas.dart';
import 'package:v_al_sam_v02/version.dart';

class DeudaOperativaScreen extends StatefulWidget {
  const DeudaOperativaScreen({super.key});

  @override
  State<DeudaOperativaScreen> createState() => _DeudaOperativaScreenState();
}

class _DeudaOperativaScreenState extends State<DeudaOperativaScreen> {
  String filter = '';
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  bool isLoading = true;
  final ScrollController _controller = ScrollController();
  int endList = 60;
  @override
  void initState() {
    Timer(const Duration(milliseconds: 800), () {
      setState(() => isLoading = false);
    });

    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() => endList += 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DEUDA OPERATIVA')),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List? data = state.deudaOperativaB?.deudaOperativaB;
          if (data == null) return Center(child: CircularProgressIndicator());
          return FloatingActionButton(
            onPressed:
                () => DescargaHojas().ahora(
                  user: context.read<MainBloc>().state.user!,
                  datos: data,
                  nombre: 'DeudaOperativa',
                ),
            child: Icon(Icons.download),
          );
        },
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      controller: _controller,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [searchField(), titleRow(), futureMng()]),
      ),
    );
  }

  Widget searchField() {
    return Center(
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Búsqueda',
        ),
        onChanged: (value) {
          setState(() {
            filter = value;
          });
        },
      ),
    );
  }

  Widget titleRow() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var listaTitulo = state.deudaOperativaB?.listaTitulo ?? [];
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
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        List<DeudaOperativaBSingle> lista =
            state.deudaOperativaB?.deudaOperativaBListSearch ?? [];
        lista =
            lista
                .where(
                  (e) => e.toList().any(
                    (el) => el.toLowerCase().contains(filter.toLowerCase()),
                  ),
                )
                .toList();
        if (lista.length > endList) {
          lista = lista.sublist(0, endList);
        }
        return tableData(
          datos: lista,
          itemsAndFlex: state.deudaOperativaB?.itemsAndFlex ?? {},
          keys: state.deudaOperativaB?.keys ?? [],
        );
      },
    );
  }

  Widget tableData({
    required List<DeudaOperativaBSingle> datos,
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
        Color? fondo;
        if (int.parse(datos[index].faltanteUnidades) > 0)
          fondo = Theme.of(context).colorScheme.errorContainer;
        if (int.parse(datos[index].faltanteUnidades) < 0)
          fondo = Theme.of(context).colorScheme.surfaceVariant;
        bool esIngreso = int.parse(datos[index].faltanteUnidades) > 0;
        void goTo(Widget page) {
          Navigator.push(context, version.createRoute(page));
        }

        return Center(
          child: Container(
            color: fondo,
            child: InkWell(
              onLongPress: () {
                goTo(
                  RegistrosTablaScreen(
                    e4e: datos[index].e4e,
                    lcl: datos[index].lcl,
                  ),
                );
              },
              onTap: () {
                goTo(
                  RegistrosTablaScreen(
                    e4e: datos[index].e4e,
                    lcl: datos[index].lcl,
                  ),
                );
              },
              onDoubleTap: () {
                goTo(
                  RegistrosTablaScreen(
                    e4e: datos[index].e4e,
                    lcl: datos[index].lcl,
                  ),
                );
              },
              child: Row(
                children: [
                  for (var dato in listaDato)
                    Expanded(
                      flex: dato['flex'],
                      child: SelectableText(
                        dato['index'] != 'faltanteValor'
                            ? dato['texto']
                            : uSFormat.format(int.parse(dato['texto'])),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color:
                              esIngreso
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer
                                  : Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
