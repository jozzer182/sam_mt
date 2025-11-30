import '../../../resources/titulo.dart';
import 'solpe_reg.dart';

class SolPeList {
  List<SolPeReg> list = [];

  List<ToCelda> get celdas => [
        ToCelda(valor: 'Pedido', flex: 2),
        ToCelda(valor: 'Pos', flex: 1),
        ToCelda(valor: 'E4e', flex: 1),
        ToCelda(valor: 'Descripción', flex: 6),
        ToCelda(valor: 'Um', flex: 1),
        ToCelda(valor: 'Ctd\nSolicitada', flex: 1),
        ToCelda(valor: 'Ctd\nPedida', flex: 1),
        ToCelda(valor: 'Pedido\nAgendado', flex: 1),
        // ToCelda(valor: 'PDI', flex: 1),
        // ToCelda(valor: 'Proyecto', flex: 1),
        ToCelda(valor: 'Circuito', flex: 2),
        ToCelda(valor: 'Persona', flex: 4),
        ToCelda(valor: 'Fecha', flex: 2),
      ];
}
