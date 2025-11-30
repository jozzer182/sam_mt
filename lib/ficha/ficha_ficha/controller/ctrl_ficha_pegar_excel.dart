// import 'package:flutter/services.dart';

// import '../../../base/main__bl.dart';
// import '../../../base/main_bloc.dart';
// import '../../main/ficha/model/ficha_model.dart';
// import '../model/ficha__ficha_model.dart';
// import '../model/ficha_reg/reg.dart';
// import '../model/ficha_reg/reg_enum.dart';
// import 'campo/descripcion/ctrl_descripcion.dart';
// import 'campo/numeros/ctrl_numeros.dart';
// import 'ctrl_ficha_lista.dart';

// class CtrlFfichaPegarExcel {
//   final Bl bl;
//   late MainState Function() state;
//   late var emit;
//   late void Function(MainEvent p1) add;
//   late Ficha ficha;
//   late FFicha fficha;

//   CtrlFfichaPegarExcel(this.bl) {
//     emit = bl.emit;
//     state = bl.state;
//     add = bl.add;
//     ficha = state().ficha!;
//     fficha = state().ficha!.fficha;
//   }

//   Future<bool> get seLogroPegar async {
//     final clipboardData = await Clipboard.getData('text/plain');
//     String? data = clipboardData?.text;
//     if (data == null) return false;
//     if (data.isEmpty) return false;
//     bool tieneFormato = data.toLowerCase().startsWith('e4e');
//     if (!tieneFormato) return false;
//     final rows = data.split('\n').map((e) => e.trim()).toList();
//     rows.removeWhere((e) => e.isEmpty);
//     if (rows.length < 2) return false;
//     int columnas = rows[0].split('\t').length;
//     if (columnas != 17) return false;
//     await ctrlFfichaLista.reset;
//     await Future.delayed(const Duration(milliseconds: 100));
//     for (int j = 1; j < rows.length; j++) {
//       String row = rows[j];
//       final values = row.split('\t').map((e) => e.trim()).toList();
//       ctrlFfichaLista.agregar;
//       await Future.delayed(const Duration(milliseconds: 100));
//       FichaReg fichaReg = state().ficha!.fficha.fichaModificada.last;
//       for (int i = 0; i < values.length; i++) {
//         await Future.delayed(const Duration(microseconds: 10));
//         String value = values[i];
//         CtrlDescripcion ctrlDescripcion = CtrlDescripcion(bl, fichaReg);
//         if (i == 0) {
//           ctrlDescripcion.cambiar(tipo: TipoRegFicha.e4e, value: value);
//         }
//         if (i == 1) {
//           ctrlDescripcion.cambiar(tipo: TipoRegFicha.circuito, value: value);
//         }
//         if (i == 2) {
//           ctrlDescripcion.cambiar(tipo: TipoRegFicha.wbe, value: value);
//         }
//         if (i == 3) {
//           ctrlDescripcion.cambiar(tipo: TipoRegFicha.pdi, value: value);
//         }
//         if (i == 4) {
//           ctrlDescripcion.cambiar(tipo: TipoRegFicha.comentario2, value: value);
//         }
//         if (i > 4 && i < 17) {
//           CtrlNumeros ctrlNumeros = CtrlNumeros(bl, fichaReg);
//           String mes = (i - 4).toString().padLeft(2, '0');
//           int newValue; // Define newValue como un entero
//           // Intenta convertir value a un número, si falla, asigna 0 a newValue
//           try {
//             double number = double.parse(value);
//             newValue = number.ceil(); // Redondea hacia arriba
//           } catch (e) {
//             newValue = 0; // Si value no es un número, asigna 0 a newValue
//           }
//           ctrlNumeros.cambiar(mes: mes, value: newValue.toString());
//         }
//       } 
//     }
//     await Future.delayed(Duration(milliseconds: 100));
//     _guardar(ficha);
//     return true;
//   }

//   _guardar(Ficha ficha) {
//     return emit(state().copyWith(ficha: ficha));
//   }

//   CtrlFfichaLista get ctrlFfichaLista {
//     return CtrlFfichaLista(bl);
//   }
// }
