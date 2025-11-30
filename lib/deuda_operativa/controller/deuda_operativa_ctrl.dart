import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../lcl/model/lcl_model.dart';
import '../../mb51/model/mb51_model.dart';
import '../../mm60/model/mm60_model.dart';
import '../../moecom/consumos_mc/model/consumos_mc_list.dart';
import '../../moecom/consumos_mc/model/consumos_mc_reg.dart';
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
    if (state().consumosMcList == null) {
      bl.mensaje(message: 'No hay consumosMc');
      return;
    }
    ConsumosMcList consumosMcList = state().consumosMcList!;

    try {
      // Preparar datos de registrosList con los filtros necesarios
      Iterable<ResgistroSingle> registrosFiltrados = registrosB.registrosList
          .where(
            (e) => [
              'entregado',
              'reintegrado',
              'Faltante_Operativo',
            ].contains(e.est_oficial),
          );

      // Crear un mapa indexado para mm60List para búsquedas rápidas
      Map<String, Mm60Single> mm60Map = {
        for (Mm60Single item in mm60.mm60List) item.material: item,
      }; // Agrupar registros por lcl, e4e, um
      Map<String, Map<String, dynamic>> groupedRegistros =
          <String, Map<String, dynamic>>{};
      for (ResgistroSingle registro in registrosFiltrados) {
        String key = '${registro.lcl}|${registro.e4e}|${registro.um}';
        groupedRegistros.update(
          key,
          (value) => {
            'lcl': registro.lcl,
            'e4e': registro.e4e,
            'um': registro.um,
            'ctd_total':
                (value['ctd_total'] as int) + int.parse(registro.ctd_total),
            'fecha': registro.fecha_e, // Tomar la última fecha
            // 'ctd_con': (value['ctd_con'] as int) + int.parse(registro.ctd_con),
          },
          ifAbsent:
              () => {
                'lcl': registro.lcl,
                'e4e': registro.e4e,
                'um': registro.um,
                'ctd_total': int.parse(registro.ctd_total),
                'fecha': registro.fecha_e,
                // 'ctd_con': int.parse(registro.ctd_con),
              },
        );
      }

      // Procesar datos agrupados
      for (Map<String, dynamic> registro in groupedRegistros.values) {
        Mm60Single? mm60Item = mm60Map[registro['e4e']];
        if (mm60Item == null) continue;
        int valorUnitario = int.parse(
          mm60Item.precio,
        ); // Determinar el campo a usar basado en la longitud del lcl
        bool usarLcl = registro['lcl'].length == 10;
        String lclValue = registro['lcl'];

        // Si lcl inicia con "df" (case insensitive), remover esas dos letras
        if (lclValue.toLowerCase().startsWith('df')) {
          lclValue = lclValue.substring(2);
        }

        String campoComparacion = usarLcl ? lclValue : lclValue;

        int cantidadSap = mb51b.mb51BList
            .where(
              (e) =>
                  usarLcl
                      ? (e.wbe == campoComparacion &&
                          e.material == registro['e4e'])
                      : (e.referencia == campoComparacion &&
                          e.material == registro['e4e']),
            )
            .map((e) => int.parse(e.ctd))
            .fold(0, (prev, curr) => prev + curr);
        int faltanteUnidades = registro['ctd_total'] + cantidadSap;
        String funcional =
            registrosB.registrosList
                .firstWhere(
                  (e) => e.lcl == registro['lcl'],
                  orElse:
                      () =>
                          ResgistroSingle.zero()
                            ..ingeniero_enel = '*Desconocido',
                )
                .ingeniero_enel; // Obtener la fecha más antigua de MB51
        String fechaMb51 = "sin contabilizacion";
        List<String> fechasMb51 =
            mb51b.mb51BList
                .where(
                  (e) =>
                      usarLcl
                          ? (e.wbe == campoComparacion &&
                              e.material == registro['e4e'])
                          : (e.referencia == campoComparacion &&
                              e.material == registro['e4e']),
                )
                .map((e) => e.fecha)
                .where((fecha) => fecha.isNotEmpty)
                .toList();

        if (fechasMb51.isNotEmpty) {
          try {
            fechasMb51.sort((a, b) {
              DateTime fechaA = DateTime.parse(a);
              DateTime fechaB = DateTime.parse(b);
              return fechaA.compareTo(fechaB);
            });
            fechaMb51 = fechasMb51.first;
          } catch (e) {
            // Si hay error al parsear las fechas, usar la primera disponible
            fechaMb51 = fechasMb51.first;
          }
        }
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
              fecha: registro['fecha'],
              fechaMb51: fechaMb51,
            ),
          );
        }
      } // Filtrar y agrupar consumosMcList
      Map<String, Map<String, dynamic>> groupedConsumosMc =
          <String, Map<String, dynamic>>{};
      for (ConsumoMc consumo in consumosMcList.list) {
        String key = '${consumo.tdc}|${consumo.e4e}|${consumo.um}';
        groupedConsumosMc.update(
          key,
          (value) => {
            'tdc': consumo.tdc,
            'e4e': consumo.e4e,
            'um': consumo.um,
            'ctd_total': (value['ctd_total'] as int) + int.parse(consumo.ctd),
            'fecha': consumo.reportado, // Tomar la última fecha
          },
          ifAbsent:
              () => {
                'tdc': consumo.tdc,
                'e4e': consumo.e4e,
                'um': consumo.um,
                'ctd_total': int.parse(consumo.ctd),
                'fecha': consumo.reportado,
              },
        );
      }

      // Procesar datos agrupados de consumosMcList
      for (int i = 0; i < groupedConsumosMc.values.length; i++) {
        Map<String, dynamic> consumo = groupedConsumosMc.values.elementAt(i);
        //si el bucle es dibisible por 1000, esperar 1 microsegundo
        if (i % 100 == 0) {
          // print('Procesando consumo $i/${groupedConsumosMc.values.length}');
          await Future.delayed(Duration(microseconds: 1));
        }

        Mm60Single? mm60Item = mm60Map[consumo['e4e']];
        if (mm60Item == null) continue;
        int valorUnitario = int.parse(mm60Item.precio);

        // Manejar el caso donde tdc inicia con "df" (case insensitive)
        String tdcValue = consumo['tdc'];
        if (tdcValue.toLowerCase().startsWith('df')) {
          tdcValue = tdcValue.substring(2);
        }

        int cantidadSap = mb51b.mb51BList
            .where(
              (e) => e.referencia == tdcValue && e.material == consumo['e4e'],
            )
            .map((e) => int.parse(e.ctd))
            .fold(0, (prev, curr) => prev + curr);
        int faltanteUnidades = consumo['ctd_total'] + cantidadSap;
        String tecnico =
            consumosMcList.list
                .firstWhere(
                  (e) => e.tdc == consumo['tdc'],
                  orElse:
                      () => ConsumoMc(
                        id: '',
                        pedido: '',
                        consecutivo: '',
                        tecnico: '*Desconocido',
                        tecnicoid: '',
                        tecnicotype: '',
                        fecha: '',
                        almacenista: '',
                        tel: '',
                        soporte: '',
                        ticket: '',
                        tdc: '',
                        item: '',
                        e4e: '',
                        descripcion: '',
                        um: '',
                        ctd: '0',
                        reportado: '',
                        comentario: '',
                        anuladonombre: '',
                        anuladocorreo: '',
                        estado: '',
                        tipo: '',
                        actualizado: '',
                      ),
                )
                .tecnico; // Obtener la fecha más antigua de MB51 para consumos MC
        String fechaMb51 = "sin contabilizacion";
        List<String> fechasMb51 =
            mb51b.mb51BList
                .where(
                  (e) =>
                      e.referencia == tdcValue && e.material == consumo['e4e'],
                )
                .map((e) => e.fecha)
                .where((fecha) => fecha.isNotEmpty)
                .toList();

        if (fechasMb51.isNotEmpty) {
          try {
            fechasMb51.sort((a, b) {
              DateTime fechaA = DateTime.parse(a);
              DateTime fechaB = DateTime.parse(b);
              return fechaA.compareTo(fechaB);
            });
            fechaMb51 = fechasMb51.first;
          } catch (e) {
            // Si hay error al parsear las fechas, usar la primera disponible
            fechaMb51 = fechasMb51.first;
          }
        }
        if (consumo['ctd_total'] != 0) {
          deudaOperativaB.deudaOperativaB.add(
            DeudaOperativaBSingle(
              lcl: consumo['tdc'],
              funcional: tecnico,
              e4e: consumo['e4e'],
              descripcion: mm60Item.descripcion,
              um: consumo['um'],
              ctd_total: consumo['ctd_total'].toString(),
              ctd_con: cantidadSap.toString(),
              faltanteUnidades: faltanteUnidades.toString(),
              faltanteValor: (faltanteUnidades * valorUnitario).toString(),
              fecha: consumo['fecha'],
              fechaMb51: fechaMb51,
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
      Map<String, String> lclMap = {
        for (LclSingle item in lcl.lclList)
          item.lcl: item.usuario.toUpperCase(),
      };
      for (DeudaOperativaBSingle reg in deudaOperativaB.deudaOperativaB) {
        reg.funcional = lclMap[reg.lcl] ?? '*${reg.funcional}';
      } // Ordenar y preparar listas de búsqueda
      deudaOperativaB.deudaOperativaB.sort((a, b) {
        // Primero verificar si alguno tiene exactamente 10 caracteres
        bool aIs10 = a.lcl.length == 10;
        bool bIs10 = b.lcl.length == 10;

        // Si uno tiene 10 caracteres y el otro no, priorizar el de 10
        if (aIs10 && !bIs10) return -1;
        if (!aIs10 && bIs10) return 1;

        // Si ambos tienen la misma condición de 10 caracteres, ordenar por fecha (más reciente primero)
        try {
          DateTime fechaA = DateTime.parse(a.fecha);
          DateTime fechaB = DateTime.parse(b.fecha);
          int fechaComparison = fechaB.compareTo(
            fechaA,
          ); // Invertido para que más reciente vaya primero

          // Si las fechas son diferentes, usar ese orden
          if (fechaComparison != 0) return fechaComparison;
        } catch (e) {
          // Si hay error al parsear fechas, comparar como strings (más reciente primero)
          int fechaStringComparison = b.fecha.compareTo(a.fecha);
          if (fechaStringComparison != 0) return fechaStringComparison;
        }

        // Si las fechas son iguales o hay error, ordenar por lcl y e4e
        return '${a.lcl}${a.e4e}'.compareTo('${b.lcl}${b.e4e}');
      });
      deudaOperativaB.deudaOperativaBListSearch = List.from(
        deudaOperativaB.deudaOperativaB,
      );
      deudaOperativaB.deudaOperativaBListSearch2 = List.from(
        deudaOperativaB.deudaOperativaB,
      )..sort(
        (b, a) =>
            int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)),
      );

      // Actualizar estado
      emit(state().copyWith(deudaOperativaB: deudaOperativaB));
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      bl.errorCarga('Deuda Operativa', e);
    }
  }
}
