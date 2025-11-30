import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../resources/constant/apis.dart';
import '../model/sustitutos_model.dart';

// onLoadSustitutos(Bl bl) async {
//   try {
//     await SustitutosController(bl).obtener;
//   } catch (e) {
//     bl.errorCarga("Sustitutos", e);
//   }
// }

class SustitutosController {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;
  // final String url = "https://ixgwpnreunngzhxiyvob.supabase.co";
  // final String key =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml4Z3dwbnJldW5uZ3poeGl5dm9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4NzIxMDQsImV4cCI6MjA2MDQ0ODEwNH0.6GNUjsUu9BJMOhlQ_9O-HIygKraKs7N0r0K7UOqV4iE";

  SustitutosController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Sustitutos sustitutos = Sustitutos();

    try {
      var dataAsListMap;

      // Primero intentar obtener datos de Supabase
      try {
        final supabaseClient = SupabaseClient(
          Api.femSamSupUrlNew,
          Api.femSamSupKeyNew,
        );
        final response =
            await supabaseClient
                .from('sustitutos') // Tabla para sustitutos
                .select();

        if (response.isNotEmpty) {
          dataAsListMap = response;
          // print('tipo de datos Sustitutos: ${dataAsListMap.runtimeType}');
        } else {
          bl.mensaje(
            message:
                'No se encontraron datos en Supabase para SUSTITUTOS, intentando con Google Script...',
          );
          // Si no hay datos en Supabase, intentar con Google Script
          dataAsListMap = await _obtenerDesdeGoogleScript();
        }
      } catch (e) {
        bl.errorCarga("Sustitutos", e);
        // Si hay error en Supabase, intentar con Google Script
        dataAsListMap = await _obtenerDesdeGoogleScript();
      }

      if (dataAsListMap == null ||
          dataAsListMap is! List ||
          dataAsListMap.isEmpty) {
        bl.mensaje(
          message:
              'No se encontraron datos en ninguna fuente para SUSTITUTOS ⚠️, intente recargar la página🔄',
        );
        return;
      }

      for (var item in dataAsListMap) {
        sustitutos.sustitutosList.add(SustitutosSingle.fromMap(item));
      }

      // Establecer lista de búsqueda
      sustitutos.sustitutosListSearch = [...sustitutos.sustitutosList];

      emit(state().copyWith(sustitutos: sustitutos));
    } catch (e) {
      bl.errorCarga("Sustitutos", e);
    }
  }

  // Método para agregar un nuevo sustituto en Supabase
  Future<void> agregarSustituto(SustitutosSingle nuevoSustituto) async {
    try {
      final supabaseClient = SupabaseClient(Api.femSamSupUrl, Api.femSamSupKey);

      // Crear un mapa con los campos según los nombres de columna en Supabase
      Map<String, dynamic> datosNuevo = {
        'CODIGO_VIEJO': nuevoSustituto.e4eV,
        'DESCRIPCION': nuevoSustituto.descripcionV,
        'CODIGO_NUEVO': nuevoSustituto.e4eN,
        'DESCRIPCION_NUEVA': nuevoSustituto.descripcionN,
      };

      // Insertar el nuevo registro en Supabase
      final response =
          await supabaseClient.from('sustitutos').insert(datosNuevo).select();

      print('Respuesta de inserción: $response');

      // Si la inserción fue exitosa, actualizar también el estado local
      // Obtener el estado actual
      Sustitutos sustitutosActual = state().sustitutos!;

      // Agregar el nuevo sustituto a la lista
      List<SustitutosSingle> nuevaLista = [
        ...sustitutosActual.sustitutosList,
        nuevoSustituto,
      ];

      // Actualizar el estado con la nueva lista
      Sustitutos nuevosSustitutos =
          Sustitutos()
            ..sustitutosList = nuevaLista
            ..sustitutosListSearch = [...nuevaLista];

      emit(state().copyWith(sustitutos: nuevosSustitutos));

      bl.mensaje(message: '✅ Sustituto agregado correctamente');
    } catch (e) {
      bl.errorCarga("Agregar sustituto", e);
    }
  }

  // Método para actualizar un sustituto en Supabase
  Future<void> actualizarSustituto(
    SustitutosSingle sustitutoAntiguo,
    SustitutosSingle sustitutoNuevo,
  ) async {
    try {
      final supabaseClient = SupabaseClient(Api.femSamSupUrl, Api.femSamSupKey);

      // Crear un mapa con los campos según los nombres de columna en Supabase
      Map<String, dynamic> datosActualizados = {
        'CODIGO_VIEJO': sustitutoNuevo.e4eV,
        'DESCRIPCION': sustitutoNuevo.descripcionV,
        'CODIGO_NUEVO': sustitutoNuevo.e4eN,
        'DESCRIPCION_NUEVA': sustitutoNuevo.descripcionN,
      };

      // Intentar actualizar el registro en Supabase basado en el código viejo y nuevo (claves primarias)
      final response =
          await supabaseClient
              .from('sustitutos')
              .update(datosActualizados)
              .eq('CODIGO_VIEJO', sustitutoAntiguo.e4eV)
              .eq('CODIGO_NUEVO', sustitutoAntiguo.e4eN)
              .select();

      print('Respuesta de actualización: $response');

      // Si la actualización fue exitosa, actualizar también el estado local
      // Obtener el estado actual
      Sustitutos sustitutosActual = state().sustitutos!;

      // Encontrar y reemplazar el sustituto actualizado en la lista
      int indice = sustitutosActual.sustitutosList.indexWhere(
        (element) =>
            element.e4eV == sustitutoAntiguo.e4eV &&
            element.e4eN == sustitutoAntiguo.e4eN,
      );

      if (indice != -1) {
        // Crear una nueva lista para no modificar la original directamente
        List<SustitutosSingle> nuevaLista = [
          ...sustitutosActual.sustitutosList,
        ];
        nuevaLista[indice] = sustitutoNuevo;

        // Actualizar el estado con la nueva lista
        Sustitutos nuevosSustitutos =
            Sustitutos()
              ..sustitutosList = nuevaLista
              ..sustitutosListSearch = [...nuevaLista];

        emit(state().copyWith(sustitutos: nuevosSustitutos));
        bl.mensaje(message: '✅ Sustituto actualizado correctamente');
      }
    } catch (e) {
      bl.errorCarga('Error al actualizar el sustituto', e);
    }
  }

  // Método para cargar múltiples sustitutos desde un archivo CSV
  Future<void> cargaMasiva(BuildContext context) async {
    try {
      // Seleccionar el archivo CSV
      FilePickerResult? resultado = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (resultado == null || resultado.files.isEmpty) {
        bl.mensaje(message: 'No se seleccionó ningún archivo');
        return;
      }

      // Obtener los bytes del archivo
      Uint8List? fileBytes = resultado.files.first.bytes;
      if (fileBytes == null) {
        bl.mensaje(message: 'No se pudo leer el archivo seleccionado');
        return;
      }

      // Convertir bytes a string
      String csvString = utf8.decode(fileBytes);

      // Parsear el CSV
      List<List<dynamic>> rows = const CsvToListConverter(
        fieldDelimiter: ";",
      ).convert(csvString);

      if (rows.isEmpty) {
        bl.mensaje(message: 'El archivo CSV está vacío');
        return;
      }

      // Verificar estructura de columnas (debe tener 4 columnas)
      List<String> headers = rows[0].map((e) => e.toString().trim()).toList();
      // print('Encabezados: $headers, longitud: ${headers.length}');

      // Verificar que el archivo tenga los 4 encabezados necesarios
      if (headers.length != 4) {
        bl.mensaje(
          message:
              'El formato del CSV es incorrecto. Debe contener 4 columnas: Código Viejo, Descripción Viejo, Código Nuevo, Descripción Nuevo',
        );
        return;
      }

      // Obtener los sustitutos actuales
      Sustitutos sustitutosActuales = state().sustitutos!;
      List<SustitutosSingle> listaActual = sustitutosActuales.sustitutosList;

      // Para registros a actualizar y a insertar
      List<Map<String, dynamic>> registrosParaActualizar = [];
      List<Map<String, dynamic>> registrosParaInsertar = [];
      List<String> errores = [];

      // Analizar cada fila (excluyendo encabezados)
      for (int i = 1; i < rows.length; i++) {
        if (rows[i].length != 4) {
          errores.add('La fila ${i + 1} no tiene 4 columnas');
          continue;
        }

        // Obtener los valores de la fila
        String e4eV = rows[i][0].toString().trim();
        String descripcionV = rows[i][1].toString().trim();
        String e4eN = rows[i][2].toString().trim();
        String descripcionN = rows[i][3].toString().trim();

        // Validar que no estén vacíos
        if (e4eV.isEmpty ||
            descripcionV.isEmpty ||
            e4eN.isEmpty ||
            descripcionN.isEmpty) {
          errores.add('La fila ${i + 1} tiene campos vacíos');
          continue;
        }

        // Crear objeto para Supabase
        Map<String, dynamic> datosFila = {
          'CODIGO_VIEJO': e4eV,
          'DESCRIPCION': descripcionV,
          'CODIGO_NUEVO': e4eN,
          'DESCRIPCION_NUEVA': descripcionN,
        };

        // Verificar si ya existe esta combinación (e4eV + e4eN)
        int indiceExistente = listaActual.indexWhere(
          (item) => item.e4eV == e4eV && item.e4eN == e4eN,
        );

        if (indiceExistente != -1) {
          // Ya existe, verificar si hay cambios
          SustitutosSingle existente = listaActual[indiceExistente];
          if (existente.descripcionV != descripcionV ||
              existente.descripcionN != descripcionN) {
            // Hay cambios, agregar a la lista para actualizar
            registrosParaActualizar.add(datosFila);
          }
        } else {
          // No existe, agregar a la lista para insertar
          registrosParaInsertar.add(datosFila);
        }
      }

      // Si hay errores, mostrar mensaje y no continuar
      if (errores.isNotEmpty) {
        String mensajeErrores =
            'Se encontraron ${errores.length} errores en el archivo:\n${errores.take(5).join('\n')}';
        if (errores.length > 5) {
          mensajeErrores += '\n...y ${errores.length - 5} más';
        }

        bl.mensaje(message: mensajeErrores);
        return;
      }

      // Ejecutar actualizaciones e inserciones en Supabase
      final supabaseClient = SupabaseClient(Api.femSamSupUrl, Api.femSamSupKey);
      String mensaje = '';
      int actualizaciones = 0;
      int inserciones = 0;

      // Realizar actualizaciones si hay registros para actualizar
      if (registrosParaActualizar.isNotEmpty) {
        for (var registro in registrosParaActualizar) {
          await supabaseClient
              .from('sustitutos')
              .update({
                'DESCRIPCION': registro['DESCRIPCION'],
                'DESCRIPCION_NUEVA': registro['DESCRIPCION_NUEVA'],
              })
              .eq('CODIGO_VIEJO', registro['CODIGO_VIEJO'])
              .eq('CODIGO_NUEVO', registro['CODIGO_NUEVO']);
          actualizaciones++;
        }
      }

      // Realizar inserciones si hay registros para insertar
      if (registrosParaInsertar.isNotEmpty) {
        await supabaseClient.from('sustitutos').insert(registrosParaInsertar);
        inserciones = registrosParaInsertar.length;
      }

      mensaje =
          '✅ Carga masiva completada: '
          '${inserciones} registros nuevos insertados, '
          '${actualizaciones} registros actualizados.';

      // Volver a cargar los datos para refrescar la lista
      await obtener;
      bl.mensaje(message: mensaje, messageColor: Colors.green);
      // emit(state().copyWith(message: mensaje));
    } catch (e) {
      bl.errorCarga('Error carga masiva', e);
    }
  }

  // Método auxiliar para obtener datos desde Google Script
  Future<dynamic> _obtenerDesdeGoogleScript() async {
    Map<String, Object> dataSend = {
      'dataReq': {'libro': 'SUSTITUTOS', 'hoja': 'reg'},
      'fname': "getHoja",
    };

    final response = await post(Uri.parse(Api.femString), body: jsonEncode(dataSend));

    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await get(
        Uri.parse(response.headers["location"].toString().replaceAll(',', '')),
      );
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }

    // Verificar si dataAsListMap contiene datos y quitar la primera fila si es cabecera
    if (dataAsListMap != null &&
        dataAsListMap is List &&
        dataAsListMap.isNotEmpty) {
      return dataAsListMap.sublist(1); // Quitar la primera fila (cabecera)
    }

    return dataAsListMap;
  }
}
