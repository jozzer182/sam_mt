// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:http/http.dart' as http;
import 'package:v_al_sam_v02/user/user_model.dart';

class TablaPlan {
  List<TablaPlanSingle> tablaPlanList = [];

  Future<List<TablaPlanSingle>> obtener(User user) async {
    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'tx': 'PMCMT'},
      'fname': "getTablaPlan"
    };
    // print(jsonEncode(dataSend));
    final response = await http.post(
      Api.sam,
      body: jsonEncode(dataSend),
    );
    var dataAsListMap;
    if (response.statusCode == 302) {
      var response2 = await http.get(Uri.parse(
          response.headers["location"].toString().replaceAll(',', '')));
      dataAsListMap = jsonDecode(response2.body)['dataFilter'];
    } else {
      dataAsListMap = jsonDecode(response.body)['dataFilter'];
    }
    for (var item in dataAsListMap) {
      tablaPlanList.add(TablaPlanSingle.fromMap(item));
      // if (item['e4e'].toString().replaceAll(',', '') == '330620') {
      //   print(item['desccripcion'].toString().replaceAll(',', '').replaceAll(',', ''));
      //   print(tablaPlanList.last.toMap());
      // }
    }
    return tablaPlanList;
  }
}

class TablaPlanSingle {
  String codigo;
  String solicitud;
  String proyecto;
  String uEjecutora;
  String pm;
  String gestor;
  String pdi;
  String e4e;
  String desccripcion;
  String ubm;
  String a2022;
  String a2023;
  String m0122;
  String m0222;
  String m0322;
  String m0422;
  String m0522;
  String m0622;
  String m0722;
  String m0822;
  String m0922;
  String m1022;
  String m1122;
  String m1222;
  String m0123;
  String m0223;
  String m0323;
  String m0423;
  String m0523;
  String m0623;
  String m0723;
  String m0823;
  String m0923;
  String m1023;
  String m1123;
  String m1223;
  String a2024;
  String m0124;
  String m0224;
  String m0324;
  String m0424;
  String m0524;
  String m0624;
  String m0724;
  String m0824;
  String m0924;
  String m1024;
  String m1124;
  String m1224;
  String a2025;
  String m0125;
  String m0225;
  String m0325;
  String m0425;
  String m0525;
  String m0625;
  String m0725;
  String m0825;
  String m0925;
  String m1025;
  String m1125;
  String m1225;
  String observaciones;
  String s_solicita;
  String s_comentario;
  String s_fecha;
  String s_estado;
  String r_responde;
  String r_comentario;
  String r_fecha;
  String r_estado;
  String estado;
  String circuito;
  String abril22;
  String mayo22;
  String junio22;
  String julio22;
  String agosto22;
  String septiembre22;
  String octubre22;
  String noviembre22;
  String diciembre22;
  String cincoMil;
  String d0422_1;
  String m0422_1;
  String d0422_2;
  String m0422_2;
  String d0422_E;
  String m0422_E;
  String d0522_1;
  String m0522_1;
  String d0522_2;
  String m0522_2;
  String d0522_E;
  String m0522_E;
  String d0622_1;
  String m0622_1;
  String d0622_2;
  String m0622_2;
  String d0622_E;
  String m0622_E;
  String d0722_1;
  String m0722_1;
  String d0722_2;
  String m0722_2;
  String d0722_E;
  String m0722_E;
  String d0822_1;
  String m0822_1;
  String d0822_2;
  String m0822_2;
  String d0822_E;
  String m0822_E;
  String d0922_1;
  String m0922_1;
  String d0922_2;
  String m0922_2;
  String d0922_E;
  String m0922_E;
  String d1022_1;
  String m1022_1;
  String d1022_2;
  String m1022_2;
  String d1022_E;
  String m1022_E;
  String d1122_1;
  String m1122_1;
  String d1122_2;
  String m1122_2;
  String d1122_E;
  String m1122_E;
  String d1222_1;
  String m1222_1;
  String d1222_2;
  String m1222_2;
  String d1222_E;
  String m1222_E;
  String d_solicitante;
  String d_fecha;
  String d_Wbe;
  String d_comentario;
  String d_entrega;
  String campo1;
  String campo2;
  String iD;
  String actualizado;
  TablaPlanSingle({
    required this.codigo,
    required this.solicitud,
    required this.proyecto,
    required this.uEjecutora,
    required this.pm,
    required this.gestor,
    required this.pdi,
    required this.e4e,
    required this.desccripcion,
    required this.ubm,
    required this.a2022,
    required this.a2023,
    required this.m0122,
    required this.m0222,
    required this.m0322,
    required this.m0422,
    required this.m0522,
    required this.m0622,
    required this.m0722,
    required this.m0822,
    required this.m0922,
    required this.m1022,
    required this.m1122,
    required this.m1222,
    required this.m0123,
    required this.m0223,
    required this.m0323,
    required this.m0423,
    required this.m0523,
    required this.m0623,
    required this.m0723,
    required this.m0823,
    required this.m0923,
    required this.m1023,
    required this.m1123,
    required this.m1223,
    required this.a2024,
    required this.m0124,
    required this.m0224,
    required this.m0324,
    required this.m0424,
    required this.m0524,
    required this.m0624,
    required this.m0724,
    required this.m0824,
    required this.m0924,
    required this.m1024,
    required this.m1124,
    required this.m1224,
    required this.a2025,
    required this.m0125,
    required this.m0225,
    required this.m0325,
    required this.m0425,
    required this.m0525,
    required this.m0625,
    required this.m0725,
    required this.m0825,
    required this.m0925,
    required this.m1025,
    required this.m1125,
    required this.m1225,
    required this.observaciones,
    required this.s_solicita,
    required this.s_comentario,
    required this.s_fecha,
    required this.s_estado,
    required this.r_responde,
    required this.r_comentario,
    required this.r_fecha,
    required this.r_estado,
    required this.estado,
    required this.circuito,
    required this.abril22,
    required this.mayo22,
    required this.junio22,
    required this.julio22,
    required this.agosto22,
    required this.septiembre22,
    required this.octubre22,
    required this.noviembre22,
    required this.diciembre22,
    required this.cincoMil,
    required this.d0422_1,
    required this.m0422_1,
    required this.d0422_2,
    required this.m0422_2,
    required this.d0422_E,
    required this.m0422_E,
    required this.d0522_1,
    required this.m0522_1,
    required this.d0522_2,
    required this.m0522_2,
    required this.d0522_E,
    required this.m0522_E,
    required this.d0622_1,
    required this.m0622_1,
    required this.d0622_2,
    required this.m0622_2,
    required this.d0622_E,
    required this.m0622_E,
    required this.d0722_1,
    required this.m0722_1,
    required this.d0722_2,
    required this.m0722_2,
    required this.d0722_E,
    required this.m0722_E,
    required this.d0822_1,
    required this.m0822_1,
    required this.d0822_2,
    required this.m0822_2,
    required this.d0822_E,
    required this.m0822_E,
    required this.d0922_1,
    required this.m0922_1,
    required this.d0922_2,
    required this.m0922_2,
    required this.d0922_E,
    required this.m0922_E,
    required this.d1022_1,
    required this.m1022_1,
    required this.d1022_2,
    required this.m1022_2,
    required this.d1022_E,
    required this.m1022_E,
    required this.d1122_1,
    required this.m1122_1,
    required this.d1122_2,
    required this.m1122_2,
    required this.d1122_E,
    required this.m1122_E,
    required this.d1222_1,
    required this.m1222_1,
    required this.d1222_2,
    required this.m1222_2,
    required this.d1222_E,
    required this.m1222_E,
    required this.d_solicitante,
    required this.d_fecha,
    required this.d_Wbe,
    required this.d_comentario,
    required this.d_entrega,
    required this.campo1,
    required this.campo2,
    required this.iD,
    required this.actualizado,
  });

  toList() {
    return [
      codigo,
      solicitud,
      proyecto,
      uEjecutora,
      pm,
      gestor,
      pdi,
      e4e,
      desccripcion,
      ubm,
      a2022,
      a2023,
      m0122,
      m0222,
      m0322,
      m0422,
      m0522,
      m0622,
      m0722,
      m0822,
      m0922,
      m1022,
      m1122,
      m1222,
      m0123,
      m0223,
      m0323,
      m0423,
      m0523,
      m0623,
      m0723,
      m0823,
      m0923,
      m1023,
      m1123,
      m1223,
      a2024,
      m0124,
      m0224,
      m0324,
      m0424,
      m0524,
      m0624,
      m0724,
      m0824,
      m0924,
      m1024,
      m1124,
      m1224,
      a2025,
      m0125,
      m0225,
      m0325,
      m0425,
      m0525,
      m0625,
      m0725,
      m0825,
      m0925,
      m1025,
      m1125,
      m1225,
      observaciones,
      s_solicita,
      s_comentario,
      s_fecha,
      s_estado,
      r_responde,
      r_comentario,
      r_fecha,
      r_estado,
      estado,
      circuito,
      abril22,
      mayo22,
      junio22,
      julio22,
      agosto22,
      septiembre22,
      octubre22,
      noviembre22,
      diciembre22,
      cincoMil,
      d0422_1,
      m0422_1,
      d0422_2,
      m0422_2,
      d0422_E,
      m0422_E,
      d0522_1,
      m0522_1,
      d0522_2,
      m0522_2,
      d0522_E,
      m0522_E,
      d0622_1,
      m0622_1,
      d0622_2,
      m0622_2,
      d0622_E,
      m0622_E,
      d0722_1,
      m0722_1,
      d0722_2,
      m0722_2,
      d0722_E,
      m0722_E,
      d0822_1,
      m0822_1,
      d0822_2,
      m0822_2,
      d0822_E,
      m0822_E,
      d0922_1,
      m0922_1,
      d0922_2,
      m0922_2,
      d0922_E,
      m0922_E,
      d1022_1,
      m1022_1,
      d1022_2,
      m1022_2,
      d1022_E,
      m1022_E,
      d1122_1,
      m1122_1,
      d1122_2,
      m1122_2,
      d1122_E,
      m1122_E,
      d1222_1,
      m1222_1,
      d1222_2,
      m1222_2,
      d1222_E,
      m1222_E,
      d_solicitante,
      d_fecha,
      d_Wbe,
      d_comentario,
      d_entrega,
      campo1,
      campo2,
      iD,
      actualizado,
    ];
  }

  TablaPlanSingle copyWith({
    String? codigo,
    String? solicitud,
    String? proyecto,
    String? uEjecutora,
    String? pm,
    String? gestor,
    String? pdi,
    String? e4e,
    String? desccripcion,
    String? ubm,
    String? a2022,
    String? a2023,
    String? m0122,
    String? m0222,
    String? m0322,
    String? m0422,
    String? m0522,
    String? m0622,
    String? m0722,
    String? m0822,
    String? m0922,
    String? m1022,
    String? m1122,
    String? m1222,
    String? m0123,
    String? m0223,
    String? m0323,
    String? m0423,
    String? m0523,
    String? m0623,
    String? m0723,
    String? m0823,
    String? m0923,
    String? m1023,
    String? m1123,
    String? m1223,
    String? a2024,
    String? m0124,
    String? m0224,
    String? m0324,
    String? m0424,
    String? m0524,
    String? m0624,
    String? m0724,
    String? m0824,
    String? m0924,
    String? m1024,
    String? m1124,
    String? m1224,
    String? a2025,
    String? m0125,
    String? m0225,
    String? m0325,
    String? m0425,
    String? m0525,
    String? m0625,
    String? m0725,
    String? m0825,
    String? m0925,
    String? m1025,
    String? m1125,
    String? m1225,
    String? observaciones,
    String? s_solicita,
    String? s_comentario,
    String? s_fecha,
    String? s_estado,
    String? r_responde,
    String? r_comentario,
    String? r_fecha,
    String? r_estado,
    String? estado,
    String? circuito,
    String? abril22,
    String? mayo22,
    String? junio22,
    String? julio22,
    String? agosto22,
    String? septiembre22,
    String? octubre22,
    String? noviembre22,
    String? diciembre22,
    String? cincoMil,
    String? d0422_1,
    String? m0422_1,
    String? d0422_2,
    String? m0422_2,
    String? d0422_E,
    String? m0422_E,
    String? d0522_1,
    String? m0522_1,
    String? d0522_2,
    String? m0522_2,
    String? d0522_E,
    String? m0522_E,
    String? d0622_1,
    String? m0622_1,
    String? d0622_2,
    String? m0622_2,
    String? d0622_E,
    String? m0622_E,
    String? d0722_1,
    String? m0722_1,
    String? d0722_2,
    String? m0722_2,
    String? d0722_E,
    String? m0722_E,
    String? d0822_1,
    String? m0822_1,
    String? d0822_2,
    String? m0822_2,
    String? d0822_E,
    String? m0822_E,
    String? d0922_1,
    String? m0922_1,
    String? d0922_2,
    String? m0922_2,
    String? d0922_E,
    String? m0922_E,
    String? d1022_1,
    String? m1022_1,
    String? d1022_2,
    String? m1022_2,
    String? d1022_E,
    String? m1022_E,
    String? d1122_1,
    String? m1122_1,
    String? d1122_2,
    String? m1122_2,
    String? d1122_E,
    String? m1122_E,
    String? d1222_1,
    String? m1222_1,
    String? d1222_2,
    String? m1222_2,
    String? d1222_E,
    String? m1222_E,
    String? d_solicitante,
    String? d_fecha,
    String? d_Wbe,
    String? d_comentario,
    String? d_entrega,
    String? campo1,
    String? campo2,
    String? iD,
    String? actualizado,
  }) {
    return TablaPlanSingle(
      codigo: codigo ?? this.codigo,
      solicitud: solicitud ?? this.solicitud,
      proyecto: proyecto ?? this.proyecto,
      uEjecutora: uEjecutora ?? this.uEjecutora,
      pm: pm ?? this.pm,
      gestor: gestor ?? this.gestor,
      pdi: pdi ?? this.pdi,
      e4e: e4e ?? this.e4e,
      desccripcion: desccripcion ?? this.desccripcion,
      ubm: ubm ?? this.ubm,
      a2022: a2022 ?? this.a2022,
      a2023: a2023 ?? this.a2023,
      m0122: m0122 ?? this.m0122,
      m0222: m0222 ?? this.m0222,
      m0322: m0322 ?? this.m0322,
      m0422: m0422 ?? this.m0422,
      m0522: m0522 ?? this.m0522,
      m0622: m0622 ?? this.m0622,
      m0722: m0722 ?? this.m0722,
      m0822: m0822 ?? this.m0822,
      m0922: m0922 ?? this.m0922,
      m1022: m1022 ?? this.m1022,
      m1122: m1122 ?? this.m1122,
      m1222: m1222 ?? this.m1222,
      m0123: m0123 ?? this.m0123,
      m0223: m0223 ?? this.m0223,
      m0323: m0323 ?? this.m0323,
      m0423: m0423 ?? this.m0423,
      m0523: m0523 ?? this.m0523,
      m0623: m0623 ?? this.m0623,
      m0723: m0723 ?? this.m0723,
      m0823: m0823 ?? this.m0823,
      m0923: m0923 ?? this.m0923,
      m1023: m1023 ?? this.m1023,
      m1123: m1123 ?? this.m1123,
      m1223: m1223 ?? this.m1223,
      a2024: a2024 ?? this.a2024,
      m0124: m0124 ?? this.m0124,
      m0224: m0224 ?? this.m0224,
      m0324: m0324 ?? this.m0324,
      m0424: m0424 ?? this.m0424,
      m0524: m0524 ?? this.m0524,
      m0624: m0624 ?? this.m0624,
      m0724: m0724 ?? this.m0724,
      m0824: m0824 ?? this.m0824,
      m0924: m0924 ?? this.m0924,
      m1024: m1024 ?? this.m1024,
      m1124: m1124 ?? this.m1124,
      m1224: m1224 ?? this.m1224,
      a2025: a2025 ?? this.a2025,
      m0125: m0125 ?? this.m0125,
      m0225: m0225 ?? this.m0225,
      m0325: m0325 ?? this.m0325,
      m0425: m0425 ?? this.m0425,
      m0525: m0525 ?? this.m0525,
      m0625: m0625 ?? this.m0625,
      m0725: m0725 ?? this.m0725,
      m0825: m0825 ?? this.m0825,
      m0925: m0925 ?? this.m0925,
      m1025: m1025 ?? this.m1025,
      m1125: m1125 ?? this.m1125,
      m1225: m1225 ?? this.m1225,
      observaciones: observaciones ?? this.observaciones,
      s_solicita: s_solicita ?? this.s_solicita,
      s_comentario: s_comentario ?? this.s_comentario,
      s_fecha: s_fecha ?? this.s_fecha,
      s_estado: s_estado ?? this.s_estado,
      r_responde: r_responde ?? this.r_responde,
      r_comentario: r_comentario ?? this.r_comentario,
      r_fecha: r_fecha ?? this.r_fecha,
      r_estado: r_estado ?? this.r_estado,
      estado: estado ?? this.estado,
      circuito: circuito ?? this.circuito,
      abril22: abril22 ?? this.abril22,
      mayo22: mayo22 ?? this.mayo22,
      junio22: junio22 ?? this.junio22,
      julio22: julio22 ?? this.julio22,
      agosto22: agosto22 ?? this.agosto22,
      septiembre22: septiembre22 ?? this.septiembre22,
      octubre22: octubre22 ?? this.octubre22,
      noviembre22: noviembre22 ?? this.noviembre22,
      diciembre22: diciembre22 ?? this.diciembre22,
      cincoMil: cincoMil ?? this.cincoMil,
      d0422_1: d0422_1 ?? this.d0422_1,
      m0422_1: m0422_1 ?? this.m0422_1,
      d0422_2: d0422_2 ?? this.d0422_2,
      m0422_2: m0422_2 ?? this.m0422_2,
      d0422_E: d0422_E ?? this.d0422_E,
      m0422_E: m0422_E ?? this.m0422_E,
      d0522_1: d0522_1 ?? this.d0522_1,
      m0522_1: m0522_1 ?? this.m0522_1,
      d0522_2: d0522_2 ?? this.d0522_2,
      m0522_2: m0522_2 ?? this.m0522_2,
      d0522_E: d0522_E ?? this.d0522_E,
      m0522_E: m0522_E ?? this.m0522_E,
      d0622_1: d0622_1 ?? this.d0622_1,
      m0622_1: m0622_1 ?? this.m0622_1,
      d0622_2: d0622_2 ?? this.d0622_2,
      m0622_2: m0622_2 ?? this.m0622_2,
      d0622_E: d0622_E ?? this.d0622_E,
      m0622_E: m0622_E ?? this.m0622_E,
      d0722_1: d0722_1 ?? this.d0722_1,
      m0722_1: m0722_1 ?? this.m0722_1,
      d0722_2: d0722_2 ?? this.d0722_2,
      m0722_2: m0722_2 ?? this.m0722_2,
      d0722_E: d0722_E ?? this.d0722_E,
      m0722_E: m0722_E ?? this.m0722_E,
      d0822_1: d0822_1 ?? this.d0822_1,
      m0822_1: m0822_1 ?? this.m0822_1,
      d0822_2: d0822_2 ?? this.d0822_2,
      m0822_2: m0822_2 ?? this.m0822_2,
      d0822_E: d0822_E ?? this.d0822_E,
      m0822_E: m0822_E ?? this.m0822_E,
      d0922_1: d0922_1 ?? this.d0922_1,
      m0922_1: m0922_1 ?? this.m0922_1,
      d0922_2: d0922_2 ?? this.d0922_2,
      m0922_2: m0922_2 ?? this.m0922_2,
      d0922_E: d0922_E ?? this.d0922_E,
      m0922_E: m0922_E ?? this.m0922_E,
      d1022_1: d1022_1 ?? this.d1022_1,
      m1022_1: m1022_1 ?? this.m1022_1,
      d1022_2: d1022_2 ?? this.d1022_2,
      m1022_2: m1022_2 ?? this.m1022_2,
      d1022_E: d1022_E ?? this.d1022_E,
      m1022_E: m1022_E ?? this.m1022_E,
      d1122_1: d1122_1 ?? this.d1122_1,
      m1122_1: m1122_1 ?? this.m1122_1,
      d1122_2: d1122_2 ?? this.d1122_2,
      m1122_2: m1122_2 ?? this.m1122_2,
      d1122_E: d1122_E ?? this.d1122_E,
      m1122_E: m1122_E ?? this.m1122_E,
      d1222_1: d1222_1 ?? this.d1222_1,
      m1222_1: m1222_1 ?? this.m1222_1,
      d1222_2: d1222_2 ?? this.d1222_2,
      m1222_2: m1222_2 ?? this.m1222_2,
      d1222_E: d1222_E ?? this.d1222_E,
      m1222_E: m1222_E ?? this.m1222_E,
      d_solicitante: d_solicitante ?? this.d_solicitante,
      d_fecha: d_fecha ?? this.d_fecha,
      d_Wbe: d_Wbe ?? this.d_Wbe,
      d_comentario: d_comentario ?? this.d_comentario,
      d_entrega: d_entrega ?? this.d_entrega,
      campo1: campo1 ?? this.campo1,
      campo2: campo2 ?? this.campo2,
      iD: iD ?? this.iD,
      actualizado: actualizado ?? this.actualizado,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'solicitud': solicitud,
      'proyecto': proyecto,
      'uEjecutora': uEjecutora,
      'pm': pm,
      'gestor': gestor,
      'pdi': pdi,
      'e4e': e4e,
      'desccripcion': desccripcion,
      'ubm': ubm,
      'a2022': a2022,
      'a2023': a2023,
      'm0122': m0122,
      'm0222': m0222,
      'm0322': m0322,
      'm0422': m0422,
      'm0522': m0522,
      'm0622': m0622,
      'm0722': m0722,
      'm0822': m0822,
      'm0922': m0922,
      'm1022': m1022,
      'm1122': m1122,
      'm1222': m1222,
      'm0123': m0123,
      'm0223': m0223,
      'm0323': m0323,
      'm0423': m0423,
      'm0523': m0523,
      'm0623': m0623,
      'm0723': m0723,
      'm0823': m0823,
      'm0923': m0923,
      'm1023': m1023,
      'm1123': m1123,
      'm1223': m1223,
      'a2024': a2024,
      'm0124': m0124,
      'm0224': m0224,
      'm0324': m0324,
      'm0424': m0424,
      'm0524': m0524,
      'm0624': m0624,
      'm0724': m0724,
      'm0824': m0824,
      'm0924': m0924,
      'm1024': m1024,
      'm1124': m1124,
      'm1224': m1224,
      'a2025': a2025,
      'm0125': m0125,
      'm0225': m0225,
      'm0325': m0325,
      'm0425': m0425,
      'm0525': m0525,
      'm0625': m0625,
      'm0725': m0725,
      'm0825': m0825,
      'm0925': m0925,
      'm1025': m1025,
      'm1125': m1125,
      'm1225': m1225,
      'observaciones': observaciones,
      's_solicita': s_solicita,
      's_comentario': s_comentario,
      's_fecha': s_fecha,
      's_estado': s_estado,
      'r_responde': r_responde,
      'r_comentario': r_comentario,
      'r_fecha': r_fecha,
      'r_estado': r_estado,
      'estado': estado,
      'circuito': circuito,
      'abril22': abril22,
      'mayo22': mayo22,
      'junio22': junio22,
      'julio22': julio22,
      'agosto22': agosto22,
      'septiembre22': septiembre22,
      'octubre22': octubre22,
      'noviembre22': noviembre22,
      'diciembre22': diciembre22,
      'cincoMil': cincoMil,
      'd0422_1': d0422_1,
      'm0422_1': m0422_1,
      'd0422_2': d0422_2,
      'm0422_2': m0422_2,
      'd0422_E': d0422_E,
      'm0422_E': m0422_E,
      'd0522_1': d0522_1,
      'm0522_1': m0522_1,
      'd0522_2': d0522_2,
      'm0522_2': m0522_2,
      'd0522_E': d0522_E,
      'm0522_E': m0522_E,
      'd0622_1': d0622_1,
      'm0622_1': m0622_1,
      'd0622_2': d0622_2,
      'm0622_2': m0622_2,
      'd0622_E': d0622_E,
      'm0622_E': m0622_E,
      'd0722_1': d0722_1,
      'm0722_1': m0722_1,
      'd0722_2': d0722_2,
      'm0722_2': m0722_2,
      'd0722_E': d0722_E,
      'm0722_E': m0722_E,
      'd0822_1': d0822_1,
      'm0822_1': m0822_1,
      'd0822_2': d0822_2,
      'm0822_2': m0822_2,
      'd0822_E': d0822_E,
      'm0822_E': m0822_E,
      'd0922_1': d0922_1,
      'm0922_1': m0922_1,
      'd0922_2': d0922_2,
      'm0922_2': m0922_2,
      'd0922_E': d0922_E,
      'm0922_E': m0922_E,
      'd1022_1': d1022_1,
      'm1022_1': m1022_1,
      'd1022_2': d1022_2,
      'm1022_2': m1022_2,
      'd1022_E': d1022_E,
      'm1022_E': m1022_E,
      'd1122_1': d1122_1,
      'm1122_1': m1122_1,
      'd1122_2': d1122_2,
      'm1122_2': m1122_2,
      'd1122_E': d1122_E,
      'm1122_E': m1122_E,
      'd1222_1': d1222_1,
      'm1222_1': m1222_1,
      'd1222_2': d1222_2,
      'm1222_2': m1222_2,
      'd1222_E': d1222_E,
      'm1222_E': m1222_E,
      'd_solicitante': d_solicitante,
      'd_fecha': d_fecha,
      'd_Wbe': d_Wbe,
      'd_comentario': d_comentario,
      'd_entrega': d_entrega,
      'campo1': campo1,
      'campo2': campo2,
      'iD': iD,
      'actualizado': actualizado,
    };
  }

  factory TablaPlanSingle.fromMap(Map<String, dynamic> map) {
    return TablaPlanSingle(
      codigo: map['codigo'].toString().replaceAll(',', ''),
      solicitud: map['solicitud'].toString().replaceAll(',', ''),
      proyecto: map['proyecto'].toString().replaceAll(',', ''),
      uEjecutora: map['uejecutora'].toString().replaceAll(',', ''),
      pm: map['pm'].toString().replaceAll(',', ''),
      gestor: map['gestor'].toString().replaceAll(',', ''),
      pdi: map['pdi'].toString().replaceAll(',', ''),
      e4e: map['e4e'].toString().replaceAll(',', ''),
      desccripcion: map['desccripcion'].toString().replaceAll(',', ''),
      ubm: map['ubm'].toString().replaceAll(',', ''),
      a2022: map['2022'].toString().replaceAll(',', ''),
      a2023: map['2023'].toString().replaceAll(',', ''),
      m0122: map['01|22'].toString().replaceAll(',', ''),
      m0222: map['02|22'].toString().replaceAll(',', ''),
      m0322: map['03|22'].toString().replaceAll(',', ''),
      m0422: map['04|22'].toString().replaceAll(',', ''),
      m0522: map['05|22'].toString().replaceAll(',', ''),
      m0622: map['06|22'].toString().replaceAll(',', ''),
      m0722: map['07|22'].toString().replaceAll(',', ''),
      m0822: map['08|22'].toString().replaceAll(',', ''),
      m0922: map['09|22'].toString().replaceAll(',', ''),
      m1022: map['10|22'].toString().replaceAll(',', ''),
      m1122: map['11|22'].toString().replaceAll(',', ''),
      m1222: map['12|22'].toString().replaceAll(',', ''),
      m0123: map['01|23'].toString().replaceAll(',', ''),
      m0223: map['02|23'].toString().replaceAll(',', ''),
      m0323: map['03|23'].toString().replaceAll(',', ''),
      m0423: map['04|23'].toString().replaceAll(',', ''),
      m0523: map['05|23'].toString().replaceAll(',', ''),
      m0623: map['06|23'].toString().replaceAll(',', ''),
      m0723: map['07|23'].toString().replaceAll(',', ''),
      m0823: map['08|23'].toString().replaceAll(',', ''),
      m0923: map['09|23'].toString().replaceAll(',', ''),
      m1023: map['10|23'].toString().replaceAll(',', ''),
      m1123: map['11|23'].toString().replaceAll(',', ''),
      m1223: map['12|23'].toString().replaceAll(',', ''),
      a2024: map['2024'].toString().replaceAll(',', ''),
      m0124: map['01|24'].toString().replaceAll(',', ''),
      m0224: map['02|24'].toString().replaceAll(',', ''),
      m0324: map['03|24'].toString().replaceAll(',', ''),
      m0424: map['04|24'].toString().replaceAll(',', ''),
      m0524: map['05|24'].toString().replaceAll(',', ''),
      m0624: map['06|24'].toString().replaceAll(',', ''),
      m0724: map['07|24'].toString().replaceAll(',', ''),
      m0824: map['08|24'].toString().replaceAll(',', ''),
      m0924: map['09|24'].toString().replaceAll(',', ''),
      m1024: map['10|24'].toString().replaceAll(',', ''),
      m1124: map['11|24'].toString().replaceAll(',', ''),
      m1224: map['12|24'].toString().replaceAll(',', ''),
      a2025: map['2025'].toString().replaceAll(',', ''),
      m0125: map['01|25'].toString().replaceAll(',', ''),
      m0225: map['02|25'].toString().replaceAll(',', ''),
      m0325: map['03|25'].toString().replaceAll(',', ''),
      m0425: map['04|25'].toString().replaceAll(',', ''),
      m0525: map['05|25'].toString().replaceAll(',', ''),
      m0625: map['06|25'].toString().replaceAll(',', ''),
      m0725: map['07|25'].toString().replaceAll(',', ''),
      m0825: map['08|25'].toString().replaceAll(',', ''),
      m0925: map['09|25'].toString().replaceAll(',', ''),
      m1025: map['10|25'].toString().replaceAll(',', ''),
      m1125: map['11|25'].toString().replaceAll(',', ''),
      m1225: map['12|25'].toString().replaceAll(',', ''),
      observaciones: map['observaciones'].toString().replaceAll(',', ''),
      s_solicita: map['s_solicita'].toString().replaceAll(',', ''),
      s_comentario: map['s_comentario'].toString().replaceAll(',', ''),
      s_fecha: map['s_fecha'].toString().replaceAll(',', ''),
      s_estado: map['s_estado'].toString().replaceAll(',', ''),
      r_responde: map['r_responde'].toString().replaceAll(',', ''),
      r_comentario: map['r_comentario'].toString().replaceAll(',', ''),
      r_fecha: map['r_fecha'].toString().replaceAll(',', ''),
      r_estado: map['r_estado'].toString().replaceAll(',', ''),
      estado: map['estado'].toString().replaceAll(',', ''),
      circuito: map['circuito'].toString().replaceAll(',', ''),
      abril22: map['abril22'].toString().replaceAll(',', ''),
      mayo22: map['mayo22'].toString().replaceAll(',', ''),
      junio22: map['junio22'].toString().replaceAll(',', ''),
      julio22: map['julio22'].toString().replaceAll(',', ''),
      agosto22: map['agosto22'].toString().replaceAll(',', ''),
      septiembre22: map['septiembre22'].toString().replaceAll(',', ''),
      octubre22: map['octubre22'].toString().replaceAll(',', ''),
      noviembre22: map['noviembre22'].toString().replaceAll(',', ''),
      diciembre22: map['diciembre22'].toString().replaceAll(',', ''),
      cincoMil: map['cincomil'].toString().replaceAll(',', ''),
      d0422_1: map['d04|22-1'].toString().replaceAll(',', ''),
      m0422_1: map['04|22-1'].toString().replaceAll(',', ''),
      d0422_2: map['d04|22-2'].toString().replaceAll(',', ''),
      m0422_2: map['04|22-2'].toString().replaceAll(',', ''),
      d0422_E: map['d04|22-E'].toString().replaceAll(',', ''),
      m0422_E: map['04|22-E'].toString().replaceAll(',', ''),
      d0522_1: map['d05|22-1'].toString().replaceAll(',', ''),
      m0522_1: map['05|22-1'].toString().replaceAll(',', ''),
      d0522_2: map['d05|22-2'].toString().replaceAll(',', ''),
      m0522_2: map['05|22-2'].toString().replaceAll(',', ''),
      d0522_E: map['d05|22-E'].toString().replaceAll(',', ''),
      m0522_E: map['05|22-E'].toString().replaceAll(',', ''),
      d0622_1: map['d06|22-1'].toString().replaceAll(',', ''),
      m0622_1: map['06|22-1'].toString().replaceAll(',', ''),
      d0622_2: map['d06|22-2'].toString().replaceAll(',', ''),
      m0622_2: map['06|22-2'].toString().replaceAll(',', ''),
      d0622_E: map['d06|22-E'].toString().replaceAll(',', ''),
      m0622_E: map['06|22-E'].toString().replaceAll(',', ''),
      d0722_1: map['d07|22-1'].toString().replaceAll(',', ''),
      m0722_1: map['07|22-1'].toString().replaceAll(',', ''),
      d0722_2: map['d07|22-2'].toString().replaceAll(',', ''),
      m0722_2: map['07|22-2'].toString().replaceAll(',', ''),
      d0722_E: map['d07|22-E'].toString().replaceAll(',', ''),
      m0722_E: map['07|22-E'].toString().replaceAll(',', ''),
      d0822_1: map['d08|22-1'].toString().replaceAll(',', ''),
      m0822_1: map['08|22-1'].toString().replaceAll(',', ''),
      d0822_2: map['d08|22-2'].toString().replaceAll(',', ''),
      m0822_2: map['08|22-2'].toString().replaceAll(',', ''),
      d0822_E: map['d08|22-E'].toString().replaceAll(',', ''),
      m0822_E: map['08|22-E'].toString().replaceAll(',', ''),
      d0922_1: map['d09|22-1'].toString().replaceAll(',', ''),
      m0922_1: map['09|22-1'].toString().replaceAll(',', ''),
      d0922_2: map['d09|22-2'].toString().replaceAll(',', ''),
      m0922_2: map['09|22-2'].toString().replaceAll(',', ''),
      d0922_E: map['d09|22-E'].toString().replaceAll(',', ''),
      m0922_E: map['09|22-E'].toString().replaceAll(',', ''),
      d1022_1: map['d10|22-1'].toString().replaceAll(',', ''),
      m1022_1: map['10|22-1'].toString().replaceAll(',', ''),
      d1022_2: map['d10|22-2'].toString().replaceAll(',', ''),
      m1022_2: map['10|22-2'].toString().replaceAll(',', ''),
      d1022_E: map['d10|22-E'].toString().replaceAll(',', ''),
      m1022_E: map['10|22-E'].toString().replaceAll(',', ''),
      d1122_1: map['d11|22-1'].toString().replaceAll(',', ''),
      m1122_1: map['11|22-1'].toString().replaceAll(',', ''),
      d1122_2: map['d11|22-2'].toString().replaceAll(',', ''),
      m1122_2: map['11|22-2'].toString().replaceAll(',', ''),
      d1122_E: map['d11|22-E'].toString().replaceAll(',', ''),
      m1122_E: map['11|22-E'].toString().replaceAll(',', ''),
      d1222_1: map['d12|22-1'].toString().replaceAll(',', ''),
      m1222_1: map['12|22-1'].toString().replaceAll(',', ''),
      d1222_2: map['d12|22-2'].toString().replaceAll(',', ''),
      m1222_2: map['12|22-2'].toString().replaceAll(',', ''),
      d1222_E: map['d12|22-E'].toString().replaceAll(',', ''),
      m1222_E: map['12|22-E'].toString().replaceAll(',', ''),
      d_solicitante: map['d_solicitante'].toString().replaceAll(',', ''),
      d_fecha: map['d_fecha'].toString().replaceAll(',', ''),
      d_Wbe: map['d_Wbe'].toString().replaceAll(',', ''),
      d_comentario: map['d_comentario'].toString().replaceAll(',', ''),
      d_entrega: map['d_entrega'].toString().replaceAll(',', ''),
      campo1: map['campo1'].toString().replaceAll(',', ''),
      campo2: map['campo2'].toString().replaceAll(',', ''),
      iD: map['id'].toString().replaceAll(',', ''),
      actualizado: map['actualizado'].toString().replaceAll(',', ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory TablaPlanSingle.fromJson(String source) =>
      TablaPlanSingle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TablaPlanSingle(codigo: $codigo, solicitud: $solicitud, proyecto: $proyecto, uEjecutora: $uEjecutora, pm: $pm, gestor: $gestor, pdi: $pdi, e4e: $e4e, desccripcion: $desccripcion, ubm: $ubm, a2022: $a2022, a2023: $a2023, m0122: $m0122, m0222: $m0222, m0322: $m0322, m0422: $m0422, m0522: $m0522, m0622: $m0622, m0722: $m0722, m0822: $m0822, m0922: $m0922, m1022: $m1022, m1122: $m1122, m1222: $m1222, m0123: $m0123, m0223: $m0223, m0323: $m0323, m0423: $m0423, m0523: $m0523, m0623: $m0623, m0723: $m0723, m0823: $m0823, m0923: $m0923, m1023: $m1023, m1123: $m1123, m1223: $m1223, a2024: $a2024, m0124: $m0124, m0224: $m0224, m0324: $m0324, m0424: $m0424, m0524: $m0524, m0624: $m0624, m0724: $m0724, m0824: $m0824, m0924: $m0924, m1024: $m1024, m1124: $m1124, m1224: $m1224, a2025: $a2025, m0125: $m0125, m0225: $m0225, m0325: $m0325, m0425: $m0425, m0525: $m0525, m0625: $m0625, m0725: $m0725, m0825: $m0825, m0925: $m0925, m1025: $m1025, m1125: $m1125, m1225: $m1225, observaciones: $observaciones, s_solicita: $s_solicita, s_comentario: $s_comentario, s_fecha: $s_fecha, s_estado: $s_estado, r_responde: $r_responde, r_comentario: $r_comentario, r_fecha: $r_fecha, r_estado: $r_estado, estado: $estado, circuito: $circuito, abril22: $abril22, mayo22: $mayo22, junio22: $junio22, julio22: $julio22, agosto22: $agosto22, septiembre22: $septiembre22, octubre22: $octubre22, noviembre22: $noviembre22, diciembre22: $diciembre22, cincoMil: $cincoMil, d0422_1: $d0422_1, m0422_1: $m0422_1, d0422_2: $d0422_2, m0422_2: $m0422_2, d0422_E: $d0422_E, m0422_E: $m0422_E, d0522_1: $d0522_1, m0522_1: $m0522_1, d0522_2: $d0522_2, m0522_2: $m0522_2, d0522_E: $d0522_E, m0522_E: $m0522_E, d0622_1: $d0622_1, m0622_1: $m0622_1, d0622_2: $d0622_2, m0622_2: $m0622_2, d0622_E: $d0622_E, m0622_E: $m0622_E, d0722_1: $d0722_1, m0722_1: $m0722_1, d0722_2: $d0722_2, m0722_2: $m0722_2, d0722_E: $d0722_E, m0722_E: $m0722_E, d0822_1: $d0822_1, m0822_1: $m0822_1, d0822_2: $d0822_2, m0822_2: $m0822_2, d0822_E: $d0822_E, m0822_E: $m0822_E, d0922_1: $d0922_1, m0922_1: $m0922_1, d0922_2: $d0922_2, m0922_2: $m0922_2, d0922_E: $d0922_E, m0922_E: $m0922_E, d1022_1: $d1022_1, m1022_1: $m1022_1, d1022_2: $d1022_2, m1022_2: $m1022_2, d1022_E: $d1022_E, m1022_E: $m1022_E, d1122_1: $d1122_1, m1122_1: $m1122_1, d1122_2: $d1122_2, m1122_2: $m1122_2, d1122_E: $d1122_E, m1122_E: $m1122_E, d1222_1: $d1222_1, m1222_1: $m1222_1, d1222_2: $d1222_2, m1222_2: $m1222_2, d1222_E: $d1222_E, m1222_E: $m1222_E, d_solicitante: $d_solicitante, d_fecha: $d_fecha, d_Wbe: $d_Wbe, d_comentario: $d_comentario, d_entrega: $d_entrega, campo1: $campo1, campo2: $campo2, iD: $iD, actualizado: $actualizado)';
  }

  @override
  bool operator ==(covariant TablaPlanSingle other) {
    if (identical(this, other)) return true;

    return other.codigo == codigo &&
        other.solicitud == solicitud &&
        other.proyecto == proyecto &&
        other.uEjecutora == uEjecutora &&
        other.pm == pm &&
        other.gestor == gestor &&
        other.pdi == pdi &&
        other.e4e == e4e &&
        other.desccripcion == desccripcion &&
        other.ubm == ubm &&
        other.a2022 == a2022 &&
        other.a2023 == a2023 &&
        other.m0122 == m0122 &&
        other.m0222 == m0222 &&
        other.m0322 == m0322 &&
        other.m0422 == m0422 &&
        other.m0522 == m0522 &&
        other.m0622 == m0622 &&
        other.m0722 == m0722 &&
        other.m0822 == m0822 &&
        other.m0922 == m0922 &&
        other.m1022 == m1022 &&
        other.m1122 == m1122 &&
        other.m1222 == m1222 &&
        other.m0123 == m0123 &&
        other.m0223 == m0223 &&
        other.m0323 == m0323 &&
        other.m0423 == m0423 &&
        other.m0523 == m0523 &&
        other.m0623 == m0623 &&
        other.m0723 == m0723 &&
        other.m0823 == m0823 &&
        other.m0923 == m0923 &&
        other.m1023 == m1023 &&
        other.m1123 == m1123 &&
        other.m1223 == m1223 &&
        other.a2024 == a2024 &&
        other.m0124 == m0124 &&
        other.m0224 == m0224 &&
        other.m0324 == m0324 &&
        other.m0424 == m0424 &&
        other.m0524 == m0524 &&
        other.m0624 == m0624 &&
        other.m0724 == m0724 &&
        other.m0824 == m0824 &&
        other.m0924 == m0924 &&
        other.m1024 == m1024 &&
        other.m1124 == m1124 &&
        other.m1224 == m1224 &&
        other.a2025 == a2025 &&
        other.m0125 == m0125 &&
        other.m0225 == m0225 &&
        other.m0325 == m0325 &&
        other.m0425 == m0425 &&
        other.m0525 == m0525 &&
        other.m0625 == m0625 &&
        other.m0725 == m0725 &&
        other.m0825 == m0825 &&
        other.m0925 == m0925 &&
        other.m1025 == m1025 &&
        other.m1125 == m1125 &&
        other.m1225 == m1225 &&
        other.observaciones == observaciones &&
        other.s_solicita == s_solicita &&
        other.s_comentario == s_comentario &&
        other.s_fecha == s_fecha &&
        other.s_estado == s_estado &&
        other.r_responde == r_responde &&
        other.r_comentario == r_comentario &&
        other.r_fecha == r_fecha &&
        other.r_estado == r_estado &&
        other.estado == estado &&
        other.circuito == circuito &&
        other.abril22 == abril22 &&
        other.mayo22 == mayo22 &&
        other.junio22 == junio22 &&
        other.julio22 == julio22 &&
        other.agosto22 == agosto22 &&
        other.septiembre22 == septiembre22 &&
        other.octubre22 == octubre22 &&
        other.noviembre22 == noviembre22 &&
        other.diciembre22 == diciembre22 &&
        other.cincoMil == cincoMil &&
        other.d0422_1 == d0422_1 &&
        other.m0422_1 == m0422_1 &&
        other.d0422_2 == d0422_2 &&
        other.m0422_2 == m0422_2 &&
        other.d0422_E == d0422_E &&
        other.m0422_E == m0422_E &&
        other.d0522_1 == d0522_1 &&
        other.m0522_1 == m0522_1 &&
        other.d0522_2 == d0522_2 &&
        other.m0522_2 == m0522_2 &&
        other.d0522_E == d0522_E &&
        other.m0522_E == m0522_E &&
        other.d0622_1 == d0622_1 &&
        other.m0622_1 == m0622_1 &&
        other.d0622_2 == d0622_2 &&
        other.m0622_2 == m0622_2 &&
        other.d0622_E == d0622_E &&
        other.m0622_E == m0622_E &&
        other.d0722_1 == d0722_1 &&
        other.m0722_1 == m0722_1 &&
        other.d0722_2 == d0722_2 &&
        other.m0722_2 == m0722_2 &&
        other.d0722_E == d0722_E &&
        other.m0722_E == m0722_E &&
        other.d0822_1 == d0822_1 &&
        other.m0822_1 == m0822_1 &&
        other.d0822_2 == d0822_2 &&
        other.m0822_2 == m0822_2 &&
        other.d0822_E == d0822_E &&
        other.m0822_E == m0822_E &&
        other.d0922_1 == d0922_1 &&
        other.m0922_1 == m0922_1 &&
        other.d0922_2 == d0922_2 &&
        other.m0922_2 == m0922_2 &&
        other.d0922_E == d0922_E &&
        other.m0922_E == m0922_E &&
        other.d1022_1 == d1022_1 &&
        other.m1022_1 == m1022_1 &&
        other.d1022_2 == d1022_2 &&
        other.m1022_2 == m1022_2 &&
        other.d1022_E == d1022_E &&
        other.m1022_E == m1022_E &&
        other.d1122_1 == d1122_1 &&
        other.m1122_1 == m1122_1 &&
        other.d1122_2 == d1122_2 &&
        other.m1122_2 == m1122_2 &&
        other.d1122_E == d1122_E &&
        other.m1122_E == m1122_E &&
        other.d1222_1 == d1222_1 &&
        other.m1222_1 == m1222_1 &&
        other.d1222_2 == d1222_2 &&
        other.m1222_2 == m1222_2 &&
        other.d1222_E == d1222_E &&
        other.m1222_E == m1222_E &&
        other.d_solicitante == d_solicitante &&
        other.d_fecha == d_fecha &&
        other.d_Wbe == d_Wbe &&
        other.d_comentario == d_comentario &&
        other.d_entrega == d_entrega &&
        other.campo1 == campo1 &&
        other.campo2 == campo2 &&
        other.iD == iD &&
        other.actualizado == actualizado;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        solicitud.hashCode ^
        proyecto.hashCode ^
        uEjecutora.hashCode ^
        pm.hashCode ^
        gestor.hashCode ^
        pdi.hashCode ^
        e4e.hashCode ^
        desccripcion.hashCode ^
        ubm.hashCode ^
        a2022.hashCode ^
        a2023.hashCode ^
        m0122.hashCode ^
        m0222.hashCode ^
        m0322.hashCode ^
        m0422.hashCode ^
        m0522.hashCode ^
        m0622.hashCode ^
        m0722.hashCode ^
        m0822.hashCode ^
        m0922.hashCode ^
        m1022.hashCode ^
        m1122.hashCode ^
        m1222.hashCode ^
        m0123.hashCode ^
        m0223.hashCode ^
        m0323.hashCode ^
        m0423.hashCode ^
        m0523.hashCode ^
        m0623.hashCode ^
        m0723.hashCode ^
        m0823.hashCode ^
        m0923.hashCode ^
        m1023.hashCode ^
        m1123.hashCode ^
        m1223.hashCode ^
        a2024.hashCode ^
        m0124.hashCode ^
        m0224.hashCode ^
        m0324.hashCode ^
        m0424.hashCode ^
        m0524.hashCode ^
        m0624.hashCode ^
        m0724.hashCode ^
        m0824.hashCode ^
        m0924.hashCode ^
        m1024.hashCode ^
        m1124.hashCode ^
        m1224.hashCode ^
        a2025.hashCode ^
        m0125.hashCode ^
        m0225.hashCode ^
        m0325.hashCode ^
        m0425.hashCode ^
        m0525.hashCode ^
        m0625.hashCode ^
        m0725.hashCode ^
        m0825.hashCode ^
        m0925.hashCode ^
        m1025.hashCode ^
        m1125.hashCode ^
        m1225.hashCode ^
        observaciones.hashCode ^
        s_solicita.hashCode ^
        s_comentario.hashCode ^
        s_fecha.hashCode ^
        s_estado.hashCode ^
        r_responde.hashCode ^
        r_comentario.hashCode ^
        r_fecha.hashCode ^
        r_estado.hashCode ^
        estado.hashCode ^
        circuito.hashCode ^
        abril22.hashCode ^
        mayo22.hashCode ^
        junio22.hashCode ^
        julio22.hashCode ^
        agosto22.hashCode ^
        septiembre22.hashCode ^
        octubre22.hashCode ^
        noviembre22.hashCode ^
        diciembre22.hashCode ^
        cincoMil.hashCode ^
        d0422_1.hashCode ^
        m0422_1.hashCode ^
        d0422_2.hashCode ^
        m0422_2.hashCode ^
        d0422_E.hashCode ^
        m0422_E.hashCode ^
        d0522_1.hashCode ^
        m0522_1.hashCode ^
        d0522_2.hashCode ^
        m0522_2.hashCode ^
        d0522_E.hashCode ^
        m0522_E.hashCode ^
        d0622_1.hashCode ^
        m0622_1.hashCode ^
        d0622_2.hashCode ^
        m0622_2.hashCode ^
        d0622_E.hashCode ^
        m0622_E.hashCode ^
        d0722_1.hashCode ^
        m0722_1.hashCode ^
        d0722_2.hashCode ^
        m0722_2.hashCode ^
        d0722_E.hashCode ^
        m0722_E.hashCode ^
        d0822_1.hashCode ^
        m0822_1.hashCode ^
        d0822_2.hashCode ^
        m0822_2.hashCode ^
        d0822_E.hashCode ^
        m0822_E.hashCode ^
        d0922_1.hashCode ^
        m0922_1.hashCode ^
        d0922_2.hashCode ^
        m0922_2.hashCode ^
        d0922_E.hashCode ^
        m0922_E.hashCode ^
        d1022_1.hashCode ^
        m1022_1.hashCode ^
        d1022_2.hashCode ^
        m1022_2.hashCode ^
        d1022_E.hashCode ^
        m1022_E.hashCode ^
        d1122_1.hashCode ^
        m1122_1.hashCode ^
        d1122_2.hashCode ^
        m1122_2.hashCode ^
        d1122_E.hashCode ^
        m1122_E.hashCode ^
        d1222_1.hashCode ^
        m1222_1.hashCode ^
        d1222_2.hashCode ^
        m1222_2.hashCode ^
        d1222_E.hashCode ^
        m1222_E.hashCode ^
        d_solicitante.hashCode ^
        d_fecha.hashCode ^
        d_Wbe.hashCode ^
        d_comentario.hashCode ^
        d_entrega.hashCode ^
        campo1.hashCode ^
        campo2.hashCode ^
        iD.hashCode ^
        actualizado.hashCode;
  }
}
