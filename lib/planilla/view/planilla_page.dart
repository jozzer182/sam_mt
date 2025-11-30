import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/inventario/model/inventario_model.dart';
import 'package:v_al_sam_v02/planilla/model/planilla_model.dart';
import 'package:v_al_sam_v02/resources/file_uploader.dart';

import '../../lcl/model/lcl_model.dart';

class PlanillaPage extends StatefulWidget {
  const PlanillaPage({super.key});

  @override
  State<PlanillaPage> createState() => _PlanillaPageState();
}

class _PlanillaPageState extends State<PlanillaPage>
    with TickerProviderStateMixin {
  TextEditingController dateControllerEntrega = TextEditingController();
  TextEditingController dateControllerReintegro = TextEditingController();
  TextEditingController rowsController = TextEditingController();
  TextEditingController fileUploadController = TextEditingController();
  bool loadingFile = false;
  late GifController controller;

  @override
  void initState() {
    controller = GifController();
    context.read<MainBloc>().planillaCtrl.modifyList(
      index: 3.toString(),
      method: 'clear',
    );

    super.initState();
  }

  @override
  void dispose() {
    dateControllerEntrega.dispose();
    dateControllerReintegro.dispose();
    rowsController.dispose();
    fileUploadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planilla'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state || loadingFile
                  ? LinearProgressIndicator()
                  : SizedBox();
            },
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text('Guardar'),
            onPressed: () async {
              bool esValido =
                  BlocProvider.of<MainBloc>(
                    context,
                  ).planillaCtrl.validarPlanilla();
              if (esValido) {
                Navigator.pop(context);
                await BlocProvider.of<MainBloc>(context).planillaCtrl.enviar();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              var data = state.planillaB!.encabezadoPlanillaB;
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Autocomplete<String>(
                            displayStringForOption: (option) {
                              return option;
                            },
                            optionsBuilder: (textEditingValue) {
                              List<LclSingle> lclList =
                                  context.read<MainBloc>().state.lcl?.lclList ??
                                  [];
                              var optionsX =
                                  lclList
                                      .where(
                                        (e) => e.lcl.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase(),
                                        ),
                                      )
                                      .map((e) => e.lcl.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => b.compareTo(a));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'lcl',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.digitsOnly,
                                // ],
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'lcl',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'LCL/TICKET',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.lclError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.lclError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Autocomplete<String>(
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
                                        (e) => e.odm.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase(),
                                        ),
                                      )
                                      .map((e) => e.odm.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'odm',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'odm',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'CONSECUTIVO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.odmError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.odmError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: Autocomplete<String>(
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
                                        (e) => e.solicitante
                                            .toLowerCase()
                                            .contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ),
                                      )
                                      .map((e) => e.solicitante.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'solicitante',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'solicitante',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'INGENIERO A CARGO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.solicitanteError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.solicitanteError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Autocomplete<String>(
                            displayStringForOption: (option) {
                              return option;
                            },
                            optionsBuilder: (textEditingValue) {
                              return context
                                  .read<MainBloc>()
                                  .state
                                  .registrosB!
                                  .registrosList
                                  .where(
                                    (e) => e.proceso.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    ),
                                  )
                                  .map((e) => e.proceso)
                                  .toSet()
                                  .toList();
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'proceso',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'proceso',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'PROCESO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.procesoError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.procesoError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Autocomplete<String>(
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
                                        (e) => e.lider_contrato_e
                                            .toLowerCase()
                                            .contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ),
                                      )
                                      .map((e) => e.lider_contrato_e.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'lider_contrato_e',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'lider_contrato_e',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'CUADRILLERO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.lider_contrato_eError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.lider_contrato_eError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Autocomplete<String>(
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
                                        (e) =>
                                            e.placa_cuadrilla_e
                                                .toLowerCase()
                                                .contains(
                                                  textEditingValue.text
                                                      .toLowerCase(),
                                                ) &&
                                            !e.placa_cuadrilla_e.startsWith(
                                              '*',
                                            ),
                                      )
                                      .map((e) => e.placa_cuadrilla_e.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'placa_cuadrilla_e',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'placa_cuadrilla_e',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'PLACA MOVIL',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.placa_cuadrilla_eError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.placa_cuadrilla_eError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Autocomplete<String>(
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
                                        (e) =>
                                            e.circuito.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ),
                                      )
                                      .map((e) => e.circuito.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'circuito',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'circuito',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'CIRCUITO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.circuitoError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.circuitoError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Autocomplete<String>(
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
                                        (e) => e.nodo.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase(),
                                        ),
                                      )
                                      .map((e) => e.nodo.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'nodo',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'nodo',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'NODO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.nodoError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.nodoError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Autocomplete<String>(
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
                                        (e) => e.cc_lider_contrato_e
                                            .toLowerCase()
                                            .contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ),
                                      )
                                      .map((e) => e.cc_lider_contrato_e.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'cc_lider_contrato_e',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'cc_lider_contrato_e',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'CEDULA CUADRILLERO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.cc_lider_contrato_eError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.cc_lider_contrato_eError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Autocomplete<String>(
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
                                        (e) =>
                                            e.circuito.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ),
                                      )
                                      .map(
                                        (e) =>
                                            e.ingeniero_enel
                                                .trim()
                                                .toUpperCase(),
                                      )
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'ingeniero_enel',
                                              valor: option,
                                            );
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
                              //validate data.ingeniero_enel is a email @enel.com
                              if (data.ingeniero_enel.toLowerCase().contains(
                                    '@enel.com',
                                  ) ||
                                  data.ingeniero_enel.toUpperCase() ==
                                      'CONTROLM') {
                                textEditingController.text =
                                    data.ingeniero_enel;
                              }
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'ingeniero_enel',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'INGENIERO ENEL',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.ingeniero_enelError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.ingeniero_enelError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Expanded(
                        //   flex: 2,
                        //   child: BlocBuilder<MainBloc, MainState>(
                        //     builder: (context, state) {
                        //       List<String> personasEnel =
                        //           state.peopleB?.people
                        //               .map((e) => e.name)
                        //               .toList() ??
                        //           [];
                        //       return DropdownButtonFormField<String>(
                        //         isExpanded: true,
                        //         onChanged: (value) {
                        //           context
                        //               .read<MainBloc>()
                        //               .planillaCtrl
                        //               .encabezado
                        //               .cambiarEncabezado(
                        //                 campo: 'ingeniero_enel',
                        //                 valor: value.toString(),
                        //               );
                        //         },
                        //         items:
                        //             personasEnel
                        //                 .toSet()
                        //                 .map(
                        //                   (e) => DropdownMenuItem(
                        //                     child: Text(e),
                        //                     value: e,
                        //                   ),
                        //                 )
                        //                 .toList(),
                        //         decoration: InputDecoration(
                        //           labelText: 'RESPONSABLE ENEL',
                        //           border: OutlineInputBorder(),
                        //           enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //               color: data.ingeniero_enelError,
                        //             ),
                        //           ),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //               color: data.ingeniero_enelError,
                        //               width: 2,
                        //             ),
                        //           ),
                        //           contentPadding: EdgeInsets.symmetric(
                        //             horizontal: 10,
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Autocomplete<String>(
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
                                        (e) => e.pdl.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase(),
                                        ),
                                      )
                                      .map((e) => e.pdl.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'pdl',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'pdl',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'PDL',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.pdlError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.pdlError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Autocomplete<String>(
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
                                        (e) =>
                                            e.tel_lider_e
                                                .toLowerCase()
                                                .contains(
                                                  textEditingValue.text
                                                      .toLowerCase(),
                                                ) &&
                                            !e.tel_lider_e.startsWith('*'),
                                      )
                                      .map((e) => e.tel_lider_e.trim())
                                      .toSet()
                                      .toList();
                              optionsX.sort((a, b) => a.compareTo(b));
                              return optionsX;
                            },
                            optionsViewBuilder: (context, onSelected, options) {
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
                                        context
                                            .read<MainBloc>()
                                            .planillaCtrl
                                            .encabezado
                                            .cambiarEncabezado(
                                              campo: 'tel_lider_e',
                                              valor: option,
                                            );
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
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezado(
                                        campo: 'tel_lider_e',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'TEL CUADRILLERO',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.tel_lider_eError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: data.tel_lider_eError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2030),
                              );
                              if (newDate != null) {
                                context
                                    .read<MainBloc>()
                                    .planillaCtrl
                                    .encabezado
                                    .cambiarEncabezado(
                                      campo: 'fecha_e',
                                      valor:
                                          '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
                                    );
                              }
                            },
                            child: BlocBuilder<MainBloc, MainState>(
                              builder: (context, state) {
                                String date =
                                    state
                                        .planillaB
                                        ?.encabezadoPlanillaB
                                        .fecha_e ??
                                    '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';
                                dateControllerEntrega.text = date;
                                return TextField(
                                  controller: dateControllerEntrega,
                                  decoration: InputDecoration(
                                    labelText: 'FECHA ENTREGA',
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: data.fecha_eError,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: data.fecha_eError,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  enabled: false,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2030),
                              );
                              if (newDate != null) {
                                context
                                    .read<MainBloc>()
                                    .planillaCtrl
                                    .encabezado
                                    .cambiarEncabezado(
                                      campo: 'fecha_r',
                                      valor:
                                          '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
                                    );
                              }
                            },
                            child: BlocBuilder<MainBloc, MainState>(
                              builder: (context, state) {
                                String date =
                                    state
                                        .planillaB
                                        ?.encabezadoPlanillaB
                                        .fecha_r ??
                                    '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';
                                dateControllerReintegro.text = date;
                                return TextField(
                                  controller: dateControllerReintegro,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: 'FECHA REINTEGRO',
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: data.fecha_rError,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: data.fecha_rError,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              setState(() => loadingFile = true);
                              final result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                print('entra al if');
                                var file = result.files.first;
                                fileUploadController.text =
                                    await FileUploadToDrive().uploadAndGetUrl(
                                      user:
                                          context.read<MainBloc>().state.user!,
                                      file: file,
                                      carpeta: 'entregado',
                                    );
                                context
                                    .read<MainBloc>()
                                    .planillaCtrl
                                    .encabezado
                                    .cambiarEncabezado(
                                      campo: 'soporte_d_e',
                                      valor: fileUploadController.text,
                                    );
                                setState(() => loadingFile = false);
                              }
                              setState(() => loadingFile = false);
                            },
                            child: TextField(
                              controller: fileUploadController,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'SOPORTE ADJUNTO',
                                border: OutlineInputBorder(),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: data.soporte_d_eError,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: data.soporte_d_eError,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezado(
                                    campo: 'comentario_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'OBSERVACIONES',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: state.user!.nombre,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezado(
                                    campo: 'almacenista_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'ALMACENISTA QUE ENTREGA',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: data.almacenista_eError,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: data.almacenista_eError,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: state.user!.telefono,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezado(
                                    campo: 'tel_alm_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'TEL ALMACENISTA QUE ENTREGA',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: data.tel_alm_eError,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: data.tel_alm_eError,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezado(campo: 'lm', valor: value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Libreto de Medida (SCM)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Expanded(flex: 2, child: SizedBox()),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<MainBloc, MainState>(
                        builder: (context, state) {
                          List<PlanillaBSingle> planillaBList =
                              state.planillaB?.planillaBList ?? [];
                          return ElevatedButton(
                            child: Text('Pegar datos de Excel'),
                            onPressed: () async {
                              if (!(await context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .pegarExcel)) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: 500,
                                        child: GifView(
                                          image: AssetImage(
                                            'images/exampleplanilla.gif',
                                          ),
                                          controller: controller,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text('?'),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  width: 500,
                                  child: GifView(
                                    image: AssetImage(
                                      'images/exampleplanilla.gif',
                                    ),
                                    controller: controller,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MainBloc>().planillaCtrl.modifyList(
                            index: '1',
                            method: 'agregar',
                          );
                        },
                        child: Icon(Icons.add),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MainBloc>().planillaCtrl.modifyList(
                            index: '1',
                            method: 'eliminar',
                          );
                        },
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: TextField(
                          controller: rowsController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: '# Filas',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MainBloc>().planillaCtrl.modifyList(
                            index: rowsController.text,
                            method: 'resize',
                          );
                        },
                        child: Text('Aplicar'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Expanded(flex: 1, child: Text('Item')),
                      Expanded(flex: 1, child: Text('e4e')),
                      Expanded(flex: 3, child: Text('Descripción')),
                      Expanded(flex: 1, child: Text('Um')),
                      Expanded(flex: 1, child: Text('Entregado')),
                      Expanded(flex: 1, child: Text('Reintegrado')),
                      Expanded(flex: 1, child: Text('Instalado')),
                    ],
                  ),
                  SizedBox(height: 10),
                  listMaterials(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  BlocBuilder<MainBloc, MainState> listMaterials() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // print('rebuild');
        List<PlanillaBSingle> list = state.planillaB?.planillaBList ?? [];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return rowData(list[index], index, context);
          },
        );
      },
    );
  }

  Row rowData(PlanillaBSingle data, int index, BuildContext context) {
    TextEditingController ctdeController = TextEditingController();
    TextEditingController ctdrController = TextEditingController();
    ctdeController.value = ctdeController.value.copyWith(
      text: data.ctd_e,
      selection: TextSelection.collapsed(offset: data.ctd_e.length),
    );
    ctdrController.value = ctdrController.value.copyWith(
      text: data.ctd_r,
      selection: TextSelection.collapsed(offset: data.ctd_r.length),
    );
    return Row(
      children: [
        //delete button
        IconButton(
          onPressed: () {
            context.read<MainBloc>().planillaCtrl.lista.eliminar(index);
          },
          icon: Icon(Icons.delete),
        ),
        Expanded(flex: 1, child: Text(data.item)),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: Autocomplete<InventarioBSingle>(
              // initialValue: TextEditingValue(text: data.e4e),
              displayStringForOption: (option) {
                return option.e4e;
              },
              optionsBuilder: (textEditingValue) {
                return context
                    .read<MainBloc>()
                    .state
                    .inventarioB!
                    .inventarioList
                    .where(
                      (e) => e.e4e.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Material(
                  child: SizedBox(
                    width: 300,
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, i) {
                        InventarioBSingle option = options.toList()[i];
                        String textOption =
                            '${option.e4e} - ${option.descripcion} - ctd: ${option.ctd} ${option.um}';
                        return ListTile(
                          title: Text(
                            textOption,
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            onSelected(options.toList()[i]);
                            context
                                .read<MainBloc>()
                                .planillaCtrl
                                .lista
                                .cambiarCampos(
                                  index: index,
                                  e4e: options.toList()[i].e4e,
                                );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                textEditingController
                    .value = textEditingController.value.copyWith(
                  text: data.e4e,
                  selection: TextSelection.collapsed(offset: data.e4e.length),
                );

                return TextField(
                  controller: textEditingController, // Required by autocomplete
                  focusNode: focusNode, // Required by autocomplete
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                  onChanged: (value) {
                    context.read<MainBloc>().planillaCtrl.lista.cambiarCampos(
                      index: index,
                      e4e: value,
                    );
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: data.e4eError),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: data.e4eError, width: 2),
                    ),
                    labelText: 'E4e',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(data.descripcion),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  data.esMb52 == null
                      ? SizedBox()
                      : Text(
                        data.esMb52!,
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  data.esInv == null
                      ? SizedBox()
                      : Text(
                        data.esInv!,
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${data.um} (${data.ctdMb52 ?? ''}) {${data.ctdInv ?? ''}}',
            style: TextStyle(color: data.ctdEError),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: TextField(
              controller: ctdeController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) async {
                context.read<MainBloc>().planillaCtrl.lista.cambiarCampos(
                  index: index,
                  ctd_e: value,
                );
                await Future.delayed(Duration(milliseconds: 100));
              },
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: 'ctd',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEError),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEError, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: TextField(
              controller: ctdrController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                context.read<MainBloc>().planillaCtrl.lista.cambiarCampos(
                  index: index,
                  ctd_r: value,
                );
              },
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: 'ctd',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEError),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: data.ctdEError, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            data.ctd_total,
            textAlign: TextAlign.center,
            style: TextStyle(color: data.ctdEError),
          ),
        ),
      ],
    );
  }
}
