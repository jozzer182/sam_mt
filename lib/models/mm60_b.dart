import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Mm60B extends Equatable {
  List<Mm60SingleB> mm60List = [];
  Mm60B();

  Future<List<Mm60SingleB>> obtener() async {
    var dataSend = {
      'dataReq': {'pdi': 'GENERAL', 'tx': 'MM60'},
      'fname': "getSAP"
    };

    final response = await http.post(
      Api.sam,
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"].toString()));
      dataAsListMap = jsonDecode(response2.body)['dataObject'];
    } else {
      dataAsListMap = jsonDecode(response.body)['dataObject'];
    }
    for (var item in dataAsListMap) {
      mm60List.add(Mm60SingleB.fromMap(item));
    }
    return mm60List;
  }

  @override
  String toString() => 'Mm60(mm60List: $mm60List)';

  Map<String, dynamic> toMap() {
    return {
      'mm60List': mm60List.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mm60B && listEquals(other.mm60List, mm60List);
  }

  @override
  int get hashCode => mm60List.hashCode;

  @override
  List<Object> get props => [mm60List];
}

class Mm60SingleB {
  String material;
  String precio;
  String descripcion;
  String ultima_m;
  String tpmt;
  String grupo;
  String um;
  String mon;
  String actualizado;
  Mm60SingleB({
    required this.material,
    required this.precio,
    required this.descripcion,
    required this.ultima_m,
    required this.tpmt,
    required this.grupo,
    required this.um,
    required this.mon,
    required this.actualizado,
  });

  Mm60SingleB copyWith({
    String? material,
    String? precio,
    String? descripcion,
    String? ultima_m,
    String? tpmt,
    String? grupo,
    String? um,
    String? mon,
    String? actualizado,
  }) {
    return Mm60SingleB(
      material: material ?? this.material,
      precio: precio ?? this.precio,
      descripcion: descripcion ?? this.descripcion,
      ultima_m: ultima_m ?? this.ultima_m,
      tpmt: tpmt ?? this.tpmt,
      grupo: grupo ?? this.grupo,
      um: um ?? this.um,
      mon: mon ?? this.mon,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'precio': precio,
      'descripcion': descripcion,
      'ultima_m': ultima_m,
      'tpmt': tpmt,
      'grupo': grupo,
      'um': um,
      'mon': mon,
      'actualizado': actualizado,
    };
  }

  factory Mm60SingleB.fromMap(Map<String, dynamic> map) {
    return Mm60SingleB(
      material: map['material'].toString(),
      precio: map['precio'].toString(),
      descripcion: map['descripcion'].toString(),
      ultima_m: map['ultima_m'].toString(),
      tpmt: map['tpmt'].toString(),
      grupo: map['grupo'].toString(),
      um: map['um'].toString(),
      mon: map['mon'].toString(),
      actualizado: map['actualizado'].toString(),
    );
  }
  factory Mm60SingleB.fromInit() {
    return Mm60SingleB(
      material: '',
      precio: '0',
      descripcion: 'No existe en BD',
      ultima_m: '',
      tpmt: '',
      grupo: '',
      um: 'N/A',
      mon: '',
      actualizado: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Mm60SingleB.fromJson(String source) => Mm60SingleB.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mm60SingleB(material: $material, precio: $precio, descripcion: $descripcion, ultima_m: $ultima_m, tpmt: $tpmt, grupo: $grupo, um: $um, mon: $mon, actualizado: $actualizado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Mm60SingleB &&
      other.material == material &&
      other.precio == precio &&
      other.descripcion == descripcion &&
      other.ultima_m == ultima_m &&
      other.tpmt == tpmt &&
      other.grupo == grupo &&
      other.um == um &&
      other.mon == mon &&
      other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return material.hashCode ^
      precio.hashCode ^
      descripcion.hashCode ^
      ultima_m.hashCode ^
      tpmt.hashCode ^
      grupo.hashCode ^
      um.hashCode ^
      mon.hashCode ^
      actualizado.hashCode;
  }
}
