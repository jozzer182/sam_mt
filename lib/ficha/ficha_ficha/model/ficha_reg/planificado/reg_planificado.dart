import '../reg.dart';
import 'reg_planificado_color.dart';
import 'reg_planificado_mes.dart';
import 'reg_planificado_quincena.dart';
import 'reg_planificado_quincena_activo.dart';

class FichaRegPlanificado {
  final FichaReg fichaReg;
  FichaRegPlanificado(this.fichaReg);

  FichaRegPlanificadoColor color = FichaRegPlanificadoColor();

  FichaRegPlanificadoMes get mes => FichaRegPlanificadoMes(fichaReg);

  FichaRegPlanificadoQuincena get quincena => FichaRegPlanificadoQuincena(fichaReg);

  FichaRegPlanificadoQuincenaActivo get quincenaActivo => FichaRegPlanificadoQuincenaActivo(fichaReg);

  Map<String, String> toMapMonthPrecio(int precio) {
    return {
      'item': fichaReg.item,
      'cto': fichaReg.circuito,
      'wbe': fichaReg.wbe,
      'e4e': fichaReg.e4e,
      'descripcion': fichaReg.descripcion,
      'um': fichaReg.um,
      'valorunitario': '$precio',
      'm01': '${mes.m01}',
      'm02': '${mes.m02}',
      'm03': '${mes.m03}',
      'm04': '${mes.m04}',
      'm05': '${mes.m05}',
      'm06': '${mes.m06}',
      'm07': '${mes.m07}',
      'm08': '${mes.m08}',
      'm09': '${mes.m09}',
      'm10': '${mes.m10}',
      'm11': '${mes.m11}',
      'm12': '${mes.m12}',
      'total': '${mes.total}',
    };
  }

  Map<String, String> toMapMonthValue(int precio) {
    if (fichaReg.wbe.isNotEmpty) {
      return {
        'item': fichaReg.item,
        'cto': fichaReg.circuito,
        'wbe': fichaReg.wbe,
        'e4e': fichaReg.e4e,
        'descripcion': fichaReg.descripcion,
        'um': fichaReg.um,
        'valorunitario': '$precio',
        'm01': '0',
        'm02': '0',
        'm03': '0',
        'm04': '0',
        'm05': '0',
        'm06': '0',
        'm07': '0',
        'm08': '0',
        'm09': '0',
        'm10': '0',
        'm11': '0',
        'm12': '0',
        'total': '0',
      };
    }
    return {
      'item': fichaReg.item,
      'cto': fichaReg.circuito,
      'wbe': fichaReg.wbe,
      'e4e': fichaReg.e4e,
      'descripcion': fichaReg.descripcion,
      'um': fichaReg.um,
      'valorunitario': '$precio',
      'm01': '${mes.m01 * precio}',
      'm02': '${mes.m02 * precio}',
      'm03': '${mes.m03 * precio}',
      'm04': '${mes.m04 * precio}',
      'm05': '${mes.m05 * precio}',
      'm06': '${mes.m06 * precio}',
      'm07': '${mes.m07 * precio}',
      'm08': '${mes.m08 * precio}',
      'm09': '${mes.m09 * precio}',
      'm10': '${mes.m10 * precio}',
      'm11': '${mes.m11 * precio}',
      'm12': '${mes.m12 * precio}',
      'total': '${mes.total * precio}',
    };
  }
}
