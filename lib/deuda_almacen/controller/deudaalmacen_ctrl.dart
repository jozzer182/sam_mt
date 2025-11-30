import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../deuda_operativa/model/deudaoperativa_model.dart';
import '../model/deudaalmacen_model.dart';

class DeudaAlmacenCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  DeudaAlmacenCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear async {
    try {
      DeudaAlmacenB deudaAlmacenB = DeudaAlmacenB();
      // deudaAlmacenB.crear(
      //   deudaBrutaB: state().deudaBrutaB!,
      //   deudaOperativaB: state().deudaOperativaB!,
      // );
      final deudaBrutaB = state().deudaBrutaB!;
      final deudaOperativaB = state().deudaOperativaB!;
      List<DeudaActiva> registros = deudaOperativaB.registrosOperativos;
      for (var i = 0; i < deudaBrutaB.deudaList.length; i++) {
        for (var j = 0; j < registros.length; j++) {
          if (deudaBrutaB.deudaList[i].e4e == registros[j].e4e) {
            double valorUnitario = 0.0;
            if (deudaBrutaB.deudaList[i].faltanteUnidades != '0') {
              valorUnitario =
                  int.parse(deudaBrutaB.deudaList[i].faltanteValor) /
                  int.parse(deudaBrutaB.deudaList[i].faltanteUnidades);
            } else {
              // print('deudaBrutaB.deudaList[i] ${deudaBrutaB.deudaList[i]}');
              // print('registros[j] ${registros[j]}');
              // print('no hay unidades');
            }
            int faltanteUnidades =
                int.parse(deudaBrutaB.deudaList[i].mb52) -
                (int.parse(deudaBrutaB.deudaList[i].inv) +
                    int.parse(registros[j].ctd));
            double faltanteValor = faltanteUnidades * valorUnitario;
            // print('faltanteUnidades en ${deudaBrutaB.deudaList[i].e4e} : $faltanteUnidades');
            // print('valorunitario en ${deudaBrutaB.deudaList[i].e4e} : $valorUnitario');
            // print('faltante valor en ${deudaBrutaB.deudaList[i].e4e} : ${deudaBrutaB.deudaList[i].faltanteValor}');
            // print('faltante unidades origen en ${deudaBrutaB.deudaList[i].e4e} : ${deudaBrutaB.deudaList[i].faltanteUnidades}');
            deudaAlmacenB.deudaAlmacenB.add(
              DeudaAlmacenBSingle(
                e4e: deudaBrutaB.deudaList[i].e4e,
                descripcion: deudaBrutaB.deudaList[i].descripcion,
                um: deudaBrutaB.deudaList[i].um,
                mb52: deudaBrutaB.deudaList[i].mb52,
                inv: deudaBrutaB.deudaList[i].inv,
                sal: registros[j].ctd,
                faltanteUnidades: faltanteUnidades.toString(),
                faltanteValor: faltanteValor.round().toString(),
                valorUnitario: valorUnitario.toString(),
              ),
            );
          }
        }
        double valorUnitario =
            int.parse(deudaBrutaB.deudaList[i].faltanteValor) /
            int.parse(deudaBrutaB.deudaList[i].faltanteUnidades);
        if (!(deudaAlmacenB.deudaAlmacenB.any(
          (e) => e.e4e == deudaBrutaB.deudaList[i].e4e,
        ))) {
          deudaAlmacenB.deudaAlmacenB.add(
            DeudaAlmacenBSingle(
              e4e: deudaBrutaB.deudaList[i].e4e,
              descripcion: deudaBrutaB.deudaList[i].descripcion,
              um: deudaBrutaB.deudaList[i].um,
              mb52: deudaBrutaB.deudaList[i].mb52,
              inv: deudaBrutaB.deudaList[i].inv,
              sal: "0",
              faltanteValor: deudaBrutaB.deudaList[i].faltanteValor,
              faltanteUnidades: deudaBrutaB.deudaList[i].faltanteUnidades,
              valorUnitario: valorUnitario.toString(),
            ),
          );
        }
      }
      for (var deuda in deudaAlmacenB.deudaAlmacenB) {
        int valor = int.parse(deuda.faltanteValor);
        deudaAlmacenB.totalValor += valor;
        if (valor < 0) deudaAlmacenB.totalSobrantes += valor;
        if (valor > 0) deudaAlmacenB.totalFaltantes += valor;
      }

      deudaAlmacenB.deudaAlmacenB.sort(
        (a, b) =>
            int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)),
      );
      deudaAlmacenB.deudaAlmacenBListSearch = [...deudaAlmacenB.deudaAlmacenB];
      deudaAlmacenB.deudaAlmacenBListSearch2 = [...deudaAlmacenB.deudaAlmacenB];
      deudaAlmacenB.deudaAlmacenBListSearch2.sort(
        (b, a) =>
            int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)),
      );
      emit(state().copyWith(deudaAlmacenB: deudaAlmacenB));
      await Future.delayed(Duration(milliseconds: 50));
      // print('deudaAlmacenB: ${state().deudaAlmacenB}');
    } catch (e) {
      bl.errorCarga('Deuda Almacen', e);
    }
  }
}
