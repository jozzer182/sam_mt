
import '../../../resources/titulo.dart';
import 'entregas_mc_reg_model.dart';

class EntregasMcList {
  List<EntregaMc> list = [];
  List<EntregaMc> listEdit = [];
  
  List<ToCelda> titles = [
    ToCelda(valor: 'Pedido', flex: 2),
    ToCelda(valor: 'Consecutivo', flex: 2),
    ToCelda(valor: 'Técnico', flex: 4),
    // ToCelda(valor: 'Tecnico ID', flex: 2),
    // ToCelda(valor: 'Tecnico type', flex: 2),
    // ToCelda(valor: 'Fecha', flex: 2),
    // ToCelda(valor: 'Almacenista', flex: 4),
    // ToCelda(valor: 'Teléfono', flex: 2),
    ToCelda(valor: 'Soporte', flex: 2),
    ToCelda(valor: 'Item', flex: 1),
    ToCelda(valor: 'E4E', flex: 2),
    ToCelda(valor: 'Descripción', flex: 4),
    ToCelda(valor: 'UM', flex: 1),
    ToCelda(valor: 'Ctd', flex: 2),
    // ToCelda(valor: 'Reportado', flex: 2),
    ToCelda(valor: 'Comentario', flex: 2),
    // ToCelda(valor: 'Anulado Nombre', flex: 2),
    // ToCelda(valor: 'Anulado Correo', flex: 2),
    // ToCelda(valor: 'Estado', flex: 2),
    ToCelda(valor: 'Tipo', flex: 2),
    // ToCelda(valor: 'Actualizado', flex: 2),
  ];
}
