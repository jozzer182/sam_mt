import 'main_bloc.dart';

onMessage(
  Message event,
  emit,
  MainState Function() state,
) {
  emit(state().copyWith(
    dialogCounter: state().dialogCounter + 1,
    dialogMessage: event.message,
  ));
}
