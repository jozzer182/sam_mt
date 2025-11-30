import 'dart:convert';
import 'package:v_al_sam_v02/resources/constant/apis.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../models/mm60_b.dart';
import '../../user/user_model.dart';
import '../model/nuevoingreso_model.dart';

class NuevoIngresoCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  NuevoIngresoCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear async {
    try {
      NuevoIngresoB nuevoIngresoB = NuevoIngresoB();
      // nuevoIngresoB.crear(state().user!);
      nuevoIngresoB.nuevoIngresoList = List.generate(
        3,
        (index) => NuevoIngresoBSingle.fromIndex(index + 1),
      );
      nuevoIngresoB.encabezado = NuevoIngresoBEncabezado.fromInit(
        state().user!,
      );
      emit(state().copyWith(nuevoIngresoB: nuevoIngresoB));
      await Future.delayed(Duration(milliseconds: 50));
      // print('nuevoIngresoB: ${state().nuevoIngresoB}');
    } catch (e) {
      bl.errorCarga('Nuevo Ingreso', e);
    }
  }

  bool validarCampos() {
    NuevoIngresoB nuevoIngresoB = state().nuevoIngresoB!;
    List<dynamic>? ref1;
    List faltantes = [];
    Color r = Colors.red;
    NuevoIngresoBEncabezado e = nuevoIngresoB.encabezado;
    if (e.codigo_massyError == r) faltantes.add('Código Massy');
    if (e.soporte_iError == r) faltantes.add('Soporte de Entrega');
    for (var reg in nuevoIngresoB.nuevoIngresoList) {
      String f = 'Item: ${reg.item} =>';
      if (reg.e4eError == r) f += ' E4e,';
      if (reg.ctdError == r) f += ' Ctd,';
      if (f != 'Item: ${reg.item} =>') faltantes.add(f);
    }
    if (faltantes.isNotEmpty) {
      faltantes.insert(
        0,
        'Por favor revise los siguientes campos en la planilla, para poder realizar el guardado:',
      );
      ref1 = faltantes;
    } else {
      ref1 = null;
    }
    if (ref1 != null) {
      bl.mensajeFlotante(message: ref1.join('\n'));
      return false;
    } else {
      return true;
    }
  }

  enviar() async {
    bl.startLoading;
    NuevoIngresoB nuevoIngresoB = state().nuevoIngresoB!;
    User user = state().user!;
    List<Map> list = [];
    for (var material in nuevoIngresoB.nuevoIngresoList) {
      list.add({...material.toMap(), ...nuevoIngresoB.encabezado.toMap()});
    }
    var dataSend = {
      'dataReq': {'pdi': user.pdi, 'vals': list, 'hoja': 'ingresos'},
      'fname': "addRows",
    };
    try {
      var response = await post(
        Uri.parse(
          Api.samString,
        ),
        body: jsonEncode(dataSend),
      );
      var respuesta = jsonDecode(response.body) ?? ['error', 'error'];
      // print(respuesta);
      if (respuesta is List) {
        respuesta =
            'Se han agregado ${respuesta[0]} registros con el pedido ${respuesta[1]}';
      } else {
        print(respuesta);
      }

      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: respuesta ?? 'Error en el envío');
    } catch (e) {
      bl.errorCarga('Nuevo Ingreso', e);
    }
    bl.stopLoading;
  }

  modifyList({required String index, required String method}) {
    switch (method) {
      case 'agregar':
        agregar;
        break;
      case 'eliminar':
        eliminar;
        break;
      case 'resize':
        resize(index);
        break;
      default:
        break;
    }
    emit(state().copyWith());
  }

  get agregar {
    NuevoIngresoB nuevoIngresoB = state().nuevoIngresoB!;
    nuevoIngresoB.nuevoIngresoList.add(
      NuevoIngresoBSingle.fromIndex(nuevoIngresoB.nuevoIngresoList.length + 1),
    );
  }

  get eliminar {
    NuevoIngresoB nuevoIngresoB = state().nuevoIngresoB!;
    nuevoIngresoB.nuevoIngresoList.removeLast();
  }

  resize(String index) {
    NuevoIngresoB nuevoIngresoB = state().nuevoIngresoB!;
    index = index.isEmpty ? '1' : index;
    int size = int.parse(index);
    nuevoIngresoB.nuevoIngresoList.clear();
    nuevoIngresoB.nuevoIngresoList.length = 0;
    nuevoIngresoB.nuevoIngresoList = List.generate(
      size,
      (i) => NuevoIngresoBSingle.fromIndex(i + 1),
    );
  }

  cambiarCamposLista({required int index, String? e4e, String? ctd_e}) {
    var ref = state().nuevoIngresoB!.nuevoIngresoList[index];
    if (e4e != null) {
      Mm60B mm60B = state().mm60B!;
      String newE4e = e4e.toUpperCase();
      Mm60SingleB mm60Encontrado = mm60B.mm60List.firstWhere(
        (e) => e.material.contains(newE4e),
        orElse:
            () => Mm60SingleB(
              material: 'material',
              precio: 'precio',
              descripcion: 'No encontrado',
              ultima_m: 'modif',
              tpmt: 'tpmt',
              grupo: '',
              um: 'na',
              mon: 'mon',
              actualizado: '',
            ),
      );
      ref.e4e = newE4e;
      ref.descripcion = mm60Encontrado.descripcion;
      ref.um = mm60Encontrado.um;
    }
    if (ctd_e != null) ref.ctd = ctd_e;

    emit(state().copyWith());
  }

  cambiarEncabezado({
    required String valor,
    required String campo,
  }) {
    var ref = state().nuevoIngresoB!.encabezado;
    if (campo == "codigo_massy") ref.codigo_massy = valor;
    if (campo == "soporte_i") ref.soporte_i = valor;
    if (campo == "comentario") ref.comentario_i = valor;
    if (campo == "fecha_i") ref.fecha_i = valor;
    emit(state().copyWith());
  }
}
