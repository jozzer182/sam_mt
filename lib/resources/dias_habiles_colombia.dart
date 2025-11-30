import 'package:intl/intl.dart';

class DiasHabilesColombia {
  /// Retorna los días hábiles entre dos fechas (excluye fines de semana y festivos colombianos).
  static int calcularDiasHabiles(DateTime desde, DateTime hasta) {
    if (desde.isAfter(hasta)) {
      throw ArgumentError(
        'La fecha de inicio debe ser anterior a la fecha final',
      );
    }

    int diasHabiles = 0;
    final festivos = obtenerFestivosColombia(hasta.year);

    for (
      var fecha = desde;
      !fecha.isAfter(hasta);
      fecha = fecha.add(Duration(days: 1))
    ) {
      if (_esDiaHabil(fecha, festivos)) {
        diasHabiles++;
      }
    }

    return diasHabiles;
  }

  /// Determina si un día es hábil (no fin de semana ni festivo)
  static bool _esDiaHabil(DateTime fecha, Set<DateTime> festivos) {
    if (fecha.weekday == DateTime.saturday ||
        fecha.weekday == DateTime.sunday) {
      return false;
    }
    return !festivos.contains(_sinHora(fecha));
  }

  /// Elimina la hora de una fecha (para comparar solo día/mes/año)
  static DateTime _sinHora(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  /// Obtiene festivos colombianos para un año específico
  static Set<DateTime> obtenerFestivosColombia(int anio) {
    final Set<DateTime> festivos = {};

    // Festivos fijos
    festivos.add(DateTime(anio, 1, 1)); // Año nuevo
    festivos.add(DateTime(anio, 5, 1)); // Día del trabajo
    festivos.add(DateTime(anio, 7, 20)); // Independencia
    festivos.add(DateTime(anio, 8, 7)); // Batalla de Boyacá
    festivos.add(DateTime(anio, 12, 8)); // Inmaculada Concepción
    festivos.add(DateTime(anio, 12, 25)); // Navidad

    // Festivos móviles (calculados a partir de Semana Santa)
    final pascua = _calcularFechaPascua(anio);
    festivos.add(pascua.subtract(Duration(days: 3))); // Jueves Santo
    festivos.add(pascua.subtract(Duration(days: 2))); // Viernes Santo

    // Ley Emiliani (festivos que se trasladan al lunes)
    festivos.add(_trasladarALunes(DateTime(anio, 1, 6))); // Reyes
    festivos.add(_trasladarALunes(DateTime(anio, 3, 19))); // San José
    festivos.add(_trasladarALunes(pascua.add(Duration(days: 43)))); // Ascensión
    festivos.add(
      _trasladarALunes(pascua.add(Duration(days: 64))),
    ); // Corpus Christi
    festivos.add(
      _trasladarALunes(pascua.add(Duration(days: 71))),
    ); // Sagrado Corazón
    festivos.add(
      _trasladarALunes(DateTime(anio, 6, 29)),
    ); // San Pedro y San Pablo
    festivos.add(_trasladarALunes(DateTime(anio, 8, 15))); // Asunción
    festivos.add(_trasladarALunes(DateTime(anio, 10, 12))); // Día de la Raza
    festivos.add(_trasladarALunes(DateTime(anio, 11, 1))); // Todos los Santos
    festivos.add(
      _trasladarALunes(DateTime(anio, 11, 11)),
    ); // Independencia de Cartagena

    return festivos;
  }

  /// Algoritmo para calcular la fecha de Pascua
  static DateTime _calcularFechaPascua(int anio) {
    int a = anio % 19;
    int b = anio ~/ 100;
    int c = anio % 100;
    int d = b ~/ 4;
    int e = b % 4;
    int f = (b + 8) ~/ 25;
    int g = (b - f + 1) ~/ 3;
    int h = (19 * a + b - d - g + 15) % 30;
    int i = c ~/ 4;
    int k = c % 4;
    int l = (32 + 2 * e + 2 * i - h - k) % 7;
    int m = (a + 11 * h + 22 * l) ~/ 451;
    int mes = (h + l - 7 * m + 114) ~/ 31;
    int dia = ((h + l - 7 * m + 114) % 31) + 1;

    return DateTime(anio, mes, dia);
  }

  /// Mueve la fecha al siguiente lunes si no es lunes
  static DateTime _trasladarALunes(DateTime fecha) {
    if (fecha.weekday == DateTime.monday) return fecha;
    return fecha.add(Duration(days: (8 - fecha.weekday)));
  }
}
