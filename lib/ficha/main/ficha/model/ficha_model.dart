
import '../../../../fechas_fem/model/fechasfem_model.dart';
import '../../../../mm60/model/mm60_model.dart';
import '../../../ficha_agendados/model/ficha__pedidos_model.dart';
import '../../../ficha_ficha/model/ficha__ficha_model.dart';
import '../../../ficha_ficha/model/ficha_reg/reg.dart';

class Ficha {
  // late FResumen resumen;
  late FPedidos fichaPedidos;
  late FFicha fficha;
  // late FOficial oficial;
  // Eliminados cambios = Eliminados();
  // Solicitados solicitados = Solicitados();

  Ficha({
    required List<FichaReg> ficha,
    required Mm60 mm60,
    // required Budget budgetAll,
    required int year,
    // required List<VersionesSingle> version,
    // required Disponibilidad disponibilidad,
    required FechasFEM fechasFEM,
  }) {
    // resumen = FResumen(
    //   year: year,
    //   budgetAll: budgetAll,
    //   mm60: mm60,
    //   version: version,
    //   ficha: ficha,
    // );
    fichaPedidos = FPedidos(
      ficha: ficha,
      fechasFEM: fechasFEM,
    );
    fficha = FFicha(
      ficha: ficha.toList(),
      // version: version,
      // disponibilidad: disponibilidad,
      year: year,
    );
    // oficial = FOficial(
    //   version: version,
    // );
  }
}
