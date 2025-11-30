// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';

// var data = jsonDecode(FirebaseAuth.instance.currentUser!.photoURL ?? ' ');

// class PersonDataModel {
//   String nombre;
//   String telefono;
//   String empresa;
//   String perfil;
//   String pdi;
//   PersonDataModel({
//     required this.nombre,
//     required this.telefono,
//     required this.empresa,
//     required this.perfil,
//     required this.pdi,
//   });
// }

// class PersonData {
//   String nombre =
//       FirebaseAuth.instance.currentUser?.displayName ?? 'Problema conexión';
//   String telefono = jsonDecode(FirebaseAuth.instance.currentUser?.photoURL ??
//           '{"telefono": "x"}')['telefono'] ??
//       '';
//   String empresa = jsonDecode(FirebaseAuth.instance.currentUser?.photoURL ??
//           '{"empresa": "x"}')['empresa'] ??
//       '';
//   String perfil = jsonDecode(FirebaseAuth.instance.currentUser?.photoURL ??
//           '{"perfil": "Enel"}')['perfil'] ??
//       '';
//   String pdi = (jsonDecode(FirebaseAuth.instance.currentUser?.photoURL ??
//                   '{"perfil": "Enel"}')['perfil'] ==
//               'Enel'
//           ? 'DR20039364'
//           : jsonDecode(FirebaseAuth.instance.currentUser?.photoURL ??
//               '{"pdi": "DR20039364"}')['pdi']) ??
//       '';
// }
