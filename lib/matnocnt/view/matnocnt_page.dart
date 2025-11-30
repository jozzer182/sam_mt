import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:intl/intl.dart';
import 'package:v_al_sam_v02/matnocnt/model/matnocnt_model.dart';

import '../../resources/descarga_hojas.dart';

class MatNoPage extends StatefulWidget {
  const MatNoPage({super.key});

  @override
  State<MatNoPage> createState() => _MatNoPageState();
}

class _MatNoPageState extends State<MatNoPage> {
  String filter = '';
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  final ScrollController _controller = ScrollController();
  int endList = 70;
  bool firstTimeLoading = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        firstTimeLoading = false;
      });
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
      setState(() {
        endList += 70;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.matno == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        String fechaActualizado = state.matno?.matnoList.first.actualizado ?? '';
        if (fechaActualizado.isNotEmpty) {
          fechaActualizado = fechaActualizado.substring(0, 16).replaceAll("T", "\n");
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('MATERIAL NO CONTABILIZADO'),
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
          floatingActionButton: BlocSelector<MainBloc, MainState, Matno?>(
            selector: (state) => state.matno,
            builder: (context, state) {
              return state == null
                  ? SizedBox()
                  : FloatingActionButton(
                      onPressed: () => DescargaHojas().ahora(
                          user: context.read<MainBloc>().state.user!,
                          datos: state.matnoList,
                          nombre: 'matno'),
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
      controller: _controller,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Listado de material no contabilizado, los colores indican comparación con mb52.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            searchField(),
            SizedBox(height: 20),
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
                // context.read<MainBloc>().add(Busqueda(busqueda.text));
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
        var listaTitulo = state.matno?.listaTitulo ?? [];
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
        List<MatnoSingle> lista = state.matno?.matnoListSearch ?? [];
        if (lista.isEmpty || firstTimeLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (filter.isNotEmpty) {
          lista = lista
              .where(
                (e) => e.toList().any(
                  (el) => el.toString().toLowerCase().contains(filter.toLowerCase()),
                ),
              )
              .toList();
        }
        
        if (lista.length > endList) {
          lista = lista.sublist(0, endList);
        }
        return tableData(
          datos: lista,
          itemsAndFlex: state.matno?.itemsAndFlex ?? {},
          keys: state.matno?.keys ?? [],
        );
      },
    );
  }

  Widget tableData(
      {required List<MatnoSingle> datos,
      required Map itemsAndFlex,
      required List keys}) {
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
              'index': key
            },
        ];
        // print('datoSing: $datoSing');
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
                            color: datos[index].isMb52,
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
}
