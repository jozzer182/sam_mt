import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../chatarra/controller/chatarra_ctrl.dart';
import '../conciliaciones/controller/conciliaciones_ctrl.dart';
import '../deuda_almacen/controller/deudaalmacen_ctrl.dart';
import '../deuda_bruta/controller/deudabruta_ctrl.dart';
import '../deuda_enel/controller/deudaenel_ctrl.dart';
import '../deuda_operativa/controller/deuda_operativa_ctrl.dart';
import '../fechas_fem/controller/fechasfem_ctrl.dart';
import '../ficha/ficha_solpe/controller/solpe_list_controller.dart';
import '../ficha/main/fichas/controller/fichas_action.dart';
import '../informe_saldos/controller/informe_saldos_ctrl.dart';
import '../ingresos/controller/ingresos_ctrl.dart';
import '../inventario/controller/inventario_ctrl.dart';
import '../lcl/controller/lcl_ctrl.dart';
import '../matnocnt/controller/matno_controller.dart';
import '../mb51/controller/mb51_controller.dart';
import '../dflcl/controller/dflcl_controller.dart';
import '../mb52/controller/mb52_controller.dart';
import '../medidaans/controller/medidaans_ctrl.dart';
import '../mm60/controller/mm60_action.dart';
import '../moecom/entregas_mc/controller/entregas_mc_ctrl.dart';
import '../moecom/consumos_mc/controller/consumos_mc_ctrl.dart';
import '../nuevo_ingreso/controller/nuevoingreso_ctrl.dart';
import '../nuevo_traslado/controller/nuevo_traslado_ctrl.dart';
import '../pedidos/controller/pedidos_actions.dart';
import '../planilla/controller/planilla_ctrl.dart';
import '../registros/controller/registros_ctrl.dart';
import '../sustitutos/controller/sustitutos_ctrl.dart';
import '../users/controller/users_controller.dart';
import '../aportacion/controller/aportacion_actions.dart';
import '../carretes/controller/carretes_ctrl.dart';
import '../colas/controller/colas_ctrl.dart';
import '../homologacion/controller/homologacion_ctrl.dart';
import '../people/controller/people_ctrl.dart';
import '../plataforma/controller/plataforma_controller.dart';
import '../rastreable/controller/rastreable_ctrl.dart';
import '../transformadores/controller/transformadores_ctrl.dart';

import 'main__bl.dart';
import 'main_bloc.dart';

Future onLoadUserData(
  LoadData event,
  emit,
  MainState Function() state,
  add,
) async {
  emit(state().copyWith(isLoading: true));
  print(FirebaseAuth.instance.currentUser?.email);

  if (FirebaseAuth.instance.currentUser?.email != null &&
      state().users != null) {
    await UsersCtrl(Bl(emit, state, add)).onCreateUser;
    if (state().user != null) {
      await PlanillaCtrl(Bl(emit, state, add)).crear;
      await NuevoIngresoCtrl(Bl(emit, state, add)).crear;
      await NuevotrasladoCtrl(Bl(emit, state, add)).crear;
      FutureGroup futureGroup = FutureGroup();
      FutureGroup futureGroupDeuda = FutureGroup();
      FutureGroup futureGroupFEM = FutureGroup();
      futureGroupDeuda.add(Mm60Controller(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(Mb51Controller(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(Mb52Controller(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(RegistrosCtrl(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(IngresosCtrl(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(ConciliacionesCtrl(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(ConsumosMcCtrl(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(EntregasMcCtrl(Bl(emit, state, add)).obtener);
      futureGroupDeuda.add(LclCtrl(Bl(emit, state, add)).obtener);
      futureGroupDeuda.close();
      futureGroup.add(
        futureGroupDeuda.future.whenComplete(() async {
          await InventarioCtrl(Bl(emit, state, add)).crear;
          await DeudabrutaCtrl(Bl(emit, state, add)).crear;
          await DeudaOperativaCtrl(Bl(emit, state, add)).crear;
          await DeudaAlmacenCtrl(Bl(emit, state, add)).crear;
          await InformeSaldosCtrl(Bl(emit, state, add)).crear;
          await DeudaEnelCtrl(Bl(emit, state, add)).crear;
          await MedidaansCtrl(Bl(emit, state, add)).crear;
          await MatnoController(Bl(emit, state, add)).obtener();
        }),
      );

      futureGroupFEM.add(FechasFemCtrl(Bl(emit, state, add)).obtener);
      futureGroupFEM.add(FichasController(Bl(emit, state, add)).obtener);
      futureGroupFEM.add(
        FichaSolPeListController(Bl(emit, state, add)).obtener,
      );
      futureGroupFEM.close();
      futureGroup.add(
        futureGroupFEM.future.whenComplete(() async {
          await FichasController(Bl(emit, state, add)).onCrearFichas;
          await PedidosController(Bl(emit, state, add)).createPedidos;
        }),
      );


      futureGroup.add(ChatarraCtrl(Bl(emit, state, add)).obtener);
      futureGroup.add(SustitutosController(Bl(emit, state, add)).obtener);
      futureGroup.add(DflclController(Bl(emit, state, add)).obtener);
      futureGroup.add(PeopleCtrl(Bl(emit, state, add)).obtener);

      futureGroup.add(PlataformaController(Bl(emit, state, add)).obtener);
      futureGroup.add(CarretesCtrl(Bl(emit, state, add)).obtener);
      futureGroup.add(ColasCtrl(Bl(emit, state, add)).obtener);
      futureGroup.add(TransformadoresCtrl(Bl(emit, state, add)).obtener);
      futureGroup.add(HomologacionCtrl(Bl(emit, state, add)).obtener);
      futureGroup.add(RastreableCtrl(Bl(emit, state, add)).obtener);
      futureGroup.add(AportacionCtrl(Bl(emit, state, add)).obtener);

      futureGroup.close();
      try {
        await futureGroup.future.whenComplete(() async {
          Bl(emit, state, add).stopLoading;
        });
      } on Exception catch (e) {
        Bl(emit, state, add).errorCarga("FutureGroup", e);
        print(e.toString());
      }
    }
  }
  // print('state().users.usersList: ${state().users!.usersList}');
  emit(state().copyWith(isLoading: false));
}
