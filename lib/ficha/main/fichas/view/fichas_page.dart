import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:v_al_sam_v02/ficha/main/fichas/model/fichas_model.dart';

import '../../../../bloc/main_bloc.dart';
import '../../../../resources/descarga_hojas.dart';
import '../../../../resources/transicion_pagina.dart';
import '../../../ficha_ficha/model/ficha_reg/reg.dart';
import '../../ficha/model/ficha_model.dart';
import '../../ficha/view/ficha_page.dart';

class FichasPage extends StatefulWidget {
  const FichasPage({key});

  @override
  State<FichasPage> createState() => _FichasPageState();
}

class _FichasPageState extends State<FichasPage> {
  String year = '2025';
  String filter = '';
  int endList = 70;
  final ScrollController _controller = ScrollController();
  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        endList += 70;
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
    context.read<MainBloc>().fichasController.onSeleccionarYear(year: year);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void goTo(Widget page) => Navigator.push(context, createRoute(page));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fichas'),
        actions: [
          // ElevatedButton(
          //   onPressed: () {
          //     // context.read<MainBloc>().add(
          //     //       SeleccionarSapmlm(
          //     //         planilla: Sapmlm.fromInit(),
          //     //       ),
          //     //     );
          //     goTo(const NuevoPage());
          //   },
          //   child: const Text(
          //     'Nueva\nFicha',
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
      floatingActionButton: BlocSelector<MainBloc, MainState, Fichas?>(
        selector: (state) => state.fichas,
        builder: (context, state) {
          List<FichaReg> datos = [];
          if (year == '2025') datos = state?.f2025Raw ?? [];
          if (year == '2026') datos = state?.f2026Raw ?? [];
          if (year == '2027') datos = state?.f2027Raw ?? [];
          if (year == '2028') datos = state?.f2028Raw ?? [];
          if (state == null) {
            return const CircularProgressIndicator();
          } else {
            return Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed:
                    () => DescargaHojas().ahora(
                      user: context.read<MainBloc>().state.user!,
                      datos: datos,
                      nombre: 'Fichas',
                    ),
                child: const Icon(Icons.download),
              ),
            );
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: year,
                    onChanged: (String? newValue) {
                      setState(() {
                        year = newValue!;
                      });
                      context
                          .read<MainBloc>()
                          .fichasController
                          .onSeleccionarYear(year: year);
                    },
                    items:
                        <String>[
                          '2024',
                          '2025',
                          '2026',
                          '2027',
                          '2028',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Año',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        filter = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Búsqueda',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                List<Ficha> fichas = [];
                if (state.fichas != null) {
                  if (year == '2025') fichas = state.fichas?.f2025 ?? [];
                  if (year == '2026') fichas = state.fichas?.f2026 ?? [];
                  if (year == '2027') fichas = state.fichas?.f2027 ?? [];
                  if (year == '2028') fichas = state.fichas?.f2028 ?? [];
                  fichas =
                      fichas
                          .where(
                            (e) => e.fficha.ficha.any(
                              (el) =>
                                  el.proyecto.toLowerCase().contains(
                                    filter.toLowerCase(),
                                  ) ||
                                  el.pm.toLowerCase().contains(
                                    filter.toLowerCase(),
                                  ) ||
                                  el.solicitante.toLowerCase().contains(
                                    filter.toLowerCase(),
                                  ),
                            ),
                          )
                          .toList();
                }
                if (fichas.length > endList) {
                  fichas = fichas.sublist(0, endList);
                }
                return SingleChildScrollView(
                  controller: _controller,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Text('Fichas.lenght = ${fichas.length} '),
                      for (Ficha ficha in fichas)
                        Builder(
                          builder: (context) {
                            // int budgetTotal = ficha.resumen.budgetTotal;
                            // int budgetMaterial = ficha.resumen.budgetMaterial;
                            // List<BudgetSingle> budget = ficha.resumen.budget;
                            // String id = '';
                            // if (budget.isNotEmpty) {
                            //   id = budget[0].id;
                            // }
                            String pm =
                                ficha.fficha.ficha.last.pm.toLowerCase();
                            String solicitante =
                                ficha.fficha.ficha.last.solicitante;
                            String unidad = ficha.fficha.ficha.last.unidad;
                            if (solicitante ==
                                'yuly.barretorodriguez@enel.com') {
                              solicitante = '';
                            }
                            Image icono = Image.asset('images/pole2.png');
                            if (unidad.contains('sh')) {
                              icono = Image.asset('images/transformer.png');
                            }
                            if (unidad.contains('AT')) {
                              icono = Image.asset('images/at.png');
                            }
                            if (unidad.contains('Mob')) {
                              icono = Image.asset('images/mob.png');
                            }
                            if (unidad.contains('Urb')) {
                              icono = Image.asset('images/urb.png');
                            }
                            String proyecto =
                                  ficha.fficha.ficha[0].proyecto;
                            String id = ficha.fficha.ficha[0].iden;
                            return InkWell(
                              onTap: () {
                                context
                                    .read<MainBloc>()
                                    .fichasController
                                    .onSeleccionarFicha(ficha: ficha);
                                goTo(const FichaPage(esNuevo: false));
                              },
                              onDoubleTap: () {
                                context
                                    .read<MainBloc>()
                                    .fichasController
                                    .onSeleccionarFicha(ficha: ficha);
                                goTo(const FichaPage(esNuevo: false));
                              },
                              onLongPress: () {
                                context
                                    .read<MainBloc>()
                                    .fichasController
                                    .onSeleccionarFicha(ficha: ficha);
                                goTo(const FichaPage(esNuevo: false));
                              },
                              child: Card(
                                child: ListTile(
                                  isThreeLine: true,
                                  title: SelectableText(
                                    '$id - $proyecto',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'PM: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        TextSpan(text: '$pm - '),
                                        TextSpan(
                                          text: 'Funcional: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        TextSpan(text: '$solicitante \n'),
                                        TextSpan(
                                          text: 'Unidad: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        TextSpan(text: '$unidad \n'),
                                        // TextSpan(
                                        //   text: 'BudgetTotal: ',
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.blueGrey[700],
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // TextSpan(
                                        //   text:
                                        //       '${uSFormat.format(budgetTotal / 1000000)}M, ',
                                        //   style: const TextStyle(
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // TextSpan(
                                        //   text: 'BudgetMaterial: ',
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.blueGrey[700],
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // TextSpan(
                                        //   text:
                                        //       '${uSFormat.format(budgetMaterial / 1000000)}M (${(100 * budgetMaterial / budgetTotal).toStringAsFixed(0)}%), ',
                                        //   style: const TextStyle(
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // TextSpan(
                                        //   text: 'ValorFicha: ',
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.blueGrey[700],
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // TextSpan(
                                        //   text:
                                        //       '${uSFormat.format(ficha.resumen.total / 1000000)}M ',
                                        //   style: const TextStyle(
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // TextSpan(
                                        //   text:
                                        //       '(${(100 * ficha.resumen.total / budgetMaterial).toStringAsFixed(0)}%)',
                                        //   style:
                                        //       ficha.resumen.total > budgetMaterial
                                        //           ? const TextStyle(
                                        //               color: Colors.red,
                                        //               fontSize: 12)
                                        //           : const TextStyle(fontSize: 12),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  trailing: icono,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
