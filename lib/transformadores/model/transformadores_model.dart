import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:http/http.dart' as http;
import '../../resources/titulo.dart';

class Transformadores {
  List<TransformadoresSingle> transformadoresList = [];
  List<TransformadoresSingle> transformadoresListSearch = [];
  int view = 70;

  List<ToCelda> titles = [
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'DESCRIPCIÓN', flex: 8), 
    ToCelda(valor: 'UM', flex: 2),
    ToCelda(valor: 'MAGNETRÓN', flex: 2),
    ToCelda(valor: 'RYMEL', flex: 2),
    ToCelda(valor: 'SIEMENS', flex: 2),
    ToCelda(valor: 'TOSHIBA', flex: 2),
    ToCelda(valor: 'GETRA', flex: 2),
    ToCelda(valor: 'OTROS', flex: 2),
  ];

  obtener() async {
    var dataSend = {
      'dataReq': {'hoja': 'transformadores'},
      'fname': "getMainData"
    };
    final response = await http.post(
      Api.sam,
      body: jsonEncode(dataSend),
    );
    var dataAsListMap = jsonDecode(response.body);
    for (var item in dataAsListMap) {
      transformadoresList.add(TransformadoresSingle.fromMap(item));
    }
    transformadoresListSearch = [...transformadoresList];
  }
}

class TransformadoresSingle {
  String e4e;
  String descripcion;
  String um;
  String magnetron;
  String rymel;
  String siemens;
  String toshiba;
  String getra;
  String otros;
  
  TransformadoresSingle({
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.magnetron,
    required this.rymel,
    required this.siemens,
    required this.toshiba,
    required this.getra,
    required this.otros,
  });

  List<String> toList() {
    return [
      e4e, descripcion, um, magnetron, rymel,
      siemens, toshiba, getra, otros
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'magnetron': magnetron,
      'rymel': rymel,
      'siemens': siemens,
      'toshiba': toshiba,
      'getra': getra,
      'otros': otros,
    };
  }

  factory TransformadoresSingle.fromMap(Map<String, dynamic> map) {
    return TransformadoresSingle(
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      magnetron: map['magnetron'].toString(),
      rymel: map['rymel'].toString(),
      siemens: map['siemens'].toString(),
      toshiba: map['toshiba'].toString(),
      getra: map['getra'].toString(),
      otros: map['otros'].toString(),
    );
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e, flex: 2),
    ToCelda(valor: descripcion, flex: 8),
    ToCelda(valor: um, flex: 2),
    ToCelda(valor: magnetron, flex: 2),
    ToCelda(valor: rymel, flex: 2),
    ToCelda(valor: siemens, flex: 2),
    ToCelda(valor: toshiba, flex: 2),
    ToCelda(valor: getra, flex: 2),
    ToCelda(valor: otros, flex: 2),
  ];
}
