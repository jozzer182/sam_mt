import 'ficha_reg/reg.dart';

class FFicha {
  List<FichaReg> ficha;
  // List<VersionesSingle> version;
  // List<AnoList> disponibilidadList = [];
  List<FichaReg> nuevos = [];
  late List<FichaReg> fichaModificada;
  List<FichaReg> libres = [];
  List<FichaReg> controlados = [];
  List<FichaReg> eliminados = [];
  bool editar = false;
  bool verDinero = false;
  bool verCto = false;
  String get razon {
    if (libres.isNotEmpty) return libres.first.log.razon;
    if (controlados.isNotEmpty) return controlados.first.log.razon;
    return '';
  }

  FFicha({
    required this.ficha,
    // required this.version,
    // required Disponibilidad disponibilidad,
    required int year,
  }) {
    verCto = ficha.any((e) => e.circuito.isNotEmpty);
    fichaModificada = ficha.map((e) => e.copyWith()).toList();
    // DateTime fechaActual = DateTime.now();
    // fechaActual = DateTime(fechaActual.year, fechaActual.month, 1);
    // int anoActual = fechaActual.year;
    // int mesActual = fechaActual.month;
    // // print('Ano: $anoActual, mes: $mesActual');

    // int mesesParaQuatrimestre = 0;
    // for (int i = mesActual; i < 17; i++) {
    //   // print('i: $i, i % 4: ${i % 4}');
    //   if (i - mesActual >= 4 && i % 4 == 0) {
    //     mesesParaQuatrimestre = i - mesActual;
    //     i = 17;
    //   }
    // }

    // // Sumar 8 meses a la fecha actual
    // DateTime nuevaFecha = sumarMeses(fechaActual, mesesParaQuatrimestre);
    // int ano8Meses = nuevaFecha.year;
    // // int mes8meses = nuevaFecha.month;
    // if (year == anoActual || year == ano8Meses) {
    //   List<String> allE4e = ficha.map((e) => e.e4e).toSet().toList();
    //   for (String e4e in allE4e) {
    //     AnoList anoList = disponibilidad.anoList.firstWhere(
    //       (e) => e.e4e == e4e,
    //       orElse: () => AnoList.zero(),
    //     );
    //     disponibilidadList.add(anoList);
    //   }
    // }
  }
}
