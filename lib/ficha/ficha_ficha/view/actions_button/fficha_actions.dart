import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/main_bloc.dart';
import '../../../../mm60/model/mm60_model.dart';
import '../../../../resources/a_entero_2.dart';
import '../../../../resources/descarga_hojas.dart';
import '../../../main/ficha/model/ficha_model.dart';

class Actionsficha extends StatefulWidget {
  final ValueNotifier<int> selectedTabIndex;
  final TabController tabController;
  const Actionsficha({
    required this.selectedTabIndex,
    required this.tabController,
    key,
  });

  @override
  State<Actionsficha> createState() => _ActionsfichaState();
}

class _ActionsfichaState extends State<Actionsficha> {
  bool verDinero = false;
  // bool editar = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // bool edit = state.ficha!.fficha.editar;
        return ValueListenableBuilder<int>(
          valueListenable: widget.selectedTabIndex,
          builder: (c, value, child) {
            // bool editar = context.watch<MainBloc>().state.ficha!.fficha.editar;
            bool esFichaTab = widget.tabController.index == 0;
            if (esFichaTab) {
              return Row(
                children: [
                  // if (edit) const BotonGuardarFicha(),
                  // const Gap(10),
                  // if (!verDinero)
                  //   ElevatedButton(
                  //     onPressed: () {
                  //       BlocProvider.of<MainBloc>(context)
                  //           .fichaFichaController
                  //           .editar(!edit);
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: edit
                  //           ? Colors.green
                  //           : Theme.of(context).colorScheme.secondary,
                  //     ),
                  //     child: Text(edit ? 'Cancelar' : 'Editar'),
                  //   ),
                  // const Gap(10),
                  // if (!edit)
                  //   ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor:
                  //           Theme.of(context).colorScheme.secondary,
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         verDinero = !verDinero;
                  //       });
                  //       context
                  //           .read<MainBloc>()
                  //           .fichaFichaController
                  //           .verDinero(verDinero);
                  //     },
                  //     child: verDinero
                  //         ? const Text('A Unidades')
                  //         : const Text(
                  //             'A Dinero\n(MCOP)',
                  //             textAlign: TextAlign.center,
                  //           ),
                  //   ),
                  // const Gap(10),
                  BlocSelector<MainBloc, MainState, Ficha?>(
                    selector: (state) => state.ficha,
                    builder: (context, state) {
                      if (state == null) {
                        return const CircularProgressIndicator();
                      }
                      // List<dynamic> datos = state.fficha.ficha;
                      // if (!verDinero) {
                        List<Map<String, dynamic>> datos = state.fficha.ficha
                            .map((el) =>
                                el.planificado.toMapMonthPrecio(aEntero(context
                                    .read<MainBloc>()
                                    .state
                                    .mm60!
                                    .mm60List
                                    .firstWhere(
                                      (e) => e.material == el.e4e,
                                      orElse: () => Mm60Single.fromInit(),
                                    )
                                    .precio)))
                            .toList();
                        return ElevatedButton(
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor:
                          //       Theme.of(context).colorScheme.secondary,
                          // ),
                          onPressed: () => DescargaHojas.ahoraMap(
                            datos: datos,
                            nombre:
                                'Ficha por Mes de ${state.fficha.ficha.first.proyecto}',
                            user: context.read<MainBloc>().state.user!,
                          ),
                          child: const Icon(Icons.download),
                        );
                      // }
                      // if (verDinero) {
                      //   List<Map<String, dynamic>> datos = state.fficha.ficha
                      //       .map((el) =>
                      //           el.planificado.toMapMonthValue(aEntero(context
                      //               .read<MainBloc>()
                      //               .state
                      //               .mm60!
                      //               .mm60List
                      //               .firstWhere(
                      //                 (e) => e.material == el.e4e,
                      //                 orElse: () => Mm60Single.fromInit(),
                      //               )
                      //               .precio)))
                      //       .toList();
                      //   return ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor:
                      //           Theme.of(context).colorScheme.secondary,
                      //     ),
                      //     onPressed: () => DescargaHojas().ahoraMap(
                      //         datos: datos,
                      //         nombre:
                      //             'Ficha por Mes Precio de ${state.fficha.ficha.first.proyecto}'),
                      //     child: const Icon(Icons.download),
                      //   );
                      // }
                      // return ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         Theme.of(context).colorScheme.secondary,
                      //   ),
                      //   onPressed: () => DescargaHojas().ahora(
                      //       datos: datos,
                      //       nombre:
                      //           'Ficha de ${state.fficha.ficha.first.proyecto}'),
                      //   child: const Icon(Icons.download),
                      // );
                    },
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
