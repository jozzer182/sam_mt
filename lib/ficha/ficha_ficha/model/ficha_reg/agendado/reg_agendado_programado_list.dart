import 'dart:convert';

import '../../../../../resources/a_entero_2.dart';
import '../reg.dart';

class FichaRegAgendadoProgramado {
  int m01q1 = 0;
  int m01q2 = 0;
  int m02q1 = 0;
  int m02q2 = 0;
  int m03q1 = 0;
  int m03q2 = 0;
  int m04q1 = 0;
  int m04q2 = 0;
  int m05q1 = 0;
  int m05q2 = 0;
  int m06q1 = 0;
  int m06q2 = 0;
  int m07q1 = 0;
  int m07q2 = 0;
  int m08q1 = 0;
  int m08q2 = 0;
  int m09q1 = 0;
  int m09q2 = 0;
  int m10q1 = 0;
  int m10q2 = 0;
  int m11q1 = 0;
  int m11q2 = 0;
  int m12q1 = 0;
  int m12q2 = 0;

  FichaRegAgendadoProgramado(FichaReg fichaReg) {
    List lista = jsonDecode(fichaReg.estdespacho)[0].values.toList();
    m01q1 = aEntero(lista[0]);
    m01q2 = aEntero(lista[1]);
    m02q1 = aEntero(lista[2]);
    m02q2 = aEntero(lista[3]);
    m03q1 = aEntero(lista[4]);
    m03q2 = aEntero(lista[5]);
    m04q1 = aEntero(lista[6]);
    m04q2 = aEntero(lista[7]);
    m05q1 = aEntero(lista[8]);
    m05q2 = aEntero(lista[9]);
    m06q1 = aEntero(lista[10]);
    m06q2 = aEntero(lista[11]);
    m07q1 = aEntero(lista[12]);
    m07q2 = aEntero(lista[13]);
    m08q1 = aEntero(lista[14]);
    m08q2 = aEntero(lista[15]);
    m09q1 = aEntero(lista[16]);
    m09q2 = aEntero(lista[17]);
    m10q1 = aEntero(lista[18]);
    m10q2 = aEntero(lista[19]);
    m11q1 = aEntero(lista[20]); 
    m11q2 = aEntero(lista[21]);
    m12q1 = aEntero(lista[22]);
    m12q2 = aEntero(lista[23]);
  }

  int get(String quincena){
    if (quincena == '01-1') return m01q1;
    if (quincena == '01-2') return m01q2;
    if (quincena == '02-1') return m02q1;
    if (quincena == '02-2') return m02q2;
    if (quincena == '03-1') return m03q1;
    if (quincena == '03-2') return m03q2;
    if (quincena == '04-1') return m04q1;
    if (quincena == '04-2') return m04q2;
    if (quincena == '05-1') return m05q1;
    if (quincena == '05-2') return m05q2;
    if (quincena == '06-1') return m06q1;
    if (quincena == '06-2') return m06q2;
    if (quincena == '07-1') return m07q1;
    if (quincena == '07-2') return m07q2;
    if (quincena == '08-1') return m08q1;
    if (quincena == '08-2') return m08q2;
    if (quincena == '09-1') return m09q1;
    if (quincena == '09-2') return m09q2;
    if (quincena == '10-1') return m10q1;
    if (quincena == '10-2') return m10q2;
    if (quincena == '11-1') return m11q1;
    if (quincena == '11-2') return m11q2;
    if (quincena == '12-1') return m12q1;
    if (quincena == '12-2') return m12q2;
    return 0;
  }
}
