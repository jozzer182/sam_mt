import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gif_view/gif_view.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';

import '../../../resources/file_uploader.dart';
import '../model/entregas_mc_list_model.dart';
import '../model/entregas_mc_reg_model.dart';

class EntregasMcPageEdit extends StatefulWidget {
  final bool esNuevo;
  final String pedido;
  final String tecnicoid;

  const EntregasMcPageEdit({
    super.key,
    this.esNuevo = true,
    this.pedido = '',
    this.tecnicoid = '',
  });

  @override
  State<EntregasMcPageEdit> createState() => _EntregasMcPageEditState();
}

class _EntregasMcPageEditState extends State<EntregasMcPageEdit>
    with TickerProviderStateMixin {
  DateTime date = DateTime.now();
  bool loadingFile = false;
  late GifController controller;
  TextEditingController rowsController = TextEditingController();
  TextEditingValue tecnicoController = TextEditingValue();

  @override
  void initState() {
    controller = GifController();
    if (widget.esNuevo) {
      context.read<MainBloc>().entregasMcCtrl.crearNuevo;
    } else {
      context.read<MainBloc>().entregasMcCtrl.cargarPedido(widget.pedido);
    }

    if (widget.tecnicoid.isNotEmpty) {
      context.read<MainBloc>().entregasMcCtrl.cambiarEncabezado(
        campo: 'tecnicoid',
        valor: widget.tecnicoid,
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    rowsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        EntregasMcList cargasMcList = state.entregasMcList!;
        List<EntregaMc> listEdit = cargasMcList.listEdit;
        EntregaMc first =
            listEdit.isNotEmpty ? listEdit.first : EntregaMc.fromInit(0);
        return Scaffold(
          appBar: AppBar(
            title: Text('ENTREGAS - REINTEGROS'),
            automaticallyImplyLeading: !loadingFile,
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
              Builder(
                builder: (context) {
                  if (widget.esNuevo) return SizedBox();
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmación'),
                            content: Text(
                              '¿Está seguro que desea anular este registro?',
                            ),
                            actions: [
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Cierra el diálogo
                                },
                              ),
                              TextButton(
                                child: Text('Sí'),
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Cierra el diálogo
                                  context.read<MainBloc>().entregasMcCtrl.anular;
                                  Navigator.pop(
                                    context,
                                  ); // Regresa a la pantalla anterior
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Anular'),
                  );
                },
              ),
              const Gap(10),
              ElevatedButton(
                child: Text('Guardar'),
                onPressed: () {
                  bool esvalido =
                      context.read<MainBloc>().entregasMcCtrl.validarCampos();
                  if (esvalido) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmación'),
                          content: Text(
                            '¿Está seguro que desea guardar los cambios?',
                          ),
                          actions: [
                            TextButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop(); // Cierra el diálogo
                              },
                            ),
                            TextButton(
                              child: Text('Sí'),
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop(); // Cierra el diálogo
                                Navigator.pop(
                                  context,
                                ); // Regresa a la pantalla anterior
                                context.read<MainBloc>().entregasMcCtrl.enviar;
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'DATOS ORIGEN',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2030),
                              );
                              if (newDate != null) {
                                date = newDate;
                                String dateSelected =
                                    '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
                                context
                                    .read<MainBloc>()
                                    .entregasMcCtrl
                                    .cambiarEncabezado(
                                      valor: dateSelected,
                                      campo: 'fecha',
                                    );
                              }
                            },
                            child: TextField(
                              controller: TextEditingController(
                                text: first.fecha,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Fecha Movimiento',
                                border: OutlineInputBorder(),
                                enabled: false,
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (first.pedido.isEmpty) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return TextFormField(
                                initialValue: first.pedido,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Pedido',
                                  border: OutlineInputBorder(),
                                ),
                              );
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: first.consecutivo,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Consecutivo',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: first.consecutivoError,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: first.consecutivoError,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .entregasMcCtrl
                                  .cambiarEncabezado(
                                    valor: value,
                                    campo: 'consecutivo',
                                  );
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child:
                              loadingFile
                                  ? Center(child: CircularProgressIndicator())
                                  : InkWell(
                                    onTap: () async {
                                      setState(() => loadingFile = true);
                                      final result =
                                          await FilePicker.platform.pickFiles();
                                      if (result != null) {
                                        var file = result.files.first;
                                        String fileUrlr =
                                            await FileUploadToDrive()
                                                .uploadAndGetUrl(
                                                  user:
                                                      context
                                                          .read<MainBloc>()
                                                          .state
                                                          .user!,
                                                  file: file,
                                                  carpeta: 'ingresado',
                                                );
                                        print('fileUrlr: $fileUrlr');
                                        context
                                            .read<MainBloc>()
                                            .entregasMcCtrl
                                            .cambiarEncabezado(
                                              valor: fileUrlr,
                                              campo: 'soporte',
                                            );
                                        setState(() => loadingFile = false);
                                      }
                                      setState(() => loadingFile = false);
                                    },
                                    child: TextField(
                                      enabled: false,
                                      controller: TextEditingController(
                                        text: first.soporte,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Soporte de entrega',
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        border: OutlineInputBorder(),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: first.soporteError,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField(
                            value: first.tipo.isEmpty ? null : first.tipo,
                            items:
                                ['ENTREGA', 'REINTEGRO']
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            decoration: InputDecoration(
                              labelText: 'Tipo',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              // isDense: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: first.tipoError),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: first.tipoError,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .entregasMcCtrl
                                  .cambiarEncabezado(
                                    valor: value.toString().toUpperCase(),
                                    campo: 'tipo',
                                  );
                            },
                          ),
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Autocomplete<String>(
                            initialValue: TextEditingValue(
                              text: first.tecnicoid,
                            ),
                            displayStringForOption: (option) {
                              return option;
                            },
                            optionsBuilder: (textEditingValue) {
                              List<EntregaMc> list =
                                  context
                                      .read<MainBloc>()
                                      .state
                                      .entregasMcList
                                      ?.list ??
                                  [];
                              var optionsX =
                                  list
                                      .where(
                                        (e) =>
                                            e.tecnicoid.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase(),
                                            ),
                                      )
                                      .map((e) => e.tecnicoid.trim())
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
                                            .entregasMcCtrl
                                            .cambiarEncabezado(
                                              campo: 'tecnicoid',
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
                              if (first.tecnicoid !=
                                  textEditingController.text) {
                                textEditingController.text = first.tecnicoid;
                              }
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .entregasMcCtrl
                                      .cambiarEncabezado(
                                        campo: 'tecnicoid',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'Técnico ID',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: first.tecnicoidError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: first.tecnicoidError,
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
                              List<EntregaMc> list =
                                  context
                                      .read<MainBloc>()
                                      .state
                                      .entregasMcList
                                      ?.list ??
                                  [];
                              var optionsX =
                                  list
                                      .where(
                                        (e) => e.tecnico.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase(),
                                        ),
                                      )
                                      .map((e) => e.tecnico.trim())
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
                                            .entregasMcCtrl
                                            .cambiarEncabezado(
                                              campo: 'tecnico',
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
                              if (first.tecnico != textEditingController.text) {
                                textEditingController.text = first.tecnico;
                              }
                              return TextField(
                                controller:
                                    textEditingController, // Required by autocomplete
                                focusNode:
                                    focusNode, // Required by autocomplete
                                onChanged: (value) {
                                  context
                                      .read<MainBloc>()
                                      .entregasMcCtrl
                                      .cambiarEncabezado(
                                        campo: 'tecnico',
                                        valor: value,
                                      );
                                },
                                decoration: InputDecoration(
                                  labelText: 'Técnico Nombre',
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: first.tecnicoError,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: first.tecnicoError,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField(
                            value:
                                first.tecnicotype.isEmpty
                                    ? null
                                    : first.tecnicotype,
                            items:
                                ['MOE', 'COM']
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            decoration: InputDecoration(
                              labelText: 'Tipo Técnico',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              // isDense: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: first.tecnicotypeError,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: first.tecnicotypeError,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .entregasMcCtrl
                                  .cambiarEncabezado(
                                    valor: value.toString().toUpperCase(),
                                    campo: 'tecnicotype',
                                  );
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: first.comentario,
                            decoration: InputDecoration(
                              labelText: 'Comentario',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              context
                                  .read<MainBloc>()
                                  .entregasMcCtrl
                                  .cambiarEncabezado(
                                    valor: value,
                                    campo: 'comentario',
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'DATOS MATERIAL',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool esValido =
                              await context
                                  .read<MainBloc>()
                                  .entregasMcCtrl
                                  .validarDatosExcel;
                          if (esValido) {
                            context
                                .read<MainBloc>()
                                .entregasMcCtrl
                                .pegarDatosExcel;
                          }
                        },
                        child: Text('Pegar datos de Excel'),
                      ),
                      const Gap(10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MainBloc>().entregasMcCtrl.agregarfila;
                        },
                        child: Icon(Icons.add),
                      ),
                      const Gap(10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MainBloc>().entregasMcCtrl.eliminarFila;
                        },
                        child: Icon(Icons.remove),
                      ),
                    ],
                  ),
                  Gap(10),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        for (EntregaMc carga in listEdit)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text('${carga.index}'),
                                const Gap(10),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: carga.e4e,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'E4E',

                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: carga.e4eError,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: carga.e4eError,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      context
                                          .read<MainBloc>()
                                          .entregasMcCtrl
                                          .cambiarList(
                                            valor: value,
                                            campo: 'e4e',
                                            index: carga.index,
                                          );
                                    },
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Text(
                                        carga.descripcion.isEmpty
                                            ? 'Descripción'
                                            : carga.descripcion,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        carga.e4eInfo,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: carga.e4eError,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                                Text(carga.um),
                                const Gap(10),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: carga.ctd,
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'ctd',
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: carga.ctdError,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: carga.ctdError,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      context
                                          .read<MainBloc>()
                                          .entregasMcCtrl
                                          .cambiarList(
                                            valor: value,
                                            campo: 'ctd',
                                            index: carga.index,
                                          );
                                    },
                                  ),
                                ),
                                const Gap(10),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const Gap(10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
