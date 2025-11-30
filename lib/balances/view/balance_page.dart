import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/balances/view/dialog/pedidosSelect_dialog.dart';
import 'package:v_al_sam_v02/balances/view/balance_pdf.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';
import 'package:v_al_sam_v02/resources/group_by_List.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../../bloc/main_bloc.dart';
import '../../chatarra/model/chatarra_list.dart';
import '../../resources/descarga_hojas.dart';
import '../../version.dart';
import 'balance_page_planilla_card.dart';
import 'dialog/chatarraSelect_dialog.dart';
import 'dialog/confirmEmail_dialog.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({
    required this.esNuevo,
    required this.user,
    this.lcl,
    this.lm,
    super.key,
  });
  final String? lcl;
  final String? lm;
  final bool esNuevo;
  final User user;

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  bool viewGrid = true;
  bool editMode = false;
  late bool viewMode;
  List<String> odmList = [];
  List<String> odmListToClear = [];
  List<String> pedidoList = [];
  List<String> pedidoListToClear = [];
  String lcl = '';
  String fecha = '';
  String balance = '';
  String comentario = '';
  String estado = 'Borrador';
  bool isLoading = false;
  bool confirm = false;
  String email = '';
  EmailDialog? emailDialog;

  void deleteOdm(String odm) {
    setState(() {
      odmList.remove(odm);
    });
    if (editMode) {
      odmListToClear.add(odm);
    }
  }

  void deletePedido(String pedido) {
    setState(() {
      pedidoList.remove(pedido);
    });
    if (editMode) {
      pedidoListToClear.add(pedido);
    }
  }

  Future lastBalance() async {
    String ultimoBalance =
        await context.read<MainBloc>().balancesCtrl.lastBalance();
    setState(() => balance = ultimoBalance);
  }

  @override
  void initState() {
    viewMode = widget.lcl != null && widget.lm != null;
    if (widget.esNuevo) lastBalance();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isReady =
        lcl.isNotEmpty &&
        fecha.isNotEmpty &&
        balance.isNotEmpty &&
        (odmList.isNotEmpty || pedidoList.isNotEmpty);
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        isLoading = state.isLoading;
        List<ResgistroSingle> data = [
          ...[
            ...state.registrosB?.registrosList ?? [],
          ].where((e) => e.est_oficial != 'anulado').toList(),
        ];
        List<ChatarraSingle> dataChatarra = [
          ...[
            ...state.chatarraList?.list ?? [],
          ].where((e) => e.estado != 'anulado').toList(),
        ];
        String fechaView =
            data
                .firstWhere(
                  (e) => (e.lcl == widget.lcl && e.lm == widget.lm),
                  orElse: () => ResgistroSingle.zero(),
                )
                .fecha_conciliacion;
        String comentarioView =
            data
                .firstWhere(
                  (e) => (e.lcl == widget.lcl && e.lm == widget.lm),
                  orElse: () => ResgistroSingle.zero(),
                )
                .comentario_op;
        String est_contratoView =
            data
                .firstWhere(
                  (e) => (e.lcl == widget.lcl && e.lm == widget.lm),
                  orElse: () => ResgistroSingle.zero(),
                )
                .est_contrato;
        String responsable_contratoView =
            data
                .firstWhere(
                  (e) => (e.lcl == widget.lcl && e.lm == widget.lm),
                  orElse: () => ResgistroSingle.zero(),
                )
                .responsable_contrato;
        if (viewMode) {
          odmList =
              data
                  .where((e) => (e.lcl == widget.lcl && e.lm == widget.lm))
                  .map((e) => e.odm)
                  .toSet()
                  .toList();
          pedidoList =
              dataChatarra
                  .where((e) => (e.lcl == widget.lcl && e.balance == widget.lm))
                  .map((e) => e.pedido)
                  .toSet()
                  .toList();
        }
        // ignore: unused_local_variable
        int items = data.where((e) => odmList.contains(e.odm)).length;
        if (est_contratoView.isNotEmpty && estado == 'Borrador') {
          estado = est_contratoView;
        }
        List<ResgistroSingle> dataToSum =
            data.where((e) => (odmList.contains(e.odm))).toList();
        List<Map<String, dynamic>> e4eSum = GroupBy.list(
          data:
              dataToSum
                  .map(
                    (e) => {
                      ...e.toMap(),
                      ...{
                        'ctd_entregada': GroupBy.aInt(e.ctd_e),
                        'ctd_reintregada': GroupBy.aInt(e.ctd_r),
                        'ctd_instalda': GroupBy.aInt(e.ctd_total),
                      },
                    },
                  )
                  .toList(),
          keysToSelect: ['e4e', 'descripcion', 'um'],
          keysToSum: ['ctd_entregada', 'ctd_reintregada', 'ctd_instalda'],
        );
        //Chatarra
        List<ChatarraSingle> dataToSumChatarra =
            dataChatarra.where((e) => (pedidoList.contains(e.pedido))).toList();
        List<Map<String, dynamic>> e4eSumChatarra = GroupBy.list(
          data:
              dataToSumChatarra
                  .map(
                    (e) => {
                      ...e.toMap(),
                      ...{
                        'ctd_entregada': 0,
                        'ctd_reintregada': GroupBy.aInt(e.ctd),
                        'ctd_instalda': 0,
                      },
                    },
                  )
                  .toList(),
          keysToSelect: ['e4e', 'descripcion', 'um'],
          keysToSum: ['ctd_entregada', 'ctd_reintregada', 'ctd_instalda'],
        );
        e4eSum = [...e4eSum, ...e4eSumChatarra];
        e4eSum.sort((a, b) => a['e4e'].compareTo(b['e4e']));
        // print(e4eSum);
        return Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: BlocSelector<MainBloc, MainState, bool>(
                selector: (state) => state.isLoading,
                builder: (context, state) {
                  return state ? LinearProgressIndicator() : SizedBox();
                },
              ),
            ),
            title:
                viewMode
                    ? const Text("Balance")
                    : editMode
                    ? const Text("Editar Balance")
                    : const Text("Nuevo Balance"),
            automaticallyImplyLeading: !isLoading,
            actions: [
              if (viewMode)
                ElevatedButton(
                  onPressed:
                      () => generatePdf(e4eSum: e4eSum, registros: dataToSum),
                  child: Text('PDF'),
                )
              else
                SizedBox(),
              if (viewMode)
                ElevatedButton(
                  onPressed: () async {
                    await DescargaHojas.ahoraMap(
                      datos: e4eSum,
                      nombre: 'LCL ${widget.lcl} LM ${widget.lm}',
                      user: context.read<MainBloc>().state.user!,
                    );
                  },
                  child: Text('Descarga'),
                )
              else
                SizedBox(),
              if ((viewMode || editMode) &&
                  !isLoading &&
                  (estado == "Borrador" || estado == "Rechazado"))
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      viewMode = !viewMode;
                      editMode = !editMode;
                    });
                  },
                  child: editMode ? Text('Cancelar') : Text('Editar'),
                )
              else
                SizedBox(),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    //onprimary Color
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                )
              else
                ElevatedButton(
                  onPressed:
                      !isReady && !editMode
                          ? null
                          : () async {
                            setState(() => isLoading = true);
                            if (estado == "Solicitado") {
                              emailDialog = await showDialog(
                                context: context,
                                builder: (c) => ConfirmEmailDialog(),
                              );
                              if (confirm && email.isNotEmpty) {}
                            }
                            if (estado != "Solicitado" || emailDialog != null) {
                              String balanceEnviar =
                                  balance.isEmpty ? widget.lm! : balance;
                              String fechaEnviar =
                                  fecha.isEmpty ? fechaView : fecha;
                              String comentarioEnviar =
                                  comentario.isEmpty
                                      ? comentarioView
                                      : comentario;
                              context
                                  .read<MainBloc>()
                                  .balancesCtrl
                                  .guardarBalance(
                                    pedidoList: pedidoList,
                                    pedidoListToClear: pedidoListToClear,
                                    balance: balanceEnviar,
                                    odmList: odmList,
                                    odmListToClear: odmListToClear,
                                    lcl: lcl.isEmpty ? widget.lcl! : lcl,
                                    fecha: fechaEnviar,
                                    esNuevo: widget.esNuevo,
                                    comentario: comentarioEnviar,
                                    estado: estado,
                                    context: context,
                                  );
                            }
                            setState(() => isLoading = false);
                          },
                  child: Text('Guardar'),
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
                  Version.status('Balances', ''),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
          floatingActionButton:
              viewMode || isLoading || (lcl.isEmpty && widget.lcl == null)
                  ? SizedBox()
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 48.0,
                        child: RawMaterialButton(
                          fillColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            ChatarraSingle? pedidoChatarra = await showDialog(
                              context: context,
                              builder:
                                  (c) => ChatarraSelectDialog(
                                    lcl: lcl.isEmpty ? widget.lcl! : lcl,
                                    pedidoList: pedidoList,
                                  ),
                            );
                            if (pedidoChatarra != null) {
                              setState(() {
                                pedidoList.add(pedidoChatarra.pedido);
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Agregar\nChatarra',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 48.0,
                        child: RawMaterialButton(
                          fillColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            ResgistroSingle? pedido = await showDialog(
                              context: context,
                              builder:
                                  (c) => PedidosSelectDialog(
                                    lcl: lcl.isEmpty ? widget.lcl! : lcl,
                                    odmList: odmList,
                                  ),
                            );
                            if (pedido != null) {
                              setState(() {
                                odmList.add(pedido.odm);
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Agregar\nRemisiones',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                          viewMode
                              ? TextFormField(
                                initialValue: widget.lcl,
                                readOnly: viewMode,
                                decoration: InputDecoration(
                                  labelText: 'LCL',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    lcl = value;
                                  });
                                },
                              )
                              : Autocomplete<String>(
                                displayStringForOption: (option) {
                                  return option;
                                },
                                optionsBuilder: (textEditingValue) {
                                  var optionsX =
                                      context
                                          .read<MainBloc>()
                                          .state
                                          .registrosB!
                                          .registrosList
                                          .where(
                                            (e) => e.lcl.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ),
                                          )
                                          .map((e) => e.lcl.trim())
                                          .toSet()
                                          .toList();
                                  optionsX.sort((a, b) => b.compareTo(a));
                                  return optionsX;
                                },
                                optionsViewBuilder: (
                                  context,
                                  onSelected,
                                  options,
                                ) {
                                  return Material(
                                    child: ListView.builder(
                                      itemCount: options.length,
                                      itemBuilder: (context, i) {
                                        String option = options.toList()[i];
                                        return ListTile(
                                          title: Text(
                                            option,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          onTap: () {
                                            onSelected(options.toList()[i]);
                                            setState(() {
                                              lcl = option;
                                              odmList.clear();
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                fieldViewBuilder: (
                                  context,
                                  textEditingController,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  if (widget.lcl != null) {
                                    textEditingController.text = widget.lcl!;
                                  }
                                  return TextField(
                                    controller:
                                        textEditingController, // Required by autocomplete
                                    focusNode:
                                        focusNode, // Required by autocomplete
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        lcl = value;
                                        odmList.clear();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'LCL',
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                              ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (balance.isEmpty && widget.lm != null) {
                            balance = widget.lm!;
                          }
                          if (balance.isEmpty && widget.lm == null) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return TextFormField(
                            initialValue: balance,
                            readOnly: true,
                            onChanged: (value) {
                              setState(() {
                                balance = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Balance',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextFormField(
                        onTap:
                            viewMode
                                ? null
                                : () async {
                                  DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2030),
                                  );
                                  if (newDate != null) {
                                    setState(() {
                                      fecha =
                                          '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}';
                                    });
                                  }
                                },
                        readOnly: true,
                        controller: TextEditingController(
                          text:
                              viewMode
                                  ? fechaView
                                  : fecha.isEmpty
                                  ? fechaView
                                  : fecha,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextFormField(
                        initialValue: comentarioView,
                        readOnly: viewMode,
                        onChanged: (value) {
                          setState(() {
                            comentario = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Comentario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue:
                            viewMode
                                ? responsable_contratoView
                                : state.user!.nombre,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Persona',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        setState(() => viewGrid = !viewGrid);
                      },
                      icon: Icon(Icons.shelves),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (viewGrid)
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: [...odmList, ...pedidoList].length,
                    itemBuilder: (context, index) {
                      return PlanillaCard(
                        esChatarra: pedidoList.contains(
                          [...odmList, ...pedidoList][index],
                        ),
                        odm: [...odmList, ...pedidoList][index],
                        deleteOdm: deleteOdm,
                        viewMode: viewMode,
                        editMode: editMode,
                        deletePedido: deletePedido,
                      );
                    },
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: e4eSum.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          for (String keyE4e in e4eSum[index].keys.toList())
                            Expanded(
                              flex: keyE4e == "descripcion" ? 6 : 1,
                              child: Text(
                                e4eSum[index][keyE4e].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LinearIndicatorTime extends StatefulWidget {
  final int tiempo;
  const LinearIndicatorTime({required this.tiempo, Key? key}) : super(key: key);

  @override
  State<LinearIndicatorTime> createState() => _LinearIndicatorTimeState();
}

class _LinearIndicatorTimeState extends State<LinearIndicatorTime>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.tiempo),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController)..addListener(() {
      setState(() {});
    });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(value: _animation.value);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
