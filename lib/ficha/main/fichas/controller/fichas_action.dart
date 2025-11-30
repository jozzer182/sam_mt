import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../bloc/main__bl.dart';
import '../../../../bloc/main_bloc.dart';
import '../../../../resources/constant/apis.dart';
import '../../../../resources/future_group_add.dart';
import '../../../ficha_ficha/model/ficha_reg/reg.dart';
import '../model/fichas_model.dart';
import '../../ficha/model/ficha_enum.dart';
import '../../ficha/model/ficha_model.dart';

class FichasController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  FichasController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    bl.startLoading;
    Fichas fichas = Fichas();
    // emit(state().copyWith(fichas: fichas));
    FutureGroupDelayed futureGroupFEM = FutureGroupDelayed();

    List<String> years = ["2025", "2026", "2027", "2028"];
    for (String year in years) {
      futureGroupFEM.addF(_obtenerFicha('f$year', fichas));
    }
    futureGroupFEM.close();
    try {
      await futureGroupFEM.future.whenComplete(() {
        emit(state().copyWith(fichas: fichas));
      });
      // print(state().fichas!.f2024Raw);
    } catch (e) {
      bl.errorCarga("Fichas", e);
    }
    // bl.stopLoading;
  }

  Future _obtenerFicha(String year, Fichas fichas) async {
    try {
      SupabaseClient supabaseClient = SupabaseClient(
        Api.femSamSupUrlNew,
        Api.femSamSupKeyNew,
      );
      PostgrestList dataAsListMap = [];
      bool error = true;

      try {
        dataAsListMap =
            await supabaseClient
                .from(year) // Tabla para sustitutos
                .select();
        error = false;
      } catch (e) {
        bl.mensaje(
          message: "Obtener Ficha $year 1ER intento ($e)",
          messageColor: Colors.green,
        );
        try {
          await Future.delayed(const Duration(seconds: 2));
          dataAsListMap =
              await supabaseClient
                  .from(year) // Tabla para sustitutos
                  .select();
          error = false;
        } catch (e) {
          bl.mensaje(
            message: "Obtener Ficha $year 2DO intento ($e)",
            messageColor: Colors.orange,
          );
          try {
            await Future.delayed(const Duration(seconds: 5));
            dataAsListMap =
                await supabaseClient
                    .from(year) // Tabla para sustitutos
                    .select();
            error = false;
          } catch (e) {
            bl.mensaje(
              message: "Obtener Ficha $year 3ER intento ($e)",
              messageColor: Colors.red,
            );
            await Future.delayed(const Duration(seconds: 7));
            dataAsListMap =
                await supabaseClient
                    .from(year) // Tabla para sustitutos
                    .select();
            error = false;
          }
        }
      }

      if (error) {
        bl.errorCarga("Obtener Ficha $year", "Error al obtener datos de $year");
      } else {
        List<FichaReg> ficha = fichas.f2025Raw;

        if (year == "f2025") ficha = fichas.f2025Raw;
        if (year == "f2026") ficha = fichas.f2026Raw;
        if (year == "f2027") ficha = fichas.f2027Raw;
        if (year == "f2028") ficha = fichas.f2028Raw;

        String pdiUsuario = state().user!.pdi.toUpperCase();

        if (dataAsListMap.isNotEmpty) {
          for (Map<String, dynamic> item in dataAsListMap) {
            if (item['pdi'] != null &&
                item['pdi'].toString().toUpperCase().contains(pdiUsuario)) {
              FichaReg singleFEM = FichaReg.fromMap(item);
              ficha.add(singleFEM);
            }
          }
          ficha.sort((a, b) {
            int projectCompare = a.proyecto.compareTo(b.proyecto);
            if (projectCompare != 0) return projectCompare;
            return a.e4e.compareTo(b.e4e);
          });
        }
      }
    } catch (e) {
      bl.errorCarga('FEM ficha del $year', e);
    }
  }

  Future<void> get onCrearFichas async {
    var emit = bl.emit;
    MainState Function() state = bl.state;
    Fichas fichas = state().fichas!;
    try {
      await fichas.crear(
        // fem: state().fem!,
        mm60: state().mm60!,
        // budgetAll: state().budget!,
        // versiones: state().versiones!,
        // disponibilidad: state().disponibilidad!,
        bl: bl,
        fechasFEM: state().fechasFEM!,
      );
      emit(state().copyWith(fichas: fichas));
    } catch (e) {
      bl.errorCarga("Fichas", e);
    }
  }

  onSeleccionarYear({required String year}) {
    try {
      emit(state().copyWith(year: year));
    } catch (e) {
      bl.mensaje(
        message:
            '🤕Error seleccionando año ⚠️$e => ${e.runtimeType},' +
            'intente recargar la página🔄',
      );
    }
  }

  onSeleccionarFicha({required Ficha ficha}) {
    try {
      emit(state().copyWith(ficha: ficha));
    } catch (e) {
      bl.mensaje(
        message: '🤕Error seleccionando ficha ⚠️$e => ${e.runtimeType}',
      );
    }
  }

  onCambiarFicha({
    required CampoFicha campo,
    required String valor,
    required int item,
  }) async {
    Ficha ficha = state().ficha!;
    // ficha.asignar(
    //   valor: valor,
    //   item: item,
    //   campo: campo,
    // );
    //esperar 100 milisegundos
    await Future.delayed(const Duration(milliseconds: 100), () {
      emit(state().copyWith(ficha: ficha));
    });
  }
}
