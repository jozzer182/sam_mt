import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

import '../../bloc/main_bloc.dart';
import '../../version.dart';
import '../model/conciliacion_enum.dart';
import '../model/conciliacion_model.dart';
import 'conciliacion_page__campos.dart';
import 'conciliacion_page__estados.dart';
import 'conciliacion_page__guardar_estados.dart';
import 'conciliacion_page__seleccionar_campos.dart';

class ConciliacionPage extends StatefulWidget {
  final bool esNuevo;
  final bool esPrimeraVez;
  final String pdi;

  const ConciliacionPage({
    required this.esNuevo,
    required this.esPrimeraVez,
    required this.pdi,
    super.key,
  });

  @override
  State<ConciliacionPage> createState() => _ConciliacionPageState();
}

class _ConciliacionPageState extends State<ConciliacionPage> {
  late bool esNuevo;

  Future<String> _futureLastNumberReg() async {
    String lastnumber =
        await context.read<MainBloc>().conciliacionCtrl.lastConciliacion();
    if (widget.esPrimeraVez) {
      context
          .read<MainBloc>()
          .conciliacionCtrl
          .cambiarCampos
          .changeConciliacion(
            value: lastnumber,
            campo: CampoConciliacion.conciliacion,
          );
      context
          .read<MainBloc>()
          .conciliacionCtrl
          .cambiarCampos
          .changeConciliacion(
            value: 'true',
            campo: CampoConciliacion.esprimeravez,
          );
    }

    return lastnumber;
  }

  @override
  void initState() {
    esNuevo = widget.esNuevo;
    if (widget.esPrimeraVez) {
      _futureLastNumberReg();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Version.data, style: Theme.of(context).textTheme.labelSmall),
            Text(
              Version.status('Conciliacion', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
      appBar: AppBar(
        title: const Text('CONCILIACIÓN'),
        automaticallyImplyLeading: false, // Disable the default back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Your custom logic here
            if (esNuevo) {
              Navigator.of(context).pop();
            }
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? LinearProgressIndicator() : SizedBox();
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return EstadosDialog();
                },
              );
            },
            child: Text('Estados?'),
          ),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (!widget.esNuevo) {
                return SizedBox();
              }
              User user = state.user!;
              bool estadoCarga =
                  state.conciliacion!.estado == "carga archivos" ||
                  state.conciliacion!.estado == "revisar";
              bool seleccionarAdjuntos =
                  user.permisos.contains("seleccionar_adjuntos") && estadoCarga;
              return ElevatedButton(
                onPressed:
                    !seleccionarAdjuntos
                        ? null
                        : () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DialogSeleccionarCampos();
                            },
                          );
                        },
                child: Text('Seleccionar\nCampos', textAlign: TextAlign.center),
              );
            },
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (!widget.esNuevo) {
                return SizedBox();
              }
              User user = state.user!;
              String estadoAnterior = state.conciliacion!.estado;
              bool estado = estadoAnterior == "carga archivos";
              bool anular =
                  user.permisos.contains("anular_conciliacion") && estado;
              if (!anular) {
                return SizedBox();
              }
              return ElevatedButton(
                onPressed: () {
                  // print('anular');
                  context
                      .read<MainBloc>()
                      .conciliacionCtrl
                      .cambiarCampos
                      .changeConciliacion(
                        campo: CampoConciliacion.estado,
                        value: 'anular',
                      );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConciliacionGuardarEstado(
                        estadoAnterior: estadoAnterior,
                      );
                    },
                  );
                },
                child: Text('Anular', textAlign: TextAlign.center),
              );
            },
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (!widget.esNuevo) {
                return SizedBox();
              }
              User user = state.user!;
              String estadoAnterior = state.conciliacion!.estado;
              bool estado = state.conciliacion!.estado == "carga archivos";
              bool revisar =
                  user.permisos.contains("revisar_conciliacion") && estado;
              if (!revisar) {
                return SizedBox();
              }
              return ElevatedButton(
                onPressed: () {
                  // print('revisar');
                  context
                      .read<MainBloc>()
                      .conciliacionCtrl
                      .cambiarCampos
                      .changeConciliacion(
                        campo: CampoConciliacion.estado,
                        value: 'revisar',
                      );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConciliacionGuardarEstado(
                        estadoAnterior: estadoAnterior,
                      );
                    },
                  );
                },
                child: Text('Revisar', textAlign: TextAlign.center),
              );
            },
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (!widget.esNuevo) {
                return SizedBox();
              }
              User user = state.user!;
              String estadoAnterior = state.conciliacion!.estado;
              bool estado = state.conciliacion!.estado == "aprobado";
              bool revisarenel =
                  user.permisos.contains("revisarenel_conciliacion") && estado;
              if (!revisarenel) {
                return SizedBox();
              }
              return ElevatedButton(
                onPressed: () {
                  // print('revisar enel');
                  context
                      .read<MainBloc>()
                      .conciliacionCtrl
                      .cambiarCampos
                      .changeConciliacion(
                        campo: CampoConciliacion.estado,
                        value: 'revisar enel',
                      );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConciliacionGuardarEstado(
                        estadoAnterior: estadoAnterior,
                      );
                    },
                  );
                },
                child: Text('Revisar\nEnel', textAlign: TextAlign.center),
              );
            },
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              User user = state.user!;
              // bool nuevaConciliacion =
              //     user.permisos.contains("nueva_conciliacion");
              bool editarConciliacion = user.permisos.contains(
                "editar_conciliacion",
              );
              if (!widget.esNuevo || !editarConciliacion) {
                return SizedBox();
              }
              bool habilitado = false;
              String estado = state.conciliacion!.estado;
              bool contrato = user.permisos.contains("subir_archivos_contrato");
              bool enel = user.permisos.contains("subir_archivos_enel");
              Conciliacion conciliacion = state.conciliacion!;
              //campos Contrato
              bool balanceBool =
                  (conciliacion.balance.isNotEmpty &&
                      conciliacion.balancesam.isNotEmpty) ||
                  conciliacion.balanceestado.isEmpty;
              bool planillatrabajoBool =
                  conciliacion.planillatrabajo.isNotEmpty ||
                  conciliacion.planillatrabajoestado.isEmpty;
              bool descargosBool =
                  conciliacion.descargos.isNotEmpty ||
                  conciliacion.descargosestado.isEmpty;
              bool docseguridadBool =
                  conciliacion.docseguridad.isNotEmpty ||
                  conciliacion.docseguridadestado.isEmpty;
              bool medidapatBool =
                  conciliacion.medidapat.isNotEmpty ||
                  conciliacion.medidapatestado.isEmpty;
              bool formatoarrimeBool =
                  conciliacion.formatoarrime.isNotEmpty ||
                  conciliacion.formatoarrimeestado.isEmpty;
              bool planoBool =
                  conciliacion.plano.isNotEmpty ||
                  conciliacion.planoestado.isEmpty;
              bool docsalmacenBool =
                  conciliacion.docsalmacen.isNotEmpty ||
                  conciliacion.docsalmacenestado.isEmpty;
              bool regfotograficoBool =
                  conciliacion.regfotografico.isNotEmpty ||
                  conciliacion.regfotograficoestado.isEmpty;
              bool cortesobraBool =
                  conciliacion.cortesobra.isNotEmpty ||
                  conciliacion.cortesobraestado.isEmpty;
              bool pruebasconcretoBool =
                  conciliacion.pruebasconcreto.isNotEmpty ||
                  conciliacion.pruebasconcretoestado.isEmpty;
              bool varios1Bool =
                  conciliacion.varios1.isNotEmpty ||
                  conciliacion.varios1estado.isEmpty;
              bool varios2Bool =
                  conciliacion.varios2.isNotEmpty ||
                  conciliacion.varios2estado.isEmpty;
              bool varios3Bool =
                  conciliacion.varios3.isNotEmpty ||
                  conciliacion.varios3estado.isEmpty;
              bool camposContrato =
                  balanceBool &&
                  planillatrabajoBool &&
                  descargosBool &&
                  docseguridadBool &&
                  medidapatBool &&
                  formatoarrimeBool &&
                  planoBool &&
                  docsalmacenBool &&
                  regfotograficoBool &&
                  cortesobraBool &&
                  pruebasconcretoBool &&
                  varios1Bool &&
                  varios2Bool &&
                  varios3Bool;
              //campos Enel
              bool planillafirmada =
                  conciliacion.planillafirmada.isNotEmpty ||
                  conciliacion.planillafirmadaestado.isEmpty;
              bool balanceBoolEnel =
                  (conciliacion.balance.isNotEmpty &&
                      conciliacion.balanceestado == 'true') ||
                  conciliacion.balanceestado.isEmpty;
              bool planillatrabajoBoolEnel =
                  (conciliacion.planillatrabajo.isNotEmpty &&
                      conciliacion.planillatrabajoestado == 'true') ||
                  conciliacion.planillatrabajoestado.isEmpty;
              bool descargosBoolEnel =
                  (conciliacion.descargos.isNotEmpty &&
                      conciliacion.descargosestado == 'true') ||
                  conciliacion.descargosestado.isEmpty;
              bool docseguridadBoolEnel =
                  (conciliacion.docseguridad.isNotEmpty &&
                      conciliacion.docseguridadestado == 'true') ||
                  conciliacion.docseguridadestado.isEmpty;
              bool medidapatBoolEnel =
                  (conciliacion.medidapat.isNotEmpty &&
                      conciliacion.medidapatestado == 'true') ||
                  conciliacion.medidapatestado.isEmpty;
              bool formatoarrimeBoolEnel =
                  (conciliacion.formatoarrime.isNotEmpty &&
                      conciliacion.formatoarrimeestado == 'true') ||
                  conciliacion.formatoarrimeestado.isEmpty;
              bool planoBoolEnel =
                  (conciliacion.plano.isNotEmpty &&
                      conciliacion.planoestado == 'true') ||
                  conciliacion.planoestado.isEmpty;
              bool docsalmacenBoolEnel =
                  (conciliacion.docsalmacen.isNotEmpty &&
                      conciliacion.docsalmacenestado == 'true') ||
                  conciliacion.docsalmacenestado.isEmpty;
              bool regfotograficoBoolEnel =
                  (conciliacion.regfotografico.isNotEmpty &&
                      conciliacion.regfotograficoestado == 'true') ||
                  conciliacion.regfotograficoestado.isEmpty;
              bool cortesobraBoolEnel =
                  (conciliacion.cortesobra.isNotEmpty &&
                      conciliacion.cortesobraestado == 'true') ||
                  conciliacion.cortesobraestado.isEmpty;
              bool pruebasconcretoBoolEnel =
                  (conciliacion.pruebasconcreto.isNotEmpty &&
                      conciliacion.pruebasconcretoestado == 'true') ||
                  conciliacion.pruebasconcretoestado.isEmpty;
              bool varios1BoolEnel =
                  (conciliacion.varios1.isNotEmpty &&
                      conciliacion.varios1estado == 'true') ||
                  conciliacion.varios1estado.isEmpty;
              bool varios2BoolEnel =
                  (conciliacion.varios2.isNotEmpty &&
                      conciliacion.varios2estado == 'true') ||
                  conciliacion.varios2estado.isEmpty;
              bool varios3BoolEnel =
                  (conciliacion.varios3.isNotEmpty &&
                      conciliacion.varios3estado == 'true') ||
                  conciliacion.varios3estado.isEmpty;

              bool camposEnel =
                  planillafirmada &&
                  balanceBoolEnel &&
                  planillatrabajoBoolEnel &&
                  descargosBoolEnel &&
                  docseguridadBoolEnel &&
                  medidapatBoolEnel &&
                  formatoarrimeBoolEnel &&
                  planoBoolEnel &&
                  docsalmacenBoolEnel &&
                  regfotograficoBoolEnel &&
                  cortesobraBoolEnel &&
                  pruebasconcretoBoolEnel &&
                  varios1BoolEnel &&
                  varios2BoolEnel &&
                  varios3BoolEnel;
              bool lm = conciliacion.lm.isNotEmpty;
              bool aprobadoEnel = conciliacion.planillafirmadaestado == "true";
              bool camposContratoAprobacion = lm && aprobadoEnel;
              if (estado == "carga archivos" && contrato && camposContrato) {
                habilitado = true;
              }
              if (estado == "carga archivos" && enel && camposEnel) {
                habilitado = true;
              }
              if (estado == "aprobado" &&
                  contrato &&
                  camposContratoAprobacion) {
                habilitado = true;
              }
              if (estado == "aprobado" && enel) {
                habilitado = true;
              }
              if (estado == "carga scm" && contrato) {
                habilitado = true;
              }
              return ElevatedButton(
                onPressed:
                    !habilitado
                        ? null
                        : () {
                          if (estado == "carga archivos" &&
                              enel &&
                              camposEnel) {
                            context
                                .read<MainBloc>()
                                .conciliacionCtrl
                                .cambiarCampos
                                .changeConciliacion(
                                  campo: CampoConciliacion.estado,
                                  value: 'aprobado',
                                );
                          } else if ((estado == "aprobado" ||
                                  estado == "carga scm") &&
                              contrato &&
                              camposContratoAprobacion) {
                            context
                                .read<MainBloc>()
                                .conciliacionCtrl
                                .cambiarCampos
                                .changeConciliacion(
                                  campo: CampoConciliacion.estado,
                                  value: 'carga scm',
                                );
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConciliacionGuardarEstado(
                                estadoAnterior: estado,
                              );
                            },
                          );
                        },
                child: Text('Guardar', textAlign: TextAlign.center),
              );
            },
          ),
          const SizedBox(width: 10),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              Conciliacion conciliacion = state.conciliacion!;
              if (widget.esNuevo) {
                return SizedBox();
              } else {
                List<Conciliacion> listaConciliaciones =
                    state.conciliaciones!.conciliacionesList
                        .where(
                          (e) =>
                              e.conciliacion ==
                              state.conciliacion!.conciliacion,
                        )
                        .toList();
                Conciliacion ultimaConciliacion = listaConciliaciones.last;
                if (conciliacion.id != ultimaConciliacion.id) {
                  return SizedBox();
                }
              }
              User user = state.user!;
              bool editarConciliacion = user.permisos.contains(
                "editar_conciliacion",
              );

              return ElevatedButton(
                onPressed:
                    !editarConciliacion
                        ? null
                        : () {
                          String nuevoEstado = conciliacion.estado;
                          if (conciliacion.estado == "revisar" ||
                              conciliacion.estado == "anular") {
                            nuevoEstado = "carga archivos";
                          }
                          if (conciliacion.estado == "revisar enel") {
                            nuevoEstado = "aprobado";
                          }
                          context
                              .read<MainBloc>()
                              .conciliacionesCtrl
                              .seleccionarConciliacion(
                                conciliacion.copyWith(
                                  persona: user.correo,
                                  comentario: '',
                                  fecha: DateTime.now().toString().substring(
                                    0,
                                    16,
                                  ),
                                  estado: nuevoEstado,
                                ),
                              );
                          Navigator.push(
                            context,
                            version.createRoute(
                              ConciliacionPage(
                                esPrimeraVez: false,
                                esNuevo: true,
                                pdi: user.pdi,
                              ),
                            ),
                          );
                        },
                child: Text('Nuevo\nEstado', textAlign: TextAlign.center),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ConciliacionFields(esNuevo: esNuevo),
              const SizedBox(height: 10),
              ConciliacionEstados(esNuevo: esNuevo),
            ],
          ),
        ),
      ),
    );
  }
}

class EstadosDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Image.asset('images/estadosimagen.png')],
      ),
    );
  }
}
