class FichaRegRiesgo {
  int m01Riesgo = 0;
  int m02Riesgo = 0;
  int m03Riesgo = 0;
  int m04Riesgo = 0;
  int m05Riesgo = 0;
  int m06Riesgo = 0;
  int m07Riesgo = 0;
  int m08Riesgo = 0;
  int m09Riesgo = 0;
  int m10Riesgo = 0;
  int m11Riesgo = 0;
  int m12Riesgo = 0;
  
  void setRiesgo(
    String mes,
    int value,
  ) {
    if (mes == '01') m01Riesgo = value;
    if (mes == '02') m02Riesgo = value;
    if (mes == '03') m03Riesgo = value;
    if (mes == '04') m04Riesgo = value;
    if (mes == '05') m05Riesgo = value;
    if (mes == '06') m06Riesgo = value;
    if (mes == '07') m07Riesgo = value;
    if (mes == '08') m08Riesgo = value;
    if (mes == '09') m09Riesgo = value;
    if (mes == '10') m10Riesgo = value;
    if (mes == '11') m11Riesgo = value;
    if (mes == '12') m12Riesgo = value;
  }

  int mesRiesgo(String mes) {
    if (mes == '01') return m01Riesgo;
    if (mes == '02') return m02Riesgo;
    if (mes == '03') return m03Riesgo;
    if (mes == '04') return m04Riesgo;
    if (mes == '05') return m05Riesgo;
    if (mes == '06') return m06Riesgo;
    if (mes == '07') return m07Riesgo;
    if (mes == '08') return m08Riesgo;
    if (mes == '09') return m09Riesgo;
    if (mes == '10') return m10Riesgo;
    if (mes == '11') return m11Riesgo;
    if (mes == '12') return m12Riesgo;
    return 0;
  }
}
