import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:v_al_sam_v02/user/user_model.dart';

class Mb52B {
  List<Mb52BSingle> mb52BList = [];
  List<Mb52BSingle> mb52BListSearch = [];
  int view = 100;
  int totalValor = 0;
  Map itemsAndFlex = {
    'material': 1,
    'descripcion': 6,
    'ctd': 2,
    'umb': 1,
    'valor': 2,
  };
  Mb52B();

  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  buscar(String busqueda) {
    mb52BListSearch = [...mb52BList];
    mb52BListSearch = mb52BList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  Future<List<Mb52BSingle>> obtener(User user) async {
    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'tx': 'MB52'},
      'fname': "getSAP"
    };

    final response = await http.post(
      Api.sam,
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"] ?? ''));
      dataAsListMap = jsonDecode(response2.body)['dataObject'];
    } else {
      dataAsListMap = jsonDecode(response.body)['dataObject'];
    }
    // print('FROM MB52 dataAsListMap: $dataAsListMap');
    for (var item in dataAsListMap) {
      // print('FROM MB52 item: $item');
      if (item['material'] != "") {
        mb52BList.add(Mb52BSingle.fromMap(item));
      }
    }
    mb52BListSearch = [...mb52BList];
    // print('FROM MB52 mb52BList: $mb52BListSearch');
    total();
    return mb52BList;
  }

  int total() {
    for (var item in mb52BList) {
      // print('FROM MB52 item: $item');
      totalValor += double.parse(item.valor).toInt();
    }
    return totalValor;
  }

  @override
  String toString() => 'Mb52B(totalValor $totalValor ,mb52BList: $mb52BList)';

  Map<String, dynamic> toMap() {
    return {
      'mb52BList': mb52BList.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mb52B && listEquals(other.mb52BList, mb52BList);
  }

  @override
  int get hashCode => mb52BList.hashCode;

}

class Mb52BSingle {
  String material;
  String descripcion;
  String umb;
  String ctd;
  String valor;
  String wbe;
  String parte_proyecto;
  String status;
  String proyecto;
  String actualizado;
  Mb52BSingle({
    required this.material,
    required this.descripcion,
    required this.umb,
    required this.ctd,
    required this.valor,
    required this.wbe,
    required this.parte_proyecto,
    required this.status,
    required this.proyecto,
    required this.actualizado,
  });

  Mb52BSingle copyWith({
    String? material,
    String? descripcion,
    String? umb,
    String? ctd,
    String? valor,
    String? wbe,
    String? parte_proyecto,
    String? status,
    String? proyecto,
    String? actualizado,
  }) {
    return Mb52BSingle(
      material: material ?? this.material,
      descripcion: descripcion ?? this.descripcion,
      umb: umb ?? this.umb,
      ctd: ctd ?? this.ctd,
      valor: valor ?? this.valor,
      wbe: wbe ?? this.wbe,
      parte_proyecto: parte_proyecto ?? this.parte_proyecto,
      status: status ?? this.status,
      proyecto: proyecto ?? this.proyecto,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'descripcion': descripcion,
      'umb': umb,
      'ctd': ctd,
      'valor': valor,
      'wbe': wbe,
      'parte_proyecto': parte_proyecto,
      'status': status,
      'proyecto': proyecto,
      'actualizado': actualizado,
    };
  }

  factory Mb52BSingle.fromMap(Map<String, dynamic> map) {
    return Mb52BSingle(
      material: map['material'].toString(),
      descripcion: map['descripcion'].toString(),
      umb: map['umb'].toString(),
      ctd: num.parse(map['ctd'].toString()).ceil().toString(),
      valor: num.parse(map['valor'].toString()).ceil().toString(),
      wbe: map['wbe'].toString(),
      parte_proyecto: map['parte_proyecto'].toString(),
      status: map['status'].toString(),
      proyecto: map['proyecto'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }

  factory Mb52BSingle.fromInit() {
    return Mb52BSingle(
      material: '',
      descripcion: 'No está en MB52',
      umb: '',
      ctd: '0',
      valor: '',
      wbe: '',
      parte_proyecto: '',
      status: '',
      proyecto: '',
      actualizado: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Mb52BSingle.fromJson(String source) =>
      Mb52BSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mb52BSingle(material: $material, descripcion: $descripcion, umb: $umb, ctd: $ctd, valor: $valor, wbe: $wbe, parte_proyecto: $parte_proyecto, status: $status, proyecto: $proyecto, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mb52BSingle &&
        other.material == material &&
        other.descripcion == descripcion &&
        other.umb == umb &&
        other.ctd == ctd &&
        other.valor == valor &&
        other.wbe == wbe &&
        other.parte_proyecto == parte_proyecto &&
        other.status == status &&
        other.proyecto == proyecto &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return material.hashCode ^
        descripcion.hashCode ^
        umb.hashCode ^
        ctd.hashCode ^
        valor.hashCode ^
        wbe.hashCode ^
        parte_proyecto.hashCode ^
        status.hashCode ^
        proyecto.hashCode ^
        actualizado.hashCode;
  }

  List<String> toList() {
    return [
      material,
      descripcion,
      umb,
      ctd,
      valor,
      wbe,
      parte_proyecto,
      status,
      proyecto,
      actualizado,
    ];
  }
}
