import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:v_al_sam_v02/resources/constant/apis.dart';

class Pedido {
  Uri get url => Api.sam;
  
  Future<String> getPed({required String pdi, required String hoja}) async {
    Map<String, Object> dataSend = {
      'dataReq': {'pdi': pdi, 'hoja': hoja},
      'fname': "getLastPed"
    };
    var response = await http.post(url, body: jsonEncode(dataSend));
    // String data = jsonDecode(response.body).toString();
    var data = (await redirectHandler(response)).toString();
    return data;
  }

  var redirectHandler = (http.Response response) async {
    var data;
    if (response.statusCode == 302) {
      var response2 =
          await http.get(Uri.parse(response.headers["location"] ?? ''));
      data = jsonDecode(response2.body);
    } else {
      // print('response.statusCode = ${response.statusCode}');
      data = jsonDecode(response.body);
      // print('data = $data');
    }
    return data;
  };
}
