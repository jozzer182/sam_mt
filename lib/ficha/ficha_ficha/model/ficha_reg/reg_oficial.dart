class FichaRegOficial {
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

  String mesOficial(String mes) {
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
}
