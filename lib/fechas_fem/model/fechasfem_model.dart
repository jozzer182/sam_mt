import 'dart:convert';

import '../../resources/a_entero_2.dart';
import '../../resources/titulo.dart';
import 'fechasfem_asyear_model.dart';
import 'fechasfem_enabledate.dart';
import 'fehcasfem_datebool_model.dart';

class FechasFEM {
  List<FechasFEMSingle> fechasFEMList = [];
  List<FechasFEMSingle> fechasFEMListSearch = [];
  List<FechasFEMDateBool> fechasFemDateBoolList = [];
  List<FechasFEMAsYear> fechasFEMAsYearList = [];

  int view = 70;
  Map itemsAndFlex = {
    'ano': [2, 'año'],
    'version': [1, 'V'],
    'versionfecha': [2, 'fecha versión'],
    'pedido': [2, 'pedido'],
    'fecha': [2, 'fecha pedido'],
    'estado': [2, 'estado pedido'],
    'fechadelivery': [2, 'fecha delivery'],
    'delivered': [2, 'delivered'],
  };

  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys)
        {'texto': itemsAndFlex[key][1], 'flex': itemsAndFlex[key][0]},
    ];
  }

  List<ToCelda> titles = [
    ToCelda(valor: 'Año', flex: 2),
    ToCelda(valor: 'V', flex: 1),
    ToCelda(valor: 'Fecha Versión', flex: 2),
    ToCelda(valor: 'Pedido', flex: 2),
    ToCelda(valor: 'Fecha Pedido', flex: 2),
    ToCelda(valor: 'Estado Pedido', flex: 2),
    ToCelda(valor: 'Fecha Entrega', flex: 2),
    ToCelda(valor: 'Entregado', flex: 2),
  ];

  buscar(String query) {
    fechasFEMListSearch =
        fechasFEMList
            .where(
              (element) => element.toList().any(
                (item) =>
                    item.toString().toLowerCase().contains(query.toLowerCase()),
              ),
            )
            .toList();
  }

  Map<String, EnableDate> enableDates(String ano) {
    Map<String, EnableDate> enableDates = {};
    List<String> meses = [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
    ];
    int index = fechasFEMList.indexWhere((e) => e.ano == ano);
    bool noExisteAnoEnTabla = index == -1;
    if (noExisteAnoEnTabla) {
      for (String mes in meses) {
        enableDates[mes] = EnableDate(
          mes: mes,
          versionActivaq1: true,
          versionActivaq2: true,
          pedidoActivoq1: true,
          pedidoActivoq2: true,
        );
      }
      return enableDates;
    }

    for (String mes in meses) {
      enableDates[mes] = EnableDate(
        mes: mes,
        versionActivaq1: false,
        versionActivaq2: false,
        pedidoActivoq1: false,
        pedidoActivoq2: false,
      );
    }
    List<FechasFEMSingle> anoList =
        fechasFEMList.where((e) => e.ano == ano).toList();
    for (String mes in meses) {
      List<FechasFEMSingle> mesEstado =
          anoList.where((e) => e.pedido.substring(0, 2) == mes).toList();
      if (mesEstado.length == 2) {
        enableDates[mes] = EnableDate(
          mes: mes,
          versionActivaq1: mesEstado[0].versionestado == 'true',
          versionActivaq2: mesEstado[1].versionestado == 'true',
          pedidoActivoq1: mesEstado[0].estado == 'true',
          pedidoActivoq2: mesEstado[1].estado == 'true',
        );
      } else {
        print('Error mes $mes no tiene 2 versiones ${mesEstado.length}');
        print('just2023 -1 mes $mes ${anoList[0].pedido.substring(0, 2)}');
      }
    }
    return enableDates;
  }

  Map<int, EnableDateInt> enableDatesInt(int ano) {
    Map<int, EnableDateInt> enableDates = {};
    List<int> meses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    int index = fechasFEMList.indexWhere((e) => e.ano == '$ano');
    bool noExisteAnoEnTabla = index == -1;
    if (noExisteAnoEnTabla) {
      for (int mes in meses) {
        enableDates[mes] = EnableDateInt(
          mes: mes,
          versionActivaq1: true,
          versionActivaq2: true,
          pedidoActivoq1: true,
          pedidoActivoq2: true,
          entredoQ1: false,
          entredoQ2: false,
        );
      }
      return enableDates;
    }

    for (int mes in meses) {
      enableDates[mes] = EnableDateInt(
        mes: mes,
        versionActivaq1: false,
        versionActivaq2: false,
        pedidoActivoq1: false,
        pedidoActivoq2: false,
        entredoQ1: false,
        entredoQ2: false,
      );
    }
    List<FechasFEMSingle> anoList =
        fechasFEMList.where((e) => e.ano == '$ano').toList();
    for (int mes in meses) {
      List<FechasFEMSingle> mesEstado =
          anoList
              .where((e) => aEntero(e.pedido.substring(0, 2)) == mes)
              .toList();
      if (mesEstado.length == 2) {
        enableDates[mes] = EnableDateInt(
          mes: mes,
          versionActivaq1: mesEstado[0].versionestado == 'true',
          versionActivaq2: mesEstado[1].versionestado == 'true',
          pedidoActivoq1: mesEstado[0].estado == 'true',
          pedidoActivoq2: mesEstado[1].estado == 'true',
          entredoQ1: mesEstado[0].delivered == 'true',
          entredoQ2: mesEstado[1].delivered == 'true',
        );
      } else {}
    }
    return enableDates;
  }

  List<String> closedVersions() {
    return fechasFEMList
        .where((e) => e.estado == "true" && e.versionestado == "false")
        .map((e) => e.name)
        .toList();
  }

  int get anoActivo {
    if (mesActivo == 12) {
      return fechasFemDateBoolList
              .firstWhere((e) => e.versionestado == true)
              .ano -
          1;
    }
    return fechasFemDateBoolList.firstWhere((e) => e.versionestado == true).ano;
  }

  int get mesActivo {
    String mes = fechasFemDateBoolList
        .firstWhere((e) => e.versionestado == true)
        .pedido
        .substring(0, 2);
    if (mes == '01') mes = '13';
    return aEntero(mes) - 1;
  }

  List<int> correccionAno(int year) {
    List<int> correccion = List.filled(12, 1);
    Map<int, EnableDateInt> dates = enableDatesInt(year);
    int esteMes = DateTime.now().month;
    int esteAno = DateTime.now().year;
    if (dates[esteMes]!.entredoQ2 && esteAno == year) {
      correccion[esteMes - 1] = 0;
    }
    return correccion;
  }
}

class FechasFEMSingle {
  String version;
  String ano;
  String name;
  String pedido;
  String fecha;
  String estado;
  String fechadelivery;
  String delivered;
  String versionfecha;
  String versionestado;
  FechasFEMSingle({
    required this.version,
    required this.ano,
    required this.name,
    required this.pedido,
    required this.fecha,
    required this.estado,
    required this.fechadelivery,
    required this.delivered,
    required this.versionfecha,
    required this.versionestado,
  });

  List<String> toList() {
    return [
      version,
      ano,
      name,
      pedido,
      fecha,
      estado,
      fechadelivery,
      delivered,
      versionfecha,
      versionestado,
    ];
  }

  List<ToCelda> get celdas => [
    ToCelda(valor: ano, flex: 2),
    ToCelda(valor: version, flex: 1),
    ToCelda(valor: versionfecha, flex: 2),
    ToCelda(valor: pedido, flex: 2),
    ToCelda(valor: fecha, flex: 2),
    ToCelda(valor: estado == "false" ? "Cerrado" : "Abierto", flex: 2),
    ToCelda(valor: fechadelivery, flex: 2),
    ToCelda(valor: delivered == "true" ? "Si" : "No", flex: 2),
  ];

  FechasFEMSingle copyWith({
    String? version,
    String? ano,
    String? name,
    String? pedido,
    String? fecha,
    String? estado,
    String? fechadelivery,
    String? delivered,
    String? versionfecha,
    String? versionestado,
  }) {
    return FechasFEMSingle(
      version: version ?? this.version,
      ano: ano ?? this.ano,
      name: name ?? this.name,
      pedido: pedido ?? this.pedido,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
      fechadelivery: fechadelivery ?? this.fechadelivery,
      delivered: delivered ?? this.delivered,
      versionfecha: versionfecha ?? this.versionfecha,
      versionestado: versionestado ?? this.versionestado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'ano': ano,
      'name': name,
      'pedido': pedido,
      'fecha': fecha,
      'estado': estado,
      'fechadelivery': fechadelivery,
      'delivered': delivered,
      'versionfecha': versionfecha,
      'versionestado': versionestado,
    };
  }

  factory FechasFEMSingle.fromMap(Map<String, dynamic> map) {
    return FechasFEMSingle(
      version: map['version'] ?? '',
      ano: map['ano'] ?? '',
      name: map['name'] ?? '',
      pedido: map['pedido'] ?? '',
      fecha: map['fecha'] ?? '',
      estado: map['estado'] ?? '',
      fechadelivery: map['fechadelivery'] ?? '',
      delivered: map['delivered'] ?? '',
      versionfecha: map['versionfecha'] ?? '',
      versionestado: map['versionestado'] ?? '',
    );
  }

  factory FechasFEMSingle.fromList(List l) {
    return FechasFEMSingle(
      version: l[0].toString(),
      ano: l[1].toString(),
      name: l[2].toString(),
      pedido: l[3].toString(),
      fecha:
          l[4].toString().length > 10
              ? l[4].toString().substring(0, 10)
              : l[4].toString(),
      estado: l[5].toString(),
      fechadelivery:
          l[6].toString().length > 10
              ? l[6].toString().substring(0, 10)
              : l[6].toString(),
      delivered: l[7].toString(),
      versionfecha:
          l[8].toString().length > 10
              ? l[8].toString().substring(0, 10)
              : l[8].toString(),
      versionestado: l[9].toString(),
    );
  }

  factory FechasFEMSingle.fromZero() {
    return FechasFEMSingle(
      version: '',
      ano: '',
      name: '',
      pedido: '',
      fecha: '',
      estado: '',
      fechadelivery: 'funciona',
      delivered: '',
      versionfecha: '',
      versionestado: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FechasFEMSingle.fromJson(String source) =>
      FechasFEMSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FechasFEMSingle(version: $version, ano: $ano, name: $name, pedido: $pedido, fecha: $fecha, estado: $estado, fechadelivery: $fechadelivery, delivered: $delivered)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FechasFEMSingle &&
        other.version == version &&
        other.ano == ano &&
        other.name == name &&
        other.pedido == pedido &&
        other.fecha == fecha &&
        other.estado == estado &&
        other.fechadelivery == fechadelivery &&
        other.delivered == delivered;
  }

  @override
  int get hashCode {
    return version.hashCode ^
        ano.hashCode ^
        name.hashCode ^
        pedido.hashCode ^
        fecha.hashCode ^
        estado.hashCode ^
        fechadelivery.hashCode ^
        delivered.hashCode;
  }
}
