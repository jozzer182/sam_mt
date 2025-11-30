import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/planilla/model/planilla_model_edit_b.dart';
import 'package:v_al_sam_v02/resources/file_uploader.dart';
import 'package:v_al_sam_v02/user/user_model.dart';
import 'package:v_al_sam_v02/version.dart';

// import 'package:v_al_sam_v02/src/models_b/planilla_b.dart';

class PlanillaPageEdit extends StatefulWidget {
  const PlanillaPageEdit({Key? key}) : super(key: key);

  @override
  State<PlanillaPageEdit> createState() => _PlanillaPageEditState();
}

class _PlanillaPageEditState extends State<PlanillaPageEdit> {
  TextEditingController dateControllerEntrega = TextEditingController();
  TextEditingController dateControllerReintegro = TextEditingController();
  TextEditingController rowsController = TextEditingController();
  TextEditingController fileUploadController = TextEditingController();
  bool loadingFile = false;
  bool editingCabecera = false;
  bool editingMateriales = false;
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
    void goTo(Widget page) {
      Navigator.push(context, version.createRoute(page));
    }

    bool editarCabeceraP = context
        .read<MainBloc>()
        .state
        .user!
        .permisos
        .contains("editar_datos_planilla");
    User user = context.read<MainBloc>().state.user!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Planilla'),
        automaticallyImplyLeading: !(editingCabecera || editingMateriales),
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
          !user.permisos.contains("editar_lcl_planilla")
              ? SizedBox()
              : ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Atención'),
                        content: Text(
                          'Se anulará el pedido seleccionado, esta acción no de podrá deshacer, ¿Desea contitnuar?',
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
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .anularPedido(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  /////////////////////////
                },
                child: Text('Anular\nPlanilla', textAlign: TextAlign.center),
              ),
          !(editingCabecera || editingMateriales)
              ? SizedBox()
              : ElevatedButton(
                child: Text('Guardar'),
                onPressed: () async {
                  if (editingCabecera) {
                    bool esValido =
                        BlocProvider.of<MainBloc>(
                          context,
                        ).planillaCtrl.validarPlanillaMateriales();
                    if (esValido) {
                      Navigator.pop(context);
                      await BlocProvider.of<MainBloc>(
                        context,
                      ).planillaCtrl.enviarEdit();
                    }
                  } else {
                    bool esValido =
                        BlocProvider.of<MainBloc>(
                          context,
                        ).planillaCtrl.validarPlanillaMateriales();
                    if (esValido) {
                      Navigator.pop(context);
                      await BlocProvider.of<MainBloc>(
                        context,
                      ).planillaCtrl.enviarNuevo();
                    }
                  }
                },
              ),
          !(editingCabecera || editingMateriales)
              ? SizedBox()
              : ElevatedButton(
                child: Text('Cancelar'),
                onPressed: () {
                  setState(() {
                    editingCabecera = false;
                    editingMateriales = false;
                    context.read<MainBloc>().planillaCtrl.modifyListEdit(
                      index: '1',
                      method: 'reset',
                    );
                    Navigator.pop;
                    goTo(PlanillaPageEdit());
                  });
                },
              ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (editingCabecera || editingMateriales)
                ? SizedBox()
                : !user.permisos.contains("editar_lcl_planilla")
                ? SizedBox()
                : ElevatedButton(
                  child: Text('Editar Datos'),
                  onPressed: () {
                    setState(() {
                      editingCabecera = true;
                    });
                  },
                ),
            // SizedBox(width: 10),
            (editingCabecera || editingMateriales)
                ? SizedBox()
                : !user.permisos.contains("agregar_materiales_planilla")
                ? SizedBox()
                : ElevatedButton(
                  child: Text('Agregar Materiales'),
                  onPressed: () {
                    setState(() {
                      editingMateriales = true;
                    });
                  },
                ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              var data = state.planillaEditB;
              if (data == null) {
                return Center(child: CircularProgressIndicator());
              }
              List<PlanillaBEditSingle> list = data.planillaBListParaEnvio;
              list.sort(
                (a, b) => int.parse(a.item).compareTo(int.parse(b.item)),
              );
              List fixedList = data.planillaBList;
              // print('rebuild');
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: data.encabezadoPlanillaBParaEnvio.lcl,
                            enabled:
                                editingCabecera &&
                                user.permisos.contains("editar_lcl_planilla"),
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'lcl',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'LCL/TICKET',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: data.encabezadoPlanillaBParaEnvio.odm,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'odm',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'CONSECUTIVO',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.solicitante,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'solicitante',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'INGENIERO A CARGO',
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
                          flex: 2,
                          child: TextFormField(
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.proceso,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'proceso',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'PROCESO',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                data
                                    .encabezadoPlanillaBParaEnvio
                                    .lider_contrato_e,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'lider_contrato_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'CUADRILLERO',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                data
                                    .encabezadoPlanillaBParaEnvio
                                    .placa_cuadrilla_e,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'placa_cuadrilla_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'PLACA MOVIL',
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
                          flex: 2,
                          child: TextFormField(
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.circuito,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'circuito',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'CIRCUITO',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.nodo,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'nodo',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'NODO',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue:
                                data
                                    .encabezadoPlanillaBParaEnvio
                                    .cc_lider_contrato_e,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'cc_lider_contrato_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'CEDULA CUADRILLERO',
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
                        //         value:
                        //             data
                        //                 .encabezadoPlanillaBParaEnvio
                        //                 .ingeniero_enel,
                        //         disabledHint: Text(
                        //           data
                        //               .encabezadoPlanillaBParaEnvio
                        //               .ingeniero_enel,
                        //         ),
                        //         isExpanded: true,
                        //         onChanged: (value) {
                        //           context
                        //               .read<MainBloc>()
                        //               .planillaCtrl
                        //               .encabezado
                        //               .cambiarEncabezadoEdit(
                        //                 campo: 'ingeniero_enel',
                        //                 valor: value.toString(),
                        //               );
                        //         },
                        //         items:
                        //             editingCabecera && editarCabeceraP
                        //                 ? personasEnel
                        //                     .toSet()
                        //                     .map(
                        //                       (e) => DropdownMenuItem(
                        //                         child: Text(e),
                        //                         value: e,
                        //                       ),
                        //                     )
                        //                     .toList()
                        //                 : [],
                        //         decoration: InputDecoration(
                        //           labelText: 'RESPONSABLE ENEL',
                        //           border: OutlineInputBorder(),
                        //           contentPadding: EdgeInsets.symmetric(
                        //             horizontal: 10,
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
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
                                            .cambiarEncabezadoEdit(
                                              campo: 'ingeniero_enel',
                                              valor: option,
                                            );
                                        // context
                                        //     .read<MainBloc>()
                                        //     .planillaCtrl
                                        //     .encabezado
                                        //     .cambiarEncabezado(
                                        //       campo: 'ingeniero_enel',
                                        //       valor: option,
                                        //     );
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
                              if ((data
                                      .encabezadoPlanillaBParaEnvio
                                      .ingeniero_enel
                                      .toLowerCase()
                                      .contains('@enel.com') ||
                                  data
                                          .encabezadoPlanillaBParaEnvio
                                          .ingeniero_enel
                                          .toUpperCase() ==
                                      'CONTROLM') || !(editingCabecera && editarCabeceraP)) {
                                textEditingController.text =
                                    data
                                        .encabezadoPlanillaBParaEnvio
                                        .ingeniero_enel;
                              }
                              return TextField(
                                enabled: editingCabecera && editarCabeceraP,
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .encabezado
                                      .cambiarEncabezadoEdit(
                                        campo: 'ingeniero_enel',
                                        valor: value.toString(),
                                      );
                                  // context
                                  //     .read<MainBloc>()
                                  //     .planillaCtrl
                                  //     .encabezado
                                  //     .cambiarEncabezado(
                                  //       campo: 'ingeniero_enel',
                                  //       valor: value,
                                  //     );
                                },
                                decoration: InputDecoration(
                                  labelText: 'INGENIERO ENEL',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    // borderSide: BorderSide(
                                    //   color:
                                    //       data
                                    //           .encabezadoPlanillaBParaEnvio
                                    //           .ingeniero_enelError,
                                    // ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    // borderSide: BorderSide(
                                    //   color:
                                    //       data
                                    //           .encabezadoPlanillaBParaEnvio
                                    //           .ingeniero_enelError,
                                    //   width: 2,
                                    // ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: data.encabezadoPlanillaBParaEnvio.pdl,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'pdl',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'PDL',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.tel_lider_e,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'tel_lider_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'TEL CUADRILLERO',
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
                          child: InkWell(
                            onTap:
                                editingCabecera && editarCabeceraP
                                    ? () async {
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
                                            .cambiarEncabezadoEdit(
                                              campo: 'fecha_e',
                                              valor:
                                                  '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
                                            );
                                      }
                                    }
                                    : null,
                            child: BlocBuilder<MainBloc, MainState>(
                              builder: (context, state) {
                                String date =
                                    state
                                        .planillaEditB
                                        ?.encabezadoPlanillaBParaEnvio
                                        .fecha_e ??
                                    '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';
                                dateControllerEntrega.text = date;
                                return TextFormField(
                                  initialValue:
                                      data.encabezadoPlanillaBParaEnvio.fecha_e,
                                  // controller: dateControllerEntrega,
                                  decoration: InputDecoration(
                                    labelText: 'FECHA ENTREGA',
                                    border: OutlineInputBorder(),
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
                            onTap:
                                editingCabecera && editarCabeceraP
                                    ? () async {
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
                                            .cambiarEncabezadoEdit(
                                              campo: 'fecha_r',
                                              valor:
                                                  '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
                                            );
                                      }
                                    }
                                    : null,
                            child: BlocBuilder<MainBloc, MainState>(
                              builder: (context, state) {
                                String date =
                                    state
                                        .planillaEditB
                                        ?.encabezadoPlanillaBParaEnvio
                                        .fecha_r ??
                                    '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}';
                                dateControllerReintegro.text = date;
                                return TextFormField(
                                  initialValue:
                                      data.encabezadoPlanillaBParaEnvio.fecha_r,
                                  // controller: dateControllerReintegro,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: 'FECHA REINTEGRO',
                                    border: OutlineInputBorder(),
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
                          child: Tooltip(
                            message:
                                'Soporte subido en "Nueva Planilla", si desea subir uno nuevo, puede hacerlo en "SOPORTE REINTEGRO" ',
                            child: InkWell(
                              onTap: () async {
                                await launchUrl(
                                  Uri.parse(
                                    data
                                        .encabezadoPlanillaBParaEnvio
                                        .soporte_d_e,
                                  ),
                                );
                              },
                              child: TextFormField(
                                initialValue:
                                    data
                                        .encabezadoPlanillaBParaEnvio
                                        .soporte_d_e,
                                // controller: fileUploadController,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'SOPORTE ENTREGA',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Tooltip(
                            message:
                                'Se tomó el mismo soporte de "Nueva Planilla", si es necesario favor cambiarlo.',
                            child: InkWell(
                              onTap:
                                  editingCabecera && editarCabeceraP
                                      ? () async {
                                        setState(() => loadingFile = true);
                                        final result =
                                            await FilePicker.platform
                                                .pickFiles();
                                        if (result != null) {
                                          var file = result.files.first;
                                          fileUploadController
                                              .text = await FileUploadToDrive()
                                              .uploadAndGetUrl(
                                                file: file,
                                                carpeta: 'reintegrado',
                                                user:
                                                    context
                                                        .read<MainBloc>()
                                                        .state
                                                        .user!,
                                              );
                                          context
                                              .read<MainBloc>()
                                              .planillaCtrl
                                              .encabezado
                                              .cambiarEncabezadoEdit(
                                                campo: 'soporte_d_r',
                                                valor:
                                                    fileUploadController.text,
                                              );
                                          setState(() => loadingFile = false);
                                        }
                                        setState(() => loadingFile = false);
                                      }
                                      : () async {
                                        await launchUrl(
                                          Uri.parse(
                                            data
                                                .encabezadoPlanillaBParaEnvio
                                                .soporte_d_r,
                                          ),
                                        );
                                      },
                              child: TextFormField(
                                // initialValue:
                                //     data.encabezadoPlanillaBParaEnvio.soporte_d_r,
                                controller: TextEditingController(
                                  text:
                                      data
                                          .encabezadoPlanillaBParaEnvio
                                          .soporte_d_r,
                                ),
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'SOPORTE REINTEGRO',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.comentario_e,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
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
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.almacenista_e,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'almacenista_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'ALMACENISTA QUE ENTREGA',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                                data.encabezadoPlanillaBParaEnvio.tel_alm_e,
                            enabled: editingCabecera && editarCabeceraP,
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .planillaCtrl
                                  .encabezado
                                  .cambiarEncabezadoEdit(
                                    campo: 'tel_alm_e',
                                    valor: value,
                                  );
                            },
                            decoration: InputDecoration(
                              labelText: 'TEL ALMACENISTA QUE ENTREGA',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            !editingMateriales
                                ? null
                                : () {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .modifyListEdit(
                                        index: '1',
                                        method: 'agregar',
                                      );
                                },
                        child: Icon(Icons.add),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:
                            !editingMateriales
                                ? null
                                : () {
                                  context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .modifyListEdit(
                                        index: '1',
                                        method: 'eliminar',
                                      );
                                },
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:
                            editingCabecera
                                ? () async {
                                  await context
                                      .read<MainBloc>()
                                      .planillaCtrl
                                      .pegarExcelEdit;
                                }
                                : null,
                        child: Text('Pegar Desde Excel (REINTEGRADO)'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      bool isSource = fixedList.length > index;
                      var dat = list[index];
                      return singleMaterialRow(dat, isSource, context, index);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Row singleMaterialRow(
    PlanillaBEditSingle dat,
    bool isSource,
    BuildContext context,
    int index,
  ) {
    TextEditingController ctdrController = TextEditingController();
    ctdrController.value = ctdrController.value.copyWith(
      text: dat.ctd_r.isEmpty ? '0' : dat.ctd_r,
      selection: TextSelection.collapsed(offset: dat.ctd_r.length),
    );
    return Row(
      children: [
        Expanded(flex: 1, child: Text(dat.item)),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: TextFormField(
              initialValue: dat.e4e,
              enabled: (editingMateriales && !isSource) || editingCabecera,
              onChanged: (value) {
                context.read<MainBloc>().planillaCtrl.lista.cambiarCamposEdit(
                  index: index,
                  e4e: value,
                );
              },
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: 'E4e',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: dat.e4eError),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: dat.e4eError, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(dat.descripcion),
              dat.esMb52 == null
                  ? SizedBox()
                  : Text(
                    dat.esMb52!,
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ],
          ),
        ),
        Expanded(flex: 1, child: Text('${dat.um} (${dat.ctdMb52 ?? ''})')),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 30,
            child: TextFormField(
              initialValue: dat.ctd_e,
              enabled: (editingMateriales && !isSource) || editingCabecera,
              onChanged: (value) {
                context.read<MainBloc>().planillaCtrl.lista.cambiarCamposEdit(
                  index: index,
                  ctd_e: value,
                );
              },
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: 'ctd',
                border: OutlineInputBorder(),
                enabledBorder:
                    !dat.errorValue
                        ? null
                        : OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
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
            child: TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // initialValue: dat.ctd_r.isEmpty ? '0' : dat.ctd_r,
              controller: ctdrController,
              enabled: (editingMateriales && !isSource) || editingCabecera,
              onChanged: (value) {
                context.read<MainBloc>().planillaCtrl.lista.cambiarCamposEdit(
                  index: index,
                  ctd_r: value,
                );
              },
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                labelText: 'ctd',
                border: OutlineInputBorder(),
                enabledBorder:
                    !dat.errorValue
                        ? null
                        : OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(dat.ctd_total, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
