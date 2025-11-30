// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/main_bloc.dart';
import '../file_uploader.dart';

class FieldFile extends StatelessWidget {
  final TextEditingController fileUploadController = TextEditingController();
  final int? flex;
  final String file;
  final String carpeta;
  final String pdi;
  // final CampoFicha campo;
  final String label;
  final Color color;
  final int item;
  final bool edit;

  FieldFile({
    required this.flex,
    required this.file,
    required this.carpeta,
    required this.pdi,
    // required this.campo,
    required this.label,
    required this.color,
    this.edit = false,
    this.item = -1,
    key,
  });

  @override
  Widget build(BuildContext context) {
    if (edit) {
      return OpenFile(
        flex: flex,
        file: file,
        carpeta: carpeta,
        pdi: pdi,
        // campo: campo,
        label: label,
        color: color,
      );
    }
    fileUploadController.text = file;
    if (flex == null) {
      return SizedBox(
        height: 40,
        child: _intField(context),
      );
    }
    return Expanded(
      flex: flex!,
      child: _intField(context),
    );
  }

  TextField _intField(BuildContext context) {
    return TextField(
      controller: fileUploadController,
      readOnly: true,
      onTap: () async {
        context.read<MainBloc>().add(
              Loading(isLoading: true),
            );
        final result = await FilePicker.platform.pickFiles();
        if (result != null) {
          var file = result.files.first;
          fileUploadController.text = await FileUploadToDrive().uploadAndGetUrl(
            file: file,
            carpeta: carpeta,
            user: context.read<MainBloc>().state.user!,
          );
          // context.read<MainBloc>().fichasController.onCambiarFicha(
          //       campo: campo,
          //       valor: fileUploadController.text,
          //       item: 0,
          //     );
          context.read<MainBloc>().add(
                Loading(isLoading: false),
              );
        }
        context.read<MainBloc>().add(
              Loading(isLoading: false),
            );
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        suffixIcon: fileUploadController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  launchUrl(Uri.parse(fileUploadController.text));
                },
                icon: const Icon(Icons.file_present),
              ),
      ),
    );
  }
}

class OpenFile extends StatelessWidget {
  final TextEditingController fileUploadController = TextEditingController();
  final int? flex;
  final String file;
  final String carpeta;
  final String pdi;
  // final CampoFicha campo;
  final String label;
  final Color color;

  OpenFile({
    required this.flex,
    required this.file,
    required this.carpeta,
    required this.pdi,
    // required this.campo,
    required this.label,
    required this.color,
    key,
  });

  @override
  Widget build(BuildContext context) {
    fileUploadController.text = file;
    if (flex == null) {
      return SizedBox(
        height: 40,
        child: _intField(),
      );
    }
    return Expanded(
      flex: flex!,
      child: _intField(),
    );
  }

  InkWell _intField() {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(file));
      },
      child: TextField(
        controller: fileUploadController,
        readOnly: true,
        onTap: () async {
          await launchUrl(Uri.parse(file));
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
