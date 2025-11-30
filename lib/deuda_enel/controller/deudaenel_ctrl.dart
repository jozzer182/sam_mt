import '../../bloc/main__bl.dart';
import '../../bloc/main_bloc.dart';
import '../../mb52/mb52_b.dart';
import '../model/deudaenel_model.dart';

class DeudaEnelCtrl {
  final Bl bl;
  late MainState Function() state;
  late void Function(MainEvent p1) add;
  late var emit;

  DeudaEnelCtrl(this.bl) {
    emit = bl.emit;
    state = bl.state;
    add = bl.add;
  }

  get crear async {
    try {
      DeudaEnelB deudaEnelB = DeudaEnelB();
      // deudaEnelB.crear(mb52B: state().mb52B!, registrosB: state().registrosB!);
      final mb52B = state().mb52B!;
      final registrosB = state().registrosB!;
      var registros = registrosB.registrosEnel;
      var mb52 = mb52B.mb52BList;
      for (var registro in registros) {
        // print('registro: $registro');
        var mb52Single = mb52.firstWhere(
          (e) => e.material == registro['e4e'].toString(),
          orElse:
              () => Mb52BSingle(
                material: 'material',
                descripcion: 'descripcion',
                umb: 'umb',
                ctd: '1',
                valor: '0',
                wbe: 'wbe',
                parte_proyecto: 'parte_proyecto',
                status: 'status',
                proyecto: 'proyecto',
                actualizado: 'actualizado',
              ),
        );
        // print('mb52Single: $mb52Single');
        var valorUnitario =
            int.parse(mb52Single.valor) / int.parse(mb52Single.ctd);

        String ctd_sap =
            registro['ctd_ma'] > 0
                ? registro['ctd_ma'].toString()
                : registro['ctd_au'].toString();

        // print('ctd_sap: $ctd_sap');
        deudaEnelB.deudaEnel.add(
          DeudaEnelBSingle(
            e4e: registro['e4e'].toString(),
            descripcion: registro['descripcion'],
            um: registro['um'],
            ctd_total: registro['ctd_total'].toString(),
            ctd_sap: ctd_sap,
            faltanteUnidades:
                (int.parse(registro['ctd_total'].toString()) -
                        int.parse(ctd_sap))
                    .toString(),
            faltanteValor:
                ((int.parse(registro['ctd_total'].toString()) -
                            int.parse(ctd_sap)) *
                        valorUnitario)
                    .toString(),
          ),
        );
      }
      for (var deuda in deudaEnelB.deudaEnel) {
        deudaEnelB.totalValor += int.parse(deuda.faltanteValor);
      }
      deudaEnelB.deudaEnel.sort(
        (a, b) =>
            int.parse(b.faltanteValor).compareTo(int.parse(a.faltanteValor)),
      );
      deudaEnelB.deudaEnelListSearch = [...deudaEnelB.deudaEnel];

      emit(state().copyWith(deudaEnelB: deudaEnelB));
      await Future.delayed(Duration(milliseconds: 50));
      // print('deudaEnelB: ${state().deudaEnelB}');
    } catch (e) {
      bl.errorCarga('Deuda Enel', e);
    }
  }
}
