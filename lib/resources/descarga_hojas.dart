import 'package:v_al_sam_v02/resources/onlycsv.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../registros/model/resgistros_b.dart';

class DescargaHojas {
  DateTime date = DateTime.now();
  Future<List<List<String>>> ahora({
    required List datos,
    required String nombre,
    required User user,
  }) async {
    // print('DescargaHojas.ahora()');
    DateTime date = DateTime.now();
    List<String> keys = datos[0].toMap().keys.toList();
    List<List<String>> datosParaDescarga = [];
    datosParaDescarga.add(keys);
    for (var row in datos) {
      datosParaDescarga.add(row.toList());
    }
    // print('datosParaDescarga: $datosParaDescarga');
    await SaveAsCsv().saveCSV(
        dataValue: datosParaDescarga,
        fileName:
            '$nombre de ${user.pdi} al ${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}');
    return datosParaDescarga;
  }

  static Future<List<List<String>>> ahoraMap({
    required List<Map<String, dynamic>> datos,
    required String nombre,
    required User user,
  }) async {
    // print('DescargaHojas.ahora()');
    DateTime date = DateTime.now();
    List<String> keys = datos[0].keys.toList();
    List<List<String>> datosParaDescarga = [];
    datosParaDescarga.add(keys);
    for (Map row in datos) {
      datosParaDescarga.add(row.values.map((e) => e.toString()).toList());
    }
    // print('datosParaDescarga: $datosParaDescarga');
    await SaveAsCsv().saveCSV(
        dataValue: datosParaDescarga,
        fileName:
            '$nombre de ${user.pdi} al ${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}');
    return datosParaDescarga;
  }

  Future<List<List<String>>> ahoraSIPWEB({
    required List<ResgistroSingle> datos,
    required String nombre,
    required User user,
  }) async {
    // print('DescargaHojas.ahora()');
    DateTime date = DateTime.now();
    List<List<String>> datosParaDescarga = [];
    datosParaDescarga.add(encabezadoSipWeb);
    for (var row in datos) {
      datosParaDescarga.add(row.toListSIPWEB());
    }
    // print('datosParaDescarga: $datosParaDescarga');
    await SaveAsCsv().saveCSV(
        dataValue: datosParaDescarga,
        fileName:
            '$nombre (SippWeb) de ${user.pdi} al ${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}');
    return datosParaDescarga;
  }

  List<String> encabezadoSipWeb = [
    'Id',
    'Pdi',
    'Nombre_almacen',
    'Proceso',
    'Circuito',
    'Proyecto',
    'Nodo',
    'Pdl',
    'Lcl_ticket',
    'Odm_grafo',
    'Cuadrillero_recibe',
    'Cedula',
    'Fecha_entrega_material',
    'Codigo_e4e',
    'Descripcion_material',
    'Aportacion_enel',
    'Material_custodia',
    'Um',
    'Cantidad_solicitada',
    'Cantidad_entregada',
    'Cantidad_consumida',
    'Cantidad_reintegrada',
    'Fecha_reintegro',
    'Consecutivo_bodega',
    'Doc_wms_carga',
    'Gestor_operativo',
    'Documento_sap',
    'Posicion_doc_material_sap',
    'Validacion_eecc',
    'Observacion_eecc',
    'Fecha_modificacion',
    'Usuario',
    'Localidad_municipio',
    'Validacion',
    'Area',
    'Lcl_final',
    'sel',
    'sel2',
  ];
}
