import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/deuda_almacen/model/deudaalmacen_model.dart';

class RowSaldos extends StatefulWidget {
  final DeudaAlmacenBSingle dato;
  // Function callBackDato;
  final int index;

  const RowSaldos({
    super.key,
    required this.dato,
    // required this.callBackDato,
    required this.index,
  });

  @override
  State<RowSaldos> createState() => _RowSaldosState();
}

class _RowSaldosState extends State<RowSaldos> {
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  bool esIngreso = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          DeudaAlmacenBSingle? datos = state.saldos?.saldosList[widget.index];
          if (datos == null) return Text('Cargando...');
          return Row(
            children: [
              for (var dato in datos.toMapListFlex())
                Expanded(
                  flex: dato['flex'],
                  child:
                      dato['index'] == 'inv'
                          ? SizedBox(
                            height: 30,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: widget.dato.inv,
                                isDense: true,
                              ),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                value = value.isEmpty ? '0' : value;
                                context
                                    .read<MainBloc>()
                                    .informeSaldosCtrl
                                    .cambioSaldos(
                                      index: widget.index,
                                      inv: value,
                                    );
                              },
                            ),
                          )
                          : SelectableText(
                            dato['index'] == 'faltanteValor'
                                ? uSFormat.format(int.parse(dato['texto']))
                                : dato['texto'],
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color:
                                  esIngreso
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.onErrorContainer
                                      : Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                            ),
                          ),
                ),
            ],
          );
        },
      ),
    );
  }
}
