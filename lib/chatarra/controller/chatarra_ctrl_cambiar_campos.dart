import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../models/mm60_b.dart';
import '../model/chatarra_enum.dart';
import '../model/chatarra_model.dart';
import '../model/chatarra_reg_enum.dart';
import '../model/chatarra_registros.dart';

class ChatarraCtrlCambiarCampos {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ChatarraCtrlCambiarCampos(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  changeChatarra({
    required CampoChatarra campo,
    required String value,
    CampoChatarraReg campoReg = CampoChatarraReg.um,
    String index = '1',
  }) {
    Chatarra chatarra = state().chatarra!;
    final mm60 = state().mm60B!;
    if (campo == CampoChatarra.id) {
      chatarra.id = value;
    }
    if (campo == CampoChatarra.pedido) {
      chatarra.pedido = value;
    }
    if (campo == CampoChatarra.acta) {
      chatarra.acta = value;
    }
    if (campo == CampoChatarra.fecha_i) {
      chatarra.fecha_i = value;
    }
    if (campo == CampoChatarra.almacenista_i) {
      chatarra.almacenista_i = value;
    }
    if (campo == CampoChatarra.tel_i) {
      chatarra.tel_i = value;
    }
    if (campo == CampoChatarra.soporte_i) {
      chatarra.soporte_i = value;
    }
    if (campo == CampoChatarra.lcl) {
      chatarra.lcl = value;
    }
    if (campo == CampoChatarra.items) {
      if (index == 'add') {
        print('Adding new item');
        chatarra.items.add(
          ChatarraReg.fromNuevo('${chatarra.items.length + 1}'),
        );
      }
      if (index == 'remove') {
        chatarra.items.removeLast();
      }
      if (index == 'resize') {
        chatarra.items.clear();
        chatarra.items.length = 0;
        // print('resizeValor: $valor');
        chatarra.items = [];
        chatarra.items = List.generate(
          int.parse(value),
          (index) => ChatarraReg.fromNuevo('${index + 1}'),
        );
        // print('items: $items');
      }
      if (campoReg == CampoChatarraReg.e4e) {
        // print('valor: $valor');
        // print('index: $index');
        chatarra.items[int.parse(index)].e4e = value;
        // print('items: ${items}');
        if (value.length == 6) {
          Mm60SingleB inMm60 = mm60.mm60List.firstWhere(
            (e) => e.material.contains(value),
            orElse: () => Mm60SingleB.fromInit(),
          );

          chatarra.items[int.parse(index)].descripcion = inMm60.descripcion;
          chatarra.items[int.parse(index)].um = inMm60.um;
          chatarra.items[int.parse(index)].valor = inMm60.precio;
        }
      }
      if (campoReg == CampoChatarraReg.ctd) {
        chatarra.items[int.parse(index)].ctd = value;
      }
    }
    if (campo == CampoChatarra.comentario_i) {
      chatarra.comentario_i = value;
    }
    if (campo == CampoChatarra.balance) {
      chatarra.balance = value;
    }
    if (campo == CampoChatarra.reportado) {
      chatarra.reportado = value;
    }
    if (campo == CampoChatarra.estadopersona) {
      chatarra.estadopersona = value;
    }
    if (campo == CampoChatarra.estado) {
      chatarra.estado = value;
    }
    emit(state().copyWith(chatarra: chatarra));
  }
}
