import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:http/http.dart';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../perfiles/model/perfiles_model.dart';
import '../../user/user_model.dart';
import '../model/users_model.dart';

class UsersCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  UsersCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    Users users = Users();
    try {
      // print('onLoadLm');
      Map<String, Object> dataSend = {
        'dataReq': {'hoja': 'users'},
        'fname': "getMainData",
      };
      final response = await post(
        Api.sam,
        body: jsonEncode(dataSend),
      );
      var dataAsListMap;
      dataAsListMap = jsonDecode(response.body);

      // print('dataAsListMap from users: $dataAsListMap');
      for (var item in dataAsListMap) {
        users.usersList.add(User.fromMap(item));
      }
      emit(state().copyWith(users: users));
      // print('users: ${state().users?.usersList}');
    } catch (e) {
      bl.errorCarga('Users', e);
    }
  }

  get onCreateUser async {
    try {
      User user = state().users!.usersList.firstWhere(
        (e) => e.correo == FirebaseAuth.instance.currentUser!.email,
        orElse: User.fromInit,
      );
      List<PerfilesSingle> perfiles = state().perfiles!.perfilesList;
      user.permisos =
          perfiles
              .where((e) => e.perfil.toLowerCase() == user.perfil.toLowerCase())
              .map((e) => e.permiso.toLowerCase())
              .toList();
      // print('user: $user');
      emit(state().copyWith(user: user));
      // print('user from state: ${state().user}');
      await Future.delayed(Duration(milliseconds: 50));
    } catch (e) {
      bl.errorCarga('User Creation', e);
    }
  }
}
