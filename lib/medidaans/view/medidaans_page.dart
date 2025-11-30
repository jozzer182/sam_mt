import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/medidaans/model/medidaans_model.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/main_bloc.dart';
import '../../resources/descarga_hojas.dart';

class MedidaAnsPage extends StatefulWidget {
  const MedidaAnsPage({Key? key}) : super(key: key);

  @override
  State<MedidaAnsPage> createState() => _MedidaAnsPageState();
}

class _MedidaAnsPageState extends State<MedidaAnsPage> {
  double _lowerValue = 0.0;
  double _upperValue = 1.0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double dateDifference = 1;
  List<BarChartGroupData> graphData = [];
  @override
  void initState() {
    startDate =
        context.read<MainBloc>().state.medidaAns?.fechaInicio ?? DateTime.now();
    endDate =
        context.read<MainBloc>().state.medidaAns?.fechaFin ?? DateTime.now();
    // _lowerValue = endDate.difference(startDate).inDays.toDouble();
    _upperValue = endDate.difference(startDate).inDays.toDouble();
    dateDifference = endDate.difference(startDate).inDays.toDouble();
    graphData =
        context.read<MainBloc>().state.medidaAns!.distribucion.map((data) {
          final dias = data.dias;
          final cantidad = data.cantidad;
          return BarChartGroupData(
            x: dias,
            barRods: [
              BarChartRodData(toY: cantidad.toDouble(), color: Colors.blue),
            ],
          );
        }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medida Ans')),
      floatingActionButton: BlocSelector<MainBloc, MainState, MedidaAns?>(
        selector: (state) => state.medidaAns,
        builder: (context, state) {
          return state == null
              ? SizedBox()
              : FloatingActionButton(
                onPressed:
                    () => DescargaHojas().ahora(
                      user: context.read<MainBloc>().state.user!,
                      datos: state.medidaAnsList,
                      nombre: 'Medida Ans',
                    ),
                child: Icon(Icons.download),
              );
        },
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          bool renderThis = false;
          if (state.medidaAns!.medidaAnsList
              .where((e) => e.tiempototal != "<--")
              .isNotEmpty) {
            renderThis = true;
          }
          return SelectionArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Se analizarán los datos de los registros con estado "carga scm" entre los rangos de fechas:',
                  ),
                  if (renderThis)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlutterSlider(
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBar: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          inactiveTrackBar: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                        ),
                        values: [_lowerValue, _upperValue],
                        rangeSlider: true,
                        max:
                            dateDifference, // Máximo número de días en tu rango de fechas
                        min: 0.0,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          setState(() {
                            _lowerValue = lowerValue;
                            _upperValue = upperValue;
                          });
                          context.read<MainBloc>().medidaansCtrl.setDates(
                            startDate: startDate.add(
                              Duration(days: _lowerValue.toInt()),
                            ),
                            endDate: startDate.add(
                              Duration(days: _upperValue.toInt()),
                            ),
                          );
                          // setState(() {
                          //   graphData = [];
                          // });
                          // wait 3 segs to update graph
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              graphData =
                                  state.medidaAns!.distribucion.map((data) {
                                    final dias = data.dias;
                                    final cantidad = data.cantidad;
                                    return BarChartGroupData(
                                      x: dias,
                                      barRods: [
                                        BarChartRodData(
                                          toY: cantidad.toDouble(),
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ],
                                    );
                                  }).toList();
                            });
                          });
                        },
                        tooltip: FlutterSliderTooltip(
                          alwaysShowTooltip: true,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            color: Colors.transparent,
                          ),
                          leftPrefix: Text(
                            formatDate(
                              startDate.add(
                                Duration(days: _lowerValue.toInt()),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          rightSuffix: Text(
                            formatDate(
                              startDate.add(
                                Duration(days: _upperValue.toInt()),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(),
                  Text(
                    'Fecha Inicio: ${state.medidaAns?.fechaInicio.toIso8601String().substring(0, 10) ?? 0}',
                  ),
                  Text(
                    'Fecha Fin: ${state.medidaAns?.fechaFin.toIso8601String().substring(0, 10) ?? 0}',
                  ),
                  Text('Cantidad: ${state.medidaAns?.count ?? 0} registros'),
                  Text('Suma: ${state.medidaAns?.sum ?? 0} días'),
                  Text('Máximo: ${state.medidaAns?.max ?? 0} días'),
                  Text('Mínimo: ${state.medidaAns?.min ?? 0} días'),
                  Text(
                    'Promedio: ${state.medidaAns?.mean.toStringAsFixed(1) ?? 0} días',
                  ),
                  Text('Mediana: ${state.medidaAns?.median ?? 0} días'),
                  Text('Moda: ${state.medidaAns?.mode ?? 0} días'),
                  Text('Centro: ${state.medidaAns?.center ?? 0} días'),
                  Text(
                    'Varianza: ${state.medidaAns?.variance.toStringAsFixed(1) ?? 0} días²',
                  ),
                  Text(
                    'Desviación estándar: ${state.medidaAns?.standardDeviation.toStringAsFixed(1) ?? 0} días',
                  ),
                  SizedBox(height: 8),
                  if (renderThis)
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          barGroups: graphData,
                          // maxY: state.medidaAns?.max.toDouble() ?? 0.0,
                          minY: 0.0,
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Días',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            rightTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Cantidad',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
