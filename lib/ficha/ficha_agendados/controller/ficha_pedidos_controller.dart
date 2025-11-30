import '../../../bloc/main__bl.dart';
import '../../../bloc/main_bloc.dart';


class FichaPedidosController {
  final Bl bl;
  late MainState Function() state;
  late var emit;
  late void Function(MainEvent p1) add;

  FichaPedidosController(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  // void editar(bool editar) {
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   fichaPedidos.editar = editar;
  //   fichaPedidos.fichaModificada =
  //       fichaPedidos.ficha.map((e) => e.copyWith()).toList();
  //   emit(state().copyWith(ficha: ficha));
  // }

  // void check({
  //   required String item,
  //   required String pedido,
  //   required String valor,
  // }) {
  //   // print('check $item $pedido $valor');
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<FichaReg> fichaModificada = fichaPedidos.fichaModificada;
  //   FichaReg singleFEM = fichaModificada.firstWhere(
  //     (e) => e.item == item,
  //     orElse: () => FichaReg.fromInit(0),
  //   );
  //   if (singleFEM.item != '0') {
  //     String q = pedido.substring(6);
  //     String mes = pedido.substring(0, 2);
  //     // print('m${mes}q${q}');
  //     bool noHaypedidoQ1 = singleFEM.toMapInt()['m${mes}q1'] == 0;
  //     bool noHaypedidoQ2 = singleFEM.toMapInt()['m${mes}q2'] == 0;
  //     if (q == '1' && noHaypedidoQ1) {
  //       bl.mensaje(
  //           message:
  //               'El valor de la cantidad en ${singleFEM.e4e} - mes:$mes Q1 no puede ser 0.');
  //     } else if (q == '2' && noHaypedidoQ2) {
  //       bl.mensaje(
  //           message:
  //               'El valor de la cantidad en ${singleFEM.e4e} - mes:$mes Q2 no puede ser 0.');
  //     } else if (singleFEM.pdi.isEmpty) {
  //       bl.mensaje(message: '${singleFEM.e4e} Requiere asignar PDI');
  //     } else if (singleFEM.tipo.isEmpty) {
  //       bl.mensaje(message: '${singleFEM.e4e} Requiere asignar tipo de envio');
  //     } else {
  //       singleFEM = singleFEM.setPedido(pedido, valor);
  //     }
  //   }
  //   // fichaPedidos.fichaModificada = fichaModificada;
  //   // ficha.fichaPedidos = fichaPedidos;
  //   emit(state().copyWith(ficha: ficha));
  // }

  // cambiarCampo({
  //   required String item,
  //   required TipoFem tipo,
  //   required String value,
  // }) {
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<SingleFEM> fichaModificada = fichaPedidos.fichaModificada;
  //   SingleFEM singleFEM = fichaModificada.firstWhere(
  //     (e) => e.item == item,
  //     orElse: () => SingleFEM.fromInit(0),
  //   );
  //   bool femExiste = singleFEM.item != '0';
  //   bool esCTO = tipo == TipoFem.circuito;
  //   if (femExiste) {
  //     if (esCTO) {
  //       _setCTO(fichaModificada, singleFEM, tipo, value);
  //     } else {
  //       singleFEM.setWithEnum(value: value, tipoFem: tipo);
  //     }
  //   }
  //   emit(state().copyWith(ficha: ficha));
  // }

  // _setCTO(
  //   List<SingleFEM> fichaModificada,
  //   SingleFEM singleFEM,
  //   TipoFem tipo,
  //   String value,
  // ) {
  //   List<String> e4eCtoFicha =
  //       fichaModificada.map((e) => '${e.circuito}${e.e4e}').toList();
  //   bool noSeRepiteEnFicha = !e4eCtoFicha.contains('${value}${singleFEM.e4e}');
  //   if (noSeRepiteEnFicha) {
  //     singleFEM.setWithEnum(value: value, tipoFem: tipo);
  //   } else {
  //     bl.mensaje(
  //         message:
  //             'REPETIDO: El circuito ${value} ya esta asignado a ${singleFEM.e4e}');
  //   }
  // }

  // void paraTodos({
  //   required List<String> items,
  //   required TipoFem tipo,
  //   required String value,
  //   String? pedido,
  // }) {
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<SingleFEM> fichaModificada = fichaPedidos.fichaModificada;
  //   Map e4eCtoScope = {};
  //   for (String item in items) {
  //     SingleFEM singleFEM = fichaModificada.firstWhere(
  //       (e) => e.item == item,
  //       orElse: () => SingleFEM.fromInit(0),
  //     );
  //     if (singleFEM.item != '0') {
  //       bool esCto = tipo == TipoFem.circuito;
  //       bool esEstdespacho = tipo == TipoFem.estdespacho;
  //       if (esCto) {
  //         List<String> e4eCtoFicha =
  //             fichaModificada.map((e) => '${e.circuito}${e.e4e}').toList();
  //         bool noSeRepiteEnFicha =
  //             !e4eCtoFicha.contains('$value${singleFEM.e4e}');
  //         bool noSeRepiteEnScope = e4eCtoScope[singleFEM.e4e] == null;
  //         if (noSeRepiteEnScope && noSeRepiteEnFicha) {
  //           e4eCtoScope[singleFEM.e4e] = singleFEM.circuito;
  //           singleFEM.setWithEnum(value: value, tipoFem: tipo);
  //         }
  //       }
  //       if (esEstdespacho && pedido != null) {
  //         String q = pedido.substring(6);
  //         String mes = pedido.substring(0, 2);
  //         // print('m${mes}q${q}');
  //         bool noHaypedidoQ1 = singleFEM.toMapInt()['m${mes}q1'] == 0;
  //         bool noHaypedidoQ2 = singleFEM.toMapInt()['m${mes}q2'] == 0;
  //         if (!(q == '1' && noHaypedidoQ1) &&
  //             !(q == '2' && noHaypedidoQ2) &&
  //             singleFEM.pdi.isNotEmpty &&
  //             singleFEM.tipo.isNotEmpty) {
  //           singleFEM.setPedido(pedido, value);
  //         }
  //       } else {
  //         singleFEM.setWithEnum(value: value, tipoFem: tipo);
  //       }
  //     }
  //   }
  //   emit(state().copyWith(ficha: ficha));
  // }

  // cambiarCantidad({
  //   required String item,
  //   required String campo,
  //   required String value,
  //   required int mes,
  //   required bool b1,
  // }) {
  //   // print('cambiarCantidad  $item $campo $value');
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<SingleFEM> fichaModificada = fichaPedidos.fichaModificada;
  //   SingleFEM singleFEM = fichaModificada.firstWhere(
  //     (e) => e.item == item,
  //     orElse: () => SingleFEM.fromInit(0),
  //   );
  //   if (singleFEM.item != '0') {
  //     // print('cambiarCantidad2  $item $campo $value');
  //     //hacer que la suma de los dos q sea igual a la cantidad
  //     if (!b1) {
  //       String campoQ1 = campo.replaceFirst('q2', 'q1');
  //       int q1 = singleFEM.toMapInt()[campoQ1]!;
  //       int q2 = mes - q1;
  //       int q2New = aEntero(value);
  //       if (q2 >= q2New) {
  //         singleFEM.setCantidad(
  //           campo: campo,
  //           value: value,
  //         );
  //       } else {
  //         bl.mensaje(
  //             message:
  //                 'La cantidad de la quincena 2 no puede ser mayor a la cantidad total del mes');
  //       }
  //     } else {
  //       bool esquincena2 = campo.contains('q2');
  //       if (esquincena2) {
  //         String campoQ1 = campo.replaceFirst('q2', 'q1');
  //         int q1 = singleFEM.toMapInt()[campoQ1]!;
  //         int q2 = int.parse(value);
  //         int cantidad = q1 + q2;
  //         if (cantidad > mes) {
  //           bl.mensaje(
  //               message:
  //                   'La cantidad de la quincena 2 no puede ser mayor a la cantidad total del mes');
  //         } else {
  //           singleFEM.setCantidad(
  //             campo: campo,
  //             value: value,
  //           );
  //         }
  //       } else {
  //         String campoQ2 = campo.replaceFirst('q1', 'q2');
  //         int q2 = singleFEM.toMapInt()[campoQ2]!;
  //         int q1 = int.parse(value);
  //         int cantidad = q1 + q2;
  //         if (cantidad > mes) {
  //           bl.mensaje(
  //               message:
  //                   'La cantidad de la quincena 1 no puede ser mayor a la cantidad total del mes');
  //         } else {
  //           singleFEM.setCantidad(
  //             campo: campo,
  //             value: value,
  //           );
  //         }
  //       }
  //     }
  //   }
  //   emit(state().copyWith(ficha: ficha));
  // }

  // String validar() {
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<SingleFEM> fichaModificada = fichaPedidos.fichaModificada;
  //   String mensaje = '';
  //   for (SingleFEM singleFEM in fichaModificada) {
  //     if (singleFEM.pdi.isEmpty) {
  //       mensaje +=
  //           'El item: ${singleFEM.item} e4e: ${singleFEM.e4e} no tiene PDI asignado\n';
  //     }
  //     if (singleFEM.tipo.isEmpty) {
  //       mensaje +=
  //           'El item: ${singleFEM.item} e4e: ${singleFEM.e4e} no tiene tipo de envio asignado\n';
  //     }
  //     if (singleFEM.proyectowbe.isEmpty ||
  //         !(singleFEM.proyectowbe == 'SI' || singleFEM.proyectowbe == 'NO')) {
  //       mensaje +=
  //           'El item: ${singleFEM.item} e4e: ${singleFEM.e4e} no tiene accion de causación asignada (Causar)\n';
  //     }

  //     if (singleFEM.wbe.isEmpty) {
  //       List<PlataformaSingle> plataformaList = state()
  //           .plataforma!
  //           .plataformaList
  //           .where(
  //               (e) => e.material == singleFEM.e4e && !e.wbe.contains('CTEC'))
  //           .toList();
  //       bool isMandatory = plataformaList.all((e) => e.wbe.isNotEmpty);
  //       if (isMandatory) {
  //         mensaje +=
  //             'El item: ${singleFEM.item} e4e: ${singleFEM.e4e} no tiene WBE asignado\n';
  //       }
  //     }
  //   }
  //   return mensaje;
  // }

  // bool crearCambios() {
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<SingleFEM> fichaModificada = fichaPedidos.fichaModificada;
  //   List<SingleFEM> fichaOriginal = fichaPedidos.ficha;
  //   List<EliminadosSingle> cambios = fichaPedidos.cambios;
  //   List<SingleFEM> nuevos = fichaPedidos.nuevos;
  //   for (int i = 0; i < fichaModificada.length; i++) {
  //     SingleFEM newFEM = fichaModificada[i];
  //     SingleFEM oldFEM = fichaOriginal[i];
  //     if (newFEM != oldFEM) {
  //       cambios.add(
  //         EliminadosSingle.fromComparison(
  //           oldFEM: oldFEM,
  //           newFEM: newFEM,
  //         ),
  //       );
  //       //fecha CAmbio as yyyy-mm-dd
  //       newFEM.fechacambio = DateTime.now().toString().substring(0, 10);
  //       newFEM.solicitante = state().user!.email;
  //       nuevos.add(newFEM);
  //     }
  //   }
  //   // print('cambios.length ${cambios.length}');
  //   if (cambios.isEmpty) {
  //     bl.mensaje(message: 'No se detectaron cambios');
  //     return false;
  //   }
  //   emit(state().copyWith(ficha: ficha));
  //   return true;
  // }

  // void agregarRazon(
  //   String razon,
  // ) {
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<EliminadosSingle> cambios = fichaPedidos.cambios;
  //   for (EliminadosSingle cambio in cambios) {
  //     cambio.razon = razon;
  //     cambio.persona = state().user!.email;
  //     cambio.fecha = DateTime.now().toString();
  //   }
  //   emit(state().copyWith(ficha: ficha));
  // }

  // void guardar() async {
  //   Ficha ficha = state().ficha!;
  //   FPedidos fichaPedidos = ficha.fichaPedidos;
  //   List<EliminadosSingle> cambios = fichaPedidos.cambios;
  //   // bl.mensaje(message: 'No se ha guardado, no se ha implementado el guardado');

  //   //guardarCambios
  //   Future<void> guardarCambios() async {
  //     Map<String, Object> dataSend = {
  //       'dataReq': {
  //         'libro': 'f${state().year}_eliminados',
  //         'hoja': 'reg',
  //         'vals': cambios.map((e) => e.toMap()).toList(),
  //       },
  //       'fname': "addRowsNotId"
  //     };
  //     // print(jsonEncode(dataSend));
  //     late Response response;
  //     try {
  //       response = await post(
  //         Uri.parse(
  //             "https://script.google.com/macros/s/AKfycbx23gG1YX3tB2r6KQ-7sBJdYNGURpHwHxnCmabRxLr8oRt3P6Te6JFvrm4-TqOBf5mX/exec"),
  //         body: jsonEncode(dataSend),
  //       );
  //     } on Exception catch (e) {
  //       bl.errorCarga('Envío Eliminados (Agendados)', e);
  //       return;
  //     }
  //     var dataAsListMap = jsonDecode(response.body);
  //     bl.mensaje(
  //       message: dataAsListMap,
  //       messageColor: Colors.green,
  //     );
  //   }

  //   //actualizarFicha
  //   Future<void> actualizarFicha() async {
  //     Map<String, Object> dataSend = {
  //       'dataReq': {
  //         'year': 'f${state().year}',
  //         'vals': fichaPedidos.nuevos.map((e) => e.toMap()).toList(),
  //       },
  //       'fname': "modFemDBLot"
  //     };
  //     // print(jsonEncode(dataSend));
  //     late Response response;
  //     try {
  //       response = await post(
  //         Uri.parse(
  //             "https://script.google.com/macros/s/AKfycbx23gG1YX3tB2r6KQ-7sBJdYNGURpHwHxnCmabRxLr8oRt3P6Te6JFvrm4-TqOBf5mX/exec"),
  //         body: jsonEncode(dataSend),
  //       );
  //     } on Exception catch (e) {
  //       bl.errorCarga('Actualizar Ficha', e);
  //       return;
  //     }
  //     var dataAsListMap = jsonDecode(response.body);
  //     bl.mensaje(
  //       message: dataAsListMap,
  //       messageColor: Colors.green,
  //     );
  //   }

  //   // concurrencia de guardado
  //   FutureGroupDelayed futureGroup = FutureGroupDelayed();
  //   futureGroup.addF(guardarCambios());
  //   futureGroup.addF(actualizarFicha());
  //   futureGroup.close();
  //   bl.startLoading;
  //   editar(false);
  //   gett.Get.back();
  //   gett.Get.back();
  //   await futureGroup.future;
  //   bl.add(Load());
  // }
}
