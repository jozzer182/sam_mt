import 'package:async/async.dart';

import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../../../fechas_fem/model/fechasfem_model.dart';
import '../../../../mm60/model/mm60_model.dart';
import '../../../ficha_ficha/model/ficha_reg/reg.dart';
import '../../ficha/model/ficha_model.dart';

class Fichas {
  List<Ficha> f2025 = [];
  List<Ficha> f2026 = [];
  List<Ficha> f2027 = [];
  List<Ficha> f2028 = [];

  List<FichaReg> f2025Raw = [];
  List<FichaReg> f2026Raw = [];
  List<FichaReg> f2027Raw = [];
  List<FichaReg> f2028Raw = [];

  Future<void> crear({
    // required Fem fem,
    required Mm60 mm60,
    // required Budget budgetAll,
    // required Versiones versiones,
    // required Disponibilidad disponibilidad,
    required Bl bl,
    required FechasFEM fechasFEM,
  }) async {
    List<List<FichaReg>> femList = [f2025Raw, f2026Raw, f2027Raw, f2028Raw];
    List<List<Ficha>> fichasList = [f2025, f2026, f2027, f2028];
    // List<List<VersionesSingle>> versionList = [
    //   versiones.v2023,
    //   versiones.v2024,
    //   versiones.v2025,
    //   versiones.v2026,
    //   versiones.v2027,
    //   versiones.v2028,
    // ];
    FutureGroup futureGroup = FutureGroup();
    for (int i = 0; i < femList.length; i++) {
      Map proyectosUnicos = {};
      for (FichaReg e in femList[i]) {
        if (proyectosUnicos[e.proyecto] == null) {
          proyectosUnicos[e.proyecto] = {'proyecto': e.proyecto};
        }
      }
      futureGroup.add(
        Future.delayed(
          Duration.zero,
          () => agregarFichasALista(
            proyectos: proyectosUnicos.keys.map((e) => e.toString()).toList(),
            fichasList: fichasList,
            femList: femList,
            // versionList: versionList,
            i: i,
            mm60: mm60,
            // budgetAll: budgetAll,
            // disponibilidad: disponibilidad,
            bl: bl,
            fechasFEM: fechasFEM,
          ),
        ),
      );
    }
    futureGroup.close();
    await futureGroup.future;
    // print('fichas: ${fichas.length}');
  }

  Future agregarFichasALista({
    required List<String> proyectos,
    required List<List<Ficha>> fichasList,
    required List<List<FichaReg>> femList,
    // required List<List<VersionesSingle>> versionList,
    required int i,
    required Mm60 mm60,
    // required Budget budgetAll,
    // required Disponibilidad disponibilidad,
    required Bl bl,
    required FechasFEM fechasFEM,
  }) async {
    var emit = bl.emit;
    MainState Function() state = bl.state;
    for (String proyecto in proyectos) {
      await Future.delayed(const Duration(milliseconds: 1));
      fichasList[i].add(
        Ficha(
          // version: versionList[i]
          //     .where((e) => e.proyecto.toLowerCase() == proyecto.toLowerCase())
          //     .toList(),
          ficha:
              femList[i]
                  .where(
                    (e) => e.proyecto.toLowerCase() == proyecto.toLowerCase(),
                  )
                  .toList(),
          mm60: mm60,
          // budgetAll: budgetAll,
          year: 2023 + i,
          // disponibilidad: disponibilidad,
          fechasFEM: fechasFEM,
        ),
      );
    }
    emit(state().copyWith(porcentajecarga: 25 + state().porcentajecarga));
  }
}
