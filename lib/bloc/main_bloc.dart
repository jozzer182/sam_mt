// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:v_al_sam_v02/aportacion/model/aportacion_model.dart';
import 'package:v_al_sam_v02/bloc/action_color.dart';
import 'package:v_al_sam_v02/carretes/model/carretes_model.dart';
import 'package:v_al_sam_v02/chatarra/model/chatarra_model.dart';

import 'package:v_al_sam_v02/conciliacion/model/conciliacion_model.dart';
import 'package:v_al_sam_v02/conciliaciones/model/conciliaciones_model.dart';
import 'package:v_al_sam_v02/dominios/model/dominios_model.dart';
import 'package:v_al_sam_v02/fechas_fem/model/fechasfem_model.dart';
import 'package:v_al_sam_v02/ficha/ficha_agendados/controller/ficha_pedidos_controller.dart';
import 'package:v_al_sam_v02/deuda_almacen/model/deudaalmacen_model.dart';
import 'package:v_al_sam_v02/deuda_bruta/model/deudabruta_model.dart';
import 'package:v_al_sam_v02/deuda_enel/model/deudaenel_model.dart';
import 'package:v_al_sam_v02/deuda_operativa/model/deudaoperativa_model.dart';
import 'package:v_al_sam_v02/informe_saldos/model/informe_saldos_model.dart';
import 'package:v_al_sam_v02/ingresos/model/ingresos_b.dart';
import 'package:v_al_sam_v02/inventario/model/inventario_model.dart';
import 'package:v_al_sam_v02/nuevo_traslado/model/traslado_model.dart';
import 'package:v_al_sam_v02/matnocnt/model/matnocnt_model.dart';
import 'package:v_al_sam_v02/mb51/model/mb51_model.dart';
import 'package:v_al_sam_v02/mb52/mb52_b.dart';
import 'package:v_al_sam_v02/medidaans/model/medidaans_model.dart';
import 'package:v_al_sam_v02/mm60/model/mm60_model.dart';
import 'package:v_al_sam_v02/models/mm60_b.dart';
import 'package:flutter/material.dart';
import 'package:v_al_sam_v02/nuevo_ingreso/model/nuevoingreso_model.dart';
import 'package:v_al_sam_v02/pdis/model/pdis_d.dart';
import 'package:v_al_sam_v02/people/model/people_model.dart';
import 'package:v_al_sam_v02/models/tabla_plan.dart';
import 'package:v_al_sam_v02/planilla/model/planilla_model.dart';
import 'package:v_al_sam_v02/pedidos/model/pedidos_model.dart';
import 'package:v_al_sam_v02/planilla/model/planilla_model_edit_b.dart';
import 'package:v_al_sam_v02/perfiles/model/perfiles_model.dart';
import 'package:v_al_sam_v02/lcl/model/lcl_model.dart';
import 'package:v_al_sam_v02/plataforma/model/plataforma.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_list.dart';
//import async

import 'package:v_al_sam_v02/user/user_model.dart';
import 'package:v_al_sam_v02/users/model/users_model.dart';

import '../balances/controller/balances_ctrl.dart';
import '../chatarra/controller/chatarra_ctrl.dart';
import '../chatarra/model/chatarra_list.dart';
import '../colas/model/colas_model.dart';
import '../conciliacion/controller/conciliacion_ctrl.dart';
import '../conciliaciones/controller/conciliaciones_ctrl.dart';
import '../dflcl/controller/dflcl_controller.dart';
import '../dflcl/model/dflcl_model.dart';
import '../dominios/controller/dominios_ctrl.dart';
import '../ficha/ficha_ficha/controller/ctrl_ficha.dart';
import '../ficha/ficha_solpe/controller/solpe_doc/solpe_doc_controller.dart';
import '../ficha/ficha_solpe/controller/solpe_list_controller.dart';
import '../ficha/ficha_solpe/model/solpe_doc.dart';
import '../ficha/main/ficha/model/ficha_model.dart';
import '../ficha/main/fichas/controller/fichas_action.dart';
import '../ficha/main/fichas/model/fichas_model.dart';
import '../homologacion/model/homologacion_model.dart';
import '../informe_saldos/controller/informe_saldos_ctrl.dart';
import '../ingresos/controller/ingresos_ctrl.dart';
import '../medidaans/controller/medidaans_ctrl.dart';
import '../moecom/entregas_mc/controller/entregas_mc_ctrl.dart';
import '../moecom/entregas_mc/model/entregas_mc_list_model.dart';
import '../moecom/movil_depot/controller/movil_depot_ctrl.dart';
import '../moecom/movil_depot/model/movil_depot_model.dart';
import '../moecom/consumos_mc/controller/consumos_mc_ctrl.dart';
import '../moecom/consumos_mc/model/consumos_mc_list.dart';
import '../nuevo_ingreso/controller/nuevoingreso_ctrl.dart';
import '../nuevo_traslado/controller/nuevo_traslado_ctrl.dart';
import '../pdis/controller/pdis_ctrl.dart';
import '../planilla/controller/planilla_ctrl.dart';
import '../rastreable/model/rastreable_model.dart';
import '../registros/controller/registros_ctrl.dart';
import '../sustitutos/model/sustitutos_model.dart';
import '../transformadores/model/transformadores_model.dart';
import 'action_load_data.dart';
import 'action_message.dart';
import 'main__bl.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState()) {
    on<Loading>(onLoading);
    on<LoadData>((ev, em) => onLoadData(ev, em, supraState, add));
    on<Load>((ev, em) => onLoadData(ev, em, supraState, add));
    on<Message>((ev, em) => onMessage(ev, em, supraState));
    on<ThemeChange>((ev, em) => onThemeChange(ev, em, supraState));
    on<ThemeColorChange>((ev, em) => onThemeColorChange(ev, em, supraState));
  }

  Bl get bl => Bl(emit, supraState, add);

  MainState supraState() => state;

  FichasController get fichasController => FichasController(bl);
  FichaPedidosController get fichaPedidosController =>
      FichaPedidosController(bl);
  FichaFichaController get fichaFichaController => FichaFichaController(bl);
  FichaSolPeListController get fichaSolPeListController =>
      FichaSolPeListController(bl);
  SolPeDocController get solPeDocController => SolPeDocController(bl);
  DflclController get dflclController => DflclController(bl);
  PdisCtrl get pdisCtrl => PdisCtrl(bl);
  DominiosCtrl get dominiosCtrl => DominiosCtrl(bl);
  MedidaansCtrl get medidaansCtrl => MedidaansCtrl(bl);
  RegistrosCtrl get registrosCtrl => RegistrosCtrl(bl);
  PlanillaCtrl get planillaCtrl => PlanillaCtrl(bl);
  ChatarraCtrl get chatarraCtrl => ChatarraCtrl(bl);
  ConciliacionCtrl get conciliacionCtrl => ConciliacionCtrl(bl);
  ConciliacionesCtrl get conciliacionesCtrl => ConciliacionesCtrl(bl);
  BalancesCtrl get balancesCtrl => BalancesCtrl(bl);
  IngresosCtrl get ingresosCtrl => IngresosCtrl(bl);
  InformeSaldosCtrl get informeSaldosCtrl => InformeSaldosCtrl(bl);
  NuevoIngresoCtrl get nuevoIngresoCtrl => NuevoIngresoCtrl(bl);
  NuevotrasladoCtrl get nuevoTrasladoCtrl => NuevotrasladoCtrl(bl);
  EntregasMcCtrl get entregasMcCtrl => EntregasMcCtrl(bl);
  MovilDepotCtrl get movilDepotCtrl => MovilDepotCtrl(bl);
  ConsumosMcCtrl get consumosMcCtrl => ConsumosMcCtrl(bl);
  MovilDepotCtrl get movilDepotController => MovilDepotCtrl(bl);


  onLoading(event, emit) {
    emit(state.copyWith(isLoading: event.isLoading));
  }
}
