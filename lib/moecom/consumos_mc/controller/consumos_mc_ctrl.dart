import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../../../aportacion/model/aportacion_model.dart';
import '../../../bloc/main__bl.dart';
import '../../../bloc/main_bloc.dart';
import '../../../inventario/model/inventario_model.dart';
import '../../../mb52/mb52_b.dart';
import '../../../models/mm60_b.dart';
import '../../../resources/a_entero_2.dart';
import '../../entregas_mc/model/entregas_mc_list_model.dart';
import '../../entregas_mc/model/entregas_mc_reg_model.dart';
import '../model/consumos_mc_list.dart';
import '../model/consumos_mc_reg.dart';

class ConsumosMcCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ConsumosMcCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    ConsumosMcList planillasMcList = ConsumosMcList();
    String pdi = state().user?.pdi ?? '';

    final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

    try {
      // final supabase = Supabase.instance.client;
      final dataAsListMap = await supabase.from('${pdi}_planillas_mc').select();
      if (dataAsListMap.isNotEmpty) {
        for (var item in dataAsListMap) {
          planillasMcList.list.add(ConsumoMc.fromMap(item));
        }
      }
      //sort by pedido, largest to smallest
      planillasMcList.list.sort((a, b) {
        return b.pedido.compareTo(a.pedido);
      });

      emit(state().copyWith(consumosMcList: planillasMcList));
    } catch (e) {
      bl.errorCarga('Consumos MC', e);
    }
  }

  get crearNuevo {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    planillasMcList.listEdit = List.generate(
      3,
      (index) => ConsumoMc.fromInit(index + 1),
    );
    planillasMcList.edit = false;
    emit(state().copyWith(consumosMcList: planillasMcList));
    obtenerNumPedido();
    evaluateRules();
  }

  cargarPedido(pedido) {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    //como copia no referencia
    planillasMcList.listEdit =
        planillasMcList.list
            .where((e) => e.pedido == pedido)
            .map((e) => ConsumoMc.fromMap(e.toMap()))
            .toList();
    //agregar indice
    for (int i = 0; i < planillasMcList.listEdit.length; i++) {
      planillasMcList.listEdit[i].index = i + 1;
    }
    planillasMcList.edit = true;
    emit(state().copyWith(consumosMcList: planillasMcList));
    evaluateRules();
  }

  get agregarfila {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    if (planillasMcList.listEdit.isEmpty) {
      bl.errorCarga('Consumos MC', 'No hay datos para agregar una fila nueva');
      return;
    }
    ConsumoMc lastRow = planillasMcList.listEdit.last;
    ConsumoMc newRow = ConsumoMc.fromInit(lastRow.index + 1);
    planillasMcList.listEdit.add(newRow);
    emit(state().copyWith(consumosMcList: planillasMcList));
    evaluateRules();
  }

  get eliminarFila {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    if (planillasMcList.listEdit.isEmpty) {
      bl.errorCarga('Consumos MC', 'No hay datos para eliminar una fila');
      return;
    }
    if (planillasMcList.listEdit.length == 1) {
      bl.errorCarga('Consumos MC', 'No se puede eliminar la última fila');
      return;
    }
    planillasMcList.listEdit.removeLast();
    emit(state().copyWith(consumosMcList: planillasMcList));
    evaluateRules();
  }

  cambiarEncabezado({required String valor, required String campo}) {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    ConsumoMc ref = planillasMcList.listEdit[0];
    if (campo == 'pedido') ref.pedido = valor;
    if (campo == 'consecutivo') ref.consecutivo = valor;
    if (campo == 'fecha') ref.fecha = valor;
    if (campo == 'almacenista') ref.almacenista = valor;
    if (campo == 'tel') ref.tel = valor;
    if (campo == 'soporte') ref.soporte = valor;
    if (campo == 'item') ref.item = valor;
    if (campo == 'tdc') ref.tdc = valor;
    if (campo == 'ticket') ref.ticket = valor;
    if (campo == 'e4e') ref.e4e = valor;
    if (campo == 'descripcion') ref.descripcion = valor;
    if (campo == 'um') ref.um = valor;
    if (campo == 'ctd') ref.ctd = valor;
    if (campo == 'reportado') ref.reportado = valor;
    if (campo == 'comentario') ref.comentario = valor;
    if (campo == 'anuladonombre') ref.anuladonombre = valor;
    if (campo == 'anuladocorreo') ref.anuladocorreo = valor;
    if (campo == 'estado') ref.estado = valor;
    if (campo == 'tipo') ref.tipo = valor;
    if (campo == 'actualizado') ref.actualizado = valor;
    // if (campo == 'tecnico') {
    //   ref.tecnico = valor;
    //   bool isInList = planillasMcList.list.any(
    //     (element) => element.tecnico == valor,
    //   );
    //   if (isInList) {
    //     ConsumoMc found = planillasMcList.list.lastWhere(
    //       (element) => element.tecnico == valor,
    //     );
    //     ref.tecnicotype = found.tecnicotype;
    //     ref.tecnicoid = found.tecnicoid;
    //   } else {
    //     EntregasMcList cargasMcList = state().entregasMcList!;
    //     bool isInListCargas = cargasMcList.list.any(
    //       (element) => element.tecnico == valor,
    //     );
    //     if (isInListCargas) {
    //       EntregaMc found = cargasMcList.list.lastWhere(
    //         (element) => element.tecnico == valor,
    //       );
    //       ref.tecnicotype = found.tecnicotype;
    //       ref.tecnicoid = found.tecnicoid;
    //     }
    //   }
    // }
    // if (campo == 'tecnicoid') {
    //   ref.tecnicoid = valor;
    //   bool isInList = planillasMcList.list.any(
    //     (element) => element.tecnicoid == valor,
    //   );
    //   if (isInList) {
    //     ConsumoMc found = planillasMcList.list.lastWhere(
    //       (element) => element.tecnicoid == valor,
    //     );
    //     ref.tecnicotype = found.tecnicotype;
    //     ref.tecnico = found.tecnico;
    //   } else {
    //     EntregasMcList cargasMcList = state().entregasMcList!;
    //     bool isInListCargas = cargasMcList.list.any(
    //       (element) => element.tecnicoid == valor,
    //     );
    //     if (isInListCargas) {
    //       EntregaMc found = cargasMcList.list.lastWhere(
    //         (element) => element.tecnicoid == valor,
    //       );
    //       ref.tecnicotype = found.tecnicotype;
    //       ref.tecnico = found.tecnico;
    //     }
    //   }
    // }
    // if (campo == 'tecnicotype') ref.tecnicotype = valor;
    emit(state().copyWith(consumosMcList: planillasMcList));
    evaluateRules();
  }

  cambiarList({
    required String valor,
    required String campo,
    required int index,
  }) {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    if (planillasMcList.listEdit.isEmpty) {
      bl.errorCarga('Consumos MC', 'No hay datos para cambiar');
      return;
    }
    ConsumoMc ref = planillasMcList.listEdit[index - 1];
    if (campo == 'e4e') {
      ref.e4e = valor;
      // if (ref.e4e.length == 6) {
      Mm60SingleB mm60 = state().mm60B!.mm60List.firstWhere(
        (element) => element.material.contains(ref.e4e),
        orElse: () => Mm60SingleB.fromInit(),
      );
      ref.descripcion = mm60.descripcion;
      ref.um = mm60.um;
      // }
    }
    if (campo == 'descripcion') ref.descripcion = valor;
    if (campo == 'um') ref.um = valor;
    if (campo == 'ctd') ref.ctd = valor;
    if (campo == 'tdc') ref.tdc = valor;
    if (campo == 'ticket') ref.ticket = valor;

    if (campo == 'comentario') ref.comentario = valor;
    if (campo == 'tecnicoid') {
      ref.tecnicoid = valor;
      bool isInList = planillasMcList.list.any(
        (element) => element.tecnicoid == valor,
      );
      if (isInList) {
        ConsumoMc found = planillasMcList.list.lastWhere(
          (element) => element.tecnicoid == valor,
        );
        ref.tecnicotype = found.tecnicotype;
        ref.tecnico = found.tecnico;
      } else {
        EntregasMcList cargasMcList = state().entregasMcList!;
        bool isInListCargas = cargasMcList.list.any(
          (element) => element.tecnicoid == valor,
        );
        if (isInListCargas) {
          EntregaMc found = cargasMcList.list.lastWhere(
            (element) => element.tecnicoid == valor,
          );
          ref.tecnicotype = found.tecnicotype;
          ref.tecnico = found.tecnico;
        }
      }
    }

    emit(state().copyWith(consumosMcList: planillasMcList));
    evaluateRules();
  }

  fillFields() {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    for (ConsumoMc ref in planillasMcList.listEdit) {
      Mm60SingleB mm60 = state().mm60B!.mm60List.firstWhere(
        (element) => element.material.contains(ref.e4e),
        orElse: () => Mm60SingleB.fromInit(),
      );
      ref.descripcion = mm60.descripcion;
      ref.um = mm60.um;
      bool isInList = planillasMcList.list.any(
        (element) => element.tecnicoid == ref.tecnicoid,
      );
      if (isInList) {
        ConsumoMc found = planillasMcList.list.lastWhere(
          (element) => element.tecnicoid == ref.tecnicoid,
        );
        ref.tecnicotype = found.tecnicotype;
        ref.tecnico = found.tecnico;
      } else {
        EntregasMcList cargasMcList = state().entregasMcList!;
        bool isInListCargas = cargasMcList.list.any(
          (element) => element.tecnicoid == ref.tecnicoid,
        );
        if (isInListCargas) {
          EntregaMc found = cargasMcList.list.lastWhere(
            (element) => element.tecnicoid == ref.tecnicoid,
          );
          ref.tecnicotype = found.tecnicotype;
          ref.tecnico = found.tecnico;
        }
      }
    }
    emit(state().copyWith(consumosMcList: planillasMcList));
  }

  evaluateRules() {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    ConsumoMc ref = planillasMcList.listEdit[0];
    //alwaysgreen
    ref.comentarioError = Colors.green;

    //rules encabezado
    if (ref.consecutivo.isEmpty) ref.consecutivoError = Colors.red;
    if (ref.consecutivo.isNotEmpty) ref.consecutivoError = Colors.green;
    if (ref.fecha.isEmpty) ref.fechaError = Colors.red;
    if (ref.fecha.isNotEmpty) ref.fechaError = Colors.green;
    if (ref.almacenista.isEmpty) ref.almacenistaError = Colors.red;
    if (ref.almacenista.isNotEmpty) ref.almacenistaError = Colors.green;
    if (ref.tel.isEmpty) ref.telError = Colors.red;
    if (ref.tel.isNotEmpty) ref.telError = Colors.green;
    if (ref.soporte.isEmpty) ref.soporteError = Colors.red;
    if (ref.soporte.isNotEmpty) ref.soporteError = Colors.green;

    if (ref.reportado.isEmpty) ref.reportadoError = Colors.red;
    if (ref.reportado.isNotEmpty) ref.reportadoError = Colors.green;
    if (ref.tipo.isEmpty) ref.tipoError = Colors.red;
    if (ref.tipo.isNotEmpty) ref.tipoError = Colors.green;

    //rules list
    for (ConsumoMc ref in planillasMcList.listEdit) {
      ref.tecnicotypeError = Colors.green;
      // if (ref.tecnicotype.isEmpty) ref.tecnicotypeError = Colors.red;
      ref.tecnicoError = Colors.green;
      // if (ref.tecnico.isEmpty) ref.tecnicoError = Colors.red;
      ref.tecnicoidError = Colors.green;
      // if (ref.tecnicoid.isEmpty || ref.tecnico.isEmpty) {
      //   ref.tecnicoidError = Colors.red;
      // }
      if (ref.tecnicoid.isEmpty) {
        ref.tecnicoidError = Colors.red;
      }
      ref.e4eError = Colors.green;
      if (ref.e4e.isEmpty || ref.e4e.length != 6) {
        ref.e4eError = Colors.red;
      }
      if (ref.descripcion.isEmpty) ref.descripcionError = Colors.red;
      if (ref.descripcion.isNotEmpty) ref.descripcionError = Colors.green;
      if (ref.um.isEmpty) ref.umError = Colors.red;
      if (ref.um.isNotEmpty) ref.umError = Colors.green;
      ref.ctdError = Colors.green;
      if (ref.ctd.isEmpty || ref.ctd == '0') {
        ref.ctdError = Colors.red;
      }
      ref.tdcError = Colors.green;
      ref.ticketError = Colors.green;
      if (ref.tdc.isEmpty && ref.ticket.isEmpty) {
        ref.tdcError = Colors.red;
        ref.ticketError = Colors.red;
      }
      if (ref.e4e.length == 6) {
        Mm60SingleB mm60 = state().mm60B!.mm60List.firstWhere(
          (element) => element.material == ref.e4e,
          orElse: () => Mm60SingleB.fromInit(),
        );
        if (mm60.material.isEmpty) {
          ref.e4eError = Colors.red;
        }
        ref.e4eInfo = '';
        //validar que no se repita misma tdc-e4e en consumos
        bool isInList = planillasMcList.list.any(
          (element) => element.tdc == ref.tdc && element.e4e == ref.e4e && element.estado == 'correcto',
        );
        if (isInList && !planillasMcList.edit) {
          ConsumoMc regi = planillasMcList.list.firstWhere(
            (element) => element.tdc == ref.tdc && element.e4e == ref.e4e && element.estado == 'correcto',
          );
          // si se repite, marcar error y agregar info de consecutivo
          ref.e4eError = Colors.red;
          ref.tdcError = Colors.red;
          ref.e4eInfo = '${ref.e4eInfo}[REPETIDO ${regi.consecutivo}] ';
        }
        bool isInThisList =
            planillasMcList.listEdit
                .where(
                  (element) => element.tdc == ref.tdc && element.e4e == ref.e4e,
                )
                .length >
            1;
        if (isInThisList) {
          ref.e4eError = Colors.red;
          ref.tdcError = Colors.red;
          ref.e4eInfo = '${ref.e4eInfo}[REPETIDO EN ESTA LISTA] ';
        }
        InventarioBSingle inventario = state().inventarioB!.inventarioList
            .firstWhere(
              (element) => element.e4e == ref.e4e,
              orElse: () => InventarioBSingle.fromInit(),
            );
        if (inventario.ctd == '0') {
          if (!planillasMcList.edit) {
            ref.e4eError = Colors.red;
          }
          ref.e4eInfo = '${ref.e4eInfo} [SIN INVENTARIO SAM] ';
        } else {
          ref.e4eInfo = '${ref.e4eInfo} [SAM: ${inventario.ctd}] ';
        }
        Mb52BSingle mb52B = state().mb52B!.mb52BList.firstWhere(
          (element) => element.material == ref.e4e,
          orElse: () => Mb52BSingle.fromInit(),
        );
        ref.e4eInfo = '${ref.e4eInfo} [MB52: ${mb52B.ctd}] ';

        AportacionSingle aportacion = state().aportacion!.aportacionList
            .firstWhere(
              (element) => element.e4e == ref.e4e,
              orElse: () => AportacionSingle.fromInit(),
            );
        if (aportacion.e4e.isNotEmpty) {
          ref.e4eError = Colors.red;
          ref.e4eInfo = '${ref.e4eInfo} [APORTACIÓN] ';
        }
      }
    }

    emit(state().copyWith(consumosMcList: planillasMcList));
  }

  obtenerNumPedido() async {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    ConsumoMc ref = planillasMcList.listEdit[0];
    //llamar a supabase solo para la columna pedido, tener en cuenta que pedido esta almacenado como BIGINT
    // por lo que la query podria ser solo el maximo de la columna pedido

    final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

    try {
      // final supabase = Supabase.instance.client;
      final response =
          await supabase
              .from('${state().user?.pdi}_planillas_mc')
              .select('pedido')
              .order('pedido', ascending: false)
              .limit(1)
              .maybeSingle();

      // Si encontramos un pedido, incrementarlo en 1
      if (response != null && response['pedido'] != null) {
        // Convertir a entero, sumar 1 y volver a convertir a String
        int ultimoPedido = int.tryParse(response['pedido'].toString()) ?? 0;
        int nuevoPedido = ultimoPedido + 1;
        ref.pedido = nuevoPedido.toString();
      } else {
        // Si no hay pedidos previos, empezar con el número 1
        ref.pedido = '4400001';
      }
      emit(state().copyWith(consumosMcList: planillasMcList));
    } catch (e) {
      // Si hay error al obtener el último pedido, comenzar con 1
      ref.pedido = '4400001';
      emit(state().copyWith(consumosMcList: planillasMcList));
      bl.errorCarga('Consumos MC', e);
    }
  }

  bool validarCampos() {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    List<dynamic>? ref1;
    List faltantes = [];
    Color r = Colors.red;
    ConsumoMc e = planillasMcList.listEdit[0];
    if (e.consecutivoError == r) faltantes.add('Consecutivo');
    if (e.soporteError == r) faltantes.add('Soporte');
    for (var reg in planillasMcList.listEdit) {
      String f = 'Item: ${reg.index} =>';
      if (reg.tecnicoError == r) f += ' Técnico,';
      if (reg.tecnicoidError == r) f += ' ID Técnico,';
      if (reg.tecnicotypeError == r) f += ' Tipo Técnico,';
      if (reg.tdcError == r) f += ' Tdc,';
      if (reg.ticketError == r) f += ' Ticket,';
      if (reg.e4eError == r) f += ' E4e,';
      if (reg.ctdError == r) f += ' Ctd,';
      if (f != 'Item: ${reg.index} =>') faltantes.add(f);
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

  get enviar async {
    bl.startLoading;
    ConsumosMcList planillasMcList = state().consumosMcList!;
    User user = state().user!;
    // replicar los valores de encabezado en cada fila de la lista
    for (ConsumoMc e in planillasMcList.listEdit) {
      e.item = e.index.toString();
      e.pedido = planillasMcList.listEdit.first.pedido;
      e.consecutivo = planillasMcList.listEdit.first.consecutivo;
      e.fecha = planillasMcList.listEdit.first.fecha;
      e.almacenista = '${user.nombre}(${user.correo})';
      e.tel = user.telefono;
      e.soporte = planillasMcList.listEdit.first.soporte;
      e.reportado = planillasMcList.listEdit.first.reportado;
      e.comentario = planillasMcList.listEdit.first.comentario;
      e.anuladonombre = planillasMcList.listEdit.first.anuladonombre;
      e.anuladocorreo = planillasMcList.listEdit.first.anuladocorreo;
      e.estado = planillasMcList.listEdit.first.estado;
      e.tipo = planillasMcList.listEdit.first.tipo;
      e.actualizado = planillasMcList.listEdit.first.actualizado;
      // e.tecnico = planillasMcList.listEdit.first.tecnico;
      // e.tecnicoid = planillasMcList.listEdit.first.tecnicoid;
      // e.tecnicotype = planillasMcList.listEdit.first.tecnicotype;
    } //Preparar data
    List<Map<String, dynamic>> planillasMcListMap =
        planillasMcList.listEdit
            .map((e) => e.toMap())
            .toList(); //remover actualizado que no es necesario para la operación
    for (Map<String, dynamic> carga in planillasMcListMap) {
      carga.remove('actualizado');
      if (carga['id'] == null || carga['id'].toString().isEmpty) {
        carga.remove('id'); // Eliminar el campo id para que se autogenere
      }
      if (carga['pedido'] == null || carga['pedido'].toString().isEmpty) {
        carga['pedido'] = 0; // Valor predeterminado si está vacío
      } else {
        carga['pedido'] = aEntero(carga['pedido'].toString());
      }
    }
    final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

    // final supabase = Supabase.instance.client;
    String tableName = '${state().user?.pdi}_planillas_mc';
    try {
      await supabase
          .from(tableName)
          .upsert(
            planillasMcListMap,
            onConflict: 'idnew',
            defaultToNull: false,
          );
      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: '¡Los datos se guardaron correctamente!');
    } catch (e) {
      bl.errorCarga('Consumos MC - Guardado', e);
    }
    bl.stopLoading;
  }

  get anular async {
    bl.startLoading;
    ConsumosMcList planillasMcList = state().consumosMcList!;
    User user = state().user!;
    // replicar los valores de encabezado en cada fila de la lista
    for (ConsumoMc e in planillasMcList.listEdit) {
      e.item = e.index.toString();
      e.reportado = DateTime.now().toString();
      e.comentario = planillasMcList.listEdit.first.comentario;
      e.anuladonombre = '${user.nombre}(${user.correo})';
      e.anuladocorreo = user.correo;
      e.estado = 'anulado';
    } //Preparar data
    List<Map<String, dynamic>> planillasMcListMap =
        planillasMcList.listEdit
            .map((e) => e.toMap())
            .toList(); //remover actualizado que no es necesario para la operación
    for (Map<String, dynamic> carga in planillasMcListMap) {
      carga.remove('actualizado');
      if (carga['id'] == null || carga['id'].toString().isEmpty) {
        carga.remove('id'); // Eliminar el campo id para que se autogenere
      }
      if (carga['pedido'] == null || carga['pedido'].toString().isEmpty) {
        carga['pedido'] = 0; // Valor predeterminado si está vacío
      } else {
        carga['pedido'] = aEntero(carga['pedido'].toString());
      }
    }
    final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

    // final supabase = Supabase.instance.client;
    String tableName = '${state().user?.pdi}_planillas_mc';
    try {
      await supabase.from(tableName).upsert(planillasMcListMap);
      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: '¡Los datos se guardaron correctamente!');
    } catch (e) {
      bl.errorCarga('Consumos MC - Anulado', e);
    }
    bl.stopLoading;
  }

  Future<bool> get validarDatosExcel async {
    final clipboardData = await Clipboard.getData('text/plain');
    String? data = clipboardData?.text;
    if (data == null) {
      bl.mensajeFlotante(message: 'No hay datos en el portapapeles');
      return false;
    }
    // RegExp numbersOnly = RegExp(r'^[0-9]+$');
    // if (!numbersOnly.hasMatch(data.replaceAll(RegExp(r'\s+'), ''))) {
    //   bl.mensajeFlotante(
    //     message:
    //         'Los datos del portapapeles no son válidos, solo se permiten números',
    //   );
    //   return false;
    // }
    // las columnas de la data deben ser solo dos
    final rows = data.split('\n').map((e) => e.trim()).toList();
    rows.removeWhere((e) => e.isEmpty);
    if (rows.isEmpty) {
      bl.mensajeFlotante(
        message: 'No hay datos en el portapapeles, filas vacías',
      );
      return false;
    }
    for (String row in rows) {
      List<String> columns = row.split('\t');
      if (columns.length != 5) {
        bl.mensajeFlotante(
          message:
              'Los datos del portapapeles no son válidos, solo se permiten cinco columnas\nhay ${columns.length} columnas',
        );
        return false;
      }
    }
    return true;
  }

  get pegarDatosExcel async {
    ConsumosMcList planillasMcList = state().consumosMcList!;
    ConsumoMc first = planillasMcList.listEdit[0].copyWith();
    planillasMcList.listEdit = [];
    emit(
      state().copyWith(consumosMcList: planillasMcList),
    ); //para que se limpie la vista
    await Future.delayed(Duration(milliseconds: 100));
    final clipboardData = await Clipboard.getData('text/plain');
    String? data = clipboardData?.text;
    if (data == null) {
      bl.mensajeFlotante(message: 'No hay datos en el portapapeles');
      return;
    }
    final rows = data.split('\n').map((e) => e.trim()).toList();
    rows.removeWhere((e) => e.isEmpty);
    planillasMcList.listEdit = List.generate(
      rows.length,
      (index) => ConsumoMc.fromInit(index + 1),
    );
    for (int i = 0; i < rows.length; i++) {
      List<String> columns = rows[i].split('\t');
      ConsumoMc planilla = planillasMcList.listEdit[i];
      planilla.tecnicoid = columns[0].toString();
      planilla.tdc = columns[1].toString();
      planilla.ticket = columns[2].toString();
      planilla.e4e = columns[3].toString();
      // Mm60SingleB mm60 = state().mm60B!.mm60List.firstWhere(
      //   (element) => element.material.contains(planilla.e4e),
      //   orElse: () => Mm60SingleB.fromInit(),
      // );
      // planilla.descripcion = mm60.descripcion;
      // planilla.um = mm60.um;
      planilla.ctd = columns[4].toString();
    }
    User user = state().user!;
    for (ConsumoMc e in planillasMcList.listEdit) {
      e.item = e.index.toString();
      e.pedido = first.pedido;
      e.consecutivo = first.consecutivo;
      e.fecha = first.fecha;
      e.almacenista = '${user.nombre}(${user.correo})';
      e.tel = user.telefono;
      e.soporte = first.soporte;
      e.reportado = first.reportado;
      e.comentario = first.comentario;
      e.anuladonombre = first.anuladonombre;
      e.anuladocorreo = first.anuladocorreo;
      e.estado = first.estado;
      e.tipo = first.tipo;
      e.actualizado = first.actualizado;
      // e.tecnico = first.tecnico;
      // e.tecnicoid = first.tecnicoid;
      // e.tecnicotype = first.tecnicotype;
    }
    fillFields();
    emit(state().copyWith(consumosMcList: planillasMcList));
    evaluateRules();
  }
}
