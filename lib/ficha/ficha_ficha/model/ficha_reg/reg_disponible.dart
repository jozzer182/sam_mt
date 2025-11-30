import '../../../../resources/a_entero_2.dart';

class FichaRegDisponible {
  String m01 = '0';
  String m02 = '0';
  String m03 = '0';
  String m04 = '0';
  String m05 = '0';
  String m06 = '0';
  String m07 = '0';
  String m08 = '0';
  String m09 = '0';
  String m10 = '0';
  String m11 = '0';
  String m12 = '0';

  void set(String mes, String value) {
    if (mes == '01') m01 = value;
    if (mes == '02') m02 = value;
    if (mes == '03') m03 = value;
    if (mes == '04') m04 = value;
    if (mes == '05') m05 = value;
    if (mes == '06') m06 = value;
    if (mes == '07') m07 = value;
    if (mes == '08') m08 = value;
    if (mes == '09') m09 = value;
    if (mes == '10') m10 = value;
    if (mes == '11') m11 = value;
    if (mes == '12') m12 = value;
  }

  String get(String mes) {
    if (mes == '01') return m01;
    if (mes == '02') return m02;
    if (mes == '03') return m03;
    if (mes == '04') return m04;
    if (mes == '05') return m05;
    if (mes == '06') return m06;
    if (mes == '07') return m07;
    if (mes == '08') return m08;
    if (mes == '09') return m09;
    if (mes == '10') return m10;
    if (mes == '11') return m11;
    if (mes == '12') return m12;
    return '0';
  }

  int getInt(String mes) {
    if (mes == '01') return aEntero(m01);
    if (mes == '02') return aEntero(m02);
    if (mes == '03') return aEntero(m03);
    if (mes == '04') return aEntero(m04);
    if (mes == '05') return aEntero(m05);
    if (mes == '06') return aEntero(m06);
    if (mes == '07') return aEntero(m07);
    if (mes == '08') return aEntero(m08);
    if (mes == '09') return aEntero(m09);
    if (mes == '10') return aEntero(m10);
    if (mes == '11') return aEntero(m11);
    if (mes == '12') return aEntero(m12);
    return 0;
  }
}
