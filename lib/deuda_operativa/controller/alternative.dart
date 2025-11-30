import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../lcl/model/lcl_model.dart';
import '../../mb51/model/mb51_model.dart';
import '../../mm60/model/mm60_model.dart';
import '../model/deudaoperativa_model.dart';

class DeudaOperativaCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  DeudaOperativaCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear async {
    DeudaOperativaB deudaOperativaB = DeudaOperativaB();
    if (state().registrosB == null) {
      bl.mensaje(message: 'No hay registros');
      return;
    }
    RegistrosB registrosB = state().registrosB!;
    if (state().mb51B == null) {
      bl.mensaje(message: 'No hay mb51');
      return;
    }
    Mb51B mb51b = state().mb51B!;
    if (state().mm60 == null) {
      bl.mensaje(message: 'No hay mm60');
      return;
    }
    Mm60 mm60 = state().mm60!;
    if (state().lcl == null) {
      bl.mensaje(message: 'No hay lcl');
      return;
    }
    Lcl lcl = state().lcl!;

    try {
      // Preparar datos de registrosList con los filtros necesarios
      var registrosFiltrados = registrosB.registrosList.where((e) =>
          ['entregado', 'reintegrado', 'Faltante_Operativo']
              .contains(e.est_oficial));

      // Crear un mapa indexado para mm60List para búsquedas rápidas
      var mm60Map = {for (var item in mm60.mm60List) item.material: item};

      // Agrupar registros por lcl, e4e, um
      var groupedRegistros = <String, Map<String, dynamic>>{};
      for (var registro in registrosFiltrados) {
        var key = '${registro.lcl}|${registro.e4e}|${registro.um}';
        groupedRegistros.update(
          key,
          (value) => {
            'lcl': registro.lcl,
            'e4e': registro.e4e,
            'um': registro.um,
            'ctd_total': (value['ctd_total'] as int) + int.parse(registro.ctd_total),
            'ctd_con': (value['ctd_con'] as int) + int.parse(registro.ctd_con),
          },
          ifAbsent: () => {
            'lcl': registro.lcl,
            'e4e': registro.e4e,
            'um': registro.um,
            'ctd_total': int.parse(registro.ctd_total),
            'ctd_con': int.parse(registro.ctd_con),
          },
        );
      }

      // Procesar datos agrupados
      for (var registro in groupedRegistros.values) {
        var mm60Item = mm60Map[registro['e4e']];
        if (mm60Item == null) continue;

        var valorUnitario = int.parse(mm60Item.precio);
        var cantidadSap = mb51b.mb51BList
                .where((e) => e.wbe == registro['lcl'] && e.material == registro['e4e'])
                .map((e) => int.parse(e.ctd))
                .fold(0, (prev, curr) => prev + curr);

        var faltanteUnidades = registro['ctd_total'] + cantidadSap;
        var funcional = registrosB.registrosList
            .firstWhere(
              (e) => e.lcl == registro['lcl'],
              orElse: () => ResgistroSingle(
                lcl: registro['lcl'],
                ingeniero_enel: '*Desconocido',
                pedido: '',
                est_s: '',
                fecha_s: '',
                solicitante: '',
                tel_solicitante: '',
                contrato: '',
                nombre_pdi: '',
                pdi: '',
                proceso: '',
                proyecto: '',
                unidad: '',
                odm: '',
                grafo: '',
                pdl: '',
                nodo: '',
                localidad_municipio: '',
                circuito: '',
                subestacion_cabecera: '',
                fecha_peticion_s: '',
                comentario_s: '',
                soporte_d_s: '',
                soporte_e_s: '',
                item: '',
                e4e: '',
                descripcion: '',
                um: '',
                ctd_s: '',
                aportacion: '',
                fecha_p: '',
                estado_p: '',
                comentario_p: '',
                fecha_futuro_p: '',
                almacenista_p: '',
                almacenista_a: '',
                tel_alm_a: '',
                fecha_a: '',
                hora_a: '',
                ctd_a: '',
                comentario_a: '',
                almacenista_e: '',
                tel_alm_e: '',
                fecha_e: '',
                hora_e: '',
                ctd_e: '',
                lider_contrato_e: '',
                cc_lider_contrato_e: '',
                placa_cuadrilla_e: '',
                tel_lider_e: '',
                comentario_e: '',
                soporte_d_e: '',
                soporte_e_e: '',
                almacenista_r: '',
                tel_alm_r: '',
                fecha_r: '',
                hora_r: '',
                ctd_r: '',
                lider_contrato_r: '',
                placa_cuadrilla_r: '',
                tel_lider_r: '',
                soporte_d_r: '',
                soporte_e_r: '',
                ctd_total: '',
                est_contrato: '',
                fecha_conciliacion: '',
                fecha_cierre: '',
                responsable_contrato: '',
                ctd_con: '',
                comentario_op: '',
                lm: '',
                soporte_d_c: '',
                soporte_e_c: '',
                ctd_cob: '',
                fecha_sap_au: '',
                est_sap_au: '',
                sap_au: '',
                ctd_au: '',
                fecha_sap_ma: '',
                est_sap_ma: '',
                sap_ma: '',
                ctd_ma: '',
                soporte_ma: '',
                est_sap: '',
                sap: '',
                ctd_sap: '',
                fecha_sap: '',
                ctd_dif: '',
                est_oficial: '',
                est_oficial_fecha: '',
                est_oficial_pers: '',
              ),
            )
            .ingeniero_enel;

        if (registro['ctd_total'] != 0) {
          deudaOperativaB.deudaOperativaB.add(
            DeudaOperativaBSingle(
              lcl: registro['lcl'],
              funcional: funcional,
              e4e: registro['e4e'],
              descripcion: mm60Item.descripcion,
              um: registro['um'],
              ctd_total: registro['ctd_total'].toString(),
              ctd_con: cantidadSap.toString(),
              faltanteUnidades: faltanteUnidades.toString(),
              faltanteValor: (faltanteUnidades * valorUnitario).toString(),
            ),
          );
        }
      }

      // Calcular totales
      deudaOperativaB.totalValor = deudaOperativaB.deudaOperativaB
          .map((e) => int.parse(e.faltanteValor))
          .fold(0, (prev, curr) => prev + curr);
      deudaOperativaB.totalSobrantes = deudaOperativaB.deudaOperativaB
          .where((e) => int.parse(e.faltanteValor) < 0)
          .map((e) => int.parse(e.faltanteValor))
          .fold(0, (prev, curr) => prev + curr);
      deudaOperativaB.totalFaltantes = deudaOperativaB.deudaOperativaB
          .where((e) => int.parse(e.faltanteValor) > 0)
          .map((e) => int.parse(e.faltanteValor))
          .fold(0, (prev, curr) => prev + curr);

      // Actualizar información de funcionales
      var lclMap = {for (var item in lcl.lclList) item.lcl: item.usuario.toUpperCase()};
      for (var reg in deudaOperativaB.deudaOperativaB) {
        reg.funcional = lclMap[reg.lcl] ?? '*${reg.funcional}';
      }

      // Ordenar y preparar listas de búsqueda
      deudaOperativaB.deudaOperativaB.sort((a, b) => '${b.lcl}${a.e4e}'.compareTo('${a.lcl}${b.e4e}'));
      deudaOperativaB.deudaOperativaBListSearch = List.from(deudaOperativaB.deudaOperativaB);
      deudaOperativaB.deudaOperativaBListSearch2 = List.from(deudaOperativaB.deudaOperativaB)
        ..sort((b, a) => int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)));

      // Actualizar estado
      emit(state().copyWith(deudaOperativaB: deudaOperativaB));
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      bl.errorCarga('Deuda Operativa', e);
    }
  }
}
