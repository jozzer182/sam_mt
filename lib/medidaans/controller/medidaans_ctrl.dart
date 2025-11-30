import 'package:statistics/statistics.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../conciliacion/model/conciliacion_model.dart';
import '../../mm60/model/mm60_model.dart';
import '../../registros/model/resgistros_b.dart';
import '../../resources/dias_habiles_colombia.dart';
import '../model/medidaans_model.dart';

class MedidaansCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  MedidaansCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear async {
    MedidaAns medidaAns = MedidaAns();
    try {
      final registrosB = state().registrosB!;
      final mm60 = state().mm60!;
      final conciliaciones = state().conciliaciones!;
      List<ResgistroSingle> registrosConciliacion = [];
      registrosConciliacion =
          registrosB.registrosList
              .where(
                (e) =>
                    e.est_sap_au.isNotEmpty &&
                    e.est_oficial == "reintegrado"
                &&
                e.est_contrato == "Borrador",
              )
              .toList();
      for (ResgistroSingle registro in registrosConciliacion) {
        String conciliacion =
            registro.est_sap_ma.isNotEmpty
                ? registro.est_sap_ma
                : registro.est_sap_au;
        Conciliacion ultimaConciliacion = Conciliacion.anulada();
        if (conciliaciones.conciliacionesList
                .where((e) => e.conciliacion == conciliacion)
                .isNotEmpty &&
            conciliacion.isNotEmpty) {
          ultimaConciliacion =
              conciliaciones.conciliacionesList
                  .where((e) => e.conciliacion == conciliacion)
                  .last;
        }
        Mm60Single mm60Registro = mm60.mm60List.firstWhere(
          (e) => e.material == registro.e4e,
          orElse: () => Mm60Single.fromInit(),
        );
        double valor =
            double.parse(registro.ctd_e) * double.parse(mm60Registro.precio);
        DateTime fechaentrega = DateTime.parse(registro.fecha_e);
        DateTime fechacargaarchivos = DateTime.parse(registro.fecha_sap_au);
        int tiempo1 = fechacargaarchivos.difference(fechaentrega).inDays;
        if (tiempo1 < 0) {
          tiempo1 = 0;
        } else {
          tiempo1 = DiasHabilesColombia.calcularDiasHabiles(
            fechaentrega,
            fechacargaarchivos,
          );
        }
        int? tiempo2;
        if (registro.fecha_sap_ma.isNotEmpty && registro.fecha_sap.isNotEmpty) {
          DateTime fechaaprobado = DateTime.parse(registro.fecha_sap_ma);
          DateTime fechacargascm = DateTime.parse(registro.fecha_sap);
          tiempo2 = fechacargascm.difference(fechaaprobado).inDays;
          if (tiempo2 < 0) {
            tiempo2 = 0;
          } else {
            tiempo2 = DiasHabilesColombia.calcularDiasHabiles(
              fechaaprobado,
              fechacargascm,
            );
          }
        }
        bool validezEstado =
            (ultimaConciliacion.estado == "aprobado" &&
                registro.fecha_sap_ma.isNotEmpty) ||
            (ultimaConciliacion.estado == "carga scm" &&
                registro.fecha_sap.isNotEmpty) ||
            (ultimaConciliacion.estado == "carga archivos" &&
                registro.fecha_sap_au.isNotEmpty);
        if (validezEstado) {
          medidaAns.medidaAnsList.add(
            MedidaAnsSingle(
              conciliacion: conciliacion,
              estado: ultimaConciliacion.estado,
              personacontrato: ultimaConciliacion.personacontrato,
              personaenel: ultimaConciliacion.personaenel,
              balance: registro.lm,
              fechabalance: registro.fecha_conciliacion,
              planilla: registro.odm,
              lcl: registro.lcl,
              lm: ultimaConciliacion.lm,
              nodo: registro.nodo,
              cto: registro.circuito,
              e4e: registro.e4e,
              descripcion: mm60Registro.descripcion,
              ctd: registro.ctd_e,
              um: mm60Registro.um,
              valor: valor.toInt().toString(),
              fechaentrega: registro.fecha_e,
              fechacargaarchivos: registro.fecha_sap_au,
              fechaaprobado: registro.fecha_sap_ma,
              fechacargascm: registro.fecha_sap,
              tiempo1: tiempo1.toString(),
              tiempo2:
                  tiempo2 == null
                      ? "Pendiente aprobado o carga scm"
                      : tiempo2.toString(),
              tiempototal:
                  tiempo2 == null ? "<--" : (tiempo1 + tiempo2).toString(),
            ),
          );
        }
      }
      medidaAns.medidaAnsListSearch = medidaAns.medidaAnsList;
      if (medidaAns.medidaAnsList
          .where((e) => e.tiempototal != "<--")
          .isNotEmpty) {
        medidaAns.fechaInicio = medidaAns.medidaAnsList
            .where((e) => e.tiempototal != "<--")
            .map((e) => DateTime.parse(e.fechacargascm))
            .reduce(
              (value, element) => value.isBefore(element) ? value : element,
            );
        medidaAns.fechaFin = medidaAns.medidaAnsList
            .where((e) => e.tiempototal != "<--")
            .map((e) => DateTime.parse(e.fechacargascm))
            .reduce(
              (value, element) => value.isAfter(element) ? value : element,
            );
        calcular(medidaAns: medidaAns);
      }
      emit(state().copyWith(medidaAns: medidaAns));
      await Future.delayed(Duration(milliseconds: 50));
      // print('matno: ${state().matno}');
    } catch (e) {
      bl.errorCarga('Medida Ans', e);
    }
  }

  calcular({MedidaAns? medidaAns}) {
    medidaAns ??= state().medidaAns!;
    medidaAns.distribucion = [];
    List<double> numeros =
        medidaAns.medidaAnsList
            .where(
              (e) =>
                  e.tiempototal != "<--" &&
                  DateTime.parse(e.fechacargascm).isAfter(
                    medidaAns!.fechaInicio.subtract(Duration(days: 1)),
                  ) &&
                  DateTime.parse(
                    e.fechacargascm,
                  ).isBefore(medidaAns.fechaFin.add(Duration(days: 1))),
            ) // Para que incluya el último día en el cálculo
            .map((e) => double.parse(e.tiempototal))
            .toList();
    Statistics<double> estadisticasNoCero = numeros.statistics;
    medidaAns.max = estadisticasNoCero.max;
    medidaAns.min = estadisticasNoCero.min;
    medidaAns.mean = estadisticasNoCero.mean;
    medidaAns.standardDeviation = estadisticasNoCero.standardDeviation;
    medidaAns.sum = estadisticasNoCero.sum.toDouble();
    medidaAns.center = estadisticasNoCero.center;
    medidaAns.median = estadisticasNoCero.median.toDouble();
    medidaAns.variance =
        numeros
            .map(
              (numero) =>
                  (numero - medidaAns!.mean) * (numero - medidaAns.mean),
            )
            .reduce((a, b) => a + b) /
        numeros.length;
    medidaAns.mode = modaCalc(numeros).toDouble();
    medidaAns.count = numeros.length;
    Map<String, int> conteo = {};
    for (double numero in numeros) {
      conteo[numero.toInt().toString()] =
          (conteo[numero.toInt().toString()] ?? 0) + 1;
    }
    conteo.forEach((key, value) {
      medidaAns!.distribucion.add(
        DistribucionSingle(dias: int.parse(key), cantidad: value),
      );
    });
    medidaAns.distribucion.sort((a, b) => a.dias.compareTo(b.dias));
    // print(distribucion);
  }

  setDates({required DateTime startDate, required DateTime endDate}) async {
    try {
      MedidaAns medidaAns = state().medidaAns!;
      medidaAns.fechaInicio = startDate;
      medidaAns.fechaFin = endDate;
      calcular(medidaAns: medidaAns);
      emit(state().copyWith(medidaAns: medidaAns));
    } catch (e) {
      emit(
        state().copyWith(
          errorCounter: state().errorCounter + 1,
          message:
              '🤕Error creando⚙️ la tabla de datos MedidaAns ⚠️$e => ${e.runtimeType}, intente recargar la página🔄, total errores: ${state().errorCounter + 1}',
        ),
      );
    }
  }
}
