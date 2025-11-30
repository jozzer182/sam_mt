import 'reg.dart';

class FichaRegLog {
  final FichaReg fichaReg;
  FichaRegLog(this.fichaReg);

  String cambio = '';
  String razon = '';
  String persona = '';
  String fecha = '';
  String respuesta = '';
  String razonrespuesta = '';
  String personarespuesta = '';
  String fecharespuesta = '';

    Map<String, dynamic> toMap() {
    return {
      'item': fichaReg.item,
      'year': fichaReg.year,
      'id': fichaReg.id,
      'estado': fichaReg.estado,
      'estdespacho': fichaReg.estdespacho,
      'tipo': fichaReg.tipo,
      'fechainicial': fichaReg.fechainicial,
      'fechacambio': fichaReg.fechacambio,
      'fechasolicitud': fichaReg.fechasolicitud,
      'unidad': fichaReg.unidad,
      'codigo': fichaReg.codigo,
      'proyecto': fichaReg.proyecto,
      'circuito': fichaReg.circuito,
      'pm': fichaReg.pm,
      'solicitante': fichaReg.solicitante,
      'pdi': fichaReg.pdi,
      'wbe': fichaReg.wbe,
      'proyectowbe': fichaReg.proyectowbe,
      'comentario1': fichaReg.comentario1,
      'comentario2': fichaReg.comentario2,
      'e4e': fichaReg.e4e,
      'descripcion': fichaReg.descripcion,
      'um': fichaReg.um,
      'm01q1': fichaReg.m01q1,
      'm01q2': fichaReg.m01q2,
      'm01qx': fichaReg.m01qx,
      'm02q1': fichaReg.m02q1,
      'm02q2': fichaReg.m02q2,
      'm02qx': fichaReg.m02qx,
      'm03q1': fichaReg.m03q1,
      'm03q2': fichaReg.m03q2,
      'm03qx': fichaReg.m03qx,
      'm04q1': fichaReg.m04q1,
      'm04q2': fichaReg.m04q2,
      'm04qx': fichaReg.m04qx,
      'm05q1': fichaReg.m05q1,
      'm05q2': fichaReg.m05q2,
      'm05qx': fichaReg.m05qx,
      'm06q1': fichaReg.m06q1,
      'm06q2': fichaReg.m06q2,
      'm06qx': fichaReg.m06qx,
      'm07q1': fichaReg.m07q1,
      'm07q2': fichaReg.m07q2,
      'm07qx': fichaReg.m07qx,
      'm08q1': fichaReg.m08q1,
      'm08q2': fichaReg.m08q2,
      'm08qx': fichaReg.m08qx,
      'm09q1': fichaReg.m09q1,
      'm09q2': fichaReg.m09q2,
      'm09qx': fichaReg.m09qx,
      'm10q1': fichaReg.m10q1,
      'm10q2': fichaReg.m10q2,
      'm10qx': fichaReg.m10qx,
      'm11q1': fichaReg.m11q1,
      'm11q2': fichaReg.m11q2,
      'm11qx': fichaReg.m11qx,
      'm12q1': fichaReg.m12q1,
      'm12q2': fichaReg.m12q2,
      'm12qx': fichaReg.m12qx,
      'cambio': cambio,
      'razon': razon,
      'persona': persona,
      'fecha': fecha,
      'respuesta': respuesta,
      'razonrespuesta': razonrespuesta,
      'personarespuesta': personarespuesta,
      'fecharespuesta': fecharespuesta,
    };
  }

}
