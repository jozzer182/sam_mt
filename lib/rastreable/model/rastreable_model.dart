import 'dart:convert';
import '../../resources/titulo.dart';

class Rastreable {
  List<RastreableSingle> rastreableList = [];
  List<RastreableSingle> rastreableListSearch = [];
  int view = 70;

  List<ToCelda> titles = [
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'SIE', flex: 2),
    ToCelda(valor: 'DESCRIPCIÓN', flex: 6),
    ToCelda(valor: 'RASTREABLE', flex: 2)
  ];
}

class RastreableSingle {
  String e4e;
  String sie;
  String descripcion;
  String rastreable;

  RastreableSingle({
    required this.e4e, 
    required this.sie,
    required this.descripcion,
    required this.rastreable,
  });

  List<String> toList() {
    return [e4e, sie, descripcion, rastreable];
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e': e4e,
      'sie': sie,
      'descripcion': descripcion,
      'rastreable': rastreable,
    };
  }

  factory RastreableSingle.fromMap(Map<String, dynamic> map) {
    return RastreableSingle(
      e4e: map['e4e'].toString(),
      sie: map['sie'].toString(),
      descripcion: map['descripcion'].toString(),
      rastreable: map['rastreable'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RastreableSingle.fromJson(String source) =>
      RastreableSingle.fromMap(json.decode(source));

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e, flex: 2),
    ToCelda(valor: sie, flex: 2),
    ToCelda(valor: descripcion, flex: 6),
    ToCelda(valor: rastreable, flex: 2)
  ];
}
