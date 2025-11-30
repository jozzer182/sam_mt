import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_view/gif_view.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/nuevo_traslado/model/traslado_model.dart';
import 'package:v_al_sam_v02/models/mm60_b.dart';
import 'package:v_al_sam_v02/resources/file_uploader.dart';

class TrasladoScreen extends StatefulWidget {
  const TrasladoScreen({super.key});

  @override
  State<TrasladoScreen> createState() => _TrasladoScreenState();
}

class _TrasladoScreenState extends State<TrasladoScreen>
    with TickerProviderStateMixin {
  DateTime date = DateTime.now();
  bool loadingFile = false;
  late GifController controller;
  TextEditingController rowsController = TextEditingController();

  @override
  void initState() {
    controller = GifController();
    context.read<MainBloc>().nuevoTrasladoCtrl.modifyList(
      index: 3.toString(),
      method: 'resize',
    );

    super.initState();
  }

  @override
  void dispose() {
    rowsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NUEVO TRASLADO'),
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
          ElevatedButton(
            child: Text('Guardar'),
            onPressed: () {
              bool esValido =
                  context.read<MainBloc>().nuevoTrasladoCtrl.validarCampos();
              if (esValido) {
                Navigator.pop(context);
                context.read<MainBloc>().nuevoTrasladoCtrl.enviar();
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
              SizedBox(height: 10),
              gridViewDatosOrigen(),
              SizedBox(height: 10),
              Text(
                'DATOS MATERIAL',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              actionButtons(),
              SizedBox(height: 10),
              addMaterialWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridViewDatosOrigen() {
    return SizedBox(
      height: 40,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          NuevoTrasladoBEncabezado? data = state.nuevoTrasladoB?.encabezado;
          if (data == null) return CircularProgressIndicator();
          return Row(
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
                          .nuevoTrasladoCtrl
                          .cambiarEncabezado(
                            valor: dateSelected,
                            campo: 'fecha_i',
                          );
                    }
                  },
                  child: TextField(
                    controller: TextEditingController(text: data.fecha_i),
                    decoration: InputDecoration(
                      labelText: 'Fecha Ingreso',
                      border: OutlineInputBorder(),
                      enabled: false,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Código Massy',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: data.codigo_massyError),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: data.codigo_massyError,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    context
                        .read<MainBloc>()
                        .nuevoTrasladoCtrl
                        .cambiarEncabezado(valor: value, campo: 'codigo_massy');
                  },
                ),
              ),
              SizedBox(width: 10),
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
                              String fileUrlr = await FileUploadToDrive()
                                  .uploadAndGetUrl(
                                    user: context.read<MainBloc>().state.user!,
                                    file: file,
                                    carpeta: 'ingresado',
                                  );
                              print('fileUploadController.text: ${fileUrlr}');
                              context
                                  .read<MainBloc>()
                                  .nuevoTrasladoCtrl
                                  .cambiarEncabezado(
                                    valor: fileUrlr,
                                    campo: 'soporte_i',
                                  );
                              setState(() => loadingFile = false);
                            }
                            print('result: $result');

                            setState(() => loadingFile = false);
                          },
                          child: TextField(
                            enabled: false,
                            controller: TextEditingController(
                              text: data.soporte_i,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Soporte de entrega',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              border: OutlineInputBorder(),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: data.soporte_iError,
                                ),
                              ),
                            ),
                          ),
                        ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Comentario',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context
                        .read<MainBloc>()
                        .nuevoTrasladoCtrl
                        .cambiarEncabezado(
                          valor: value,
                          campo: 'comentario',
                        );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget addMaterialWidget() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // print('rebuild');
        List<Mm60SingleB>? mm60 = state.mm60B?.mm60List;
        List<NuevoTrasladoBSingle>? data =
            state.nuevoTrasladoB?.nuevoIngresoList;
        if (data == null || mm60 == null) return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return singleMaterialRow(
              index: index,
              data: data[index],
              context: context,
            );
          },
        );
      },
    );
  }

  Row actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            List<NuevoTrasladoBSingle> nuevoTrasladoList =
                state.nuevoTrasladoB?.nuevoIngresoList ?? [];
            return ElevatedButton(
              child: Text('Pegar datos de Excel'),
              onPressed: () async {
                final clipboardData = await Clipboard.getData('text/plain');
                String? data = clipboardData?.text;
                RegExp numbersOnly = RegExp(r'^[0-9]+$');
                // print(data);
                // print(data!.isEmpty);
                // Analizar los datos copiados y asignar los valores correspondientes a cada campo
                if (data != null &&
                    data.isNotEmpty &&
                    numbersOnly.hasMatch(data.replaceAll(RegExp(r'\s+'), ''))) {
                  final rows = data.split('\n').map((e) => e.trim()).toList();
                  rows.removeWhere((e) => e.isEmpty);
                  // if (rows.length > nuevoIngresoList.length) {
                  context.read<MainBloc>().nuevoTrasladoCtrl.modifyList(
                    index: rows.length.toString(),
                    method: 'resize',
                  );
                  await Future.delayed(Duration(milliseconds: 100));
                  // }
                  for (var i = 0; i < data.length; i++) {
                    if (i < rows.length) {
                      final values =
                          rows[i].split('\t').map((e) => e.trim()).toList();
                      context.read<MainBloc>().nuevoTrasladoCtrl.cambiarCampos(
                        index: i,
                        e4e: values[0],
                      );
                      await Future.delayed(Duration(milliseconds: 100));
                      context.read<MainBloc>().nuevoTrasladoCtrl.cambiarCampos(
                        index: i,
                        ctd_e: (-int.parse(values[1])).toString(),
                      );
                      await Future.delayed(Duration(milliseconds: 100));
                    }
                  }
                  // print(rows);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: SizedBox(
                          width: 500,
                          child: GifView(
                            image: AssetImage('images/example.gif'),
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
                      image: AssetImage('images/example.gif'),
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
          child: Icon(Icons.add),
          onPressed: () {
            context.read<MainBloc>().nuevoTrasladoCtrl.modifyList(
              index: '1',
              method: 'agregar',
            );
          },
        ),
        SizedBox(width: 10),
        ElevatedButton(
          child: Icon(Icons.remove),
          onPressed: () {
            context.read<MainBloc>().nuevoTrasladoCtrl.modifyList(
              index: '0',
              method: 'eliminar',
            );
          },
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          height: 30,
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: rowsController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: '# Filas',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            context.read<MainBloc>().nuevoTrasladoCtrl.modifyList(
              index: rowsController.text,
              method: 'resize',
            );
          },
          child: Text('Aplicar'),
        ),
      ],
    );
  }

  Widget singleMaterialRow({
    required int index,
    required NuevoTrasladoBSingle data,
    required BuildContext context,
  }) {
    TextEditingController ctdController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 40,
        child: Row(
          // key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data.item),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: Autocomplete<Mm60SingleB>(
                displayStringForOption: (option) {
                  return option.material;
                },
                optionsBuilder: (textEditingValue) {
                  return context.read<MainBloc>().state.mm60B!.mm60List.where(
                    (e) => e.material.toLowerCase().contains(
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
                          Mm60SingleB option = options.toList()[i];
                          String textOption =
                              '${option.material} - ${option.descripcion}';
                          return ListTile(
                            title: Text(
                              textOption,
                              style: TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              onSelected(options.toList()[i]);
                              context
                                  .read<MainBloc>()
                                  .nuevoTrasladoCtrl
                                  .cambiarCampos(
                                    index: index,
                                    e4e: options.toList()[i].material,
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
                    controller:
                        textEditingController, // Required by autocomplete
                    focusNode: focusNode, // Required by autocomplete
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'E4E',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: data.e4eError),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: data.e4eError, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<MainBloc>().nuevoTrasladoCtrl.cambiarCampos(
                        index: index,
                        e4e: value,
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                data.descripcion,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                data.um,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            // Text('UMB'),
            Expanded(
              flex: 2,
              child: Builder(
                builder: (context) {
                  String ctd =
                      data.ctd == '0' ? '' : (-int.parse(data.ctd)).toString();
                  ctdController.value = ctdController.value.copyWith(
                    text: ctd,
                    selection: TextSelection.collapsed(offset: ctd.length),
                  );

                  return TextField(
                    controller: ctdController,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Ctd',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: data.ctdError),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: data.ctdError, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      // if (value != '0') {
                      String ctd_e =
                          value == '0' ? '' : (-int.parse(value)).toString();
                      context.read<MainBloc>().nuevoTrasladoCtrl.cambiarCampos(
                        index: index,
                        ctd_e: ctd_e,
                      );
                      // }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
