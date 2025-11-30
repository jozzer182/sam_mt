import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/ingresos/model/ingresos_b.dart';
import 'package:v_al_sam_v02/resources/descarga_hojas.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

class IngresosTablaScreen extends StatefulWidget {
  const IngresosTablaScreen({super.key});

  @override
  State<IngresosTablaScreen> createState() => _IngresosTablaScreenState();
  // late bool isLoadingFuture;
}

class _IngresosTablaScreenState extends State<IngresosTablaScreen> {
  String filter = '';
  final ScrollController _controller = ScrollController();
  int endList = 70;
  bool firstTimeLoading = true;

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 70;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('INGRESOS')),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List? data = state.ingresosB?.ingresosBList;
          if (data == null || firstTimeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return FloatingActionButton(
            onPressed:
                () => DescargaHojas().ahora(
                  user: context.read<MainBloc>().state.user!,
                  datos: data,
                  nombre: 'Ingresos',
                ),
            child: Icon(Icons.download),
          );
        },
      ),
      body: body(),
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
      child: SizedBox(
        width: 300,
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
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
        var listaTitulo = state.ingresosB?.listaTitulo ?? [];
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
      },
    );
  }
  Widget futureMng() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        List<IngresosBSingle>? data = state.ingresosB?.ingresosBListSearch;
        if (data == null || firstTimeLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        data = data
            .where(
              (e) => e.toList().any(
                (el) => el.toLowerCase().contains(filter.toLowerCase()),
              ),
            )
            .toList();
            
        if (data.length > endList) {
          data = data.sublist(0, endList);
        }
        return tableData(
          datos: data,
          itemsAndFlex: state.ingresosB?.itemsAndFlex ?? {},
          keys: state.ingresosB?.keys ?? [],
        );
      },
    );
  }

  Widget tableData({
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
        User user = context.read<MainBloc>().state.user!;
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
                            ? !user.permisos.contains("anular_ingreso")
                                ? Container()
                                : anularRegistro(datos[index])
                            : SelectableText(
                              dato['texto'],
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget anularRegistro(IngresosBSingle datoSing) {
    return datoSing.estado == 'anulado'
        ? Container()
        : SizedBox(
          height: 16,
          child: IconButton(
            padding: EdgeInsets.all(0),
            iconSize: 16,
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Atención'),
                    content: Text(
                      'Se anulará el registro seleccionado, esta acción no de podrá deshacer, ¿Desea contitnuar?',
                    ),
                    actions: [
                      TextButton(
                        child: Text('CANCELAR'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('SI'),
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          context.read<MainBloc>().ingresosCtrl.anularDato(
                            pedido: datoSing.pedido,
                            item: datoSing.item,
                            hoja: 'ingresos',
                          );
                          // Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
  }
}
