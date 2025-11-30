import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../../resources/titulo.dart';

class Mb51B {
  List<Mb51BSingle> mb51BList = [];
  List<Mb51BSingle> mb51BListSearch = [];
  int totalValor = 0;
  int view = 100;
  int view2 = 20;
  Map itemsAndFlex = {
    'documento': 2,
    'cmv': 1,
    'material': 1,
    'descripcion': 6,
    'ctd': 1,
    'umb': 1,
    'fecha': 2,
    'texto_cab': 3,
    'usuario': 4,
    'wbe': 2,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  List<ToCelda> titles = [
    ToCelda(valor: 'Documento', flex: 2),
    ToCelda(valor: 'Cmv', flex: 1),
    ToCelda(valor: 'Material', flex: 1),
    ToCelda(valor: 'Descripción', flex: 6),
    ToCelda(valor: 'Ctd', flex: 1),
    ToCelda(valor: 'Umb', flex: 1),
    ToCelda(valor: 'Fecha', flex: 2),
    ToCelda(valor: 'Texto Cab', flex: 3),
    ToCelda(valor: 'Usuario', flex: 4),
    ToCelda(valor: 'Wbe', flex: 2),
    ToCelda(valor: 'Ticket\ntdc', flex: 2),
  ];

  Map itemsAndFlex2 = {
    'documento': [2, 'doc'],
    'cmv': [1, 'cm'],
    'texto_cab': [3, 'texto'],
    'wbe': [2, 'Lcl'],
    'material': [2, 'e4e'],
    'descripcion': [6, 'descripción'],
    'ctd': [1, 'ctd'],
    'umb': [1, 'u'],
    'fecha': [2, 'fecha'],
    'usuario': [4, 'usuario'],
  };
  get keys2 {
    return itemsAndFlex2.keys.toList();
  }

  get listaTitulo2 {
    return [
      for (var key in keys2)
        {'texto': itemsAndFlex2[key][1], 'flex': itemsAndFlex2[key][0]},
    ];
  }

  buscar(String busqueda) {
    mb51BListSearch = [...mb51BList];
    mb51BListSearch =
        mb51BList
            .where(
              (element) => element.toList().any(
                (item) => item.toString().toLowerCase().contains(
                  busqueda.toLowerCase(),
                ),
              ),
            )
            .toList();
  }

  Future<List<Mb51BSingle>> obtener(User user) async {
    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'tx': 'MB51'},
      'fname': "getSAP",
    };

    final response = await http.post(
      Uri.parse(
        Api.samString,
      ),
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await http.get(
        Uri.parse(response.headers["location"] ?? ''),
      );
      dataAsListMap = jsonDecode(response2.body)['dataObject'];
    } else {
      dataAsListMap = jsonDecode(response.body)['dataObject'];
    }
    for (var item in dataAsListMap) {
      mb51BList.add(Mb51BSingle.fromMap(item));
    }
    // mb51BList.sort((a, b) => int.parse(a.documento).compareTo(
    //     int.parse(b.documento) +
    //         int.parse(a.material).compareTo(int.parse(b.material))));
    mb51BList.sort((a, b) {
      // late int fechaA;
      // late int fechaB;
      // try{
      //   fechaA = DateTime.parse(a.fecha).microsecondsSinceEpoch;
      //   fechaB = DateTime.parse(b.fecha).microsecondsSinceEpoch;
      // }catch(e){
      //   List<String> partsA
      // }
      // print('fechaA: ${a.fecha}, fechaB: ${b.fecha} ');
      return DateTime.parse(a.fecha).microsecondsSinceEpoch.compareTo(
        DateTime.parse(b.fecha).microsecondsSinceEpoch +
            int.parse(a.material).compareTo(int.parse(b.material)),
      );
    });
    mb51BList = mb51BList.reversed.toList();
    mb51BListSearch = [...mb51BList];
    return mb51BList;
  }

  // List<Map<String, dynamic>> get porLCL {
  //   var dataAsListMapMb51 =
  //       mb51BList
  //           .where((e) => e.wbe.isNotEmpty)
  //           .map(
  //             (e) => {
  //               ...e.toMap(),
  //               ...{
  //                 'ctd': int.parse(e.ctd),
  //                 'lcl': e.wbe,
  //                 'e4e': e.material,
  //                 'um': e.umb,
  //               },
  //             },
  //           )
  //           .toList();
  //   //agrupar y sumar por e4e
  //   var keysToSelectMb51 = ['lcl', 'e4e', 'descripcion', 'um'];
  //   var keysToSumMb51 = ['ctd'];
  //   var registrosMb51 = groupByList(dataAsListMapMb51, keysToSelectMb51, keysToSumMb51);
  //   registrosMb51.sort(
  //     (a, b) => int.parse(
  //       '${a['lcl']}${a['e4e']}',
  //     ).compareTo(int.parse('${b['lcl']}${b['e4e']}')),
  //   );
  //   return registrosMb51;
  // }

  List<Map<String, dynamic>> get porFuncional {
    var dataAsListMap2 =
        mb51BList
            .where((e) => e.wbe.isNotEmpty)
            .map(
              (e) => {
                ...e.toMap(),
                ...{
                  'ctd': int.parse(e.ctd),
                  'lcl': e.wbe,
                  'e4e': e.material,
                  'um': e.umb,
                  'ingeniero_enel': e.usuario,
                },
              },
            )
            .toList();
    //agrupar y sumar por e4e
    var keysToSelect = ['ingeniero_enel', 'e4e', 'descripcion', 'um'];
    var keysToSum = ['ctd'];
    var registros = groupByList(dataAsListMap2, keysToSelect, keysToSum);
    registros.sort(
      (a, b) =>
          '${a['usuario']}${a['e4e']}'.compareTo('${b['usuario']}${b['e4e']}'),
    );
    return registros;
  }

  //Agrupar y summar los registros ingresados
  List<Map<String, dynamic>> groupByList(
    List<Map<String, dynamic>> data,
    List<String> keysToSelect,
    List<String> keysToSum,
  ) {
    List<Map<String, dynamic>> dataKeyAsJson =
        data.map((e) {
          e['asJson'] = {};
          for (var key in keysToSelect) {
            e['asJson'].addAll({key: e[key]});
            e.remove(key);
          }
          e['asJson'] = jsonEncode(e['asJson']);
          return e;
        }).toList();
    // print('dataKeyAsJson = $dataKeyAsJson');

    Map<dynamic, Map<String, int>> groupAsMap = groupBy(
      dataKeyAsJson,
      (Map e) => e['asJson'],
    ).map(
      (key, value) => MapEntry(key, {
        for (var keySum in keysToSum)
          keySum: value.fold<int>(0, (p, a) => p + (a[keySum] as int)),
      }),
    );

    List<Map<String, dynamic>> result =
        groupAsMap.entries.map((e) {
          Map<String, dynamic> newMap = jsonDecode(e.key);
          return {...newMap, ...e.value};
        }).toList();
    // print('result = $result');

    return result;
  }
}

class Mb51BSingle {
  String documento;
  String cmv;
  String material;
  String descripcion;
  String lote;
  String lote_r;
  String ctd;
  String umb;
  String valor;
  String fecha;
  String texto_cab;
  String texto;
  String texto_vale;
  String usuario;
  String grupo;
  String referencia;
  String wbe;
  String proyecto;
  String orden;
  String actualizado;
  Mb51BSingle({
    required this.documento,
    required this.cmv,
    required this.material,
    required this.descripcion,
    required this.lote,
    required this.lote_r,
    required this.ctd,
    required this.umb,
    required this.valor,
    required this.fecha,
    required this.texto_cab,
    required this.texto,
    required this.texto_vale,
    required this.usuario,
    required this.grupo,
    required this.referencia,
    required this.wbe,
    required this.proyecto,
    required this.orden,
    required this.actualizado,
  });

  Map<String, dynamic> toMap() {
    return {
      'documento': documento,
      'cmv': cmv,
      'material': material,
      'descripcion': descripcion,
      'lote': lote,
      'lote_r': lote_r,
      'ctd': ctd,
      'umb': umb,
      'valor': valor,
      'fecha': fecha,
      'texto_cab': texto_cab,
      'texto': texto,
      'texto_vale': texto_vale,
      'usuario': usuario,
      'grupo': grupo,
      'referencia': referencia,
      'wbe': wbe,
      'proyecto': proyecto,
      'orden': orden,
      'actualizado': actualizado,
    };
  }

  factory Mb51BSingle.fromMap(Map<String, dynamic> map) {
    String fecha = map['fecha'];
    if (fecha.length > 10) fecha = fecha.substring(0, 10);
    if (fecha.contains('.')) {
      List<String> parts = fecha.split('.');
      fecha =
          '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    }

    // print('fecha: $fecha - documento: ${map['documento']}');

    Mb51BSingle data = Mb51BSingle(
      documento: map['documento'].toString().replaceAll(',', '.'),
      cmv: map['cmv'].toString().replaceAll(',', '.'),
      material: map['material'].toString().replaceAll(',', '.'),
      descripcion: map['descripcion'].toString().replaceAll(',', '.'),
      lote: map['lote'].toString().replaceAll(',', '.'),
      lote_r: map['lote_r'].toString().replaceAll(',', '.'),
      ctd: map['ctd'].toString().replaceAll(',', '.'),
      umb: map['umb'].toString().replaceAll(',', '.'),
      valor: map['valor'].toString(),
      fecha: fecha,
      texto_cab: map['texto_cab'].toString().replaceAll(',', '.'),
      texto: map['texto'].toString().replaceAll(',', '.'),
      texto_vale: map['texto_vale'].toString().replaceAll(',', '.'),
      usuario: map['usuario'].toString().replaceAll(',', '.'),
      grupo: map['grupo'].toString().replaceAll(',', '.'),
      referencia: map['referencia'].toString().replaceAll(',', '.'),
      wbe: map['wbe'].toString(),
      proyecto: map['proyecto'].toString(),
      orden: map['orden'].toString().replaceAll(',', '.'),
      actualizado:
          map['actualizado'] == null
              ? DateTime.now().toIso8601String().substring(0, 16)
              : map['actualizado'].toString().replaceAll(',', '.'),
    );

    if (!data.wbe.startsWith('63') && data.texto_cab.startsWith('63')) {
      data.wbe = data.texto_cab.substring(0, 10);
    }

    int referencia = int.tryParse(data.referencia) ?? 0;
    if (data.referencia.length == 10 &&
        referencia >= 6300000000 &&
        referencia < 6400000000) {
      data.wbe = data.referencia;
    }

    return data;
  }

  String toJson() => json.encode(toMap());

  factory Mb51BSingle.fromJson(String source) =>
      Mb51BSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mb51BSingle(documento: $documento, cmv: $cmv, material: $material, descripcion: $descripcion, lote: $lote, lote_r: $lote_r, ctd: $ctd, umb: $umb, valor: $valor, fecha: $fecha, texto_cab: $texto_cab, texto: $texto, texto_vale: $texto_vale, usuario: $usuario, grupo: $grupo, referencia: $referencia, wbe: $wbe, proyecto: $proyecto, orden: $orden)';
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is Mb51BSingle &&
  //     other.documento == documento &&
  //     other.cmv == cmv &&
  //     other.material == material &&
  //     other.descripcion == descripcion &&
  //     other.lote == lote &&
  //     other.lote_r == lote_r &&
  //     other.ctd == ctd &&
  //     other.umb == umb &&
  //     other.valor == valor &&
  //     other.fecha == fecha &&
  //     other.texto_cab == texto_cab &&
  //     other.texto == texto &&
  //     other.texto_vale == texto_vale &&
  //     other.usuario == usuario &&
  //     other.grupo == grupo &&
  //     other.referencia == referencia &&
  //     other.wbe == wbe &&
  //     other.proyecto == proyecto &&
  //     other.orden == orden;
  // }

  @override
  int get hashCode {
    return documento.hashCode ^
        cmv.hashCode ^
        material.hashCode ^
        descripcion.hashCode ^
        lote.hashCode ^
        lote_r.hashCode ^
        ctd.hashCode ^
        umb.hashCode ^
        valor.hashCode ^
        fecha.hashCode ^
        texto_cab.hashCode ^
        texto.hashCode ^
        texto_vale.hashCode ^
        usuario.hashCode ^
        grupo.hashCode ^
        referencia.hashCode ^
        wbe.hashCode ^
        proyecto.hashCode ^
        orden.hashCode;
  }

  List<String> toList() {
    return [
      documento,
      cmv,
      material,
      descripcion,
      lote,
      lote_r,
      ctd,
      umb,
      valor,
      fecha.length > 10 ? fecha.substring(0, 10) : fecha,
      texto_cab,
      texto,
      texto_vale,
      usuario,
      grupo,
      referencia,
      wbe,
      proyecto,
      orden,
      actualizado,
    ];
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: documento, flex: 2),
    ToCelda(valor: cmv, flex: 1),
    ToCelda(valor: material, flex: 1),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: ctd, flex: 1),
    ToCelda(valor: umb, flex: 1),
    ToCelda(valor: fecha, flex: 2),
    ToCelda(valor: texto_cab, flex: 3),
    ToCelda(valor: usuario, flex: 4),
    ToCelda(valor: wbe, flex: 2),
    ToCelda(valor: referencia, flex: 2),

  ];
}
