import 'dart:convert';


class IngresosB {
  List<IngresosBSingle> ingresosBList = [];
  List<IngresosBSingle> ingresosBListSearch = [];
  int totalValor = 0;
  int view = 50;
  Map itemsAndFlex = {
    'pedido': 2,
    'codigo_massy': 2,
    'fecha_i': 2,
    'soporte_r': 1,
    'item': 1,
    'e4e': 2,
    'descripcion': 6,
    'um': 1,
    'ctd': 1,
    'X': 1,
  };

  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

  buscar(String busqueda) {
    ingresosBListSearch = [...ingresosBList];
    ingresosBListSearch = ingresosBList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }


  @override
  String toString() => 'IngresosB(ingresosBList: $ingresosBList)';
}

class IngresosBSingle {
  String pedido;
  String codigo_massy;
  String fecha_i;
  String almacenista_i;
  String tel_i;
  String soporte_i;
  String item;
  String e4e;
  String descripcion;
  String um;
  String ctd;
  String proyecto;
  String ingeniero_enel;
  String almacenista_r;
  String tel_r;
  String fecha_r;
  String unidad_r;
  String soporte_r;
  String reportado;
  String comentario_i;
  String estado;
  String tipo;
  IngresosBSingle({
    required this.pedido,
    required this.codigo_massy,
    required this.fecha_i,
    required this.almacenista_i,
    required this.tel_i,
    required this.soporte_i,
    required this.item,
    required this.e4e,
    required this.descripcion,
    required this.um,
    required this.ctd,
    required this.proyecto,
    required this.ingeniero_enel,
    required this.almacenista_r,
    required this.tel_r,
    required this.fecha_r,
    required this.unidad_r,
    required this.soporte_r,
    required this.reportado,
    required this.comentario_i,
    required this.estado,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'pedido': pedido,
      'codigo_massy': codigo_massy,
      'fecha_i': fecha_i,
      'almacenista_i': almacenista_i,
      'tel_i': tel_i,
      'soporte_i': soporte_i,
      'item': item,
      'e4e': e4e,
      'descripcion': descripcion,
      'um': um,
      'ctd': ctd,
      'proyecto': proyecto,
      'ingeniero_enel': ingeniero_enel,
      'almacenista_r': almacenista_r,
      'tel_r': tel_r,
      'fecha_r': fecha_r,
      'unidad_r': unidad_r,
      'soporte_r': soporte_r,
      'reportado': reportado,
      'comentario_i': comentario_i,
      'estado': estado,
      'tipo': tipo,
    };
  }

  factory IngresosBSingle.fromMap(Map<String, dynamic> map) {
    return IngresosBSingle(
      pedido: map['pedido'].toString(),
      codigo_massy: map['codigo_massy'].toString(),
      fecha_i: map['fecha_i'].toString().length > 0
          ? map['fecha_i'].toString().substring(0, 10)
          : map['fecha_i'].toString(),
      almacenista_i: map['almacenista_i'].toString(),
      tel_i: map['tel_i'].toString(),
      soporte_i: map['soporte_i'].toString(),
      item: map['item'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      um: map['um'].toString(),
      ctd: map['ctd'].toString(),
      proyecto: map['proyecto'].toString(),
      ingeniero_enel: map['ingeniero_enel'].toString(),
      almacenista_r: map['almacenista_r'].toString(),
      tel_r: map['tel_r'].toString(),
      fecha_r: map['fecha_r'].toString().length > 0
          ? map['fecha_r'].toString().substring(0, 10)
          : map['fecha_r'].toString(),
      unidad_r: map['unidad_r'].toString(),
      soporte_r: map['soporte_r'].toString(),
      reportado: map['reportado'].toString(),
      comentario_i: map['comentario_i'].toString(),
      estado: map['estado'].toString(),
      tipo: map['tipo'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory IngresosBSingle.fromJson(String source) =>
      IngresosBSingle.fromMap(json.decode(source));

  List<String> toList() {
    return [
      pedido,
      codigo_massy,
      fecha_i.length > 10 ? fecha_i.substring(0, 10) : fecha_i,
      almacenista_i,
      tel_i,
      soporte_i,
      item,
      e4e,
      descripcion,
      um,
      ctd,
      proyecto,
      ingeniero_enel,
      almacenista_r,
      tel_r,
      fecha_r.length > 10 ? fecha_r.substring(0, 10) : fecha_r,
      unidad_r,
      soporte_r,
      reportado.length > 10 ? reportado.substring(0, 10) : reportado,
      comentario_i,
      estado,
      tipo
    ];
  }

  @override
  String toString() {
    return 'IngresosBSingle(pedido: $pedido, codigo_massy: $codigo_massy, fecha_i: $fecha_i, almacenista_i: $almacenista_i, tel_i: $tel_i, soporte_i: $soporte_i, item: $item, e4e: $e4e, descripcion: $descripcion, um: $um, ctd: $ctd, proyecto: $proyecto, ingeniero_enel: $ingeniero_enel, almacenista_r: $almacenista_r, tel_r: $tel_r, fecha_r: $fecha_r, unidad_r: $unidad_r, soporte_r: $soporte_r, reportado: $reportado, comentario_i: $comentario_i, estado: $estado, tipo: $tipo)';
  }
}
