import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async/async.dart';
import 'package:v_al_sam_v02/bloc/action_color.dart';
import 'package:v_al_sam_v02/bloc/action_load_ud.dart';
import '../pdis/controller/pdis_ctrl.dart';
import '../perfiles/controller/perfiles_ctrl.dart';
import '../users/controller/users_controller.dart';
import 'main__bl.dart';
import 'main_bloc.dart';

onLoadData(
  event,
  Emitter<MainState> emit,
  MainState Function() state,
  add,
) async {
  state().initial();
  emit(state().copyWith(isLoading: true));
  FutureGroup futureGroup0 = FutureGroup();
  futureGroup0.add(PerfilesCtrl(Bl(emit, state, add)).obtener);
  futureGroup0.add(UsersCtrl(Bl(emit, state, add)).obtener);
  futureGroup0.add(PdisCtrl(Bl(emit, state, add)).obtener);
  futureGroup0.close();
  FutureGroup futureGroup = FutureGroup();
  futureGroup.add(
    futureGroup0.future.whenComplete(
      () async => await onLoadUserData(event, emit, state, add),
    ),
  );

  futureGroup.add(themeLoader(event, emit, state));
  futureGroup.add(themeColorLoader(event, emit, state));
  futureGroup.close();
  try {
    await futureGroup.future.whenComplete(() async {});
    if (state().fichas != null) {}
  } on Exception catch (e) {
    Bl(emit, state, add).errorCarga('Error al cargar los datos', e);
    // print(e.toString());
  }
  // print('state().users.usersList: ${state().users!.usersList}');
  emit(state().copyWith(isLoading: false));
}
