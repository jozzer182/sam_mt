import '../../../resources/titulo.dart';
import 'consumos_mc_reg.dart';

class ConsumosMcList {
  List<ConsumoMc> list = [];
  List<ConsumoMc> listEdit = [];
  bool edit = false;

  List<ToCelda> titles = [
    ToCelda(valor: 'Pedido', flex: 2),
    ToCelda(valor: 'Consecutivo', flex: 2),
    ToCelda(valor: 'Técnico', flex: 4),
    ToCelda(valor: 'Soporte', flex: 2),
    ToCelda(valor: 'Item', flex: 1),
    ToCelda(valor: 'TDC', flex: 2),
    ToCelda(valor: 'Ticket', flex: 2),
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'Descripción', flex: 4),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'Ctd', flex: 2),
    ToCelda(valor: 'Comentario', flex: 2),
    ToCelda(valor: 'Tipo', flex: 2),
  ];
}
