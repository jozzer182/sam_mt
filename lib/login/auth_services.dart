// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translator/translator.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:v_al_sam_v02/user/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? errorCall;
  String? errorPassworReset;
  final translator = GoogleTranslator();

  Future login(String email, String password, BuildContext context) async {
    errorCall = null;
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      var translation =
          await translator.translate(e.message.toString(), to: 'es');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(translation.toString()),
          backgroundColor: Colors.orange));
      errorCall = translation.toString();
    } catch (e) {
      // print(e);
    }
  }

  Future register({
    required String email,
    required String password,
    required String nombre,
    required String telefono,
    required String empresa,
    required String perfil,
    required BuildContext context,
    required String pdi,
  }) async {
    errorCall = null;

    UserCredential userCredential;
    return await firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      value.user!.updateDisplayName(nombre);
      const JsonEncoder encoder = JsonEncoder();
      final data = {
        'telefono': telefono,
        'empresa': empresa,
        'pdi': pdi,
        'perfil': perfil,
      };
      final String jsonString = encoder.convert(data);
      // print(jsonString);
      await value.user!.updatePhotoURL(jsonString);
      await _registerOnUsersSheet(
        email: email.toLowerCase(),
        password: password,
        nombre: nombre,
        telefono: telefono,
        empresa: empresa,
        perfil: perfil,
        context: context,
        pdi: pdi,
      );
      return value.user;
    }).onError((FirebaseAuthException e, stackTrace) async {
      var translation =
          await translator.translate(e.message.toString(), to: 'es');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(translation.toString()),
          backgroundColor: Colors.orange));
      errorCall = translation.toString();
    });
  }

  Future _registerOnUsersSheet({
    required String email,
    required String password,
    required String nombre,
    required String telefono,
    required String empresa,
    required String perfil,
    required BuildContext context,
    required String pdi,
  }) async {
    var dataSend = {
      'dataReq': {
        "libro": "USERS",
        "hoja": "users",
        'map': {
          'correo': email,
          'nombre': nombre,
          'telefono': telefono,
          'empresa': empresa,
          'pdi': pdi,
          'perfil': perfil,
          // 'nombrecorto': pdi.nombrecorto,
        }
      },
      'fname': 'addMap'
    };
    // print(jsonEncode(dataSend));
    try {
      final response = await http.post(
        Api.sam,
        body: jsonEncode(dataSend),
      );
      // print('response ${response.body}');
      var dataAsListMap;
      if (response.statusCode == 302) {
        var response2 =
            await http.get(Uri.parse(response.headers["location"] ?? ''));
        dataAsListMap = jsonDecode(response2.body);
      } else {
        dataAsListMap = jsonDecode(response.body);
      }
      // print(dataAsListMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(dataAsListMap), backgroundColor: Colors.green));
      context.read<MainBloc>().add(
            LoadData(),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  Future<void> updateUser(
      String pdi, User user, String empresa, BuildContext context) async {
    const JsonEncoder encoder = JsonEncoder();
    final data = {
      'telefono': user.telefono,
      'empresa': user.empresa,
      'pdi': pdi,
      'perfil': user.perfil,
    };
    final String jsonString = encoder.convert(data);
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(jsonString);

    var dataSend = {
      'dataReq': {
        "libro": "USERS",
        "hoja": "users",
        'map': {
          'id': user.id,
          'correo': user.correo,
          'nombre': user.nombre,
          'telefono': user.telefono,
          'empresa': user.empresa,
          'pdi': pdi,
          'perfil': user.perfil,
          // 'nombrecorto': pdi.nombrecorto,
        }
      },
      'fname': 'updateMap'
    };
    // print(jsonEncode(dataSend));
    try {
      final response = await http.post(
        Api.sam,
        body: jsonEncode(dataSend),
      );
      // print('response ${response.body}');
      var dataAsListMap;
      if (response.statusCode == 302) {
        var response2 =
            await http.get(Uri.parse(response.headers["location"] ?? ''));
        dataAsListMap = jsonDecode(response2.body);
      } else {
        dataAsListMap = jsonDecode(response.body);
      }
      // print(dataAsListMap);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(dataAsListMap), backgroundColor: Colors.green));
      context.read<MainBloc>().add(
            LoadData(),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  Future<void> passwordReset(
      {required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      var translation =
          await translator.translate(e.message.toString(), to: 'es');
      errorPassworReset = translation.toString();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()), backgroundColor: Colors.orange));
    }
  }

  Future<void> singOut() async {
    await firebaseAuth.signOut();
  }
}
