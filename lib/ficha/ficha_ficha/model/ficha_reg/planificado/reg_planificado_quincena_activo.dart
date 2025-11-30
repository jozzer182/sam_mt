import '../reg.dart';

class FichaRegPlanificadoQuincenaActivo {
  late int m01q1;
  late int m01q2;
  late int m01qx;
  late int m02q1;
  late int m02q2;
  late int m02qx;
  late int m03q1;
  late int m03q2;
  late int m03qx;
  late int m04q1;
  late int m04q2;
  late int m04qx;
  late int m05q1;
  late int m05q2;
  late int m05qx;
  late int m06q1;
  late int m06q2;
  late int m06qx;
  late int m07q1;
  late int m07q2;
  late int m07qx;
  late int m08q1;
  late int m08q2;
  late int m08qx;
  late int m09q1;
  late int m09q2;
  late int m09qx;
  late int m10q1;
  late int m10q2;
  late int m10qx;
  late int m11q1;
  late int m11q2;
  late int m11qx;
  late int m12q1;
  late int m12q2;
  late int m12qx;
  late int total;

  FichaRegPlanificadoQuincenaActivo(FichaReg fichaReg) {
    List<String> meses = [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
    ];
    for (String mes in meses) {
      setMes(mes, fichaReg);
    }
    total = m01q1 +
        m01q2 +
        m01qx +
        m02q1 +
        m02q2 +
        m02qx +
        m03q1 +
        m03q2 +
        m03qx +
        m04q1 +
        m04q2 +
        m04qx +
        m05q1 +
        m05q2 +
        m05qx +
        m06q1 +
        m06q2 +
        m06qx +
        m07q1 +
        m07q2 +
        m07qx +
        m08q1 +
        m08q2 +
        m08qx +
        m09q1 +
        m09q2 +
        m09qx +
        m10q1 +
        m10q2 +
        m10qx +
        m11q1 +
        m11q2 +
        m11qx +
        m12q1 +
        m12q2 +
        m12qx;
  }

  setMes(String mes, FichaReg fichaReg) {
    bool q1Activo = fichaReg.agendado.activoQuincena.get('$mes-1');
    bool q2Activo = fichaReg.agendado.activoQuincena.get('$mes-2');
    set('$mes-1', q1Activo ? fichaReg.planificado.quincena.get('$mes-1') : 0);
    set('$mes-2', q2Activo ? fichaReg.planificado.quincena.get('$mes-2') : 0);
    set('$mes-x', q2Activo ? fichaReg.planificado.quincena.get('$mes-x') : 0);
  }

  set(String quincena, int value) {
    if (quincena == '01-1') m01q1 = value;
    if (quincena == '01-2') m01q2 = value;
    if (quincena == '01-x') m01qx = value;
    if (quincena == '02-1') m02q1 = value;
    if (quincena == '02-2') m02q2 = value;
    if (quincena == '02-x') m02qx = value;
    if (quincena == '03-1') m03q1 = value;
    if (quincena == '03-2') m03q2 = value;
    if (quincena == '03-x') m03qx = value;
    if (quincena == '04-1') m04q1 = value;
    if (quincena == '04-2') m04q2 = value;
    if (quincena == '04-x') m04qx = value;
    if (quincena == '05-1') m05q1 = value;
    if (quincena == '05-2') m05q2 = value;
    if (quincena == '05-x') m05qx = value;
    if (quincena == '06-1') m06q1 = value;
    if (quincena == '06-2') m06q2 = value;
    if (quincena == '06-x') m06qx = value;
    if (quincena == '07-1') m07q1 = value;
    if (quincena == '07-2') m07q2 = value;
    if (quincena == '07-x') m07qx = value;
    if (quincena == '08-1') m08q1 = value;
    if (quincena == '08-2') m08q2 = value;
    if (quincena == '08-x') m08qx = value;
    if (quincena == '09-1') m09q1 = value;
    if (quincena == '09-2') m09q2 = value;
    if (quincena == '09-x') m09qx = value;
    if (quincena == '10-1') m10q1 = value;
    if (quincena == '10-2') m10q2 = value;
    if (quincena == '10-x') m10qx = value;
    if (quincena == '11-1') m11q1 = value;
    if (quincena == '11-2') m11q2 = value;
    if (quincena == '11-x') m11qx = value;
    if (quincena == '12-1') m12q1 = value;
    if (quincena == '12-2') m12q2 = value;
    if (quincena == '12-x') m12qx = value;
  }
}
