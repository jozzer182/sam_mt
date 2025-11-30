import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';

class AportacionCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  AportacionCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get obtener async {
    
  }
}
