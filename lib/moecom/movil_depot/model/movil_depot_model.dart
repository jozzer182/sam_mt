import '../../../resources/titulo.dart';
import 'moveil_depot_inv_model.dart';
import 'movil_depot_movs_model.dart';

class MovilDepotList {
  List<MovilDepot> list = [];
  List<MDMovs> movs = [];
  List<MDInv> inv = [];

  List<ToCelda> titles = [
    ToCelda(valor: 'Mov', flex: 2),
    ToCelda(valor: 'Pedido', flex: 2),
    ToCelda(valor: 'Consecutivo', flex: 2),
    ToCelda(valor: 'Fecha', flex: 2),
    ToCelda(valor: 'Soporte', flex: 2),
    ToCelda(valor: 'Item', flex: 1),
    ToCelda(valor: 'TDC', flex: 2),
    ToCelda(valor: 'Ticket', flex: 2),
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'Descripción', flex: 4),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'Ctd', flex: 2),
    ToCelda(valor: 'Comentario', flex: 2),
    // ToCelda(valor: 'Tipo', flex: 2),
  ];

  List<ToCelda> titlesInv = [
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'Descripción', flex: 4),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'Movs', flex: 2),
    ToCelda(valor: 'Entregas', flex: 2),
    ToCelda(valor: 'Consumos', flex: 2),
    ToCelda(valor: 'Cantidad', flex: 2),

    // ToCelda(valor: 'Tipo', flex: 2),
  ];
}

class MovilDepot {
  String tecnico;
  String tecnicoid;
  String tecnicotype;
  int valor;
  int items;
  MovilDepot({
    required this.tecnico,
    required this.tecnicoid,
    required this.tecnicotype,
    required this.valor,
    required this.items,
  });

  List<String> toList() {
    return [
      tecnico,
      tecnicoid,
      tecnicotype,
      valor.toString(),
      items.toString(),
    ];
  }
}
