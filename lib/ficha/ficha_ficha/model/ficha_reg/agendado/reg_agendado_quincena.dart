import '../../../../../resources/a_entero_2.dart';
import '../reg.dart';
import 'reg_agendado_programado_list.dart';

class FichaRegAgendadoQuincena {
  late int m01q1;
  late int m01q2;
  late int m02q1;
  late int m02q2;
  late int m03q1;
  late int m03q2;
  late int m04q1;
  late int m04q2;
  late int m05q1;
  late int m05q2;
  late int m06q1;
  late int m06q2;
  late int m07q1;
  late int m07q2;
  late int m08q1;
  late int m08q2;
  late int m09q1;
  late int m09q2;
  late int m10q1;
  late int m10q2;
  late int m11q1;
  late int m11q2;
  late int m12q1;
  late int m12q2;
  late int m01qx;
  late int m02qx;
  late int m03qx;
  late int m04qx;
  late int m05qx;
  late int m06qx;
  late int m07qx;
  late int m08qx;
  late int m09qx;
  late int m10qx;
  late int m11qx;
  late int m12qx;

  FichaRegAgendadoQuincena(
    FichaReg fichaReg,
    FichaRegAgendadoProgramado programado,
  ) {
    m01q1 = aEntero(fichaReg.m01q1) * programado.m01q1;
    m01q2 = aEntero(fichaReg.m01q2) * programado.m01q2;
    m02q1 = aEntero(fichaReg.m02q1) * programado.m02q1;
    m02q2 = aEntero(fichaReg.m02q2) * programado.m02q2;
    m03q1 = aEntero(fichaReg.m03q1) * programado.m03q1;
    m03q2 = aEntero(fichaReg.m03q2) * programado.m03q2;
    m04q1 = aEntero(fichaReg.m04q1) * programado.m04q1;
    m04q2 = aEntero(fichaReg.m04q2) * programado.m04q2;
    m05q1 = aEntero(fichaReg.m05q1) * programado.m05q1;
    m05q2 = aEntero(fichaReg.m05q2) * programado.m05q2;
    m06q1 = aEntero(fichaReg.m06q1) * programado.m06q1;
    m06q2 = aEntero(fichaReg.m06q2) * programado.m06q2;
    m07q1 = aEntero(fichaReg.m07q1) * programado.m07q1;
    m07q2 = aEntero(fichaReg.m07q2) * programado.m07q2;
    m08q1 = aEntero(fichaReg.m08q1) * programado.m08q1;
    m08q2 = aEntero(fichaReg.m08q2) * programado.m08q2;
    m09q1 = aEntero(fichaReg.m09q1) * programado.m09q1;
    m09q2 = aEntero(fichaReg.m09q2) * programado.m09q2;
    m10q1 = aEntero(fichaReg.m10q1) * programado.m10q1;
    m10q2 = aEntero(fichaReg.m10q2) * programado.m10q2;
    m11q1 = aEntero(fichaReg.m11q1) * programado.m11q1;
    m11q2 = aEntero(fichaReg.m11q2) * programado.m11q2;
    m12q1 = aEntero(fichaReg.m12q1) * programado.m12q1;
    m12q2 = aEntero(fichaReg.m12q2) * programado.m12q2;
    m01qx = aEntero(fichaReg.m01qx);
    m02qx = aEntero(fichaReg.m02qx);
    m03qx = aEntero(fichaReg.m03qx);
    m04qx = aEntero(fichaReg.m04qx);
    m05qx = aEntero(fichaReg.m05qx);
    m06qx = aEntero(fichaReg.m06qx);
    m07qx = aEntero(fichaReg.m07qx);
    m08qx = aEntero(fichaReg.m08qx);
    m09qx = aEntero(fichaReg.m09qx);
    m10qx = aEntero(fichaReg.m10qx);
    m11qx = aEntero(fichaReg.m11qx);
    m12qx = aEntero(fichaReg.m12qx);
  }

  int get(String quincena){
    if (quincena == '01-1') return m01q1;
    if (quincena == '01-2') return m01q2;
    if (quincena == '01-x') return m01qx;
    if (quincena == '02-1') return m02q1;
    if (quincena == '02-2') return m02q2;
    if (quincena == '02-x') return m02qx;
    if (quincena == '03-1') return m03q1;
    if (quincena == '03-2') return m03q2;
    if (quincena == '03-x') return m03qx;
    if (quincena == '04-1') return m04q1;
    if (quincena == '04-2') return m04q2;
    if (quincena == '04-x') return m04qx;
    if (quincena == '05-1') return m05q1;
    if (quincena == '05-2') return m05q2;
    if (quincena == '05-x') return m05qx;
    if (quincena == '06-1') return m06q1;
    if (quincena == '06-2') return m06q2;
    if (quincena == '06-x') return m06qx;
    if (quincena == '07-1') return m07q1;
    if (quincena == '07-2') return m07q2;
    if (quincena == '07-x') return m07qx;
    if (quincena == '08-1') return m08q1;
    if (quincena == '08-2') return m08q2;
    if (quincena == '08-x') return m08qx;
    if (quincena == '09-1') return m09q1;
    if (quincena == '09-2') return m09q2;
    if (quincena == '09-x') return m09qx;
    if (quincena == '10-1') return m10q1;
    if (quincena == '10-2') return m10q2;
    if (quincena == '10-x') return m10qx;
    if (quincena == '11-1') return m11q1;
    if (quincena == '11-2') return m11q2;
    if (quincena == '11-x') return m11qx;
    if (quincena == '12-1') return m12q1;
    if (quincena == '12-2') return m12q2;
    if (quincena == '12-x') return m12qx;
    return 0;
  }
}
