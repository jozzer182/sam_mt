import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/inventario_model.dart';

class InventarioCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late dynamic emit;

  InventarioCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  Future<void> get crear async {
    try {
      final inventarioB = InventarioB();
      final Map<String, Map<String, dynamic>> inventarioMap = {};

      // Procesar ingresos
      final ingresos = state().ingresosB?.ingresosBList ?? [];
      for (final ingreso in ingresos) {
        if (ingreso.estado != 'correcto') continue;

        final key = '${ingreso.e4e}_${ingreso.um}';
        final cantidad = int.parse(ingreso.ctd);

        inventarioMap.update(
          key,
          (value) => {
            'e4e': ingreso.e4e,
            'um': ingreso.um,
            'ctd': (value['ctd'] as int) + cantidad,
            'moecom': (value['moecom'] as int) + 0,
          },
          ifAbsent:
              () => {
                'e4e': ingreso.e4e,
                'um': ingreso.um,
                'ctd': cantidad,
                'moecom': 0,
              },
        );
      }

      // Procesar registros (salidas)
      final registros = state().registrosB?.registrosList ?? [];
      for (final registro in registros) {
        if (registro.est_oficial == 'anulado') continue;

        final key = '${registro.e4e}_${registro.um}';
        final cantidad = int.parse(registro.ctd_total);

        inventarioMap.update(
          key,
          (value) => {
            'e4e': registro.e4e,
            'um': registro.um,
            'ctd': (value['ctd'] as int) - cantidad,
            'moecom': (value['moecom'] as int) + 0,
          },
          ifAbsent:
              () => {
                'e4e': registro.e4e,
                'um': registro.um,
                'ctd': -cantidad,
                'moecom': 0,
              },
        );
      }

      // Procesar cargasmc (entradas)
      final cargasmc = state().entregasMcList?.list ?? [];
      for (final registro in cargasmc) {
        if (registro.estado == 'anulado') continue;

        final key = '${registro.e4e}_${registro.um}';
        final cantidad = int.parse(registro.ctd);

        inventarioMap.update(
          key,
          (value) => {
            'e4e': registro.e4e,
            'um': registro.um,
            'ctd': value['ctd'] ?? 0,
            'moecom': (value['moecom'] ?? 0) + cantidad,
          },
          ifAbsent:
              () => {
                'e4e': registro.e4e,
                'um': registro.um,
                'ctd': 0,
                'moecom': cantidad,
              },
        );
      }

      // Procesar planillasmc (salidas)
      final planillasMc = state().consumosMcList?.list ?? [];
      for (final registro in planillasMc) {
        if (registro.estado == 'anulado') continue;

        final key = '${registro.e4e}_${registro.um}';
        final cantidad = int.parse(registro.ctd);

        inventarioMap.update(
          key,
          (value) => {
            'e4e': registro.e4e,
            'um': registro.um,
            'ctd': (value['ctd'] ?? 0) - cantidad,
            'moecom': (value['moecom'] ?? 0) - cantidad,
          },
          ifAbsent:
              () => {
                'e4e': registro.e4e,
                'um': registro.um,
                'ctd': -cantidad,
                'moecom': -cantidad,
              },
        );
      }

      // Convertir a lista y filtrar positivos
      final inventarioFiltrado =
          inventarioMap.values.where((item) => (item['ctd'] as int) > 0).map((
            item,
          ) {
            final e4eCodigo = item['e4e'].toString();
            final descripcion =
                state().mm60!.mm60List
                    .firstWhere((e) => e.material == e4eCodigo)
                    .descripcion;

            return InventarioBSingle(
              e4e: e4eCodigo,
              descripcion: descripcion,
              um: item['um'].toString(),
              ctd: item['ctd'].toString(),
              almacen: (item['ctd'] - item['moecom']).toString(),
              moecom: item['moecom'].toString(),
            );
          }).toList();

      // Ordenar por código e4e
      inventarioFiltrado.sort((a, b) => a.e4e.compareTo(b.e4e));

      // Actualizar el modelo
      inventarioB.inventarioList = inventarioFiltrado;
      inventarioB.inventarioListSearch = [...inventarioFiltrado];

      // Actualizar el estado
      emit(state().copyWith(inventarioB: inventarioB));
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      bl.errorCarga('Inventario', e);
    }
  }
}
