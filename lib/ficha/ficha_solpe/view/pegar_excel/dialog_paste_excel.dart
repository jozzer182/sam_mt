import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:gap/gap.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';


class PasteExcelDialog extends StatefulWidget {
  const PasteExcelDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<PasteExcelDialog> createState() => _PasteExcelDialogState();
}

class _PasteExcelDialogState extends State<PasteExcelDialog>
    with TickerProviderStateMixin {
  late GifController controller;

  @override
  void initState() {
    controller = GifController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pegar datos de Excel'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GifView(
              image: const AssetImage('images/PegarExcelSOLPE.gif'),
              controller: controller,
            ),
            const Gap(20),
            ElevatedButton(
              onPressed: () async {
                const String csvContent = 'e4e;ctd';

                // Convert the string to bytes for the file_saver
                final Uint8List bytes = Uint8List.fromList(utf8.encode(csvContent));
                
                // Use FileSaver to download the CSV file
                await FileSaver.instance.saveFile(
                  name: "Plantilla Solicitud Pedidos",
                  bytes: bytes,
                  ext: 'csv',
                  mimeType: MimeType.csv,
                );
              },
              child: const Text('Descargar Plantilla'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
