part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class LoadData extends MainEvent {}
class Load extends MainEvent {}

class Loading extends MainEvent {
  final bool isLoading;
  Loading({
    required this.isLoading,
  });
}

// class Busqueda extends MainEvent {
//   final String value;
//   final String table;
//   Busqueda({
//     required this.value,
//     required this.table,
//   });
// }

class CalculateData extends MainEvent {}


class LoadindList extends MainEvent {
  final String table;
  final bool loading;
  LoadindList({
    required this.table,
    required this.loading,
  });
}

class EnviarPlanilla extends MainEvent {}


// class CambioLCL extends MainEvent {
//   String tabla;
//   String lcl;
//   Map map;
//   CambioLCL({
//     required this.tabla,
//     required this.map,
//     required this.lcl,
//   });
// }


class ThemeChange extends MainEvent {
  ThemeChange();
}

class ThemeColorChange extends MainEvent {
  final Color color;
  ThemeColorChange({
    required this.color,
  });
}

class Message extends MainEvent {
  final String message;
  Message({
    required this.message,
  });
}
