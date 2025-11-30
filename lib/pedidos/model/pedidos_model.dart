import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart' as http;

import '../../resources/titulo.dart';

class Pedidos {
  List<PedidosSingle> pedidosList = [];
  List<PedidosSingle> pedidosListSearch = [];
  List<PedidosSingle> pedidosListCart = [];
  List<PedidosSingle> pedidosListCartSearch = [];
  int view = 70;
  int viewCart = 70;
  Map itemsAndFlex = {
    'pedido': [2, 'pedido'],
    // 'id': [2, 'id'],
    'e4e': [2, 'e4e'],
    'descripcion': [6, 'descripcion'],
    'ctdi': [1, 'ctd_i'],
    // 'ctdf': [2, 'ctd_f'],
    'um': [1, 'um'],
    // 'comentario': [2, 'comentario'],
    'solicitante': [4, 'solicitante'],
    // 'tipoenvio': [2, 'tipoenvio'],
    // 'pdi': [2, 'pdi'],
    // 'pdiname': [2, 'pdiname'],
    'proyecto': [5, 'proyecto'],
    'ref': [3, 'ref'],
    // 'wbe': [2, 'wbe'],
    // 'wbeproyecto': [2, 'wbeproyecto'],
    // 'wbeparte': [2, 'wbeparte'],
    // 'wbeestado': [2, 'wbeestado'],
    // 'fecha': [2, 'fecha'],
    'estado': [2, 'estado'],
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
    ToCelda(valor: 'pedido', flex: 2),
    ToCelda(valor: 'e4e', flex: 2),
    ToCelda(valor: 'descripcion', flex: 6),
    ToCelda(valor: 'ctd_i', flex: 1),
    ToCelda(valor: 'um', flex: 1),
    ToCelda(valor: 'proyecto', flex: 5),
    ToCelda(valor: 'ref', flex: 3),
    ToCelda(valor: 'estado', flex: 2),
  ];

  obtener() async {
    pedidosList = [];
    pedidosListSearch = [];
    // var dataSend = {'dataReq': {}, 'fname': "obtenerPedidos"};

    // final response = await http.post(
    //   Uri.parse(
    //       "https://script.google.com/macros/s/AKfycbx23gG1YX3tB2r6KQ-7sBJdYNGURpHwHxnCmabRxLr8oRt3P6Te6JFvrm4-TqOBf5mX/exec"),
    //   body: jsonEncode(dataSend),
    // );
    // // print(response.body);
    // List dataAsListMap;
    // if (response.statusCode == 302) {
    //   var response2 = await http.get(Uri.parse(
    //       response.headers["location"].toString().replaceAll(',', '')));
    //   dataAsListMap = jsonDecode(response2.body);
    // } else {
    //   dataAsListMap = jsonDecode(response.body);
    // }

    // for (var item in dataAsListMap.sublist(1)) {
    //   // print(item);
    //   PedidosSingle pedidosSingle = PedidosSingle.fromMap(item);

    //   if (pedidosSingle.estado != 'borrado') {
    //     pedidosList.add(pedidosSingle);
    //   }
    // }
    // // print(pedidosList);
    // pedidosList
    //     .sort((a, b) => sumaPedido(a.pedido).compareTo(sumaPedido(b.pedido)));
    // pedidosList = pedidosList.reversed.toList();
    // pedidosListSearch = [...pedidosList];
  }

  sumaPedido(String fecha) {
    RegExp regExp = RegExp(
        r'\d+'); // Expresión regular para encontrar secuencias de dígitos

    Iterable<Match> matches = regExp.allMatches(fecha);
    int sum = 0;

    for (Match match in matches) {
      String? matchValue =
          match.group(0); // Obtener el valor del grupo coincidente
      int number = int.parse(matchValue!); // Convertir la cadena a un entero
      // Multiplicar el número según ciertas condiciones
      if (matchValue == '23' || matchValue == '24' || matchValue == '25') {
        number *= 1000;
      }
      sum += number; // Sumar al total
    }

    return sum;
  }

  Future salvarCesta() async {
    List<Map> pedidosAEnviar = pedidosListCart.map((e) => e.toMap()).toList();
    var dataSend = {
      'dataReq': {'vals': pedidosAEnviar},
      'fname': "addPedido"
    };

    // limpiar la cesta
    pedidosListCart = [];
    pedidosListCartSearch = [];

    // print(jsonEncode(dataSend));
    final response = await http.post(
      Api.fem,
      body: jsonEncode(dataSend),
    );
    // hacer algo con el mensaje de respuesta
    String dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await http.get(Uri.parse(
          response.headers["location"].toString().replaceAll(',', '')));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }

    //salvar los datos a lista de pedidos actuales
    for (var element in pedidosListCart) {
      pedidosList.add(element);
      pedidosListSearch.add(element);
    }

    // limpiar la cesta
    pedidosListCart = [];
    pedidosListCartSearch = [];

    return dataAsListMap;
  }

  Future borrarPedido({required String id, required String pedido}) async {
    var dataSend = {
      'dataReq': {'id': id, 'pedido': pedido, 'estado': 'borrado'},
      'fname': "cambiarEstadoPedido"
    };
    print(jsonEncode(dataSend));
    final response = await http.post(
      Api.fem,
      body: jsonEncode(dataSend),
    );

    // hacer algo con el mensaje de respuesta
    String dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await http.get(Uri.parse(
          response.headers["location"].toString().replaceAll(',', '')));
      dataAsListMap = jsonDecode(response2.body);
    } else {
      dataAsListMap = jsonDecode(response.body);
    }
    print(dataAsListMap);

    return dataAsListMap;
  }

  buscar(String busqueda) {
    pedidosListSearch = pedidosList
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }

  buscarCart(String busqueda) {
    pedidosListCartSearch = pedidosListCart
        .where((element) => element.toList().any((item) =>
            item.toString().toLowerCase().contains(busqueda.toLowerCase())))
        .toList();
  }
}

class PedidosSingle {
  String pedido;
  String id;
  String e4e;
  String descripcion;
  String ctdi;
  String ctdf;
  String um;
  String comentario;
  String solicitante;
  String tipoenvio;
  String pdi;
  String pdiname;
  String proyecto;
  String ref;
  String wbe;
  String wbeproyecto;
  String wbeparte;
  String wbeestado;
  String fecha;
  String estado;
  String lastperson;
  PedidosSingle({
    required this.pedido,
    required this.id,
    required this.e4e,
    required this.descripcion,
    required this.ctdi,
    required this.ctdf,
    required this.um,
    required this.comentario,
    required this.solicitante,
    required this.tipoenvio,
    required this.pdi,
    required this.pdiname,
    required this.proyecto,
    required this.ref,
    required this.wbe,
    required this.wbeproyecto,
    required this.wbeparte,
    required this.wbeestado,
    required this.fecha,
    required this.estado,
    required this.lastperson,
  });

  List<String> toList() {
    return [
      pedido,
      id,
      e4e,
      descripcion,
      ctdi,
      ctdf,
      um,
      comentario,
      solicitante,
      tipoenvio,
      pdi,
      pdiname,
      proyecto,
      ref,
      wbe,
      wbeproyecto,
      wbeparte,
      wbeestado,
      fecha,
      estado,
      lastperson,
    ];
  }

  Map get mapToTitlesPedidos => {
        'pedido': [2, pedido],
        // 'id': [2, 'id'],
        'e4e': [2, e4e],
        'descripcion': [6, descripcion],
        'ctdi': [1, ctdi],
        // 'ctdf': [2, 'ctd_f'],
        'um': [1, um],
        // 'comentario': [2, 'comentario'],
        'solicitante': [4, solicitante],
        // 'tipoenvio': [2, 'tipoenvio'],
        // 'pdi': [2, 'pdi'],
        // 'pdiname': [2, 'pdiname'],
        'proyecto': [5, proyecto],
        'ref': [3, ref],
        // 'wbe': [2, 'wbe'],
        // 'wbeproyecto': [2, 'wbeproyecto'],
        // 'wbeparte': [2, 'wbeparte'],
        // 'wbeestado': [2, 'wbeestado'],
        // 'fecha': [2, 'fecha'],
        'estado': [2, estado],
      };

  List<ToCelda> get celdasToExtra => [
        ToCelda(valor: pedido, flex: 2),
        ToCelda(valor: e4e, flex: 2),
        ToCelda(valor: descripcion, flex: 6),
        ToCelda(valor: ctdi, flex: 1),
        ToCelda(valor: um, flex: 1),
        ToCelda(valor: proyecto, flex: 5),
        ToCelda(valor: ref, flex: 3),
        ToCelda(valor: estado, flex: 2),
  ];

  PedidosSingle copyWith({
    String? pedido,
    String? id,
    String? e4e,
    String? descripcion,
    String? ctdi,
    String? ctdf,
    String? um,
    String? comentario,
    String? solicitante,
    String? tipoenvio,
    String? pdi,
    String? pdiname,
    String? proyecto,
    String? ref,
    String? wbe,
    String? wbeproyecto,
    String? wbeparte,
    String? wbeestado,
    String? fecha,
    String? estado,
    String? lastperson,
  }) {
    return PedidosSingle(
      pedido: pedido ?? this.pedido,
      id: id ?? this.id,
      e4e: e4e ?? this.e4e,
      descripcion: descripcion ?? this.descripcion,
      ctdi: ctdi ?? this.ctdi,
      ctdf: ctdf ?? this.ctdf,
      um: um ?? this.um,
      comentario: comentario ?? this.comentario,
      solicitante: solicitante ?? this.solicitante,
      tipoenvio: tipoenvio ?? this.tipoenvio,
      pdi: pdi ?? this.pdi,
      pdiname: pdiname ?? this.pdiname,
      proyecto: proyecto ?? this.proyecto,
      ref: ref ?? this.ref,
      wbe: wbe ?? this.wbe,
      wbeproyecto: wbeproyecto ?? this.wbeproyecto,
      wbeparte: wbeparte ?? this.wbeparte,
      wbeestado: wbeestado ?? this.wbeestado,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
      lastperson: lastperson ?? this.lastperson,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pedido': pedido,
      'id': id,
      'e4e': e4e,
      'descripcion': descripcion,
      'ctdi': ctdi,
      'causar': ctdf,
      'um': um,
      'comentario': comentario,
      'solicitante': solicitante,
      'tipoenvio': tipoenvio,
      'pdi': pdi,
      'pdiname': pdiname,
      'proyecto': proyecto,
      'ref': ref,
      'wbe': wbe,
      'wbeproyecto': wbeproyecto,
      'wbeparte': wbeparte,
      'wbeestado': wbeestado,
      'fecha': fecha,
      'estado': estado,
      'lastperson': lastperson,
    };
  }

  factory PedidosSingle.fromList(List l) {
    return PedidosSingle(
      pedido: l[0].toString(),
      id: l[1].toString(),
      e4e: l[2].toString(),
      descripcion: l[3].toString(),
      ctdi: l[4].toString(),
      ctdf: l[5].toString(),
      um: l[6].toString(),
      comentario: l[7].toString(),
      solicitante: l[8].toString(),
      tipoenvio: l[9].toString(),
      pdi: l[10].toString(),
      pdiname: l[11].toString(),
      proyecto: l[12].toString(),
      ref: l[13].toString(),
      wbe: l[14].toString(),
      wbeproyecto: l[15].toString(),
      wbeparte: l[16].toString(),
      wbeestado: l[17].toString(),
      fecha: l[18].toString(),
      estado: l[19].toString(),
      lastperson: l[20].toString(),
    );
  }

  factory PedidosSingle.fromListFEM(List l) {
    return PedidosSingle(
      pedido: l[0].toString(),
      id: l[1].toString(),
      e4e: l[2].toString(),
      descripcion: l[3].toString(),
      ctdi: l[4].toString(),
      ctdf: l[5].toString(),
      um: l[6].toString(),
      comentario: l[7].toString(),
      solicitante: l[8].toString(),
      tipoenvio: l[9].toString(),
      pdi: l[10].toString(),
      pdiname: l[11].toString(),
      proyecto: l[12].toString(),
      ref: l[13].toString(),
      wbe: l[14].toString(),
      wbeproyecto: l[15].toString(),
      wbeparte: l[16].toString(),
      wbeestado: l[17].toString(),
      fecha: l[18].toString(),
      estado: l[19].toString(),
      lastperson: l[20].toString(),
    );
  }

  factory PedidosSingle.fromMap(Map<String, dynamic> map) {
    return PedidosSingle(
      pedido: map['pedido'].toString(),
      id: map['id'].toString(),
      e4e: map['e4e'].toString(),
      descripcion: map['descripcion'].toString(),
      ctdi: map['ctd'].toString(),
      ctdf: map['ctdf'].toString(),
      um: map['um'].toString(),
      comentario: map['comentario'].toString(),
      solicitante: map['solicitante'].toString(),
      tipoenvio: map['tipoenvio'].toString(),
      pdi: map['pdi'].toString(),
      pdiname: map['pdiname'].toString(),
      proyecto: map['proyecto'].toString(),
      ref: map['ref'].toString(),
      wbe: map['wbe'].toString(),
      wbeproyecto: map['wbeproyecto'].toString(),
      wbeparte: map['wbeparte'].toString(),
      wbeestado: map['wbeestado'].toString(),
      fecha: map['fecha'].toString(),
      estado: "En ficha",
      lastperson: map['lastperson'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidosSingle.fromJson(String source) =>
      PedidosSingle.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PedidosSingle(pedido: $pedido, id: $id, e4e: $e4e, descripcion: $descripcion, ctdi: $ctdi, ctdf: $ctdf, um: $um, comentario: $comentario, solicitante: $solicitante, tipoenvio: $tipoenvio, pdi: $pdi, pdiname: $pdiname, proyecto: $proyecto, ref: $ref, wbe: $wbe, wbeproyecto: $wbeproyecto, wbeparte: $wbeparte, wbeestado: $wbeestado, fecha: $fecha, estado: $estado, lastperson: $lastperson)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PedidosSingle &&
        other.pedido == pedido &&
        other.id == id &&
        other.e4e == e4e &&
        other.descripcion == descripcion &&
        other.ctdi == ctdi &&
        other.ctdf == ctdf &&
        other.um == um &&
        other.comentario == comentario &&
        other.solicitante == solicitante &&
        other.tipoenvio == tipoenvio &&
        other.pdi == pdi &&
        other.pdiname == pdiname &&
        other.proyecto == proyecto &&
        other.ref == ref &&
        other.wbe == wbe &&
        other.wbeproyecto == wbeproyecto &&
        other.wbeparte == wbeparte &&
        other.wbeestado == wbeestado &&
        other.fecha == fecha &&
        other.estado == estado &&
        other.lastperson == lastperson;
  }

  @override
  int get hashCode {
    return pedido.hashCode ^
        id.hashCode ^
        e4e.hashCode ^
        descripcion.hashCode ^
        ctdi.hashCode ^
        ctdf.hashCode ^
        um.hashCode ^
        comentario.hashCode ^
        solicitante.hashCode ^
        tipoenvio.hashCode ^
        pdi.hashCode ^
        pdiname.hashCode ^
        proyecto.hashCode ^
        ref.hashCode ^
        wbe.hashCode ^
        wbeproyecto.hashCode ^
        wbeparte.hashCode ^
        wbeestado.hashCode ^
        fecha.hashCode ^
        estado.hashCode ^
        lastperson.hashCode;
  }
}
