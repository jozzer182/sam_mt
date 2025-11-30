// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ProyectosB {
//   List<ProyectosBSingle> proyectos = [];
  
//   Future<List<ProyectosBSingle>> obtener() async {
//     var dataSend = {
//       'dataReq': {'hoja': 'proyectos'},
//       'fname': "getMainData"
//     };
//     final response = await http.post(
//       Uri.parse(
//           "https://script.google.com/macros/s/AKfycbx3CHLQGu7N9euquaTtKgPexhfcQ-F5qHiiBByvSsmuSSvvTjE/exec"),
//       body: jsonEncode(dataSend),
//     );
//     var dataAsListMap;
//     if (response.statusCode == 302) {
//       var response2 =
//           await http.get(Uri.parse(response.headers["location"] ?? ''));
//       dataAsListMap = jsonDecode(response2.body);
//     } else {
//       dataAsListMap = jsonDecode(response.body);
//     }
//     for (var item in dataAsListMap) {
//       proyectos.add(ProyectosBSingle.fromMap(item));
//     }
//     return proyectos;
//   }
  
//   @override
//   String toString() => 'ProyectosB(proyectos: $proyectos)';
// }



// class ProyectosBSingle {
//   String unidad;
//   String proyecto;
//   ProyectosBSingle({
//     required this.unidad,
//     required this.proyecto,
//   });
  

//   Map<String, dynamic> toMap() {
//     return {
//       'unidad': unidad,
//       'proyecto': proyecto,
//     };
//   }

//   factory ProyectosBSingle.fromMap(Map<String, dynamic> map) {
//     return ProyectosBSingle(
//       unidad: map['unidad'] ?? '',
//       proyecto: map['proyecto'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ProyectosBSingle.fromJson(String source) => ProyectosBSingle.fromMap(json.decode(source));
// }