import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../bloc/main_bloc.dart';


class PedidosTitulosMeses extends StatelessWidget {
  const PedidosTitulosMeses({key});

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
                // RichText(
                //   text: TextSpan(
                //     text: 'Valor Pedidos: ',
                //     style: DefaultTextStyle.of(context).style,
                //     children: [
                //       TextSpan(
                //         text:
                //             uSFormat.format(state.ficha?.resumen.totalped ?? 0),
                //       ),
                //       TextSpan(
                //         text:
                //             ' (${(100 * state.ficha!.resumen.totalped / state.ficha!.resumen.total).toStringAsFixed(0)}%)',
                //       ),
                //     ],
                //   ),
                // ),
              );
            },
          ),
          const Gap(48 + 18 + 3),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '01',
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
                '02',
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
                '03',
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
                '04',
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
                '05',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
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
                '06',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
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
                '07',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
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
                '08',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
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
                '09',
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
                '10',
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
                '11',
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
                '12',
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
                'T',
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
