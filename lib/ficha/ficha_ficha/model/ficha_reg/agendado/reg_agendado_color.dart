class FichaRegAgendadoColor {
  bool m01 = false;
  bool m02 = false;
  bool m03 = false;
  bool m04 = false;
  bool m05 = false;
  bool m06 = false;
  bool m07 = false;
  bool m08 = false;
  bool m09 = false;
  bool m10 = false;
  bool m11 = false;
  bool m12 = false;

  void set(String mes, bool value) {
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

  bool get(String mes) {
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
    return false;
  }
}
