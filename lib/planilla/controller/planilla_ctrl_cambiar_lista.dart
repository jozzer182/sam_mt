import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../inventario/model/inventario_model.dart';
import '../../mb52/mb52_b.dart';
import '../../models/mm60_b.dart';

class PlanillaCtrlCambiarLista {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  PlanillaCtrlCambiarLista(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  eliminar(int index) {
    state().planillaB!.planillaBList.removeAt(index);
    //reiniciar numeracion de item
    for (int i = 0; i < state().planillaB!.planillaBList.length; i++) {
      state().planillaB!.planillaBList[i].item = '${i + 1}';
    }

    emit(state().copyWith(planillaB: state().planillaB));
  }

  cambiarCampos({
    required int index,
    String? e4e,
    String? ctd_e,
    String? ctd_r,
  }) {
    var ref = state().planillaB!.planillaBList[index];
    if (e4e != null) {
      // ref.cambioE4e(e4e, mm60r, mb52r, invr);
      String e4eN = e4e.toUpperCase();
      Mm60B mm60B = state().mm60B!;
      Mb52B mb52b = state().mb52B!;
      InventarioB inventarioB = state().inventarioB!;
      var inMb52 = mb52b.mb52BList.firstWhere(
        (e) => e.material.contains(e4eN),
        orElse: () => Mb52BSingle.fromInit(),
      );
      var inInventario = inventarioB.inventarioList.firstWhere(
        (e) => e.e4e.contains(e4eN),
        orElse: () => InventarioBSingle.fromInit(),
      );
      var inMm60 = mm60B.mm60List.firstWhere(
        (e) => e.material.contains(e4eN),
        orElse: () => Mm60SingleB.fromInit(),
      );
      ref.e4e = e4eN;
      ref.descripcion = inMm60.descripcion;
      ref.um = inMm60.um;
      ref.esMb52 =
          inMb52.descripcion == 'No está en MB52' ? 'No está en MB52' : null;
      ref.ctdMb52 =
          e4e.length == 6
              ? inMb52.ctd
              : null; //solo muestra la cantidad de MB52 cuando tiene 6
      ref.esInv =
          inInventario.descripcion == 'No hay unidades en <Inventario> SAM'
              ? 'No hay unidades en <Inventario> SAM'
              : null;
      ref.ctdInv =
          e4e.length == 6
              ? inInventario.ctd
              : null; //solo muestra la cantidad de inventario cuando tiene 6
    }
    if (ctd_e != null) {
      // ref.cambioCtdE(ctd_e, mb52r, invr);
      String ctd_eN = ctd_e;
      Mb52B mb52b = state().mb52B!;
      InventarioB inventarioB = state().inventarioB!;
      var inMb52 = mb52b.mb52BList.firstWhere(
        (e) => e.material.contains(ref.e4e),
        orElse: () => Mb52BSingle.fromInit(),
      );
      var inInventario = inventarioB.inventarioList.firstWhere(
        (e) => e.e4e.contains(ref.e4e),
        orElse: () => InventarioBSingle.fromInit(),
      );
      ref.ctd_e = ctd_eN == '' ? '0' : ctd_eN;
      ref.ctd_r = ref.ctd_r == '' ? '0' : ref.ctd_r;
      ref.ctd_total =
          '${int.parse(ref.ctd_e) - int.parse(ref.ctd_r == 'ctd' ? '0' : ref.ctd_r)}';
      bool esMayorLoReintegrado = int.parse(ref.ctd_e) < int.parse(ref.ctd_r);
      bool esMayorLoInstaladoQueMb52 =
          int.parse(ref.ctd_total) > int.parse(inInventario.ctd);
      ref.errorValue = esMayorLoReintegrado || esMayorLoInstaladoQueMb52;
    }
    if (ctd_r != null) {
      // ref.cambioCtdR(ctd_r, mb52r, invr);
      String ctd_rN = ctd_r;
      Mb52B mb52b = state().mb52B!;
      InventarioB inventarioB = state().inventarioB!;
      var inMb52 = mb52b.mb52BList.firstWhere(
        (e) => e.material.contains(ref.e4e),
        orElse: () => Mb52BSingle.fromInit(),
      );
      var inInventario = inventarioB.inventarioList.firstWhere(
        (e) => e.e4e.contains(ref.e4e),
        orElse: () => InventarioBSingle.fromInit(),
      );
      ref.ctd_r = ctd_rN == '' ? '0' : ctd_rN;
      ref.ctd_e = ref.ctd_e == '' ? '0' : ref.ctd_e;
      ref.ctd_total =
          '${int.parse(ref.ctd_e == 'ctd' ? '0' : ref.ctd_e) - int.parse(ref.ctd_r)}';
      bool esMayorLoReintegrado = int.parse(ref.ctd_e) < int.parse(ref.ctd_r);
      bool esMayorLoInstaladoQueMb52 =
          int.parse(ref.ctd_total) > int.parse(inInventario.ctd);
      ref.errorValue = esMayorLoReintegrado || esMayorLoInstaladoQueMb52;
    }
    emit(state().copyWith());
  }

  cambiarCamposEdit({
    required int index,
    String? e4e,
    String? ctd_e,
    String? ctd_r,
  }) {
    var ref = state().planillaEditB!.planillaBListParaEnvio[index];
    if (e4e != null) {
      // ref.cambioE4e(e4e, mm60r, mb52r, invr);
      String e4eN = e4e;
      Mm60B mm60B = state().mm60B!;
      Mb52B mb52b = state().mb52B!;
      InventarioB inventarioB = state().inventarioB!;

      var inMb52 = mb52b.mb52BList.firstWhere(
        (e) => e.material.contains(e4eN),
        orElse: () => Mb52BSingle.fromInit(),
      );
      var inInventario = inventarioB.inventarioList.firstWhere(
        (e) => e.e4e.contains(e4eN),
        orElse: () => InventarioBSingle.fromInit(),
      );
      var inMm60 = mm60B.mm60List.firstWhere(
        (e) => e.material.contains(e4eN),
        orElse: () => Mm60SingleB.fromInit(),
      );
      ref.e4e = e4eN;
      ref.descripcion = inMm60.descripcion;
      ref.um = inMm60.um;
      ref.esMb52 =
          inMb52.descripcion == 'No está en MB52' ? 'No está en MB52' : null;
      ref.ctdMb52 =
          e4e.length == 6
              ? inMb52.ctd
              : null; //solo muestra la cantidad de MB52 cuando tiene 6
      ref.esInv =
          inInventario.descripcion == 'No hay unidades en inventario'
              ? 'No hay unidades en inventario'
              : null;
      ref.ctdInv = e4e.length == 6 ? inInventario.ctd : null;
    }
    if (ctd_e != null) {
      // ref.cambioCtdE(ctd_e, mb52r, invr);
      String ctd_eN = ctd_e;
      Mb52B mb52b = state().mb52B!;
      InventarioB inventarioB = state().inventarioB!;
      var inMb52 = mb52b.mb52BList.firstWhere(
        (e) => e.material.contains(ref.e4e),
        orElse: () => Mb52BSingle.fromInit(),
      );
      var inInventario = inventarioB.inventarioList.firstWhere(
        (e) => e.e4e.contains(ref.e4e),
        orElse: () => InventarioBSingle.fromInit(),
      );
      ref.ctd_e = ctd_eN == '' ? '0' : ctd_eN;
      ref.ctd_total =
          '${int.parse(ref.ctd_e) - int.parse(ref.ctd_r == 'ctd' ? '0' : ref.ctd_r)}';
      bool esMayorLoReintegrado = int.parse(ref.ctd_e) < int.parse(ref.ctd_r);
      bool esMayorLoInstaladoQueMb52 =
          int.parse(ref.ctd_total) > int.parse(inInventario.ctd);
      ref.errorValue = esMayorLoReintegrado || esMayorLoInstaladoQueMb52;
    }
    if (ctd_r != null) {
      // ref.cambioCtdR(ctd_r, mb52r, invr);
      String ctd_rN = ctd_r;
      Mb52B mb52b = state().mb52B!;
      InventarioB inventarioB = state().inventarioB!;
      var inMb52 = mb52b.mb52BList.firstWhere(
        (e) => e.material.contains(ref.e4e),
        orElse: () => Mb52BSingle.fromInit(),
      );
      var inInventario = inventarioB.inventarioList.firstWhere(
        (e) => e.e4e.contains(ref.e4e),
        orElse: () => InventarioBSingle.fromInit(),
      );
      ref.ctd_r = ctd_rN == '' ? '0' : ctd_rN;
      ref.ctd_total =
          '${int.parse(ref.ctd_e == 'ctd' ? '0' : ref.ctd_e) - int.parse(ref.ctd_r)}';
      bool esMayorLoReintegrado = int.parse(ref.ctd_e) < int.parse(ref.ctd_r);
      bool esMayorLoInstaladoQueMb52 =
          int.parse(ref.ctd_total) > int.parse(inInventario.ctd);
      ref.errorValue = esMayorLoReintegrado || esMayorLoInstaladoQueMb52;
    }
    emit(state().copyWith());
  }
}
