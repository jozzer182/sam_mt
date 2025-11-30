import 'package:v_al_sam_v02/ficha/ficha_ficha/model/ficha_reg/reg.dart';

import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../ficha/main/fichas/model/fichas_model.dart';
import '../model/pedidos_model.dart';

class PedidosController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;
  PedidosController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }
  get createPedidos {
    Pedidos pedidos = Pedidos();
    MainState Function() state = bl.state;
    List<String> quincenas = [
      '01-1',
      '01-2',
      '01-x',
      '02-1',
      '02-2',
      '02-x',
      '03-1',
      '03-2',
      '03-x',
      '04-1',
      '04-2',
      '04-x',
      '05-1',
      '05-2',
      '05-x',
      '06-1',
      '06-2',
      '06-x',
      '07-1',
      '07-2',
      '07-x',
      '08-1',
      '08-2',
      '08-x',
      '09-1',
      '09-2',
      '09-x',
      '10-1',
      '10-2',
      '10-x',
      '11-1',
      '11-2',
      '11-x',
      '12-1',
      '12-2',
      '12-x',
    ];

    try {
      // await pedidos.obtener();
      Fichas fichas = state().fichas!;
      // String year = state().year!;
      for (FichaReg reg in fichas.f2025Raw) {
        String year = '2025';
        for (String quincena in quincenas) {
          int ctd = reg.agendado.quincena.get(quincena);
          bool noEsCero = ctd != 0;
          if (noEsCero) {
            pedidos.pedidosList.add(
              PedidosSingle(
                pedido: '$year||$quincena',
                id: reg.id,
                e4e: reg.e4e,
                descripcion: reg.descripcion,
                ctdi: '$ctd',
                ctdf: reg.proyectowbe,
                um: reg.um,
                comentario: reg.comentario1,
                solicitante: reg.solicitante,
                tipoenvio: reg.tipo,
                pdi: reg.pdi,
                pdiname: 'pdiname',
                proyecto: reg.proyecto,
                ref: reg.circuito,
                wbe: reg.wbe,
                wbeproyecto: '',
                wbeparte: '',
                wbeestado: '',
                fecha: reg.fechasolicitud,
                estado: 'enFicha',
                lastperson: reg.solicitante,
              ),
            );
          }
        }
      }

      bl.emit(state().copyWith(pedidos: pedidos));
    } catch (e) {
      bl.errorCarga("Pedidos", e);
    }
  }
}
