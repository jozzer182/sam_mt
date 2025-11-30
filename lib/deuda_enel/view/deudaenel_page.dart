import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/deuda_enel/model/deudaenel_model.dart';
import 'package:intl/intl.dart';

import '../../resources/descarga_hojas.dart';

class DeudaEnelScreen extends StatefulWidget {
  const DeudaEnelScreen({Key? key}) : super(key: key);

  @override
  State<DeudaEnelScreen> createState() => _DeudaEnelScreenState();
}

class _DeudaEnelScreenState extends State<DeudaEnelScreen> {
  String filter = '';
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  bool isLoading = true;
  final ScrollController _controller = ScrollController();
  int view = 60;
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
      setState(() => view += 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DEUDA ENEL')),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List? data = state.deudaBrutaB?.deudaList;
          if (data == null) return Center(child: CircularProgressIndicator());
          return FloatingActionButton(
            onPressed: () => DescargaHojas().ahora(
                user: context.read<MainBloc>().state.user!,
                datos: data,
                nombre: 'DeudaEnel'),
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
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
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
        var listaTitulo = state.deudaEnelB?.listaTitulo ?? [];
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
        List<DeudaEnelBSingle> lista = state.deudaEnelB?.deudaEnelListSearch ?? [];
        lista = lista
            .where(
              (e) => e.toList().any(
                (el) => el.toLowerCase().contains(filter.toLowerCase()),
              ),
            )
            .toList();
        int endList = view > lista.length ? lista.length : view;
        return tableData(
          datos: lista.sublist(0, endList),
          itemsAndFlex: state.deudaEnelB?.itemsAndFlex ?? {},
          keys: state.deudaEnelB?.keys ?? [],
        );
      },
    );
  }

  Widget tableData({
    required List<DeudaEnelBSingle> datos,
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
        bool esIngreso = int.parse(datos[index].faltanteUnidades) > 0;
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
                      dato['index'] != 'faltanteValor'
                          ? dato['texto']
                          : uSFormat.format(int.parse(dato['texto'])),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: esIngreso
                              ? Theme.of(context).colorScheme.onErrorContainer
                              : Theme.of(context).colorScheme.onSurface),
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
