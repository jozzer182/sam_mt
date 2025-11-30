import 'package:flutter/material.dart';
import '../../../../fechas_fem/model/fechasfem_enabledate.dart';


class FichaPedidosNumber extends StatefulWidget {
  final String item;
  final int q1;
  final int q2;
  // final bool b1;
  // final bool b2;
  final String qx;
  final int mes;
  final EnableDate estadoPed;
  const FichaPedidosNumber({
    required this.item,
    required this.q1,
    required this.q2,
    // required this.b1,
    // required this.b2,
    required this.qx,
    required this.mes,
    required this.estadoPed,
    key,
  });

  @override
  State<FichaPedidosNumber> createState() => _FichaPedidosNumberState();
}

class _FichaPedidosNumberState extends State<FichaPedidosNumber> {
  // bool renderCheckboxq1 = false;
  // bool renderCheckboxq2 = false;
  bool pedidoActivoq1 = false;
  bool pedidoActivoq2 = false;
  // bool versionActivaq1 = false;
  // bool versionActivaq2 = false;
  // int q1 = 0;
  // int q2 = 0;

  @override
  Widget build(BuildContext context) {
    pedidoActivoq1 = widget.estadoPed.pedidoActivoq1;
    pedidoActivoq2 = widget.estadoPed.pedidoActivoq2;
    // versionActivaq1 = widget.estadoPed.versionActivaq1;
    // versionActivaq2 = widget.estadoPed.versionActivaq2;
    // bool isEdit = false;
    // String year = context.read<MainBloc>().state.year!.substring(2, 4);
    // renderCheckboxq1 = isEdit && !versionActivaq1;
    // renderCheckboxq2 = isEdit && !versionActivaq2;
    // q1 = widget.b1 ? widget.q1 : 0;
    // q2 = widget.b2 ? widget.q2 : 0;
    // if (isEdit) {
    //   q1 = widget.q1;
    //   q2 = widget.q2;
    // }
    return Expanded(
      flex: 1,
      child: Tooltip(
        message: 'Total Mes:\n${widget.mes}',
        textAlign: TextAlign.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // if (renderCheckboxq1 && pedidoActivoq1)
                //   FieldTexto(
                //     flex: 1,
                //     label: '',
                //     size: 14,
                //     edit: true,
                //     isNumber: true,
                //     initialValue: q1.toString(),
                //     asignarValor: (value) {
                //       print('cambiarCantidad');
                //       context
                //           .read<MainBloc>()
                //           .fichaPedidosController
                //           .cambiarCantidad(
                //             value: value,
                //             campo: 'm${widget.estadoPed.mes}q1',
                //             item: widget.item,
                //             mes: widget.mes,
                //             b1: pedidoActivoq1
                //           );
                //       // setState(() {
                //       //   q1 = int.parse(value);
                //       // });
                //     },
                //   )
                // else
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: pedidoActivoq1
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.q1.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.q1 == 0
                              ? Colors.grey
                              : Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // if (renderCheckboxq1)
                //   SizedBox(
                //     height: 12,
                //     width: 12,
                //     child: Transform.scale(
                //       scale: 0.4,
                //       child: Checkbox(
                //         splashRadius: 22,
                //         value: widget.b1,
                //         onChanged: pedidoActivoq1
                //             ? (bool? value) {
                //                 context
                //                     .read<MainBloc>()
                //                     .fichaPedidosController()
                //                     .check(
                //                       item: widget.item,
                //                       pedido: '${widget.estadoPed.mes}|$year-1',
                //                       valor: value! ? '1' : '0',
                //                     );
                //               }
                //             : null,
                //       ),
                //     ),
                //   )
                // else
                  Container(),
              ],
            ),
            Row(
              children: [
                // if (renderCheckboxq2 && pedidoActivoq2)
                //   FieldTexto(
                //     flex: 1,
                //     label: '',
                //     size: 14,
                //     edit: true,
                //     isNumber: true,
                //     initialValue: q2.toString(),
                //     asignarValor: (value) {
                //       context
                //           .read<MainBloc>()
                //           .fichaPedidosController()
                //           .cambiarCantidad(
                //             value: value,
                //             campo: 'm${widget.estadoPed.mes}q2',
                //             item: widget.item,
                //             mes: widget.mes,
                //             b1: pedidoActivoq1
                //           );
      
                //       // setState(() {
                //       //   q2 = int.parse(value);
                //       // });
                //     },
                //   )
                // else
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: pedidoActivoq2
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.q2.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.q2 == 0
                              ? Colors.grey
                              : Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // if (renderCheckboxq2)
                //   SizedBox(
                //     height: 12,
                //     width: 12,
                //     child: Transform.scale(
                //       scale: 0.4,
                //       child: Checkbox(
                //         splashRadius: 22,
                //         value: widget.b2,
                //         onChanged: pedidoActivoq2
                //             ? (bool? value) {
                //                 context
                //                     .read<MainBloc>()
                //                     .fichaPedidosController()
                //                     .check(
                //                       item: widget.item,
                //                       pedido: '${widget.estadoPed.mes}|$year-2',
                //                       valor: value! ? '1' : '0',
                //                     );
                //               }
                //             : null,
                //       ),
                //     ),
                //   )
                // else
                  Container(),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.estadoPed.pedidoActivoq2
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.qx.isEmpty ? '0' : widget.qx,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.qx.isEmpty || widget.qx == '0'
                            ? Colors.grey
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // if (renderCheckboxq2)
                //   SizedBox(
                //     height: 12,
                //     width: 12,
                //     child: Transform.scale(
                //       scale: 0.4,
                //       child: Checkbox(
                //         splashRadius: 0,
                //         value: widget.qx.isNotEmpty && widget.qx != '0',
                //         onChanged: null,
                //       ),
                //     ),
                //   )
                // else
                  Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
