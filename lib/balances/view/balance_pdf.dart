import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';
import 'dart:io' if (dart.library.html) 'dart:io';
import 'package:path_provider/path_provider.dart';

Future generatePdf({
  required List<Map<String, dynamic>> e4eSum,
  required List<ResgistroSingle> registros,
}) async {
  List<List<String>> tablaPlanillas = registros
      .map((e) => [
            e.nodo,
            e.odm,
            e.e4e,
            e.descripcion,
            e.um,
            e.ctd_e,
            e.ctd_r,
            e.ctd_total,
          ])
      .toList();

  tablaPlanillas.sort((a, b) => int.parse(a[2]).compareTo(int.parse(b[2])));

  List<String> planillas = registros.map((e) => e.odm).toSet().toList();

  ResgistroSingle registro = registros.first;

  TextStyle headerStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
    color: PdfColors.grey,
  );

  TextStyle lclStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
    color: PdfColors.black,
  );

  TextStyle firmasStyle = TextStyle(
    fontSize: 10.0,
  );

  Document doc = Document(
    title: "BALANCE_${registro.lcl}_${registro.lm}_${registro.pdi}",
    producer: 'SAM - PM&C',
  );
  doc.addPage(
    MultiPage(
      pageFormat: PdfPageFormat.letter,
      margin: EdgeInsets.all(20.0),
      orientation: PageOrientation.landscape,
      crossAxisAlignment: CrossAxisAlignment.center,
      header: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          children: [
            Text('SAM', style: headerStyle),
            Text('BALANCE DE MATERIALES', style: headerStyle),
            Text('Versión 1.0', style: headerStyle),
          ],
        );
      },
      footer: (context) {
        return Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vbo. Almacén', style: firmasStyle),
                  Text('Vbo. Operación', style: firmasStyle),
                  Text('Vbo. Facturación', style: firmasStyle),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: Theme.of(context).defaultTextStyle.copyWith(
                      color: PdfColors.grey,
                      fontSize: 8,
                    ),
              ),
            ],
          ),
        );
      },
      build: (Context context) => [
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('LCL:', style: lclStyle),
                SizedBox(width: 10),
                Container(
                  width: 130,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: PdfColors.black),
                  ),
                  child: Text(
                    registro.lcl,
                    style: lclStyle,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('BALANCE:', style: lclStyle),
                SizedBox(width: 10),
                Container(
                  width: 130,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: PdfColors.black),
                  ),
                  child: Text(
                    registro.lm,
                    style: lclStyle,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('FECHA BALANCE:', style: lclStyle),
                SizedBox(width: 10),
                Container(
                  width: 130,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: PdfColors.black),
                  ),
                  child: Text(
                    registro.fecha_conciliacion,
                    style: lclStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Tabla 1, Resumen de planillas",
          style: Theme.of(context).defaultTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 10.0,
              ),
        ),
        Table.fromTextArray(
          cellAlignment: Alignment.center,
          cellPadding: EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 1),
          context: context,
          data: [
            [
              'E4E',
              'DESCRIPCIÓN',
              'UM',
              'ENTREGADO',
              'REINTEGRADO',
              'INSTALADO',
            ],
            for (Map row in e4eSum) row.values.toList(),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Tabla 2, Registros de planillas",
          style: Theme.of(context).defaultTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 10.0,
              ),
        ),
        Table.fromTextArray(
          cellAlignment: Alignment.center,
          cellPadding: EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 1),
          context: context,
          data: [
            [
              'NODO',
              'REMISION',
              'E4E',
              'DESCRIPCIÓN',
              'UM',
              'ENTREGADO',
              'REINTEGRADO',
              'INSTALADO',
            ],
            ...tablaPlanillas,
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Tabla 3, Planillas QR",
          style: Theme.of(context).defaultTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 10.0,
              ),
        ),
        SizedBox(height: 5),
        GridView(
          crossAxisCount: 6,
          childAspectRatio: 0.65,
          children: [
            for (String planilla in planillas)
              Column(
                children: [
                  Text(planilla),
                  SizedBox(height: 2),
                  UrlLink(
                    destination: registros
                        .firstWhere((e) => e.odm == planilla)
                        .soporte_d_r,
                    child: BarcodeWidget(
                      data: registros
                          .firstWhere((e) => e.odm == planilla)
                          .soporte_d_r,
                      width: 60,
                      height: 60,
                      barcode: Barcode.qrCode(),
                      drawText: false,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
  );

  final pdfBytes = await doc.save();
  
  // Use FileSaver for web platform
  if (kIsWeb) {
    final String fileName = "BALANCE_${registro.lcl}_${registro.lm}_${registro.pdi}.pdf";
    
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: Uint8List.fromList(pdfBytes),
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );
  } else {
    // For mobile platforms, use the appropriate method to save and open the PDF
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = "BALANCE_${registro.lcl}_${registro.lm}_${registro.pdi}.pdf";
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfBytes);
    
    // You can add platform-specific code here to open the file
    // For Android/iOS, you might want to use a plugin like open_file
  }
}
