import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../model/deudabruta_model.dart';

class DeudabrutaCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  DeudabrutaCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear async {
    try {
      DeudaBrutaB deudaBrutaB = DeudaBrutaB();

      final mb52 = state().mb52B!;
      final inventarioB = state().inventarioB!;

      for (var i = 0; i < mb52.mb52BList.length; i++) {
        for (var j = 0; j < inventarioB.inventarioList.length; j++) {
          // print(mb52.mb52BList[i].material);
          if (mb52.mb52BList[i].material == inventarioB.inventarioList[j].e4e) {
            double valorUnitario = 0;
            if (mb52.mb52BList[i].ctd != "0") {
              valorUnitario =
                  int.parse(mb52.mb52BList[i].valor) /
                  int.parse(mb52.mb52BList[i].ctd);
            }
            int faltanteUnidades =
                int.parse(mb52.mb52BList[i].ctd) -
                int.parse(inventarioB.inventarioList[j].ctd);
            double faltanteValor = faltanteUnidades * valorUnitario;
            deudaBrutaB.deudaList.add(
              DeudaBrutaBSingle(
                e4e: mb52.mb52BList[i].material,
                descripcion: mb52.mb52BList[i].descripcion,
                um: mb52.mb52BList[i].umb,
                mb52: mb52.mb52BList[i].ctd,
                inv: inventarioB.inventarioList[j].ctd,
                faltanteValor: faltanteValor.round().toString(),
                faltanteUnidades: faltanteUnidades.toString(),
              ),
            );
          }
        }
        if (!(deudaBrutaB.deudaList.any(
          (e) => e.e4e == mb52.mb52BList[i].material,
        ))) {
          deudaBrutaB.deudaList.add(
            DeudaBrutaBSingle(
              e4e: mb52.mb52BList[i].material,
              descripcion: mb52.mb52BList[i].descripcion,
              um: mb52.mb52BList[i].umb,
              mb52: mb52.mb52BList[i].ctd,
              inv: "0",
              faltanteValor: mb52.mb52BList[i].valor,
              faltanteUnidades: mb52.mb52BList[i].ctd,
            ),
          );
        }
      }
      deudaBrutaB.deudaList.sort(
        (a, b) =>
            int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)),
      );
      deudaBrutaB.deudaListSearch = [...deudaBrutaB.deudaList];
      for (var deuda in deudaBrutaB.deudaList) {
        deudaBrutaB.totalValor += int.parse(deuda.faltanteValor);
      }

      emit(state().copyWith(deudaBrutaB: deudaBrutaB));
      await Future.delayed(Duration(milliseconds: 50));
    } catch (e) {
      bl.errorCarga('DeudaBruta', e);
    }
  }
}
