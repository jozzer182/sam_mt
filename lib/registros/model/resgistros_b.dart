import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

class RegistrosB {
  List<ResgistroSingle> registrosList = [];
  List<ResgistroSingle> registrosListSearch = [];
  List<ResgistroSingle> registrosListSearch2 = [];
  String pedidoSelected = '';
  int view = 25;


  buscar(String busqueda) {
    registrosListSearch = [...registrosList];
    registrosListSearch = registrosList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
    registrosListSearch2 = registrosList
        .where((e) =>
            e.toList().any((item) => item
                .toString()
                .toLowerCase()
                .contains(busqueda.toLowerCase())) &&
            int.parse(e.ctd_total) > 0)
        .toList();
  }

  //Registros Enel, son registros que aun no se reflejan en SAP
  List<Map<String, dynamic>> get registrosEnel {
    var dataAsListMap2 = registrosList
        .where((e) =>
            e.est_oficial == 'Conciliado' || e.est_oficial == 'Faltante_Enel')
        .map((e) => {
              ...e.toMap(),
              ...{
                'ctd_total': int.parse(e.ctd_total),
                'ctd_con': int.parse(e.ctd_con)
              }
            })
        .toList();

    // print('registrosOperativos -> $dataAsListMap2');
    //agrupar y sumar por proyecto
    var keysToSelect = ['proyecto', 'e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd_total', 'ctd_au', 'ctd_ma'];
    var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    // print(registros);
    return registros;
  }

  //Registros en estado operativo, es decir, falta de conciliación
  List<Map<String, dynamic>> get registrosOperativos {
    var dataAsListMap2 = registrosList
        .where((e) =>
            e.est_oficial == 'entregado' ||
                e.est_oficial == 'reintegrado' ||
                e.est_oficial == 'Faltante_Operativo')
        .map((e) => {
              ...e.toMap(),
              ...{
                'ctd_total': int.parse(e.ctd_total),
                'ctd_con': int.parse(e.ctd_con)
              }
            })
        .toList();
    //agrupar y sumar por e4e
    var keysToSelect = ['e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd_total', 'ctd_con'];
    var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    return registros;
  }

  // List<Map<String, dynamic>> get porLCL {
  //   var dataAsListMap2 = registrosList
  //       .where((e) =>
  //           e.est_oficial == 'entregado' ||
  //           e.est_oficial == 'reintegrado' ||
  //           e.est_oficial == 'Faltante_Operativo')
  //       .map((e) => {
  //             ...e.toMap(),
  //             ...{
  //               'ctd_total': int.parse(e.ctd_total),
  //               'ctd_con': int.parse(e.ctd_con)
  //             }
  //           })
  //       .toList();
  //   //agrupar y sumar por e4e
  //   var keysToSelect = ['lcl', 'e4e', 'um'];
  //   var keysToSum = ['ctd_total', 'ctd_con'];
  //   var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
  //   registros.sort((a, b) => int.parse('${a['lcl']}${a['e4e']}')
  //       .compareTo(int.parse('${b['lcl']}${b['e4e']}')));
  //   return registros;
  // }

  List<Map<String, dynamic>> get porFuncional {
    var dataAsListMap2 = registrosList
        .where((e) =>
            e.est_oficial == 'entregado' ||
            e.est_oficial == 'reintegrado' ||
            e.est_oficial == 'Faltante_Operativo')
        .map((e) => {
              ...e.toMap(),
              ...{
                'ctd_total': int.parse(e.ctd_total),
                'ctd_con': int.parse(e.ctd_con)
              }
            })
        .toList();
    //agrupar y sumar por e4e
    var keysToSelect = ['ingeniero_enel', 'e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd_total', 'ctd_con'];
    var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    registros.sort((a, b) => '${a['ingeniero_enel']}${a['e4e']}'
        .compareTo('${b['ingeniero_enel']}${b['e4e']}'));
    return registros;
  }

  //Agrupar y summar los registros ingresados
  List<Map<String, dynamic>> groupByList(
    List<Map<String, dynamic>> data,
    List<String> keysToSelect,
    List<String> keysToSum,
  ) {
    List<Map<String, dynamic>> dataKeyAsJson = data.map((e) {
      e['asJson'] = {};
      for (var key in keysToSelect) {
        e['asJson'].addAll({key: e[key]});
        e.remove(key);
      }
      e['asJson'] = jsonEncode(e['asJson']);
      return e;
    }).toList();
    // print('dataKeyAsJson = $dataKeyAsJson');

    Map<dynamic, Map<String, int>> groupAsMap =
        groupBy(dataKeyAsJson, (Map e) => e['asJson'])
            .map((key, value) => MapEntry(key, {
                  for (var keySum in keysToSum)
                    keySum: value.fold<int>(0, (p, a) => p + (a[keySum] as int))
                }));

    List<Map<String, dynamic>> result = groupAsMap.entries.map((e) {
      Map<String, dynamic> newMap = jsonDecode(e.key);
      return {...newMap, ...e.value};
    }).toList();
    // print('result = $result');

    return result;
  }

  cambioLCL(Map dato, String lcl, User user) async {
    List vals = [];
    DateTime date = DateTime.now();
    //   for (var row in planillaBListParaEnvio) {
    vals.add({
      ...dato,
      'lcl': lcl,
      'pdi': user.pdi,
      'est_oficial': 'reintegrado',
      'est_oficial_fecha':
          '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
      'est_oficial_pers': user.nombre,
    });
    //   }

    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'rows': vals, 'hoja': 'registros'},
      'fname': "updateInfo"
    };
    // print(jsonEncode(dataSend));
    var response = await http.post(
        Api.sam,
        body: jsonEncode(dataSend));
    // print(response.body);
    var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
    // print(respuesta);
    if (respuesta is List) {
      respuesta =
          'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
    } else {
      print(respuesta);
    }
    print(respuesta);
    return respuesta;
  }

  updateLibreto(List<Map> listMapOdm) {
    for (int i = 0; i < listMapOdm.length; i++) {
      Map mapOdm = listMapOdm[i];
      for (var i = 0; i < registrosList.length; i++) {
        ResgistroSingle registro = registrosList[i];
        if (registro.odm == mapOdm['odm']) {
          registro.lm = mapOdm['lm'].toString();
          registro.fecha_conciliacion = mapOdm['fecha_conciliacion'].toString();
          registro.comentario_op = mapOdm['comentario_op'].toString();
          registro.est_contrato = mapOdm['est_contrato'].toString();
          registro.responsable_contrato =
              mapOdm['responsable_contrato'].toString();
          registro.fecha_cierre = mapOdm['fecha_cierre'].toString();
        }
      }
    }
  }
}

class ResgistroSingle {
  String pedido;
  String est_s;
  String fecha_s;
  String solicitante;
  String tel_solicitante;
  String contrato;
  String nombre_pdi;
  String pdi;
  String proceso;
  String proyecto;
  String ingeniero_enel;
  String unidad;
  String lcl;
  String odm;
  String grafo;
  String pdl;
  String nodo;
  String localidad_municipio;
  String circuito;
  String subestacion_cabecera;
  String fecha_peticion_s;
  String comentario_s;
  String soporte_d_s;
  String soporte_e_s;
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd_s;
  String aportacion;
  String fecha_p;
  String estado_p;
  String comentario_p;
  String fecha_futuro_p;
  String almacenista_p;
  String almacenista_a;
  String tel_alm_a;
  String fecha_a;
  String hora_a;
  String ctd_a;
  String comentario_a;
  String almacenista_e;
  String tel_alm_e;
  String fecha_e;
  String hora_e;
  String ctd_e;
  String lider_contrato_e;
  String cc_lider_contrato_e;
  String placa_cuadrilla_e;
  String tel_lider_e;
  String comentario_e;
  String soporte_d_e;
  String soporte_e_e;
  String almacenista_r;
  String tel_alm_r;
  String fecha_r;
  String hora_r;
  String ctd_r;
  String lider_contrato_r;
  String placa_cuadrilla_r;
  String tel_lider_r;
  String soporte_d_r;
  String soporte_e_r;
  String ctd_total;
  String est_contrato;
  String fecha_conciliacion;
  String fecha_cierre;
  String responsable_contrato;
  String ctd_con;
  String comentario_op;
  String lm;
  String soporte_d_c;
  String soporte_e_c;
  String ctd_cob;
  String fecha_sap_au;
  String est_sap_au;
  String sap_au;
  String ctd_au;
  String fecha_sap_ma;
  String est_sap_ma;
  String sap_ma;
  String ctd_ma;
  String soporte_ma;
  String est_sap;
  String sap;
  String ctd_sap;
  String fecha_sap;
  String ctd_dif;
  String est_oficial;
  String est_oficial_fecha;
  String est_oficial_pers;
  ResgistroSingle({
    required this.pedido,
    required this.est_s,
    required this.fecha_s,
    required this.solicitante,
    required this.tel_solicitante,
    required this.contrato,
    required this.nombre_pdi,
    required this.pdi,
    required this.proceso,
    required this.proyecto,
    required this.ingeniero_enel,
    required this.unidad,
    required this.lcl,
    required this.odm,
    required this.grafo,
    required this.pdl,
    required this.nodo,
    required this.localidad_municipio,
    required this.circuito,
    required this.subestacion_cabecera,
    required this.fecha_peticion_s,
    required this.comentario_s,
    required this.soporte_d_s,
    required this.soporte_e_s,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd_s,
    required this.aportacion,
    required this.fecha_p,
    required this.estado_p,
    required this.comentario_p,
    required this.fecha_futuro_p,
    required this.almacenista_p,
    required this.almacenista_a,
    required this.tel_alm_a,
    required this.fecha_a,
    required this.hora_a,
    required this.ctd_a,
    required this.comentario_a,
    required this.almacenista_e,
    required this.tel_alm_e,
    required this.fecha_e,
    required this.hora_e,
    required this.ctd_e,
    required this.lider_contrato_e,
    required this.cc_lider_contrato_e,
    required this.placa_cuadrilla_e,
    required this.tel_lider_e,
    required this.comentario_e,
    required this.soporte_d_e,
    required this.soporte_e_e,
    required this.almacenista_r,
    required this.tel_alm_r,
    required this.fecha_r,
    required this.hora_r,
    required this.ctd_r,
    required this.lider_contrato_r,
    required this.placa_cuadrilla_r,
    required this.tel_lider_r,
    required this.soporte_d_r,
    required this.soporte_e_r,
    required this.ctd_total,
    required this.est_contrato,
    required this.fecha_conciliacion,
    required this.fecha_cierre,
    required this.responsable_contrato,
    required this.ctd_con,
    required this.comentario_op,
    required this.lm,
    required this.soporte_d_c,
    required this.soporte_e_c,
    required this.ctd_cob,
    required this.fecha_sap_au,
    required this.est_sap_au,
    required this.sap_au,
    required this.ctd_au,
    required this.fecha_sap_ma,
    required this.est_sap_ma,
    required this.sap_ma,
    required this.ctd_ma,
    required this.soporte_ma,
    required this.est_sap,
    required this.sap,
    required this.ctd_sap,
    required this.fecha_sap,
    required this.ctd_dif,
    required this.est_oficial,
    required this.est_oficial_fecha,
    required this.est_oficial_pers,
  });

  ResgistroSingle copyWith({
    String? pedido,
    String? est_s,
    String? fecha_s,
    String? solicitante,
    String? tel_solicitante,
    String? contrato,
    String? nombre_pdi,
    String? pdi,
    String? proceso,
    String? proyecto,
    String? ingeniero_enel,
    String? unidad,
    String? lcl,
    String? odm,
    String? grafo,
    String? pdl,
    String? nodo,
    String? localidad_municipio,
    String? circuito,
    String? subestacion_cabecera,
    String? fecha_peticion_s,
    String? comentario_s,
    String? soporte_d_s,
    String? soporte_e_s,
    String? item,
    String? e4e,
    String? descripcion,
    String? um,
    String? ctd_s,
    String? aportacion,
    String? fecha_p,
    String? estado_p,
    String? comentario_p,
    String? fecha_futuro_p,
    String? almacenista_p,
    String? almacenista_a,
    String? tel_alm_a,
    String? fecha_a,
    String? hora_a,
    String? ctd_a,
    String? comentario_a,
    String? almacenista_e,
    String? tel_alm_e,
    String? fecha_e,
    String? hora_e,
    String? ctd_e,
    String? lider_contrato_e,
    String? cc_lider_contrato_e,
    String? placa_cuadrilla_e,
    String? tel_lider_e,
    String? comentario_e,
    String? soporte_d_e,
    String? soporte_e_e,
    String? almacenista_r,
    String? tel_alm_r,
    String? fecha_r,
    String? hora_r,
    String? ctd_r,
    String? lider_contrato_r,
    String? placa_cuadrilla_r,
    String? tel_lider_r,
    String? soporte_d_r,
    String? soporte_e_r,
    String? ctd_total,
    String? est_contrato,
    String? fecha_conciliacion,
    String? fecha_cierre,
    String? responsable_contrato,
    String? ctd_con,
    String? comentario_op,
    String? lm,
    String? soporte_d_c,
    String? soporte_e_c,
    String? ctd_cob,
    String? fecha_sap_au,
    String? est_sap_au,
    String? sap_au,
    String? ctd_au,
    String? fecha_sap_ma,
    String? est_sap_ma,
    String? sap_ma,
    String? ctd_ma,
    String? soporte_ma,
    String? est_sap,
    String? sap,
    String? ctd_sap,
    String? fecha_sap,
    String? ctd_dif,
    String? est_oficial,
    String? est_oficial_fecha,
    String? est_oficial_pers,
  }) {
    return ResgistroSingle(
      pedido: pedido ?? this.pedido,
      est_s: est_s ?? this.est_s,
      fecha_s: fecha_s ?? this.fecha_s,
      solicitante: solicitante ?? this.solicitante,
      tel_solicitante: tel_solicitante ?? this.tel_solicitante,
      contrato: contrato ?? this.contrato,
      nombre_pdi: nombre_pdi ?? this.nombre_pdi,
      pdi: pdi ?? this.pdi,
      proceso: proceso ?? this.proceso,
      proyecto: proyecto ?? this.proyecto,
      ingeniero_enel: ingeniero_enel ?? this.ingeniero_enel,
      unidad: unidad ?? this.unidad,
      lcl: lcl ?? this.lcl,
      odm: odm ?? this.odm,
      grafo: grafo ?? this.grafo,
      pdl: pdl ?? this.pdl,
      nodo: nodo ?? this.nodo,
      localidad_municipio: localidad_municipio ?? this.localidad_municipio,
      circuito: circuito ?? this.circuito,
      subestacion_cabecera: subestacion_cabecera ?? this.subestacion_cabecera,
      fecha_peticion_s: fecha_peticion_s ?? this.fecha_peticion_s,
      comentario_s: comentario_s ?? this.comentario_s,
      soporte_d_s: soporte_d_s ?? this.soporte_d_s,
      soporte_e_s: soporte_e_s ?? this.soporte_e_s,
      item: item ?? this.item,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      um: um ?? this.um,
      ctd_s: ctd_s ?? this.ctd_s,
      aportacion: aportacion ?? this.aportacion,
      fecha_p: fecha_p ?? this.fecha_p,
      estado_p: estado_p ?? this.estado_p,
      comentario_p: comentario_p ?? this.comentario_p,
      fecha_futuro_p: fecha_futuro_p ?? this.fecha_futuro_p,
      almacenista_p: almacenista_p ?? this.almacenista_p,
      almacenista_a: almacenista_a ?? this.almacenista_a,
      tel_alm_a: tel_alm_a ?? this.tel_alm_a,
      fecha_a: fecha_a ?? this.fecha_a,
      hora_a: hora_a ?? this.hora_a,
      ctd_a: ctd_a ?? this.ctd_a,
      comentario_a: comentario_a ?? this.comentario_a,
      almacenista_e: almacenista_e ?? this.almacenista_e,
      tel_alm_e: tel_alm_e ?? this.tel_alm_e,
      fecha_e: fecha_e ?? this.fecha_e,
      hora_e: hora_e ?? this.hora_e,
      ctd_e: ctd_e ?? this.ctd_e,
      lider_contrato_e: lider_contrato_e ?? this.lider_contrato_e,
      cc_lider_contrato_e: cc_lider_contrato_e ?? this.cc_lider_contrato_e,
      placa_cuadrilla_e: placa_cuadrilla_e ?? this.placa_cuadrilla_e,
      tel_lider_e: tel_lider_e ?? this.tel_lider_e,
      comentario_e: comentario_e ?? this.comentario_e,
      soporte_d_e: soporte_d_e ?? this.soporte_d_e,
      soporte_e_e: soporte_e_e ?? this.soporte_e_e,
      almacenista_r: almacenista_r ?? this.almacenista_r,
      tel_alm_r: tel_alm_r ?? this.tel_alm_r,
      fecha_r: fecha_r ?? this.fecha_r,
      hora_r: hora_r ?? this.hora_r,
      ctd_r: ctd_r ?? this.ctd_r,
      lider_contrato_r: lider_contrato_r ?? this.lider_contrato_r,
      placa_cuadrilla_r: placa_cuadrilla_r ?? this.placa_cuadrilla_r,
      tel_lider_r: tel_lider_r ?? this.tel_lider_r,
      soporte_d_r: soporte_d_r ?? this.soporte_d_r,
      soporte_e_r: soporte_e_r ?? this.soporte_e_r,
      ctd_total: ctd_total ?? this.ctd_total,
      est_contrato: est_contrato ?? this.est_contrato,
      fecha_conciliacion: fecha_conciliacion ?? this.fecha_conciliacion,
      fecha_cierre: fecha_cierre ?? this.fecha_cierre,
      responsable_contrato: responsable_contrato ?? this.responsable_contrato,
      ctd_con: ctd_con ?? this.ctd_con,
      comentario_op: comentario_op ?? this.comentario_op,
      lm: lm ?? this.lm,
      soporte_d_c: soporte_d_c ?? this.soporte_d_c,
      soporte_e_c: soporte_e_c ?? this.soporte_e_c,
      ctd_cob: ctd_cob ?? this.ctd_cob,
      fecha_sap_au: fecha_sap_au ?? this.fecha_sap_au,
      est_sap_au: est_sap_au ?? this.est_sap_au,
      sap_au: sap_au ?? this.sap_au,
      ctd_au: ctd_au ?? this.ctd_au,
      fecha_sap_ma: fecha_sap_ma ?? this.fecha_sap_ma,
      est_sap_ma: est_sap_ma ?? this.est_sap_ma,
      sap_ma: sap_ma ?? this.sap_ma,
      ctd_ma: ctd_ma ?? this.ctd_ma,
      soporte_ma: soporte_ma ?? this.soporte_ma,
      est_sap: est_sap ?? this.est_sap,
      sap: sap ?? this.sap,
      ctd_sap: ctd_sap ?? this.ctd_sap,
      fecha_sap: fecha_sap ?? this.fecha_sap,
      ctd_dif: ctd_dif ?? this.ctd_dif,
      est_oficial: est_oficial ?? this.est_oficial,
      est_oficial_fecha: est_oficial_fecha ?? this.est_oficial_fecha,
      est_oficial_pers: est_oficial_pers ?? this.est_oficial_pers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pedido': pedido,
      'est_s': est_s,
      'fecha_s': fecha_s,
      'solicitante': solicitante,
      'tel_solicitante': tel_solicitante,
      'contrato': contrato,
      'nombre_pdi': nombre_pdi,
      'pdi': pdi,
      'proceso': proceso,
      'proyecto': proyecto,
      'ingeniero_enel': ingeniero_enel,
      'unidad': unidad,
      'lcl': lcl,
      'odm': odm,
      'grafo': grafo,
      'pdl': pdl,
      'nodo': nodo,
      'localidad_municipio': localidad_municipio,
      'circuito': circuito,
      'subestacion_cabecera': subestacion_cabecera,
      'fecha_peticion_s': fecha_peticion_s,
      'comentario_s': comentario_s,
      'soporte_d_s': soporte_d_s,
      'soporte_e_s': soporte_e_s,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd_s': ctd_s,
      'aportacion': aportacion,
      'fecha_p': fecha_p,
      'estado_p': estado_p,
      'comentario_p': comentario_p,
      'fecha_futuro_p': fecha_futuro_p,
      'almacenista_p': almacenista_p,
      'almacenista_a': almacenista_a,
      'tel_alm_a': tel_alm_a,
      'fecha_a': fecha_a,
      'hora_a': hora_a,
      'ctd_a': ctd_a,
      'comentario_a': comentario_a,
      'almacenista_e': almacenista_e,
      'tel_alm_e': tel_alm_e,
      'fecha_e': fecha_e,
      'hora_e': hora_e,
      'ctd_e': ctd_e,
      'lider_contrato_e': lider_contrato_e,
      'cc_lider_contrato_e': cc_lider_contrato_e,
      'placa_cuadrilla_e': placa_cuadrilla_e,
      'tel_lider_e': tel_lider_e,
      'comentario_e': comentario_e,
      'soporte_d_e': soporte_d_e,
      'soporte_e_e': soporte_e_e,
      'almacenista_r': almacenista_r,
      'tel_alm_r': tel_alm_r,
      'fecha_r': fecha_r,
      'hora_r': hora_r,
      'ctd_r': ctd_r,
      'lider_contrato_r': lider_contrato_r,
      'placa_cuadrilla_r': placa_cuadrilla_r,
      'tel_lider_r': tel_lider_r,
      'soporte_d_r': soporte_d_r,
      'soporte_e_r': soporte_e_r,
      'ctd_total': ctd_total,
      'est_contrato': est_contrato,
      'fecha_conciliacion': fecha_conciliacion,
      'fecha_cierre': fecha_cierre,
      'responsable_contrato': responsable_contrato,
      'ctd_con': ctd_con,
      'comentario_op': comentario_op,
      'lm': lm,
      'soporte_d_c': soporte_d_c,
      'soporte_e_c': soporte_e_c,
      'ctd_cob': ctd_cob,
      'fecha_sap_au': fecha_sap_au,
      'est_sap_au': est_sap_au,
      'sap_au': sap_au,
      'ctd_au': ctd_au,
      'fecha_sap_ma': fecha_sap_ma,
      'est_sap_ma': est_sap_ma,
      'sap_ma': sap_ma,
      'ctd_ma': ctd_ma,
      'soporte_ma': soporte_ma,
      'est_sap': est_sap,
      'sap': sap,
      'ctd_sap': ctd_sap,
      'fecha_sap': fecha_sap,
      'ctd_dif': ctd_dif,
      'est_oficial': est_oficial,
      'est_oficial_fecha': est_oficial_fecha,
      'est_oficial_pers': est_oficial_pers,
    };
  }

  factory ResgistroSingle.fromMap(Map<String, dynamic> map) {
    return ResgistroSingle(
      pedido: map['pedido'].toString(),
      est_s: map['est_s'].toString(),
      fecha_s: map['fecha_s'].toString().isNotEmpty && 
              map['fecha_s'].toString().length > 10
          ? map['fecha_s'].toString().substring(0, 10)
          : map['fecha_s'].toString(),
      solicitante: map['solicitante'].toString(),
      tel_solicitante: map['tel_solicitante'].toString(),
      contrato: map['contrato'].toString(),
      nombre_pdi: map['nombre_pdi'].toString(),
      pdi: map['pdi'].toString(),
      proceso: map['proceso'].toString(),
      proyecto: map['proyecto'].toString(),
      ingeniero_enel: map['ingeniero_enel'].toString(),
      unidad: map['unidad'].toString(),
      lcl: map['lcl'].toString(),
      odm: map['odm'].toString(),
      grafo: map['grafo'].toString(),
      pdl: map['pdl'].toString(),
      nodo: map['nodo'].toString(),
      localidad_municipio: map['localidad_municipio'].toString(),
      circuito: map['circuito'].toString(),
      subestacion_cabecera: map['subestacion_cabecera'].toString(),
      fecha_peticion_s: map['fecha_peticion_s'].toString().isNotEmpty &&
              map['fecha_peticion_s'].toString().length > 10
          ? map['fecha_peticion_s'].toString().substring(0, 10)
          : map['fecha_peticion_s'].toString(),
      comentario_s: map['comentario_s'].toString(),
      soporte_d_s: map['soporte_d_s'].toString(),
      soporte_e_s: map['soporte_e_s'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd_s: map['ctd_s'].toString(),
      aportacion: map['aportacion'].toString(),
      fecha_p: map['fecha_p'].toString().isNotEmpty &&
              map['fecha_p'].toString().length > 10
          ? map['fecha_p'].toString().substring(0, 10)
          : map['fecha_p'].toString(),
      estado_p: map['estado_p'].toString(),
      comentario_p: map['comentario_p'].toString(),
      fecha_futuro_p: map['fecha_futuro_p'].toString(),
      almacenista_p: map['almacenista_p'].toString(),
      almacenista_a: map['almacenista_a'].toString(),
      tel_alm_a: map['tel_alm_a'].toString(),
      fecha_a: map['fecha_a'].toString().isNotEmpty &&
              map['fecha_a'].toString().length > 10
          ? map['fecha_a'].toString().substring(0, 10)
          : map['fecha_a'].toString(),
      hora_a: map['hora_a'].toString(),
      ctd_a: map['ctd_a'].toString(),
      comentario_a: map['comentario_a'].toString(),
      almacenista_e: map['almacenista_e'].toString(),
      tel_alm_e: map['tel_alm_e'].toString(),
      fecha_e: map['fecha_e'].toString().isNotEmpty &&
              map['fecha_e'].toString().length > 10
          ? map['fecha_e'].toString().substring(0, 10)
          : map['fecha_e'].toString(),
      hora_e: map['hora_e'].toString(),
      ctd_e: map['ctd_e'].toString(),
      lider_contrato_e: map['lider_contrato_e'].toString(),
      cc_lider_contrato_e: map['cc_lider_contrato_e'].toString(),
      placa_cuadrilla_e: map['placa_cuadrilla_e'].toString(),
      tel_lider_e: map['tel_lider_e'].toString(),
      comentario_e: map['comentario_e'].toString(),
      soporte_d_e: map['soporte_d_e'].toString(),
      soporte_e_e: map['soporte_e_e'].toString(),
      almacenista_r: map['almacenista_r'].toString(),
      tel_alm_r: map['tel_alm_r'].toString(),
      fecha_r: map['fecha_r'].toString().isNotEmpty &&
              map['fecha_r'].toString().length > 10
          ? map['fecha_r'].toString().substring(0, 10)
          : map['fecha_r'].toString(),
      hora_r: map['hora_r'].toString(),
      ctd_r: map['ctd_r'].toString(),
      lider_contrato_r: map['lider_contrato_r'].toString(),
      placa_cuadrilla_r: map['placa_cuadrilla_r'].toString(),
      tel_lider_r: map['tel_lider_r'].toString(),
      soporte_d_r: map['soporte_d_r'].toString(),
      soporte_e_r: map['soporte_e_r'].toString(),
      ctd_total: map['ctd_total'].toString(),
      est_contrato: map['est_contrato'].toString(),
      fecha_conciliacion: map['fecha_conciliacion'].toString().isNotEmpty &&
              map['fecha_conciliacion'].toString().length > 10
          ? map['fecha_conciliacion'].toString().substring(0, 10)
          : map['fecha_conciliacion'].toString(),
      fecha_cierre: map['fecha_cierre'].toString().isNotEmpty &&
              map['fecha_cierre'].toString().length > 10
          ? map['fecha_cierre'].toString().substring(0, 10)
          : map['fecha_cierre'].toString(),
      responsable_contrato: map['responsable_contrato'].toString(),
      ctd_con: map['ctd_con'].toString(),
      comentario_op: map['comentario_op'].toString(),
      lm: map['lm'].toString(),
      soporte_d_c: map['soporte_d_c'].toString(),
      soporte_e_c: map['soporte_e_c'].toString(),
      ctd_cob: map['ctd_cob'].toString(),
      fecha_sap_au: map['fecha_sap_au'].toString().isNotEmpty &&
              map['fecha_sap_au'].toString().length > 10
          ? map['fecha_sap_au'].toString().substring(0, 10)
          : map['fecha_sap_au'].toString(),
      est_sap_au: map['est_sap_au'].toString(),
      sap_au: map['sap_au'].toString(),
      ctd_au: map['ctd_au'].toString(),
      fecha_sap_ma: map['fecha_sap_ma'].toString().isNotEmpty &&
              map['fecha_sap_ma'].toString().length > 10
          ? map['fecha_sap_ma'].toString().substring(0, 10)
          : map['fecha_sap_ma'].toString(),
      est_sap_ma: map['est_sap_ma'].toString(),
      sap_ma: map['sap_ma'].toString(),
      ctd_ma: map['ctd_ma'].toString(),
      soporte_ma: map['soporte_ma'].toString(),
      est_sap: map['est_sap'].toString(),
      sap: map['sap'].toString(),
      ctd_sap: map['ctd_sap'].toString(),
      fecha_sap: map['fecha_sap'].toString().isNotEmpty &&
              map['fecha_sap'].toString().length > 10
          ? map['fecha_sap'].toString().substring(0, 10)
          : map['fecha_sap'].toString(),
      ctd_dif: map['ctd_dif'].toString(),
      est_oficial: map['almacenista_r'].toString().isNotEmpty &&
              map['almacenista_r'].toString().contains('anuló')
          ? 'anulado'
          : map['est_oficial'].toString(),
      est_oficial_fecha: map['est_oficial_fecha'].toString().isNotEmpty &&
              map['est_oficial_fecha'].toString().length > 10
          ? map['est_oficial_fecha'].toString().substring(0, 10) 
          : map['est_oficial_fecha'].toString(),
      est_oficial_pers: map['est_oficial_pers'].toString(),
    );
  }

  factory ResgistroSingle.zero() {
    return ResgistroSingle(
      pedido: '',
      est_s: '',
      fecha_s: '',
      solicitante: '',
      tel_solicitante: '',
      contrato: '',
      nombre_pdi: '',
      pdi: '',
      proceso: '',
      proyecto: '',
      ingeniero_enel: '',
      unidad: '',
      lcl: '',
      odm: '',
      grafo: '',
      pdl: '',
      nodo: '',
      localidad_municipio: '',
      circuito: '',
      subestacion_cabecera: '',
      fecha_peticion_s: '',
      comentario_s: '',
      soporte_d_s: '',
      soporte_e_s: '',
      item: '',
      e4e: '',
      descripcion: '',
      um: '',
      ctd_s: '',
      aportacion: '',
      fecha_p: '',
      estado_p: '',
      comentario_p: '',
      fecha_futuro_p: '',
      almacenista_p: '',
      almacenista_a: '',
      tel_alm_a: '',
      fecha_a: '',
      hora_a: '',
      ctd_a: '',
      comentario_a: '',
      almacenista_e: '',
      tel_alm_e: '',
      fecha_e: '',
      hora_e: '',
      ctd_e: '',
      lider_contrato_e: '',
      cc_lider_contrato_e: '',
      placa_cuadrilla_e: '',
      tel_lider_e: '',
      comentario_e: '',
      soporte_d_e: '',
      soporte_e_e: '',
      almacenista_r: '',
      tel_alm_r: '',
      fecha_r: '',
      hora_r: '',
      ctd_r: '',
      lider_contrato_r: '',
      placa_cuadrilla_r: '',
      tel_lider_r: '',
      soporte_d_r: '',
      soporte_e_r: '',
      ctd_total: '',
      est_contrato: '',
      fecha_conciliacion: '',
      fecha_cierre: '',
      responsable_contrato: '',
      ctd_con: '',
      comentario_op: '',
      lm: '',
      soporte_d_c: '',
      soporte_e_c: '',
      ctd_cob: '',
      fecha_sap_au: '',
      est_sap_au: '',
      sap_au: '',
      ctd_au: '',
      fecha_sap_ma: '',
      est_sap_ma: '',
      sap_ma: '',
      ctd_ma: '',
      soporte_ma: '',
      est_sap: '',
      sap: '',
      ctd_sap: '',
      fecha_sap: '',
      ctd_dif: '',
      est_oficial: '',
      est_oficial_fecha: '',
      est_oficial_pers: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResgistroSingle.fromJson(String source) =>
      ResgistroSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResgistroSingle(pedido: $pedido, est_s: $est_s, fecha_s: $fecha_s, solicitante: $solicitante, tel_solicitante: $tel_solicitante, contrato: $contrato, nombre_pdi: $nombre_pdi, pdi: $pdi, proceso: $proceso, proyecto: $proyecto, ingeniero_enel: $ingeniero_enel, unidad: $unidad, lcl: $lcl, odm: $odm, grafo: $grafo, pdl: $pdl, nodo: $nodo, localidad_municipio: $localidad_municipio, circuito: $circuito, subestacion_cabecera: $subestacion_cabecera, fecha_peticion_s: $fecha_peticion_s, comentario_s: $comentario_s, soporte_d_s: $soporte_d_s, soporte_e_s: $soporte_e_s, item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd_s: $ctd_s, aportacion: $aportacion, fecha_p: $fecha_p, estado_p: $estado_p, comentario_p: $comentario_p, fecha_futuro_p: $fecha_futuro_p, almacenista_p: $almacenista_p, almacenista_a: $almacenista_a, tel_alm_a: $tel_alm_a, fecha_a: $fecha_a, hora_a: $hora_a, ctd_a: $ctd_a, comentario_a: $comentario_a, almacenista_e: $almacenista_e, tel_alm_e: $tel_alm_e, fecha_e: $fecha_e, hora_e: $hora_e, ctd_e: $ctd_e, lider_contrato_e: $lider_contrato_e, cc_lider_contrato_e: $cc_lider_contrato_e, placa_cuadrilla_e: $placa_cuadrilla_e, tel_lider_e: $tel_lider_e, comentario_e: $comentario_e, soporte_d_e: $soporte_d_e, soporte_e_e: $soporte_e_e, almacenista_r: $almacenista_r, tel_alm_r: $tel_alm_r, fecha_r: $fecha_r, hora_r: $hora_r, ctd_r: $ctd_r, lider_contrato_r: $lider_contrato_r, placa_cuadrilla_r: $placa_cuadrilla_r, tel_lider_r: $tel_lider_r, soporte_d_r: $soporte_d_r, soporte_e_r: $soporte_e_r, ctd_total: $ctd_total, est_contrato: $est_contrato, fecha_conciliacion: $fecha_conciliacion, fecha_cierre: $fecha_cierre, responsable_contrato: $responsable_contrato, ctd_con: $ctd_con, comentario_op: $comentario_op, lm: $lm, soporte_d_c: $soporte_d_c, soporte_e_c: $soporte_e_c, ctd_cob: $ctd_cob, fecha_sap_au: $fecha_sap_au, est_sap_au: $est_sap_au, sap_au: $sap_au, ctd_au: $ctd_au, fecha_sap_ma: $fecha_sap_ma, est_sap_ma: $est_sap_ma, sap_ma: $sap_ma, ctd_ma: $ctd_ma, soporte_ma: $soporte_ma, est_sap: $est_sap, sap: $sap, ctd_sap: $ctd_sap, fecha_sap: $fecha_sap, ctd_dif: $ctd_dif, est_oficial: $est_oficial, est_oficial_fecha: $est_oficial_fecha, est_oficial_pers: $est_oficial_pers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResgistroSingle &&
        other.pedido == pedido &&
        other.est_s == est_s &&
        other.fecha_s == fecha_s &&
        other.solicitante == solicitante &&
        other.tel_solicitante == tel_solicitante &&
        other.contrato == contrato &&
        other.nombre_pdi == nombre_pdi &&
        other.pdi == pdi &&
        other.proceso == proceso &&
        other.proyecto == proyecto &&
        other.ingeniero_enel == ingeniero_enel &&
        other.unidad == unidad &&
        other.lcl == lcl &&
        other.odm == odm &&
        other.grafo == grafo &&
        other.pdl == pdl &&
        other.nodo == nodo &&
        other.localidad_municipio == localidad_municipio &&
        other.circuito == circuito &&
        other.subestacion_cabecera == subestacion_cabecera &&
        other.fecha_peticion_s == fecha_peticion_s &&
        other.comentario_s == comentario_s &&
        other.soporte_d_s == soporte_d_s &&
        other.soporte_e_s == soporte_e_s &&
        other.item == item &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.um == um &&
        other.ctd_s == ctd_s &&
        other.aportacion == aportacion &&
        other.fecha_p == fecha_p &&
        other.estado_p == estado_p &&
        other.comentario_p == comentario_p &&
        other.fecha_futuro_p == fecha_futuro_p &&
        other.almacenista_p == almacenista_p &&
        other.almacenista_a == almacenista_a &&
        other.tel_alm_a == tel_alm_a &&
        other.fecha_a == fecha_a &&
        other.hora_a == hora_a &&
        other.ctd_a == ctd_a &&
        other.comentario_a == comentario_a &&
        other.almacenista_e == almacenista_e &&
        other.tel_alm_e == tel_alm_e &&
        other.fecha_e == fecha_e &&
        other.hora_e == hora_e &&
        other.ctd_e == ctd_e &&
        other.lider_contrato_e == lider_contrato_e &&
        other.cc_lider_contrato_e == cc_lider_contrato_e &&
        other.placa_cuadrilla_e == placa_cuadrilla_e &&
        other.tel_lider_e == tel_lider_e &&
        other.comentario_e == comentario_e &&
        other.soporte_d_e == soporte_d_e &&
        other.soporte_e_e == soporte_e_e &&
        other.almacenista_r == almacenista_r &&
        other.tel_alm_r == tel_alm_r &&
        other.fecha_r == fecha_r &&
        other.hora_r == hora_r &&
        other.ctd_r == ctd_r &&
        other.lider_contrato_r == lider_contrato_r &&
        other.placa_cuadrilla_r == placa_cuadrilla_r &&
        other.tel_lider_r == tel_lider_r &&
        other.soporte_d_r == soporte_d_r &&
        other.soporte_e_r == soporte_e_r &&
        other.ctd_total == ctd_total &&
        other.est_contrato == est_contrato &&
        other.fecha_conciliacion == fecha_conciliacion &&
        other.fecha_cierre == fecha_cierre &&
        other.responsable_contrato == responsable_contrato &&
        other.ctd_con == ctd_con &&
        other.comentario_op == comentario_op &&
        other.lm == lm &&
        other.soporte_d_c == soporte_d_c &&
        other.soporte_e_c == soporte_e_c &&
        other.ctd_cob == ctd_cob &&
        other.fecha_sap_au == fecha_sap_au &&
        other.est_sap_au == est_sap_au &&
        other.sap_au == sap_au &&
        other.ctd_au == ctd_au &&
        other.fecha_sap_ma == fecha_sap_ma &&
        other.est_sap_ma == est_sap_ma &&
        other.sap_ma == sap_ma &&
        other.ctd_ma == ctd_ma &&
        other.soporte_ma == soporte_ma &&
        other.est_sap == est_sap &&
        other.sap == sap &&
        other.ctd_sap == ctd_sap &&
        other.fecha_sap == fecha_sap &&
        other.ctd_dif == ctd_dif &&
        other.est_oficial == est_oficial &&
        other.est_oficial_fecha == est_oficial_fecha &&
        other.est_oficial_pers == est_oficial_pers;
  }

  @override
  int get hashCode {
    return pedido.hashCode ^
        est_s.hashCode ^
        fecha_s.hashCode ^
        solicitante.hashCode ^
        tel_solicitante.hashCode ^
        contrato.hashCode ^
        nombre_pdi.hashCode ^
        pdi.hashCode ^
        proceso.hashCode ^
        proyecto.hashCode ^
        ingeniero_enel.hashCode ^
        unidad.hashCode ^
        lcl.hashCode ^
        odm.hashCode ^
        grafo.hashCode ^
        pdl.hashCode ^
        nodo.hashCode ^
        localidad_municipio.hashCode ^
        circuito.hashCode ^
        subestacion_cabecera.hashCode ^
        fecha_peticion_s.hashCode ^
        comentario_s.hashCode ^
        soporte_d_s.hashCode ^
        soporte_e_s.hashCode ^
        item.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        um.hashCode ^
        ctd_s.hashCode ^
        aportacion.hashCode ^
        fecha_p.hashCode ^
        estado_p.hashCode ^
        comentario_p.hashCode ^
        fecha_futuro_p.hashCode ^
        almacenista_p.hashCode ^
        almacenista_a.hashCode ^
        tel_alm_a.hashCode ^
        fecha_a.hashCode ^
        hora_a.hashCode ^
        ctd_a.hashCode ^
        comentario_a.hashCode ^
        almacenista_e.hashCode ^
        tel_alm_e.hashCode ^
        fecha_e.hashCode ^
        hora_e.hashCode ^
        ctd_e.hashCode ^
        lider_contrato_e.hashCode ^
        cc_lider_contrato_e.hashCode ^
        placa_cuadrilla_e.hashCode ^
        tel_lider_e.hashCode ^
        comentario_e.hashCode ^
        soporte_d_e.hashCode ^
        soporte_e_e.hashCode ^
        almacenista_r.hashCode ^
        tel_alm_r.hashCode ^
        fecha_r.hashCode ^
        hora_r.hashCode ^
        ctd_r.hashCode ^
        lider_contrato_r.hashCode ^
        placa_cuadrilla_r.hashCode ^
        tel_lider_r.hashCode ^
        soporte_d_r.hashCode ^
        soporte_e_r.hashCode ^
        ctd_total.hashCode ^
        est_contrato.hashCode ^
        fecha_conciliacion.hashCode ^
        fecha_cierre.hashCode ^
        responsable_contrato.hashCode ^
        ctd_con.hashCode ^
        comentario_op.hashCode ^
        lm.hashCode ^
        soporte_d_c.hashCode ^
        soporte_e_c.hashCode ^
        ctd_cob.hashCode ^
        fecha_sap_au.hashCode ^
        est_sap_au.hashCode ^
        sap_au.hashCode ^
        ctd_au.hashCode ^
        fecha_sap_ma.hashCode ^
        est_sap_ma.hashCode ^
        sap_ma.hashCode ^
        ctd_ma.hashCode ^
        soporte_ma.hashCode ^
        est_sap.hashCode ^
        sap.hashCode ^
        ctd_sap.hashCode ^
        fecha_sap.hashCode ^
        ctd_dif.hashCode ^
        est_oficial.hashCode ^
        est_oficial_fecha.hashCode ^
        est_oficial_pers.hashCode;
  }

  List<String> toList() {
    return [
      pedido,
      est_s,
      fecha_s,
      solicitante,
      tel_solicitante,
      contrato,
      nombre_pdi,
      pdi,
      proceso,
      proyecto,
      ingeniero_enel,
      unidad,
      lcl,
      odm,
      grafo,
      pdl,
      nodo,
      localidad_municipio,
      circuito,
      subestacion_cabecera,
      fecha_peticion_s,
      comentario_s,
      soporte_d_s,
      soporte_e_s,
      item,
      e4e,
      descripcion,
      um,
      ctd_s,
      aportacion,
      fecha_p,
      estado_p,
      comentario_p,
      fecha_futuro_p,
      almacenista_p,
      almacenista_a,
      tel_alm_a,
      fecha_a,
      hora_a,
      ctd_a,
      comentario_a,
      almacenista_e,
      tel_alm_e,
      fecha_e,
      hora_e,
      ctd_e,
      lider_contrato_e,
      cc_lider_contrato_e,
      placa_cuadrilla_e,
      tel_lider_e,
      comentario_e,
      soporte_d_e,
      soporte_e_e,
      almacenista_r,
      tel_alm_r,
      fecha_r,
      hora_r,
      ctd_r,
      lider_contrato_r,
      placa_cuadrilla_r,
      tel_lider_r,
      soporte_d_r,
      soporte_e_r,
      ctd_total,
      est_contrato,
      fecha_conciliacion,
      fecha_cierre,
      responsable_contrato,
      ctd_con,
      comentario_op,
      lm,
      soporte_d_c,
      soporte_e_c,
      ctd_cob,
      fecha_sap_au,
      est_sap_au,
      sap_au,
      ctd_au,
      fecha_sap_ma,
      est_sap_ma,
      sap_ma,
      ctd_ma,
      soporte_ma,
      est_sap,
      sap,
      ctd_sap,
      fecha_sap,
      ctd_dif,
      est_oficial,
      est_oficial_fecha,
      est_oficial_pers,
    ];
  }

  List<String> toListSIPWEB() {
    return [
      pedido,
      pdi,
      nombre_pdi,
      proceso,
      circuito,
      proyecto,
      nodo,
      pdl,
      lcl,
      '',
      lider_contrato_e,
      cc_lider_contrato_e,
      fecha_e,
      e4e,
      descripcion,
      aportacion,
      '',
      um,
      ctd_s,
      ctd_e,
      ctd_total,
      ctd_r,
      fecha_r,
      odm,
      '',
      '',
      '',
      '',
      '',
      '',
      est_oficial_fecha,
      est_oficial_pers,
      localidad_municipio,
      '',
      '',
      '',
      '',
      '',
    ];
  }
}
