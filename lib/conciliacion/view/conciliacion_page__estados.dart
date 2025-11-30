import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main_bloc.dart';
import '../../conciliaciones/model/conciliaciones_model.dart';
import '../model/conciliacion_model.dart';

class ConciliacionEstados extends StatefulWidget {
  final bool esNuevo;
  const ConciliacionEstados({required this.esNuevo, Key? key})
    : super(key: key);

  @override
  State<ConciliacionEstados> createState() => _ConciliacionEstadosState();
}

class _ConciliacionEstadosState extends State<ConciliacionEstados> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    TextStyle titleMedium = Theme.of(context).textTheme.titleMedium!.copyWith(
      color: primaryColor,
      fontWeight: FontWeight.w900,
    );
    TextStyle bodyMedium = Theme.of(context).textTheme.bodyMedium!;
    TextStyle justGrey = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: Colors.grey);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('HISTORICO ESTADOS', style: titleMedium),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(flex: 3, child: Text('Numero', style: bodyMedium)),
            Expanded(flex: 3, child: Text('Fecha', style: bodyMedium)),
            Expanded(flex: 3, child: Text('Estado', style: bodyMedium)),
            Expanded(flex: 3, child: Text('Comentario', style: bodyMedium)),
            Expanded(flex: 3, child: Text('Persona', style: bodyMedium)),
          ],
        ),
        const SizedBox(height: 10),
        BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            if (state.conciliaciones == null || state.conciliacion == null) {
              return SizedBox();
            }
            Conciliaciones conciliaciones = state.conciliaciones!;
            Conciliacion conciliacion = state.conciliacion!;
            List<Conciliacion> listaConciliaciones =
                conciliaciones.conciliacionesList
                    .where((e) => e.conciliacion == conciliacion.conciliacion)
                    .toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: listaConciliaciones.length,
              itemBuilder: (context, index) {
                Conciliacion conciliacion = listaConciliaciones[index];
                return InkWell(
                  onTap:
                      widget.esNuevo
                          ? null
                          : () {
                            context
                                .read<MainBloc>()
                                .conciliacionesCtrl
                                .seleccionarConciliacion(conciliacion);
                          },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          conciliacion.numero,
                          style: widget.esNuevo ? justGrey : bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          conciliacion.fecha,
                          style: widget.esNuevo ? justGrey : bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          conciliacion.estado,
                          style: widget.esNuevo ? justGrey : bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          conciliacion.comentario,
                          style: widget.esNuevo ? justGrey : bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          conciliacion.persona,
                          style: widget.esNuevo ? justGrey : bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
