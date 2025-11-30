import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/people_model.dart';

class PeopleCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  PeopleCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    PeopleModel peopleB = PeopleModel();
    try {
      Map<String, Object> dataSend = {
        'dataReq': {'hoja': 'people'},
        'fname': "getMainData",
      };
      final response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      var dataAsListMap;

      dataAsListMap = jsonDecode(response.body);

      for (var item in dataAsListMap) {
        peopleB.people.add(PeopleBSingle.fromMap(item));
      }

      emit(state().copyWith(peopleB: peopleB));
    } catch (e) {
      bl.errorCarga("People", e);
    }
  }
}
