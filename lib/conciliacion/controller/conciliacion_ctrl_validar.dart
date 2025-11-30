import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/conciliacion_model.dart';

class ChatarraCtrlValidar {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  ChatarraCtrlValidar(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  List? get validar {
    Conciliacion conciliacion = state().conciliacion!;
    var faltantes = <String>[];
    if (conciliacion.lcl.isEmpty) faltantes.add('lcl');
    if (faltantes.isNotEmpty) {
      faltantes.insert(
        0,
        'Por favor revise los siguientes campos para poder realizar el guardado:',
      );
      return faltantes;
    } else {
      return null;
    }
  }
}
