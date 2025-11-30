import '../../../../../resources/a_entero_2.dart';
import '../reg.dart';
import 'reg_agendado_programado_list.dart';

class FichaRegAgendadoMes {
  late int m02;
  late int m01;
  late int m03;
  late int m04;
  late int m05;
  late int m06;
  late int m07;
  late int m08;
  late int m09;
  late int m10;
  late int m11;
  late int m12;
  late int total;

  FichaRegAgendadoMes(
    FichaReg fichaReg,
    FichaRegAgendadoProgramado programado,
  ) {
    m01 = aEntero(fichaReg.m01q1) * programado.m01q1 + aEntero(fichaReg.m01q2) * programado.m01q2 + aEntero(fichaReg.m01qx);
    m02 = aEntero(fichaReg.m02q1) * programado.m02q1 + aEntero(fichaReg.m02q2) * programado.m02q2 + aEntero(fichaReg.m02qx);
    m03 = aEntero(fichaReg.m03q1) * programado.m03q1 + aEntero(fichaReg.m03q2) * programado.m03q2 + aEntero(fichaReg.m03qx);
    m04 = aEntero(fichaReg.m04q1) * programado.m04q1 + aEntero(fichaReg.m04q2) * programado.m04q2 + aEntero(fichaReg.m04qx);
    m05 = aEntero(fichaReg.m05q1) * programado.m05q1 + aEntero(fichaReg.m05q2) * programado.m05q2 + aEntero(fichaReg.m05qx);
    m06 = aEntero(fichaReg.m06q1) * programado.m06q1 + aEntero(fichaReg.m06q2) * programado.m06q2 + aEntero(fichaReg.m06qx);
    m07 = aEntero(fichaReg.m07q1) * programado.m07q1 + aEntero(fichaReg.m07q2) * programado.m07q2 + aEntero(fichaReg.m07qx);
    m08 = aEntero(fichaReg.m08q1) * programado.m08q1 + aEntero(fichaReg.m08q2) * programado.m08q2 + aEntero(fichaReg.m08qx);
    m09 = aEntero(fichaReg.m09q1) * programado.m09q1 + aEntero(fichaReg.m09q2) * programado.m09q2 + aEntero(fichaReg.m09qx);
    m10 = aEntero(fichaReg.m10q1) * programado.m10q1 + aEntero(fichaReg.m10q2) * programado.m10q2 + aEntero(fichaReg.m10qx);
    m11 = aEntero(fichaReg.m11q1) * programado.m11q1 + aEntero(fichaReg.m11q2) * programado.m11q2 + aEntero(fichaReg.m11qx);
    m12 = aEntero(fichaReg.m12q1) * programado.m12q1 + aEntero(fichaReg.m12q2) * programado.m12q2 + aEntero(fichaReg.m12qx);
    total = m01 + m02 + m03 + m04 + m05 + m06 + m07 + m08 + m09 + m10 + m11 + m12;
  }

  String get(String mes) {
    if (mes == '01') return m01.toString();
    if (mes == '02') return m02.toString();
    if (mes == '03') return m03.toString();
    if (mes == '04') return m04.toString();
    if (mes == '05') return m05.toString();
    if (mes == '06') return m06.toString();
    if (mes == '07') return m07.toString();
    if (mes == '08') return m08.toString();
    if (mes == '09') return m09.toString();
    if (mes == '10') return m10.toString();
    if (mes == '11') return m11.toString();
    if (mes == '12') return m12.toString();
    return '0';
  }
  
}
