import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:v_al_sam_v02/bloc/main_bloc.dart';
// / import 'package:v_al_sam_v02/src/models/registros_single.dart';
import 'package:v_al_sam_v02/resources/descarga_hojas.dart';
import 'package:v_al_sam_v02/planilla/view/planilla_page_edit.dart';
import 'package:v_al_sam_v02/user/user_model.dart';
import 'package:v_al_sam_v02/version.dart';

import '../model/resgistros_b.dart';

class RegistrosTablaScreen extends StatefulWidget {
  final String e4e;
  final String lcl;
  const RegistrosTablaScreen({super.key, this.e4e = '', this.lcl = ''});
  @override
  State<RegistrosTablaScreen> createState() => _RegistrosTablaScreenState();
  // late bool isLoadingFuture;
}

class _RegistrosTablaScreenState extends State<RegistrosTablaScreen> {
  String filter = '';
  int endList = 70;
  // late Future<List<IngresosModel>> future;
  // late Future<List<ResgistroSingle>> registrosFuture;
  bool isSearching = false;

  // widget.isLoadingFuture = false;
  TextEditingController busqueda = TextEditingController();
  List<ResgistroSingle> filtrado = [];
  List<ResgistroSingle> completo = [];
  List<Map<String, Object>> rows = [];
  DateTime dateReport = DateTime.now();
  bool _showDownloadButtons = false;

  final ScrollController _controller = ScrollController();
  bool isLoading = true;

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      // print('Cargando más');
      setState(() {
        endList += 70;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTROS'),
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
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              List<ResgistroSingle>? snap = state.registrosB?.registrosList;
              if (snap == null) return CircularProgressIndicator();
              return ElevatedButton(
                onPressed: () {
                  DescargaHojas().ahora(
                    user: context.read<MainBloc>().state.user!,
                    datos: snap,
                    nombre: 'Registros',
                  );
                },
                child: Text('Descargar'),
              );
            },
          ),
        ],
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
    return TextField(
      controller: busqueda,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Búsqueda',
      ),
      onChanged: (String value) {
        setState(() {
          filter = value;
        });
      },
    );
  }

  Widget titleRow() {
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
      {'texto': 'Estado', 'flex': 2},
      {'texto': 'x', 'flex': 1},
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

  Widget futureMng() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        var data = state.registrosB?.registrosListSearch;
        if (data == null) return Center(child: CircularProgressIndicator());
        data =
            data
                .where(
                  (e) => e.toList().any(
                    (el) => el.toLowerCase().contains(filter.toLowerCase()),
                  ),
                )
                .toList();
        if (widget.e4e.isNotEmpty) {
          data =
              data
                  .where(
                    (e) =>
                        e.e4e.toLowerCase().contains(widget.e4e.toLowerCase()),
                  )
                  .toList();
        }
        if (widget.lcl.isNotEmpty) {
          data =
              data
                  .where(
                    (e) =>
                        e.lcl.toLowerCase().contains(widget.lcl.toLowerCase()),
                  )
                  .toList();
        }
        if (data.length > endList) {
          data = data.sublist(0, endList);
        }

        return tableData(datos: data);
      },
    );
  }

  Widget tableData({required List<ResgistroSingle> datos}) {
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
          {'texto': datoSing.soporte_d_r, 'flex': 1, 'index': 'soporte_i'},
          {'texto': datoSing.item, 'flex': 1, 'index': 'item'},
          {'texto': datoSing.e4e, 'flex': 2, 'index': 'e4e'},
          {'texto': datoSing.descripcion, 'flex': 6, 'index': 'descripcion'},
          {'texto': datoSing.um, 'flex': 1, 'index': 'um'},
          {'texto': datoSing.ctd_total, 'flex': 1, 'index': 'ctd'},
          {'texto': datoSing.est_oficial_fecha, 'flex': 2, 'index': 'fecha_i'},
          {'texto': datoSing.est_oficial, 'flex': 2, 'index': 'est_oficial'},
          {'texto': null, 'flex': 1, 'index': 'estado'},
        ];
        // print(datos[index].toMap());
        TextEditingController _controller = TextEditingController(
          text: datos[index].lcl,
        );
        bool editLCL = false;
        void goTo(Widget page) {
          Navigator.push(context, version.createRoute(page));
        }

        User user = context.read<MainBloc>().state.user!;
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
                            : dato['index'] == 'estado'
                            ? !user.permisos.contains("anular_registro")
                                ? Container()
                                : anularRegistro(datoSing)
                            : dato['index'] == 'lcl'
                            ? LclField(
                              dato: datos[index],
                              lcl: datos[index].lcl,
                            )
                            : InkWell(
                              onLongPress: () {
                                // print('long press');
                                context
                                    .read<MainBloc>()
                                    .registrosCtrl
                                    .seleccionarPedido(pedido: datoSing.pedido);
                                goTo(PlanillaPageEdit());
                              },
                              onDoubleTap: () {
                                // print('long press');
                                context
                                    .read<MainBloc>()
                                    .registrosCtrl
                                    .seleccionarPedido(pedido: datoSing.pedido);
                                goTo(PlanillaPageEdit());
                              },
                              child: SelectableText(
                                dato['texto'],
                                textAlign: TextAlign.center,
                                style: TextStyle(),
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

  IconButton downloadButton(dato) {
    return IconButton(
      iconSize: 12,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      onPressed: () {
        launchUrl(Uri.parse(dato['texto']));
      },
      icon: Icon(Icons.download),
    );
  }

  Widget anularRegistro(ResgistroSingle datoSing) {
    return datoSing.est_oficial == 'anulado'
        ? Container()
        : IconButton(
          iconSize: 12,
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Atención',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
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
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        context.read<MainBloc>().registrosCtrl.anularDato(
                          pedido: datoSing.pedido,
                          item: datoSing.item,
                          hoja: 'registros',
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
  }
}

class LclField extends StatefulWidget {
  final String lcl;
  final ResgistroSingle dato;
  const LclField({super.key, required this.lcl, required this.dato});

  @override
  State<LclField> createState() => _LclFieldState();
}

class _LclFieldState extends State<LclField> {
  bool _editLCL = false;
  TextEditingController _controller = TextEditingController(text: "");

  @override
  void initState() {
    _controller.text = widget.lcl;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        // print('long');
        // setState(() {
        //   _editLCL = !_editLCL;
        // });
      },
      child: SizedBox(
        height: 30,
        child:
            !_editLCL
                ? Center(child: Text(widget.lcl))
                : TextField(
                  controller: TextEditingController(text: widget.lcl),
                  enabled: _editLCL,
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    suffixIcon:
                        _editLCL
                            ? IconButton(
                              visualDensity: VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                              padding: EdgeInsets.zero,
                              splashRadius: 14,
                              constraints: BoxConstraints(
                                minWidth: 2,
                                minHeight: 0,
                              ),
                              iconSize: 16,
                              tooltip: 'Guardar',
                              // hoverColor: Theme.of(context).colorScheme.primary,
                              icon: Icon(Icons.save),
                              onPressed: () {
                                print('save');
                                setState(() {
                                  _editLCL = false;
                                });
                                // context.read<MainBloc>().add(
                                //       CambioLCL(
                                //         map: widget.dato.toMap(),
                                //         lcl: _controller.text,
                                //         tabla: "registros",
                                //       ),
                                //     );
                              },
                            )
                            : null,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 1),
                  ),
                ),
      ),
    );
  }
}
