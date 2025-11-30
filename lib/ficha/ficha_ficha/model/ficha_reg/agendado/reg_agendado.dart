import '../reg.dart';
import 'reg_activo_mes.dart';
import 'reg_activo_quincena.dart';
import 'reg_agendado_color.dart';
import 'reg_agendado_mes.dart';
import 'reg_agendado_programado_list.dart';
import 'reg_agendado_quincena.dart';

class FichaRegAgendado {
  final FichaReg fichaReg;
  FichaRegAgendado(this.fichaReg);

  FichaRegAgendadoActivoMes activoMes = FichaRegAgendadoActivoMes();
  FichaRegAgendadoActivoQuincena activoQuincena = FichaRegAgendadoActivoQuincena();
  FichaRegAgendadoColor color = FichaRegAgendadoColor();

  FichaRegAgendadoQuincena get quincena => FichaRegAgendadoQuincena(fichaReg, programado);
  FichaRegAgendadoMes get mes => FichaRegAgendadoMes(fichaReg, programado);
  FichaRegAgendadoProgramado get programado => FichaRegAgendadoProgramado(fichaReg);

  Map<String, dynamic> get mapDownload => {
        'item': fichaReg.item,
        'cto': fichaReg.circuito,
        'wbe': fichaReg.wbe,
        'e4e': fichaReg.e4e,
        'descripcion': fichaReg.descripcion,
        'um': fichaReg.um,
        'm01q1': quincena.m01q1,
        'm01q2': quincena.m01q2,
        'm01qx': quincena.m01qx,
        'm02q1': quincena.m02q1,
        'm02q2': quincena.m02q2,
        'm02qx': quincena.m02qx,
        'm03q1': quincena.m03q1,
        'm03q2': quincena.m03q2,
        'm03qx': quincena.m03qx,
        'm04q1': quincena.m04q1,
        'm04q2': quincena.m04q2,
        'm04qx': quincena.m04qx,
        'm05q1': quincena.m05q1,
        'm05q2': quincena.m05q2,
        'm05qx': quincena.m05qx,
        'm06q1': quincena.m06q1,
        'm06q2': quincena.m06q2,
        'm06qx': quincena.m06qx,
        'm07q1': quincena.m07q1,
        'm07q2': quincena.m07q2,
        'm07qx': quincena.m07qx,
        'm08q1': quincena.m08q1,
        'm08q2': quincena.m08q2,
        'm08qx': quincena.m08qx,
        'm09q1': quincena.m09q1,
        'm09q2': quincena.m09q2,
        'm09qx': quincena.m09qx,
        'm10q1': quincena.m10q1,
        'm10q2': quincena.m10q2,
        'm10qx': quincena.m10qx,
        'm11q1': quincena.m11q1,
        'm11q2': quincena.m11q2,
        'm11qx': quincena.m11qx,
        'm12q1': quincena.m12q1,
        'm12q2': quincena.m12q2,
        'm12qx': quincena.m12qx,
        'total': mes.total,
      };
}
