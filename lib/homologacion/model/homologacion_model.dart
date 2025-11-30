import '../../resources/titulo.dart';

class Homologacion {
  List<HomologacionSingle> homologacionList = [];
  List<HomologacionSingle> homologacionListSearch = [];

  List<ToCelda> titles = [
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'DESCRIPCIÓN NUEVO', flex: 6),
    ToCelda(valor: 'UM', flex: 2),
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'DESCRIPCIÓN A REVISAR', flex: 2), 
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'DESCRIPCIÓN CHATARRA', flex: 6),
    ToCelda(valor: 'UM', flex: 2),
    ToCelda(valor: 'GRID', flex: 2),
  ];
}

class HomologacionSingle {
  String e4e1;
  String descripcion1;
  String um1;
  String e4e2;
  String descripcion2;
  String e4e3;
  String um3;
  String descripcion3;
  String grid;

  HomologacionSingle({
    required this.e4e1,
    required this.descripcion1,
    required this.um1,
    required this.e4e2,
    required this.descripcion2,
    required this.e4e3,
    required this.um3,
    required this.descripcion3,
    required this.grid,
  });

  List<String> toList() {
    return [
      e4e1,
      descripcion1,
      um1,
      e4e2, 
      descripcion2,
      e4e3,
      descripcion3,
      um3,
      grid,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'e4e1': e4e1,
      'descripcion1': descripcion1,
      'um1': um1,
      'e4e2': e4e2,
      'descripcion2': descripcion2,
      'e4e3': e4e3,
      'um3': um3,
      'descripcion3': descripcion3,
      'grid': grid,
    };
  }

  factory HomologacionSingle.fromMap(Map<String, dynamic> map) {
    return HomologacionSingle(
      e4e1: map['e4e1'].toString(),
      descripcion1: map['descripcion1'].toString(),
      um1: map['um1'].toString(),
      e4e2: map['e4e2'].toString(),
      descripcion2: map['descripcion2'].toString(),
      e4e3: map['e4e3'].toString(),
      um3: map['um3'].toString(),
      descripcion3: map['descripcion3'].toString(),
      grid: map['grid'].toString(),
    );
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: e4e1, flex: 2),
    ToCelda(valor: descripcion1, flex: 6),
    ToCelda(valor: um1, flex: 2), 
    ToCelda(valor: e4e2, flex: 2),
    ToCelda(valor: descripcion2, flex: 2),
    ToCelda(valor: e4e3, flex: 2),
    ToCelda(valor: descripcion3, flex: 6),
    ToCelda(valor: um3, flex: 2),
    ToCelda(valor: grid, flex: 2),
  ];
}
