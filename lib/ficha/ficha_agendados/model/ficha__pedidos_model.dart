
import '../../../fechas_fem/model/fechasfem_model.dart';
import '../../ficha_ficha/model/ficha_reg/reg.dart';

class FPedidos {
  List<FichaReg> ficha;
  late List<FichaReg> fichaModificada;
  FechasFEM fechasFEM;
  bool editar = false;
  
  FPedidos({
    required this.ficha,
    required this.fechasFEM,
  }) {
    fichaModificada = ficha.map((e) => e.copyWith()).toList();
  }
}
