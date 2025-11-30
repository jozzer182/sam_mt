import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../bloc/main_bloc.dart';
import '../../../fechas_fem/model/fechasfem_enabledate.dart';
import '../../../resources/field_pre/field_pre_texto.dart';
import '../../ficha_ficha/model/ficha_reg/reg.dart';
import '../model/ficha__pedidos_model.dart';
import 'card/card.dart';
import 'titulos/pedidos_titulos_meses.dart';
import 'titulos/pedidos_titulos_versiones.dart';

class FichaPedidosPage extends StatefulWidget {
  const FichaPedidosPage({key});

  @override
  State<FichaPedidosPage> createState() => _FichaPedidosPageState();
}

class _FichaPedidosPageState extends State<FichaPedidosPage> {
  String filter = '';
  String filterCircuito = '';
  bool firstTimeLoading = true;
  int endList = 30;
  final ScrollController _controller = ScrollController();
  List<FichaReg> ficha = [];
  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 20;
      });
    }
  }

  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );

  @override
  void initState() {
    _controller.addListener(_onScroll);
    // bool editar1 = ;
    if (context.read<MainBloc>().state.ficha!.fichaPedidos.editar) {
      ficha =
          context.read<MainBloc>().state.ficha!.fichaPedidos.fichaModificada;
    } else {
      ficha = context.read<MainBloc>().state.ficha!.fichaPedidos.ficha;
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        firstTimeLoading = false;
      });
    });
    // ficha = context.read<MainBloc>().state.ficha!.fichaPedidos.ficha;
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool editar = context.watch<MainBloc>().state.ficha!.fichaPedidos.editar;
    return BlocListener<MainBloc, MainState>(
      listenWhen: (previous, current) =>
          editar != current.ficha!.fichaPedidos.editar,
      listener: (context, state) {
        bool lastEditar = state.ficha!.fichaPedidos.editar;
        if (lastEditar) {
          setState(() {
            ficha = state.ficha!.fichaPedidos.fichaModificada;
          });
        } else {
          setState(() {
            ficha = state.ficha!.fichaPedidos.ficha;
          });
        }
      },
      child: Column(
        children: [
          const Gap(10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              FPedidos fichaPedidos = state.ficha!.fichaPedidos;
              List<FichaReg> fichaOriginal = fichaPedidos.ficha;
              bool editar = fichaPedidos.editar;
              if (editar) {
                fichaOriginal = fichaPedidos.fichaModificada;
              }
              List<String> circuitos = fichaOriginal
                  .map((e) => e.circuito)
                  .where((e) => e.isNotEmpty)
                  .toSet()
                  .toList();

              return Row(
                children: [
                  const Gap(10),
                  FieldTexto(
                    flex: 1,
                    label: 'Búsqueda',
                    edit: true,
                    initialValue: filter,
                    asignarValor: (value) {
                      setState(() {
                        filter = value;
                        ficha = fichaOriginal
                            .where((e) => e.toList().any((e) =>
                                e.toLowerCase().contains(filter.toLowerCase())))
                            .toList();
                      });
                    },
                  ),
                  const Gap(10),
                  FieldTexto(
                    flex: 1,
                    label: 'Circuito',
                    edit: true,
                    opciones: circuitos,
                    initialValue: filterCircuito,
                    asignarValor: (value) {
                      if (circuitos.contains(value)) {
                        setState(() {
                          filterCircuito = value;
                          ficha = fichaOriginal
                              .where(
                                (e) => e.toList().any(
                                      (e) => e
                                          .toLowerCase()
                                          .contains(filter.toLowerCase()),
                                    ),
                              )
                              .where(
                                (e) =>
                                    e.circuito.toUpperCase() ==
                                    filterCircuito.toUpperCase(),
                              )
                              .toList();
                        });
                      } else {
                        setState(() {
                          filterCircuito = '';
                          ficha = fichaOriginal
                              .where((e) => e.toList().any((e) => e
                                  .toLowerCase()
                                  .contains(filter.toLowerCase())))
                              .toList();
                        });
                      }
                    },
                  ),
                  const Gap(10),
                ],
              );
            },
          ),
          const Gap(5),
          const PedidosTitulosVersiones(),
          const PedidosTitulosMeses(),
          const Gap(5),
          // if (editar)
          //   PedidosCardParaTodos(
          //     items: ficha.map((e) => e.item).toList(),
          //   ),
          const Gap(5),
          Expanded(
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                if (state.ficha == null || firstTimeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                FPedidos fichaPedidos = state.ficha!.fichaPedidos;
                ficha = ficha
                    .where((e) => e.toList().any(
                        (e) => e.toLowerCase().contains(filter.toLowerCase())))
                    .toList();
                Map<String, EnableDate> dates =
                    fichaPedidos.fechasFEM.enableDates(state.year!);
                // if (ficha.length > endList) {
                //   ficha = ficha.sublist(0, endList);
                // }
                // print('state.fechasFEM!.enableDates(state.year!) ${state.fechasFEM!.enableDates(state.year!)}');
                List<FichaReg> fichaToShow = [];
                if (ficha.length > endList) {
                  fichaToShow = ficha.sublist(0, endList);
                } else {
                  fichaToShow = ficha;
                }

                return ListView.builder(
                  controller: _controller,
                  itemCount: fichaToShow.length +
                      1, // Añade uno para el indicador de carga
                  itemBuilder: (context, index) {
                    if (index == fichaToShow.length) {
                      // Último ítem - Muestra un indicador de carga y carga más datos
                      // _cargarMasDatos(); // Asegúrate de que esta función no se llame más de una vez simultáneamente
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Text('No hay más datos'),
                        ),
                      );
                    }
                    return CardPedido(
                      fem: ficha[index],
                      renderCto: ficha.any((e) => e.circuito.isNotEmpty),
                      dates: dates,
                      oldFem: state.ficha!.fichaPedidos.ficha[index],
                    ); // Tu widget de fila aquí
                  },
                );
                // SingleChildScrollView(
                //   // controller: _controller,
                //   padding: const EdgeInsets.all(4),
                //   child: Column(
                //     children: [
                //       for (int i = 0; i < ficha.length; i++)
                //         CardPedido(
                //           fem: ficha[i],
                //           renderCto: ficha.any((e) => e.circuito.isNotEmpty),
                //           dates: dates,
                //           oldFem: state.ficha!.fichaPedidos.ficha[i],
                //         ),
                //       const Gap(300),
                //     ],
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
