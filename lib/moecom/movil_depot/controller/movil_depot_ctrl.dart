import 'package:v_al_sam_v02/moecom/movil_depot/model/movil_depot_model.dart';

import '../../../bloc/main__bl.dart';
import '../../../bloc/main_bloc.dart';
import '../../../mm60/model/mm60_model.dart';
import '../../../resources/a_entero_2.dart';
import '../../entregas_mc/model/entregas_mc_list_model.dart';
import '../../entregas_mc/model/entregas_mc_reg_model.dart';
import '../../consumos_mc/model/consumos_mc_reg.dart';
import '../model/moveil_depot_inv_model.dart';
import '../model/movil_depot_movs_model.dart';

class MovilDepotCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  MovilDepotCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear {
    MovilDepotList movilDepotList = MovilDepotList();
    List<MovilDepot> list = movilDepotList.list;
    List<MDInv> inv = movilDepotList.inv;
    EntregasMcList cargasMcList = state().entregasMcList!;
    List<EntregaMc> listCargaMc = cargasMcList.list;
    List<ConsumoMc> listPlanillaMc = state().consumosMcList?.list ?? [];
    List<Mm60Single> mm60 = state().mm60?.mm60List ?? [];

    listCargaMc = listCargaMc.where((e) => e.estado != 'anulado').toList();

    for (var i = 0; i < listCargaMc.length; i++) {
      EntregaMc cargaMc = listCargaMc[i];
      if (!list.map((e) => e.tecnicoid).contains(cargaMc.tecnicoid)) {
        list.add(
          MovilDepot(
            tecnico: cargaMc.tecnico,
            tecnicoid: cargaMc.tecnicoid,
            tecnicotype: cargaMc.tecnicotype,
            valor: 0,
            items: 0,
          ),
        );
      }
      MovilDepot movilDepot = list.firstWhere(
        (e) => e.tecnicoid == cargaMc.tecnicoid,
      );
      movilDepot.items += aEntero(cargaMc.ctd);
      String precioUnitario =
          mm60
              .firstWhere(
                (e) => e.material == cargaMc.e4e,
                orElse: () => Mm60Single.fromInit(),
              )
              .precio;
      movilDepot.valor += aEntero(precioUnitario) * aEntero(cargaMc.ctd);

      if (!inv.map((e) => '${e.id}${e.e4e}').contains('${cargaMc.tecnicoid}${cargaMc.e4e}')) {
        inv.add(
          MDInv(
            id: cargaMc.tecnicoid,
            tecnico: cargaMc.tecnico,
            tecnicotype: cargaMc.tecnicotype,
            e4e: cargaMc.e4e,
            descripcion: cargaMc.descripcion,
            um: cargaMc.um,
            movs: 0,
            entregas: 0,
            consumos: 0,
            cantidad: 0,
          ),
        );
      }
      MDInv mdInv = inv.firstWhere((e) => e.id == cargaMc.tecnicoid && e.e4e == cargaMc.e4e);
      mdInv.entregas += aEntero(cargaMc.ctd);
      mdInv.cantidad += aEntero(cargaMc.ctd);
      mdInv.movs += 1;
    }

    listPlanillaMc =
        listPlanillaMc.where((e) => e.estado != 'anulado').toList();

    for (var i = 0; i < listPlanillaMc.length; i++) {
      if (!list.map((e) => e.tecnicoid).contains(listPlanillaMc[i].tecnicoid)) {
        list.add(
          MovilDepot(
            tecnico: listPlanillaMc[i].tecnico,
            tecnicoid: listPlanillaMc[i].tecnicoid,
            tecnicotype: listPlanillaMc[i].tecnicotype,
            valor: 0,
            items: 0,
          ),
        );
      }
      MovilDepot movilDepot = list.firstWhere(
        (e) => e.tecnicoid == listPlanillaMc[i].tecnicoid,
      );
      movilDepot.items += aEntero(listPlanillaMc[i].ctd);
      String precioUnitario =
          mm60
              .firstWhere(
                (e) => e.material == listPlanillaMc[i].e4e,
                orElse: () => Mm60Single.fromInit(),
              )
              .precio;
      movilDepot.valor -=
          aEntero(precioUnitario) * aEntero(listPlanillaMc[i].ctd);

      if (!inv.map((e) => '${e.id}${e.e4e}').contains('${listPlanillaMc[i].tecnicoid}${listPlanillaMc[i].e4e}')) {
        inv.add(
          MDInv(
            id: listPlanillaMc[i].tecnicoid,
            tecnico: listPlanillaMc[i].tecnico,
            tecnicotype: listPlanillaMc[i].tecnicotype,
            e4e: listPlanillaMc[i].e4e,
            descripcion: listPlanillaMc[i].descripcion,
            um: listPlanillaMc[i].um,
            movs: 0,
            entregas: 0,
            consumos: 0,
            cantidad: 0,
          ),
        );
      }
      MDInv mdInv = inv.firstWhere((e) => e.id == listPlanillaMc[i].tecnicoid && e.e4e == listPlanillaMc[i].e4e);
      mdInv.consumos += aEntero(listPlanillaMc[i].ctd);
      mdInv.cantidad -= aEntero(listPlanillaMc[i].ctd);
      mdInv.movs += 1;
    }
    //ordenar por VALOR
    list.sort((a, b) => b.valor.compareTo(a.valor));
    emit(state().copyWith(movilDepotList: movilDepotList));
  }

  crearMovs(String tecnicoid) {
    MovilDepotList movilDepotList = state().movilDepotList!;
    movilDepotList.movs = [];
    List<MDMovs> movs = movilDepotList.movs;

    //agregas lo movs de cargas mc
    EntregasMcList cargasMcList = state().entregasMcList!;
    for (var carga in cargasMcList.list) {
      if (carga.tecnicoid == tecnicoid) {
        movs.add(MDMovs.fromCargas(carga)..tipomov = 'CARGA');
      }
    }

    //agregas lo movs de planillas mc
    List<ConsumoMc> listPlanillaMc = state().consumosMcList?.list ?? [];
    for (var planilla in listPlanillaMc) {
      if (planilla.tecnicoid == tecnicoid) {
        movs.add(MDMovs.fromPlanilla(planilla)..tipomov = 'PLANILLA');
      }
    }

    //ordenar por fecha
    movs.sort((a, b) => a.fecha.compareTo(b.fecha));

    emit(state().copyWith(movilDepotList: movilDepotList));
  }
}
