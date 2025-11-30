import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/dflcl_model.dart';

class DflclController {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  DflclController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Dflcl dflcl = Dflcl();
    try {
      String pdi = state().user?.pdi ?? '';
      var dataAsListMap;

      final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

      // Intentar obtener datos de Supabase
      try {
        // final supabase = Supabase.instance.client;
        final response = await supabase.from('${pdi}_dflcl').select();

        if (response.isNotEmpty) {
          dataAsListMap = response;
        } else {
          bl.mensaje(
            message: 'No se encontraron datos en Supabase para DFLCL.',
            messageColor: Colors.teal,
          );
          // No hay datos en Supabase, pero esto es válido
          dataAsListMap = [];
        }
      } catch (e) {
        bl.errorCarga("DFLCL", e);
        // Error en Supabase
        dataAsListMap = [];
      }

      if (dataAsListMap is! List) {
        bl.mensaje(
          message:
              '🤕 Error en el formato de datos para DFLCL ⚠️, intente recargar la página🔄',
        );
        return;
      }

      for (var item in dataAsListMap) {
        dflcl.list.add(DflclSingle.fromMap(item));
      }

      // Ordenar por DF
      dflcl.list.sort((a, b) => a.df.compareTo(b.df));
      emit(state().copyWith(dflcl: dflcl));
    } catch (e) {
      bl.errorCarga("DFLCL", e);
    }
  }

  // Método para agregar un nuevo registro
  Future<bool> agregarRegistro(DflclSingle nuevoRegistro) async {
    try {
      String pdi = state().user?.pdi ?? '';
      final supabase = Supabase.instance.client;

      // Verificar si ya existe un registro con el mismo DF
      final existente = await supabase
          .from('${pdi}_dflcl')
          .select()
          .eq('df', nuevoRegistro.df);

      if (existente.isNotEmpty) {
        bl.mensaje(
          message: 'Ya existe un registro con el DF: ${nuevoRegistro.df}',
        );
        return false;
      } // Insertar el nuevo registro sin el campo actualizado
      await supabase.from('${pdi}_dflcl').insert({
        'df': nuevoRegistro.df,
        'lcl': nuevoRegistro.lcl,
      });

      // Actualizar la lista
      await obtener;
      bl.mensaje(
        message: 'Registro agregado correctamente',
        messageColor: Colors.green,
      );
      return true;
    } catch (e) {
      bl.errorCarga("DFLCL", e);
      return false;
    }
  }

  // Método para modificar un registro
  Future<bool> modificarRegistro(
    String dfOriginal,
    DflclSingle registroModificado,
  ) async {
    try {
      String pdi = state().user?.pdi ?? '';
      final supabase = Supabase.instance.client;

      // Si cambió el DF, verificar que no exista uno igual
      if (dfOriginal != registroModificado.df) {
        final existente = await supabase
            .from('${pdi}_dflcl')
            .select()
            .eq('df', registroModificado.df);

        if (existente.isNotEmpty) {
          bl.mensaje(
            message:
                'Ya existe un registro con el DF: ${registroModificado.df}',
          );
          return false;
        }
      } // Actualizar el registro sin el campo actualizado
      await supabase
          .from('${pdi}_dflcl')
          .update({'df': registroModificado.df, 'lcl': registroModificado.lcl})
          .eq('df', dfOriginal);

      // Actualizar la lista
      await obtener;

      bl.mensaje(
        message: 'Registro modificado correctamente',
        messageColor: Colors.green,
      );
      return true;
    } catch (e) {
      bl.errorCarga("DFLCL", e);
      return false;
    }
  }

  // Método para eliminar un registro
  Future<bool> eliminarRegistro(String df) async {
    try {
      String pdi = state().user?.pdi ?? '';
      final supabase = Supabase.instance.client;

      // Eliminar el registro
      await supabase.from('${pdi}_dflcl').delete().eq('df', df);

      // Actualizar la lista
      await obtener;

      bl.mensaje(
        message: 'Registro eliminado correctamente',
        messageColor: Colors.green,
      );
      return true;
    } catch (e) {
      bl.errorCarga("DFLCL", e);
      return false;
    }
  }

  // Método para cargar datos desde CSV
  Future<bool> cargarDesdeCSV(List<List<dynamic>> csvData) async {
    try {
      String pdi = state().user?.pdi ?? '';
      final supabase = Supabase.instance.client;

      // Obtener todos los DFs existentes para validación
      final existentes = await supabase.from('${pdi}_dflcl').select('df');

      final dfsExistentes = existentes.map((e) => e['df'].toString()).toSet();

      int registrosAgregados = 0;
      int registrosOmitidos = 0;

      // Procesar registros del CSV
      for (var row in csvData) {
        // Asegurarse de que la fila tenga al menos 2 columnas
        if (row.length >= 2) {
          String df = row[0].toString();
          String lcl = row[1].toString();

          // Verificar si el DF ya existe
          if (!dfsExistentes.contains(df)) {
            // Agregar nuevo registro sin el campo actualizado
            await supabase.from('${pdi}_dflcl').insert({'df': df, 'lcl': lcl});

            registrosAgregados++;
            dfsExistentes.add(df); // Actualizar la lista de DFs existentes
          } else {
            registrosOmitidos++;
          }
        }
      }

      // Actualizar la lista
      await obtener;

      bl.mensaje(
        message:
            'Carga completada. Registros agregados: $registrosAgregados, omitidos: $registrosOmitidos',
        messageColor: Colors.green,
      );
      return true;
    } catch (e) {
      bl.errorCarga("DFLCL", e);
      return false;
    }
  }

  // Método para importar datos desde CSV
  Future<bool> importCSV(List<List<dynamic>> csvData) async {
    try {
      String pdi = state().user?.pdi ?? '';
      final supabase = Supabase.instance.client;

      // Obtener todos los DFs existentes para validación
      final existentes = await supabase.from('${pdi}_dflcl').select('df');

      final dfsExistentes = existentes.map((e) => e['df'].toString()).toSet();

      int registrosAgregados = 0;
      int registrosOmitidos = 0;

      // Procesar registros del CSV
      for (var row in csvData) {
        // Asegurarse de que la fila tenga al menos 2 columnas
        if (row.length >= 2) {
          String df = row[0].toString();
          String lcl = row[1].toString();

          // Verificar si el DF ya existe
          if (!dfsExistentes.contains(df)) {
            // Agregar nuevo registro sin el campo actualizado
            await supabase.from('${pdi}_dflcl').insert({'df': df, 'lcl': lcl});

            registrosAgregados++;
            dfsExistentes.add(df);
          } else {
            registrosOmitidos++;
          }
        }
      }

      // Actualizar la lista
      await obtener;

      bl.mensaje(
        message:
            'Carga completada. Registros agregados: $registrosAgregados, omitidos: $registrosOmitidos',
        messageColor: Colors.green,
      );
      return true;
    } catch (e) {
      bl.errorCarga("DFLCL", e);
      return false;
    }
  }

  // Método que maneja la selección y procesamiento del archivo CSV
  Future<void> handleCSVImport(
    BuildContext context,
    void Function(bool) setLoading,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        setLoading(true);

        final bytes = result.files.single.bytes;
        if (bytes != null) {
          final csvString = utf8.decode(bytes);
          final List<List<dynamic>>
          csvData = const CsvToListConverter().convert(
            csvString,
          ); // La primera fila podría ser cabecera, verificar y omitir si es necesario
          if (csvData.isNotEmpty && csvData[0].length >= 2) {
            // Si la primera fila parece ser cabecera, quitarla
            final bool isHeader =
                csvData[0][0].toString().toLowerCase() == 'df' ||
                csvData[0][1].toString().toLowerCase() == 'lcl';

            final dataToProcess = isHeader ? csvData.sublist(1) : csvData;
            await importCSV(dataToProcess);
          } else {
            if (context.mounted) {
              bl.mensaje(
                message:
                    'Formato de CSV inválido. Debe tener al menos 2 columnas: DF, LCL',
              );
            }
          }
        } else {
          if (context.mounted) {
            bl.mensaje(message: 'Error al leer el archivo CSV');
          }
        }

        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        bl.mensaje(message: 'Error al importar CSV: $e');
      }
    }
  }
}
