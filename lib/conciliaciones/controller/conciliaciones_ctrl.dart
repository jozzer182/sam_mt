import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../conciliacion/model/conciliacion_model.dart';
import '../model/conciliaciones_model.dart';

class ConciliacionesCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ConciliacionesCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }
  get obtener async {
    Conciliaciones conciliaciones = Conciliaciones();
    try {
      conciliaciones.conciliacionesList.clear();
      conciliaciones.conciliacionesListSearch.clear();
      var dataSend = {
        'dataReq': {
          'pdi': state().user?.pdi ?? 'TEST',
          'hoja': 'conciliaciones',
        },
        'fname': "getHoja",
      };
      // print(jsonEncode(dataSend));
      final response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      var dataAsListMap = jsonDecode(response.body);
      for (var item in dataAsListMap) {
        // print(item);
        conciliaciones.conciliacionesList.add(Conciliacion.fromMap(item));
        conciliaciones.conciliacionesListSearch.add(Conciliacion.fromMap(item));
      }

      _procesarConciliaciones(conciliaciones);

      emit(state().copyWith(conciliaciones: conciliaciones));
      // print('onLoadConciliaciones: ${state().conciliaciones!.conciliacionesList.length}');
    } catch (e) {
      bl.errorCarga('Conciliaciones', e);
    }
  }

  /// Procesa los datos de conciliaciones para crear listas únicas y establecer estados
  void _procesarConciliaciones(Conciliaciones conciliaciones) {
    List<Map> unique = [];
    for (Conciliacion dato in conciliaciones.conciliacionesList) {
      if (unique.isEmpty) {
        unique.add({
          'lcl': dato.lcl,
          'conciliacion': dato.conciliacion,
          'estado': dato.estado,
          'nodo': dato.nodo,
          'personaenel': dato.personaenel,
          'proyecto': dato.proyecto,
        });
      } else {
        bool existe = false;
        for (var item in unique) {
          if (item['lcl'] == dato.lcl &&
              item['conciliacion'] == dato.conciliacion) {
            existe = true;
          }
        }
        if (!existe) {
          unique.add({
            'lcl': dato.lcl,
            'conciliacion': dato.conciliacion,
            'estado': dato.estado,
            'nodo': dato.nodo,
            'personaenel': dato.personaenel,
            'proyecto': dato.proyecto,
          });
        }
      }
    }
    for (Map uniq in unique) {
      List<Conciliacion> listaConciliaciones =
          conciliaciones.conciliacionesList
              .where(
                (e) =>
                    e.lcl == uniq['lcl'] &&
                    e.conciliacion == uniq['conciliacion'],
              )
              .toList();
      Conciliacion conciliacionSeleccionada = listaConciliaciones.last;
      uniq['estado'] =
          conciliacionSeleccionada.estado == 'aprobado'
              ? 'aprobado (pendiente carga scm)'
              : conciliacionSeleccionada.estado;
    }
    conciliaciones.conciliacionesEstadoList =
        unique
            .map(
              (e) => ConciliacionEstado(
                lcl: e['lcl'],
                conciliacion: e['conciliacion'],
                estado: e['estado'],
                nodo: e['nodo'],
                personaenel: e['personaenel'],
                proyecto: e['proyecto'],
              ),
            )
            .toList();
    conciliaciones.conciliacionesEstadoListSearch = [
      ...conciliaciones.conciliacionesEstadoList,
    ];
  }

  seleccionarConciliacion(Conciliacion conciliacion) {
    emit(state().copyWith(conciliacion: conciliacion));
  }
}
