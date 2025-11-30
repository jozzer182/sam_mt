// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main_bloc.dart';
import '../model/chatarra_enum.dart';
import '../model/chatarra_reg_enum.dart';
import 'chatarra_gif_paste.dart';

class ActionButtons extends StatelessWidget {
  final TextEditingController rowsController = TextEditingController();
  ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            // List<NuevoIngresoBSingle> nuevoIngresoList =
            //     state.nuevoIngresoB?.nuevoIngresoList ?? [];
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
                  context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
                    index: 'resize',
                    campo: CampoChatarra.items,
                    value: rows.length.toString(),
                  );
                  await Future.delayed(Duration(milliseconds: 100));
                  // }
                  for (var i = 0; i < data.length; i++) {
                    if (i < rows.length) {
                      final values =
                          rows[i].split('\t').map((e) => e.trim()).toList();
                      context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
                        index: '$i',
                        campo: CampoChatarra.items,
                        campoReg: CampoChatarraReg.e4e,
                        value: values[0],
                      );
                      await Future.delayed(Duration(milliseconds: 100));
                      context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
                        index: '$i',
                        campo: CampoChatarra.items,
                        campoReg: CampoChatarraReg.ctd,
                        value: values[1],
                      );
                      await Future.delayed(Duration(milliseconds: 100));
                    }
                  }
                  // print(rows);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return GifPasteExcel();
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
                return GifPasteExcel();
              },
            );
          },
        ),
        SizedBox(width: 10),
        ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () {
            context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
              index: 'add',
              campo: CampoChatarra.items,
              value: '',
            );
          },
        ),
        SizedBox(width: 10),
        ElevatedButton(
          child: Icon(Icons.remove),
          onPressed: () {
            context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
              index: 'remove',
              campo: CampoChatarra.items,
              value: '',
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
            context.read<MainBloc>().chatarraCtrl.cambiarCampos.changeChatarra(
              index: 'resize',
              campo: CampoChatarra.items,
              value: rowsController.text,
            );
          },
          child: Text('Aplicar'),
        ),
      ],
    );
  }
}
