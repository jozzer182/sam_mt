import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../bloc/main_bloc.dart';


class FichaTitulosMeses extends StatelessWidget {
  const FichaTitulosMeses({key});

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
                //     text: 'Valor Ficha: ',
                //     style: DefaultTextStyle.of(context).style,
                //     children: [
                //       TextSpan(
                //         text: uSFormat.format(resumen.total),
                //       ),
                //       TextSpan(
                //         text: porcentaje,
                //         style: resumen.total > resumen.budgetMaterial
                //             ? const TextStyle(color: Colors.red)
                //             : null,
                //       ),
                //     ],
                //   ),
                // ),
              );
            },
          ),
          const Gap(2),
          Expanded(
            flex: 12,
            child: Row(
              children: [
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
          )
        ],
      ),
    );
  }
}
