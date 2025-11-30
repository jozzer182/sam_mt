import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../bloc/main_bloc.dart';


class PedidosTitulosVersiones extends StatelessWidget {
  const PedidosTitulosVersiones({key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              return Expanded(
                flex: 8,
                child: SizedBox(),
                // Text(
                //     'Valor Ficha: ${uSFormat.format(state.ficha?.resumen.total ?? 0)}'),
              );
            },
          ),
          const Gap(48 + 18 + 3),
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                'V1',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(4),
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                'V2',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(4),
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                'V3',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Gap(1),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
