import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
// import 'package:statistics/statistics.dart';

import '../../../../bloc/main_bloc.dart';
import '../../../../fechas_fem/model/fechasfem_enabledate.dart';
import '../../../../resources/a_entero_2.dart';
import '../../../../resources/field_pre/field_pre_texto.dart';
import '../../../ficha_ficha/model/ficha_reg/reg.dart';
import 'card_number.dart';

class CardPedido extends StatefulWidget {
  final FichaReg fem;
  final FichaReg oldFem;
  final bool renderCto;
  final Map<String, EnableDate> dates;
  const CardPedido({
    required this.fem,
    required this.renderCto,
    required this.dates,
    required this.oldFem,
    key,
  });

  @override
  State<CardPedido> createState() => _CardPedidoState();
}

class _CardPedidoState extends State<CardPedido> {
  @override
  Widget build(BuildContext context) {
    FichaReg singleFEM = widget.fem;
    // bool isEdit = false;
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height:
                  // isEdit ? 56 :
                  38,
              child: Row(
                children: [
                  Text(
                    singleFEM.item,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(1),
                  Expanded(
                    flex: 2,
                    child: BlocBuilder<MainBloc, MainState>(
                      builder: (context, state) {
                        bool edit = false;
                        // List<String> ctos = state
                        //     .ficha!.fichaPedidos.fichaModificada
                        //     .map((e) => e.circuito)
                        //     .toSet()
                        //     .toList();
                        // ctos.sort();
                        // List<PlataformaSingle> plataformaList = state
                        //     .plataforma!.plataformaList
                        //     .where((e) =>
                        //         e.material == singleFEM.e4e &&
                        //         !e.status.contains('CTEC'))
                        //     .toList();
                        // List<String> wbes = plataformaList
                        //     .map((e) => '${e.wbe} - ${e.ctd} - ${e.proyecto}')
                        //     .toSet()
                        //     .toList();
                        // Color? wbeColor;
                        // Color wbeFillColor = Colors.transparent;
                        // bool isMandatory =
                        //     plataformaList.all((e) => e.wbe.isNotEmpty);
                        // bool isNotRequired =
                        //     plataformaList.all((e) => e.wbe.isEmpty) ||
                        //         plataformaList.isEmpty;
                        // if (isMandatory) {
                        //   wbeColor = singleFEM.wbe.isEmpty ? Colors.red : null;
                        // }
                        // if (isNotRequired) {
                        //   wbeColor = Colors.grey;
                        //   wbeFillColor = Colors.grey;
                        // }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FieldTexto(
                              flex: null,
                              size: 14,
                              edit: edit,
                              label: 'Cto',
                              initialValue: singleFEM.circuito,
                              asignarValor: (valor) {},
                            ),
                            Row(
                              children: [
                                FieldTexto(
                                  flex: 1,
                                  size: 14,
                                  label: 'Wbe',
                                  initialValue: singleFEM.wbe,
                                  asignarValor: (valor) {},
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const Gap(4),
                  Expanded(
                    flex: 2,
                    child: BlocBuilder<MainBloc, MainState>(
                      builder: (context, state) {
                        // bool edit = false;
                        // List<PdisSingle> pdisList = state.pdis!.pdisList;
                        // List<String> pdisListString = pdisList
                        //     .map((e) => '${e.lote} - ${e.almacen}')
                        //     .toList()
                        //     .where((e) => e.isNotEmpty)
                        //     .toList();
                        // if (edit) {
                        //   return Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         singleFEM.e4e,
                        //         textAlign: TextAlign.center,
                        //         style: const TextStyle(fontSize: 12),
                        //       ),
                        //       Row(
                        //         children: [
                        //           FieldTexto(
                        //             flex: 1,
                        //             size: 14,
                        //             edit: true,
                        //             label: 'Pdi',
                        //             color: singleFEM.pdi.isEmpty
                        //                 ? Colors.red
                        //                 : null,
                        //             opciones: pdisListString,
                        //             initialValue: singleFEM.pdi,
                        //             asignarValor: (valor) {
                        //               if (valor.isNotEmpty) {
                        //                 if (pdisListString.contains(valor)) {
                        //                   String pdi = valor.split(' - ')[0];
                        //                   context
                        //                       .read<MainBloc>()
                        //                       .fichaPedidosController()
                        //                       .cambiarCampo(
                        //                         item: singleFEM.item,
                        //                         tipo: TipoFem.pdi,
                        //                         value: pdi,
                        //                       );
                        //                 } else {
                        //                   context
                        //                       .read<MainBloc>()
                        //                       .fichaPedidosController()
                        //                       .cambiarCampo(
                        //                         item: singleFEM.item,
                        //                         tipo: TipoFem.pdi,
                        //                         value: '',
                        //                       );
                        //                 }
                        //               }
                        //             },
                        //           ),
                        //           SizedBox(
                        //             width: 14, // Ancho deseado
                        //             height: 14, // Alto deseado
                        //             child: ElevatedButton(
                        //               onPressed: () {
                        //                 showDialog(
                        //                   context: context,
                        //                   builder: (context) {
                        //                     return PdiDescripcionAgendadosDialog(
                        //                       singleFEM: singleFEM,
                        //                     );
                        //                   },
                        //                 );
                        //               },
                        //               style: ElevatedButton.styleFrom(
                        //                 padding: const EdgeInsets.all(0),
                        //                 fixedSize: const Size(14, 14),
                        //               ),
                        //               child: const Icon(
                        //                 Icons.search,
                        //                 size: 14,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       FieldTexto(
                        //         flex: null,
                        //         size: 14,
                        //         edit: true,
                        //         label: 'CAUSAR',
                        //         color: singleFEM.proyectowbe.isEmpty ||
                        //                 !(singleFEM.proyectowbe == 'SI' ||
                        //                     singleFEM.proyectowbe == 'NO')
                        //             ? Colors.red
                        //             : null,
                        //         opciones: const ["SI", "NO"],
                        //         initialValue: singleFEM.proyectowbe,
                        //         asignarValor: (valor) {
                        //           context
                        //               .read<MainBloc>()
                        //               .fichaPedidosController()
                        //               .cambiarCampo(
                        //                 item: singleFEM.item,
                        //                 tipo: TipoFem.proyectowbe,
                        //                 value: valor,
                        //               );
                        //         },
                        //       ),
                        //     ],
                        //   );
                        // }
                        return Text(
                          singleFEM.e4e,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                  const Gap(4),
                  Expanded(
                    flex: 4,
                    child: BlocBuilder<MainBloc, MainState>(
                      builder: (context, state) {
                        // bool edit = state.ficha!.fichaPedidos.editar;
                        // if (edit) {
                        //   return Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       Text(
                        //         singleFEM.descripcion,
                        //         style: const TextStyle(fontSize: 9),
                        //       ),
                        //       FieldTexto(
                        //         flex: null,
                        //         size: 14,
                        //         edit: true,
                        //         label: 'Comentario',
                        //         initialValue: singleFEM.comentario2,
                        //         asignarValor: (asignarValor) =>
                        //             singleFEM.comentario2 = asignarValor,
                        //       ),
                        //     ],
                        //   );
                        // }
                        return Text(
                          singleFEM.descripcion,
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  const Gap(2),
                  SizedBox(
                    width: 25,
                    child: BlocBuilder<MainBloc, MainState>(
                      builder: (context, state) {
                        // bool edit = state.ficha!.fichaPedidos.editar;
                        // if (edit) {
                        //   return Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       Text(
                        //         singleFEM.um,
                        //         style: const TextStyle(fontSize: 12),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //       FieldTexto(
                        //         flex: null,
                        //         size: 14,
                        //         edit: true,
                        //         label: 'Tipo',
                        //         opciones: const ["PDI", "PLATAFORMA"],
                        //         color:
                        //             singleFEM.tipo.isEmpty ? Colors.red : null,
                        //         initialValue: singleFEM.tipo,
                        //         asignarValor: (valor) {
                        //           if (["PDI", "PLATAFORMA"].contains(valor)) {
                        //             context
                        //                 .read<MainBloc>()
                        //                 .fichaPedidosController()
                        //                 .cambiarCampo(
                        //                   item: singleFEM.item,
                        //                   tipo: TipoFem.tipo,
                        //                   value: valor,
                        //                 );
                        //           } else {
                        //             context
                        //                 .read<MainBloc>()
                        //                 .fichaPedidosController()
                        //                 .cambiarCampo(
                        //                   item: singleFEM.item,
                        //                   tipo: TipoFem.tipo,
                        //                   value: '',
                        //                 );
                        //           }
                        //         },
                        //       ),
                        //     ],
                        //   );
                        // }
                        return Text(
                          singleFEM.um,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                  const Gap(2),
                  const SizedBox(
                    width: 18,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('q1', style: TextStyle(fontSize: 10)),
                        Text('q2', style: TextStyle(fontSize: 10)),
                        Text('qx', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m01q1,
                    q2: singleFEM.agendado.quincena.m01q2,
                    qx: singleFEM.m01qx,
                    estadoPed: widget.dates['01']!,
                    mes: widget.oldFem.planificado.mes.m01,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m02q1,
                    q2: singleFEM.agendado.quincena.m02q2,
                    qx: singleFEM.m02qx,
                    estadoPed: widget.dates['02']!,
                    mes: widget.oldFem.planificado.mes.m02,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m03q1,
                    q2: singleFEM.agendado.quincena.m03q2,
                    qx: singleFEM.m03qx,
                    estadoPed: widget.dates['03']!,
                    mes: widget.oldFem.planificado.mes.m03,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m04q1,
                    q2: singleFEM.agendado.quincena.m04q2,
                    qx: singleFEM.m04qx,
                    estadoPed: widget.dates['04']!,
                    mes: widget.oldFem.planificado.mes.m04,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m05q1,
                    q2: singleFEM.agendado.quincena.m05q2,
                    qx: singleFEM.m05qx,
                    estadoPed: widget.dates['05']!,
                    mes: widget.oldFem.planificado.mes.m05,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m06q1,
                    q2: singleFEM.agendado.quincena.m06q2,
                    qx: singleFEM.m06qx,
                    estadoPed: widget.dates['06']!,
                    mes: widget.oldFem.planificado.mes.m06,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m07q1,
                    q2: singleFEM.agendado.quincena.m07q2,
                    qx: singleFEM.m07qx,
                    estadoPed: widget.dates['07']!,
                    mes: widget.oldFem.planificado.mes.m07,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m08q1,
                    q2: singleFEM.agendado.quincena.m08q2,
                    qx: singleFEM.m08qx,
                    estadoPed: widget.dates['08']!,
                    mes: widget.oldFem.planificado.mes.m08,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m09q1,
                    q2: singleFEM.agendado.quincena.m09q2,
                    qx: singleFEM.m09qx,
                    estadoPed: widget.dates['09']!,
                    mes: widget.oldFem.planificado.mes.m09,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m10q1,
                    q2: singleFEM.agendado.quincena.m10q2,
                    qx: singleFEM.m10qx,
                    estadoPed: widget.dates['10']!,
                    mes: widget.oldFem.planificado.mes.m10,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m11q1,
                    q2: singleFEM.agendado.quincena.m11q2,
                    qx: singleFEM.m11qx,
                    estadoPed: widget.dates['11']!,
                    mes: widget.oldFem.planificado.mes.m11,
                  ),
                  const Gap(1),
                  FichaPedidosNumber(
                    item: singleFEM.item,
                    q1: singleFEM.agendado.quincena.m12q1,
                    q2: singleFEM.agendado.quincena.m12q2,
                    qx: singleFEM.m12qx,
                    estadoPed: widget.dates['12']!,
                    mes: widget.oldFem.planificado.mes.m12,
                  ),
                  const Gap(1),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          singleFEM.agendado.mes.total.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: singleFEM.agendado.mes.total == 0
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
