
import 'package:v_al_sam_v02/deuda_almacen/model/deudaalmacen_model.dart';

class Saldos {
  List<DeudaAlmacenBSingle> saldosList = [];
  List<DeudaAlmacenBSingle> saldosListSearch = [];
  Map itemsAndFlex = {
    'e4e': 1,
    'descripcion': 6,
    'um': 1,
    'mb52': 2,
    'inv': 2,
    'sal': 2,
    'faltanteUnidades': 2,
    'faltanteValor': 2,
  };
  get keys {
    return itemsAndFlex.keys.toList();
  }

  get listaTitulo {
    return [
      for (var key in keys) {'texto': key, 'flex': itemsAndFlex[key]},
    ];
  }

}
