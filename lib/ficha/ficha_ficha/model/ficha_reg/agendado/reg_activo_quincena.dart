class FichaRegAgendadoActivoQuincena {
  bool m01q1 = false;
  bool m01q2 = false;
  bool m02q1 = false;
  bool m02q2 = false;
  bool m03q1 = false;
  bool m03q2 = false;
  bool m04q1 = false;
  bool m04q2 = false;
  bool m05q1 = false;
  bool m05q2 = false;
  bool m06q1 = false;
  bool m06q2 = false;
  bool m07q1 = false;
  bool m07q2 = false;
  bool m08q1 = false;
  bool m08q2 = false;
  bool m09q1 = false;
  bool m09q2 = false;
  bool m10q1 = false;
  bool m10q2 = false;
  bool m11q1 = false;
  bool m11q2 = false;
  bool m12q1 = false;
  bool m12q2 = false;

  void set(String quincena, bool value){
    if (quincena == '01-1') m01q1 = value;
    if (quincena == '01-2') m01q2 = value;
    if (quincena == '02-1') m02q1 = value;
    if (quincena == '02-2') m02q2 = value;
    if (quincena == '03-1') m03q1 = value;
    if (quincena == '03-2') m03q2 = value;
    if (quincena == '04-1') m04q1 = value;
    if (quincena == '04-2') m04q2 = value;
    if (quincena == '05-1') m05q1 = value;
    if (quincena == '05-2') m05q2 = value;
    if (quincena == '06-1') m06q1 = value;
    if (quincena == '06-2') m06q2 = value;
    if (quincena == '07-1') m07q1 = value;
    if (quincena == '07-2') m07q2 = value;
    if (quincena == '08-1') m08q1 = value;
    if (quincena == '08-2') m08q2 = value;
    if (quincena == '09-1') m09q1 = value;
    if (quincena == '09-2') m09q2 = value;
    if (quincena == '10-1') m10q1 = value;
    if (quincena == '10-2') m10q2 = value;
    if (quincena == '11-1') m11q1 = value;
    if (quincena == '11-2') m11q2 = value;
    if (quincena == '12-1') m12q1 = value;
    if (quincena == '12-2') m12q2 = value;
  }  

  bool get(String quincena){
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
    return false;
  }
}