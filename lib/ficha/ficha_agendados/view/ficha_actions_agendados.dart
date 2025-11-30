import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../bloc/main_bloc.dart';
import '../../../resources/descarga_hojas.dart';

class ActionsPedidos extends StatefulWidget {
  final ValueNotifier<int> selectedTabIndex;
  final TabController tabController;
  const ActionsPedidos({
    required this.selectedTabIndex,
    required this.tabController,
    key,
  });

  @override
  State<ActionsPedidos> createState() => _ActionsPedidosState();
}

class _ActionsPedidosState extends State<ActionsPedidos> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.selectedTabIndex,
      builder: (c, value, child) {
        bool esPedidoTab = widget.tabController.index == 1;

        if (esPedidoTab) {
          return Row(
            children: [
              // if (editar)
              //   ElevatedButton(
              //     onPressed: () async {
              //       //Validar que no falte información
              //       String validacion = BlocProvider.of<MainBloc>(context)
              //           .fichaPedidosController()
              //           .validar();
              //       if (validacion.isNotEmpty) {
              //         await showDialog(
              //             context: context,
              //             builder: (context) {
              //               return AlertDialog(
              //                 title: const Text('Falta información'),
              //                 content: Text(validacion),
              //                 actions: [
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.pop(context);
              //                     },
              //                     child: const Text('Ok'),
              //                   ),
              //                 ],
              //               );
              //             });
              //         return;
              //       }
              //       //motor de detección de cambios
              //       bool hayCambios = BlocProvider.of<MainBloc>(context)
              //           .fichaPedidosController()
              //           .crearCambios();

              //       if (hayCambios) {
              //         await showDialog(
              //             context: context,
              //             builder: (context) {
              //               return const FichaPedidosGuardar();
              //             });
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: editar ? Colors.red : null,
              //     ),
              //     child: const Text('Guardar'),
              //   ),
              // const Gap(10),
              // ElevatedButton(
              //   onPressed: () {
              //     BlocProvider.of<MainBloc>(context)
              //         .fichaPedidosController
              //         .editar(!editar);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: editar
              //         ? Colors.green
              //         : Theme.of(context).colorScheme.secondary,
              //   ),
              //   child: Text(editar ? 'Cancelar' : 'Editar'),
              // ),
              const Gap(10),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state.ficha == null) {
                    return const CircularProgressIndicator();
                  }
                  List<Map<String, dynamic>> datos = state.ficha!.fficha.ficha
                      .map((e) => e.agendado.mapDownload)
                      .toList();
                  return ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Theme.of(context).colorScheme.secondary,
                    // ),
                    onPressed: () => DescargaHojas.ahoraMap(
                        user: context.read<MainBloc>().state.user!,
                        datos: datos,
                        nombre:
                            'Pedidos ${state.year!} de ${state.ficha!.fficha.ficha.first.proyecto}'),
                    child: const Icon(Icons.download),
                  );
                },
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
