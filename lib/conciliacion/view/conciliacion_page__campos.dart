import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/registros/model/resgistros_b.dart';

import '../../bloc/main_bloc.dart';
import '../../user/user_model.dart';
import '../model/conciliacion_enum.dart';
import '../model/conciliacion_model.dart';
import 'conciliacion_fields_v2.dart';

class ConciliacionFields extends StatefulWidget {
  final bool esNuevo;
  const ConciliacionFields({
    required this.esNuevo,
    super.key,
  });

  @override
  State<ConciliacionFields> createState() => _ConciliacionFieldsState();
}

class _ConciliacionFieldsState extends State<ConciliacionFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        Color primaryColor = Theme.of(context).colorScheme.primary;
        TextStyle titleMedium =
            Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                );

        if (state.conciliacion == null ||
            state.user == null ||
            state.registrosB == null) {
          return const Text('Sin Conciliacion seleccionada');
        }
        Conciliacion conciliacion = state.conciliacion!;
        String estado = conciliacion.estado;
        User user = state.user!;
        RegistrosB registrosB = state.registrosB!;
        List<String> lcls =
            [...registrosB.registrosList.map((e) => e.lcl), ...state.lcl!.lclList.map((e) => e.lcl)].toSet().toList();
        List<String> balancessam = registrosB.registrosList
            .where((e) => e.lm.isNotEmpty)
            .map((e) => '${e.lcl}_${e.lm}')
            .toSet()
            .toList();
        if (conciliacion.lcl.isNotEmpty) {
          balancessam = registrosB.registrosList
              .where((e) => e.lcl == conciliacion.lcl && e.lm.isNotEmpty)
              .map((e) => '${e.lcl}_${e.lm}')
              .toSet()
              .toList();
        }
        // bool nuevaConciliacion = user.permisos.contains("nueva_conciliacion");
        bool editarArchivosContrato =
            user.permisos.contains("subir_archivos_contrato") && widget.esNuevo && estado == 'carga archivos';
        bool aprobarArchivosContrato =
            user.permisos.contains("aprobar_archivos_contrato") &&
                widget.esNuevo && estado == 'carga archivos';
        bool subirArchivosEnel =
            user.permisos.contains("subir_archivos_enel") && widget.esNuevo;
        bool aprobarArchivosEnel =
            user.permisos.contains("aprobar_archivos_enel") && widget.esNuevo;
        List<String> proyectos = state.conciliaciones!.conciliacionesList.map((e) => e.proyecto).toSet().toList();
        return Column(
          children: [
            Row(
              children: [
                FieldPre(
                  flex: 2,
                  initialValue: conciliacion.proyecto,
                  campo: CampoConciliacion.proyecto,
                  label: "Proyecto",
                  color: Colors.grey,
                  edit: editarArchivosContrato,
                  tipoCampo: TipoCampo.texto,
                  opciones: proyectos,
                ),
                const SizedBox(width: 10),
                FieldPre(
                  flex: 2,
                  initialValue: conciliacion.lcl,
                  campo: CampoConciliacion.lcl,
                  label: "LCL",
                  color: conciliacion.lcl.isEmpty ? Colors.red : Colors.green,
                  edit: editarArchivosContrato,
                  tipoCampo: TipoCampo.texto,
                  opciones: lcls,
                ),
                const SizedBox(width: 10),
                FieldPre(
                  flex: 2,
                  initialValue: conciliacion.nodo,
                  campo: CampoConciliacion.nodo,
                  label: "Nodo",
                  color: Colors.grey,
                  edit: editarArchivosContrato,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(width: 10),
                Builder(builder: (context) {
                  if (conciliacion.conciliacion.isEmpty) {
                    return Expanded(
                      flex: 1,
                      child: Center(
                        child:CircularProgressIndicator(),
                      ),
                    );
                  }
                  return FieldPre(
                    flex: 1,
                    initialValue: conciliacion.conciliacion,
                    campo: CampoConciliacion.conciliacion,
                    label: "Conciliación",
                    color: Colors.grey,
                    edit: false,
                    tipoCampo: TipoCampo.texto,
                  );
                }),
                const SizedBox(width: 10),
                FieldPre(
                  flex: 1,
                  initialValue: conciliacion.estado,
                  campo: CampoConciliacion.estado,
                  label: "Estado",
                  color: Colors.grey,
                  edit: false,
                  tipoCampo: TipoCampo.texto,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                FieldPre(
                  flex: 2,
                  initialValue: conciliacion.personaenel,
                  campo: CampoConciliacion.personaenel,
                  label: "Persona Enel",
                  color: Colors.grey,
                  edit: editarArchivosContrato || subirArchivosEnel,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(width: 10),
                FieldPre(
                  flex: 2,
                  initialValue: conciliacion.personacontrato,
                  campo: CampoConciliacion.personacontrato,
                  label: "Persona Contrato",
                  color: Colors.grey,
                  edit: editarArchivosContrato || subirArchivosEnel,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(width: 10),
                FieldPre(
                  flex: 2,
                  initialValue: conciliacion.lm,
                  campo: CampoConciliacion.lm,
                  label: "Libreto Medida (SCM)",
                  color: Colors.grey,
                  edit: widget.esNuevo,
                  tipoCampo: TipoCampo.texto,
                ),
                const SizedBox(width: 10),
                FieldPre(
                  flex: 2,
                  initialValue: conciliacion.lmfecha,
                  campo: CampoConciliacion.lmfecha,
                  label: "Fecha carga Libreto Medida",
                  color: Colors.grey,
                  edit: widget.esNuevo,
                  tipoCampo: TipoCampo.fecha,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardEstado(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Text(
                          'Contrato',
                          style: titleMedium,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Builder(builder: (context) {
                      if (conciliacion.balanceestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.balance,
                                campo: CampoConciliacion.balance,
                                label: 'BALANCE',
                                color: state.conciliacion!.balance.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue: state.conciliacion!.balanceestado,
                                campo: CampoConciliacion.balanceestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FieldPre(
                            flex: null,
                            initialValue: state.conciliacion!.balancesam,
                            campo: CampoConciliacion.balancesam,
                            label: 'BALANCE SAM',
                            color: state.conciliacion!.balancesam.isEmpty
                                ? Colors.red
                                : Colors.green,
                            edit: editarArchivosContrato,
                            tipoCampo: TipoCampo.texto,
                            opciones: balancessam,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.planillatrabajoestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue:
                                    state.conciliacion!.planillatrabajo,
                                campo: CampoConciliacion.planillatrabajo,
                                label: 'planillatrabajo',
                                color: state.conciliacion!.planillatrabajo.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.planillatrabajoestado,
                                campo: CampoConciliacion.planillatrabajoestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.descargosestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.descargos,
                                campo: CampoConciliacion.descargos,
                                label: 'descargos',
                                color: state.conciliacion!.descargos.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.descargosestado,
                                campo: CampoConciliacion.descargosestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.docseguridadestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.docseguridad,
                                campo: CampoConciliacion.docseguridad,
                                label: 'docseguridad',
                                color: state.conciliacion!.docseguridad.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.docseguridadestado,
                                campo: CampoConciliacion.docseguridadestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.medidapatestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.medidapat,
                                campo: CampoConciliacion.medidapat,
                                label: 'medidapat',
                                color: state.conciliacion!.medidapat.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.medidapatestado,
                                campo: CampoConciliacion.medidapatestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.formatoarrimeestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.formatoarrime,
                                campo: CampoConciliacion.formatoarrime,
                                label: 'formatoarrime',
                                color: state.conciliacion!.formatoarrime.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.formatoarrimeestado,
                                campo: CampoConciliacion.formatoarrimeestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.planoestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.plano,
                                campo: CampoConciliacion.plano,
                                label: 'plano',
                                color: state.conciliacion!.plano.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue: state.conciliacion!.planoestado,
                                campo: CampoConciliacion.planoestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.docsalmacenestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.docsalmacen,
                                campo: CampoConciliacion.docsalmacen,
                                label: 'docsalmacen',
                                color: state.conciliacion!.docsalmacen.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.docsalmacenestado,
                                campo: CampoConciliacion.docsalmacenestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.regfotograficoestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue:
                                    state.conciliacion!.regfotografico,
                                campo: CampoConciliacion.regfotografico,
                                label: 'regfotografico',
                                color: state.conciliacion!.regfotografico.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.regfotograficoestado,
                                campo: CampoConciliacion.regfotograficoestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.cortesobraestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.cortesobra,
                                campo: CampoConciliacion.cortesobra,
                                label: 'cortesobra',
                                color: state.conciliacion!.cortesobra.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.cortesobraestado,
                                campo: CampoConciliacion.cortesobraestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.pruebasconcretoestado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue:
                                    state.conciliacion!.pruebasconcreto,
                                campo: CampoConciliacion.pruebasconcreto,
                                label: 'pruebasconcreto',
                                color: state.conciliacion!.pruebasconcreto.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue:
                                    state.conciliacion!.pruebasconcretoestado,
                                campo: CampoConciliacion.pruebasconcretoestado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.varios1estado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.varios1,
                                campo: CampoConciliacion.varios1,
                                label: 'varios1',
                                color: state.conciliacion!.varios1.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue: state.conciliacion!.varios1estado,
                                campo: CampoConciliacion.varios1estado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.varios2estado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.varios2,
                                campo: CampoConciliacion.varios2,
                                label: 'varios2',
                                color: state.conciliacion!.varios2.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue: state.conciliacion!.varios2estado,
                                campo: CampoConciliacion.varios2estado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    Builder(builder: (context) {
                      if (conciliacion.varios3estado.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              FieldPre(
                                flex: 6,
                                initialValue: state.conciliacion!.varios3,
                                campo: CampoConciliacion.varios3,
                                label: 'varios3',
                                color: state.conciliacion!.varios3.isEmpty
                                    ? Colors.red
                                    : Colors.green,
                                edit: editarArchivosContrato,
                                tipoCampo: TipoCampo.file,
                                pdi: user.pdi,
                              ),
                              const SizedBox(width: 10),
                              FieldPre(
                                flex: 1,
                                initialValue: state.conciliacion!.varios3estado,
                                campo: CampoConciliacion.varios3estado,
                                label: '',
                                color: Colors.grey,
                                edit: aprobarArchivosContrato,
                                tipoCampo: TipoCampo.switcher,
                                pdi: user.pdi,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                  ],
                ),
                CardEstado(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Text(
                          'Enel',
                          style: titleMedium,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        FieldPre(
                          flex: 6,
                          initialValue: state.conciliacion!.planillafirmada,
                          campo: CampoConciliacion.planillafirmada,
                          label: 'PLANILLA FIRMADA',
                          color: Colors.grey,
                          edit: subirArchivosEnel,
                          tipoCampo: TipoCampo.file,
                          pdi: user.pdi,
                        ),
                        const SizedBox(width: 10),
                        FieldPre(
                          flex: 1,
                          initialValue:
                              state.conciliacion!.planillafirmadaestado,
                          campo: CampoConciliacion.planillafirmadaestado,
                          label: '',
                          color: Colors.grey,
                          edit: aprobarArchivosEnel,
                          tipoCampo: TipoCampo.switcher,
                          pdi: user.pdi,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class CardEstado extends StatelessWidget {
  final List<Widget> children;
  const CardEstado({
    required this.children,
    // super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.background;
    return Expanded(
      child: Card(
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
