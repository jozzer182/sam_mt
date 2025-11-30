import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:v_al_sam_v02/moecom/entregas_mc/model/entregas_mc_list_model.dart';
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:v_al_sam_v02/resources/a_entero_2.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../../../aportacion/model/aportacion_model.dart';
import '../../../bloc/main__bl.dart';
import '../../../bloc/main_bloc.dart';
import '../../../inventario/model/inventario_model.dart';
import '../../../mb52/mb52_b.dart';
import '../../../models/mm60_b.dart';
import '../model/entregas_mc_reg_model.dart';

class EntregasMcCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  EntregasMcCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    EntregasMcList cargasMcList = EntregasMcList();
    String pdi = state().user?.pdi ?? '';

    final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

    try {
      // final supabase = Supabase.instance.client;
      final dataAsListMap = await supabase.from('${pdi}_carga_mc').select();
      if (dataAsListMap.isNotEmpty) {
        for (var item in dataAsListMap) {
          cargasMcList.list.add(EntregaMc.fromMap(item));
        }
      }
      //sort by pedido, largest to smallest
      cargasMcList.list.sort((a, b) {
        return b.pedido.compareTo(a.pedido);
      });

      emit(state().copyWith(entregasMcList: cargasMcList));
    } catch (e) {
      bl.errorCarga('Entregas MC', e);
    }
  }

  get crearNuevo {
    EntregasMcList cargasMcList = state().entregasMcList!;
    cargasMcList.listEdit = List.generate(
      3,
      (index) => EntregaMc.fromInit(index + 1),
    );
    emit(state().copyWith(entregasMcList: cargasMcList));
    obtenerNumPedido();
    evaluateRules();
  }

  cargarPedido(pedido) {
    EntregasMcList cargasMcList = state().entregasMcList!;
    //como copia no referencia
    cargasMcList.listEdit =
        cargasMcList.list
            .where((e) => e.pedido == pedido)
            .map((e) => EntregaMc.fromMap(e.toMap()))
            .toList();
    //agregar indice
    for (int i = 0; i < cargasMcList.listEdit.length; i++) {
      cargasMcList.listEdit[i].index = i + 1;
    }
    emit(state().copyWith(entregasMcList: cargasMcList));
    evaluateRules();
  }

  get agregarfila {
    EntregasMcList cargasMcList = state().entregasMcList!;
    if (cargasMcList.listEdit.isEmpty) {
      bl.errorCarga('Entregas MC', 'No hay datos para agregar una fila nueva');
      return;
    }
    EntregaMc lastRow = cargasMcList.listEdit.last;
    EntregaMc newRow = EntregaMc.fromInit(lastRow.index + 1);
    cargasMcList.listEdit.add(newRow);
    emit(state().copyWith(entregasMcList: cargasMcList));
    evaluateRules();
  }

  get eliminarFila {
    EntregasMcList cargasMcList = state().entregasMcList!;
    if (cargasMcList.listEdit.isEmpty) {
      bl.errorCarga('Cargas MC', 'No hay datos para eliminar una fila');
      return;
    }
    if (cargasMcList.listEdit.length == 1) {
      bl.errorCarga('Cargas MC', 'No se puede eliminar la última fila');
      return;
    }
    cargasMcList.listEdit.removeLast();
    emit(state().copyWith(entregasMcList: cargasMcList));
    evaluateRules();
  }

  cambiarEncabezado({required String valor, required String campo}) {
    EntregasMcList cargasMcList = state().entregasMcList!;
    EntregaMc ref = cargasMcList.listEdit[0];
    if (campo == 'pedido') ref.pedido = valor;
    if (campo == 'consecutivo') ref.consecutivo = valor;
    if (campo == 'fecha') ref.fecha = valor;
    if (campo == 'almacenista') ref.almacenista = valor;
    if (campo == 'tel') ref.tel = valor;
    if (campo == 'soporte') ref.soporte = valor;
    if (campo == 'item') ref.item = valor;
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
    if (campo == 'tecnico') {
      ref.tecnico = valor;
      bool isInList = cargasMcList.list.any(
        (element) => element.tecnico == valor,
      );
      if (isInList) {
        EntregaMc found = cargasMcList.list.lastWhere(
          (element) => element.tecnico == valor,
        );
        ref.tecnicotype = found.tecnicotype;
        ref.tecnicoid = found.tecnicoid;
      }
    }
    if (campo == 'tecnicoid') {
      ref.tecnicoid = valor;
      bool isInList = cargasMcList.list.any(
        (element) => element.tecnicoid == valor,
      );
      if (isInList) {
        EntregaMc found = cargasMcList.list.lastWhere(
          (element) => element.tecnicoid == valor,
        );
        ref.tecnicotype = found.tecnicotype;
        ref.tecnico = found.tecnico;
      }
    }
    if (campo == 'tecnicotype') ref.tecnicotype = valor;
    emit(state().copyWith(entregasMcList: cargasMcList));
    evaluateRules();
  }

  cambiarList({
    required String valor,
    required String campo,
    required int index,
  }) {
    EntregasMcList cargasMcList = state().entregasMcList!;
    if (cargasMcList.listEdit.isEmpty) {
      bl.errorCarga('Entregas MC', 'No hay datos para cambiar');
      return;
    }
    EntregaMc ref = cargasMcList.listEdit[index - 1];
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
    if (campo == 'ctd') {
      ref.ctd = valor;
    }
    if (campo == 'comentario') ref.comentario = valor;
    emit(state().copyWith(entregasMcList: cargasMcList));
    evaluateRules();
  }

  evaluateRules() {
    EntregasMcList cargasMcList = state().entregasMcList!;
    EntregaMc ref = cargasMcList.listEdit[0];
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
    if (ref.tecnico.isEmpty) ref.tecnicoError = Colors.red;
    if (ref.tecnico.isNotEmpty) ref.tecnicoError = Colors.green;
    if (ref.tecnicoid.isEmpty) ref.tecnicoidError = Colors.red;
    if (ref.tecnicoid.isNotEmpty) ref.tecnicoidError = Colors.green;
    if (ref.tipo.isEmpty) ref.tipoError = Colors.red;
    if (ref.tipo.isNotEmpty) ref.tipoError = Colors.green;
    if (ref.tecnicotype.isEmpty) ref.tecnicotypeError = Colors.red;
    if (ref.tecnicotype.isNotEmpty) ref.tecnicotypeError = Colors.green;

    //rules list
    for (EntregaMc ref in cargasMcList.listEdit) {
      ref.e4eError = Colors.green;
      if (ref.e4e.isEmpty || ref.e4e.length != 6) {
        ref.e4eError = Colors.red;
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
        InventarioBSingle inventario = state().inventarioB!.inventarioList
            .firstWhere(
              (element) => element.e4e == ref.e4e,
              orElse: () => InventarioBSingle.fromInit(),
            );
        if (inventario.ctd == '0') {
          ref.e4eError = Colors.red;
          ref.e4eInfo = '[SIN INVENTARIO SAM]${ref.e4eInfo}';
        } else {
          ref.e4eInfo = '[SAM: ${inventario.ctd}] ${ref.e4eInfo}';
        }
        Mb52BSingle mb52B = state().mb52B!.mb52BList.firstWhere(
          (element) => element.material == ref.e4e,
          orElse: () => Mb52BSingle.fromInit(),
        );
        ref.e4eInfo = '[MB52: ${mb52B.ctd}] ${ref.e4eInfo}';

        AportacionSingle aportacion = state().aportacion!.aportacionList
            .firstWhere(
              (element) => element.e4e == ref.e4e,
              orElse: () => AportacionSingle.fromInit(),
            );
        if (aportacion.e4e.isNotEmpty) {
          // ref.e4eError = Colors.red;
          ref.e4eInfo = '[APORTACIÓN] ${ref.e4eInfo}';
        }
      }
      if (ref.descripcion.isEmpty) ref.descripcionError = Colors.red;
      if (ref.descripcion.isNotEmpty) ref.descripcionError = Colors.green;
      if (ref.um.isEmpty) ref.umError = Colors.red;
      if (ref.um.isNotEmpty) ref.umError = Colors.green;
      ref.ctdError = Colors.green;
      if (ref.ctd.isEmpty || ref.ctd == '0') {
        ref.ctdError = Colors.red;
      }
    }

    emit(state().copyWith(entregasMcList: cargasMcList));
  }

  obtenerNumPedido() async {
    EntregasMcList cargasMcList = state().entregasMcList!;
    EntregaMc ref = cargasMcList.listEdit[0];
    //llamar a supabase solo para la columna pedido, tener en cuenta que pedido esta almacenado como BIGINT
    // por lo que la query podria ser solo el maximo de la columna pedido

    final supabase = SupabaseClient(Api.sapSupUrl, Api.sapSupKey);

    try {
      // final supabase = Supabase.instance.client;
      final response =
          await supabase
              .from('${state().user?.pdi}_carga_mc')
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
        ref.pedido = '3300001';
      }
      emit(state().copyWith(entregasMcList: cargasMcList));
    } catch (e) {
      // Si hay error al obtener el último pedido, comenzar con 1
      ref.pedido = '3300001';
      emit(state().copyWith(entregasMcList: cargasMcList));
      bl.errorCarga('Entregas MC', e);
    }
  }

  bool validarCampos() {
    EntregasMcList cargasMcList = state().entregasMcList!;
    List<dynamic>? ref1;
    List faltantes = [];
    Color r = Colors.red;
    EntregaMc e = cargasMcList.listEdit[0];
    if (e.consecutivoError == r) faltantes.add('Consecutivo');
    if (e.soporteError == r) faltantes.add('Soporte');
    if (e.tecnicoError == r) faltantes.add('Técnico');
    if (e.tecnicoidError == r) faltantes.add('ID Técnico');
    if (e.tecnicotypeError == r) faltantes.add('Tipo Técnico');
    for (var reg in cargasMcList.listEdit) {
      String f = 'Item: ${reg.index} =>';
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
    EntregasMcList cargasMcList = state().entregasMcList!;
    User user = state().user!;
    // replicar los valores de encabezado en cada fila de la lista
    for (EntregaMc e in cargasMcList.listEdit) {
      e.item = e.index.toString();
      e.pedido = cargasMcList.listEdit.first.pedido;
      e.consecutivo = cargasMcList.listEdit.first.consecutivo;
      e.fecha = cargasMcList.listEdit.first.fecha;
      e.almacenista = '${user.nombre}(${user.correo})';
      e.tel = user.telefono;
      e.soporte = cargasMcList.listEdit.first.soporte;
      e.reportado = cargasMcList.listEdit.first.reportado;
      e.comentario = cargasMcList.listEdit.first.comentario;
      e.anuladonombre = cargasMcList.listEdit.first.anuladonombre;
      e.anuladocorreo = cargasMcList.listEdit.first.anuladocorreo;
      e.estado = cargasMcList.listEdit.first.estado;
      e.tipo = cargasMcList.listEdit.first.tipo;
      e.actualizado = cargasMcList.listEdit.first.actualizado;
      e.tecnico = cargasMcList.listEdit.first.tecnico;
      e.tecnicoid = cargasMcList.listEdit.first.tecnicoid;
      e.tecnicotype = cargasMcList.listEdit.first.tecnicotype;
      // if (e.tipo == 'DESCARGA') {
      //   e.ctd =
      //       (-1 * aEntero(e.ctd))
      //           .toString(); // Para descargas, la cantidad es 0
      // }
    } //Preparar data
    List<Map<String, dynamic>> cargasMcListMap =
        cargasMcList.listEdit
            .map((e) => e.toMap())
            .toList(); //remover actualizado que no es necesario para la operación
    for (Map<String, dynamic> carga in cargasMcListMap) {
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
    String tableName = '${state().user?.pdi}_carga_mc';
    try {
      await supabase
          .from(tableName)
          .upsert(cargasMcListMap, onConflict: 'idnew', defaultToNull: false);
      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: '¡Los datos se guardaron correctamente!');
    } catch (e) {
      bl.errorCarga('Entregas MC - Guardado', e);
    }
    bl.stopLoading;
  }

  get anular async {
    bl.startLoading;
    EntregasMcList cargasMcList = state().entregasMcList!;
    User user = state().user!;
    // replicar los valores de encabezado en cada fila de la lista
    for (EntregaMc e in cargasMcList.listEdit) {
      e.item = e.index.toString();
      e.reportado = DateTime.now().toString();
      e.comentario = cargasMcList.listEdit.first.comentario;
      e.anuladonombre = '${user.nombre}(${user.correo})';
      e.anuladocorreo = user.correo;
      e.estado = 'anulado';
    } //Preparar data
    List<Map<String, dynamic>> cargasMcListMap =
        cargasMcList.listEdit
            .map((e) => e.toMap())
            .toList(); //remover actualizado que no es necesario para la operación
    for (Map<String, dynamic> carga in cargasMcListMap) {
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
    String tableName = '${state().user?.pdi}_carga_mc';
    try {
      await supabase.from(tableName).upsert(cargasMcListMap);
      add(LoadData());
      await Future.delayed(Duration(seconds: 2));
      bl.mensajeFlotante(message: '¡Los datos se guardaron correctamente!');
    } catch (e) {
      bl.errorCarga('Entregas MC - Anulado', e);
    }
    bl.stopLoading;
  }

  Future<bool> get validarDatosExcel async {
    final clipboardData = await Clipboard.getData('text/plain');
    String? data = clipboardData?.text;
    RegExp numbersOnly = RegExp(r'^[0-9]+$');
    if (data == null) {
      bl.mensajeFlotante(message: 'No hay datos en el portapapeles');
      return false;
    }
    if (!numbersOnly.hasMatch(data.replaceAll(RegExp(r'\s+'), ''))) {
      bl.mensajeFlotante(
        message:
            'Los datos del portapapeles no son válidos, solo se permiten números',
      );
      return false;
    }
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
      if (columns.length != 2) {
        bl.mensajeFlotante(
          message:
              'Los datos del portapapeles no son válidos, solo se permiten dos columnas\nhay ${columns.length} columnas',
        );
        return false;
      }
    }
    return true;
  }

  get pegarDatosExcel async {
    EntregasMcList cargasMcList = state().entregasMcList!;
    EntregaMc first = cargasMcList.listEdit[0].copyWith();
    cargasMcList.listEdit = [];
    emit(
      state().copyWith(entregasMcList: cargasMcList),
    ); //para que se limpie la vista
    await Future.delayed(Duration(milliseconds: 100));
    try {
      final clipboardData = await Clipboard.getData('text/plain');
      String? data = clipboardData?.text;
      if (data == null) {
        bl.mensajeFlotante(message: 'No hay datos en el portapapeles');
        return;
      }
      final rows = data.split('\n').map((e) => e.trim()).toList();
      rows.removeWhere((e) => e.isEmpty);
      cargasMcList.listEdit = List.generate(
        rows.length,
        (index) => EntregaMc.fromInit(index + 1),
      );
      for (int i = 0; i < rows.length; i++) {
        List<String> columns = rows[i].split('\t');
        EntregaMc carga = cargasMcList.listEdit[i];
        carga.e4e = columns[0].toString();
        Mm60SingleB mm60 = state().mm60B!.mm60List.firstWhere(
          (element) => element.material.contains(carga.e4e),
          orElse: () => Mm60SingleB.fromInit(),
        );
        carga.descripcion = mm60.descripcion;
        carga.um = mm60.um;
        carga.ctd = columns[1].toString();
      }
      User user = state().user!;
      for (EntregaMc e in cargasMcList.listEdit) {
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
        e.tecnico = first.tecnico;
        e.tecnicoid = first.tecnicoid;
        e.tecnicotype = first.tecnicotype;
      }
      emit(state().copyWith(entregasMcList: cargasMcList));
      evaluateRules();
    } catch (e) {
      bl.errorCarga('Entregas MC - Pegar Datos Excel', e);
    }
  }
}
