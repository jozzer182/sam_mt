import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/model/solpe_reg_enum.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/view/solpe_doc/solpe_doc_row.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/view/solpe_doc/solpe_doc_titles.dart';
import 'package:v_al_sam_v02/resources/a_entero_2.dart';

import '../../../../bloc/main_bloc.dart';
import '../../../../resources/descarga_hojas.dart';
import '../../../../resources/field_pre/field_pre.dart';
import '../../model/solpe_reg.dart';
import '../pegar_excel/boton_pegar_excel.dart';
import 'actions/solpe_doc_anular.dart';
import 'actions/solpe_doc_cancelar.dart';
import 'actions/solpe_doc_edit.dart';
import 'actions/solpe_doc_guardar.dart';

class SolpeDocPage extends StatefulWidget {
  final bool esNuevo;
  const SolpeDocPage({required this.esNuevo, super.key});

  @override
  State<SolpeDocPage> createState() => _SolpeDocPageState();
}

class _SolpeDocPageState extends State<SolpeDocPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.solPeDoc == null) {
          return const Center(child: CircularProgressIndicator());
        }
        List<SolPeReg> list = state.solPeDoc?.list ?? [];
        bool editar = state.solPeDoc?.editar ?? false;
        List<String> pedidos =
            state.fechasFEM?.fechasFemDateBoolList
                .where((e) => e.estado)
                .map((e) => e.pedido)
                .toList() ??
            [];
        pedidos.sort((a, b) {
          int aNumber = aEntero(
            '${a.substring(3, 5)}${a.substring(0, 2)}${a.substring(6, 7)}',
          );
          int bNumber = aEntero(
            '${a.substring(3, 5)}${a.substring(0, 2)}${a.substring(6, 7)}',
          );
          return aNumber.compareTo(bNumber);
        });
        pedidos.insert(0, "");
        return WillPopScope(
          onWillPop: () async {
            if (editar) {
              context.read<MainBloc>().solPeDocController.editChanger;
              context.read<MainBloc>().solPeDocController.revertSecure;
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('${widget.esNuevo ? "Nueva " : ""}Solicitud Pedido'),
              actions: [
                if (!editar &&
                    !widget.esNuevo &&
                    state.solPeDoc?.list.first.estado == "Solicitado")
                  SolPeDocAnularButton(),
                if (!editar &&
                    !widget.esNuevo &&
                    state.solPeDoc?.list.first.estado == "Solicitado")
                  SolPeDocEditButton(),
                if (editar &&
                    !widget.esNuevo &&
                    state.solPeDoc?.list.first.estado == "Solicitado")
                  SolPeDocCancelarButton(),
                if (!editar && !widget.esNuevo)
                  ElevatedButton(
                    onPressed: () {
                      List<Map<String, dynamic>> datos =
                          state.solPeDoc?.list.map((e) => e.toMap()).toList() ??
                          [];
                      DescargaHojas.ahoraMap(
                        datos: datos,
                        nombre:
                            'Solicitud Pedidos ${state.solPeDoc?.list.first.pedidonumber} de ${state.solPeDoc?.list.first.pdi}',
                        user: context.read<MainBloc>().state.user!,
                      );
                    },
                    child: const Text('Descarga'),
                  ),
                if (widget.esNuevo || editar) SolpeDocGuardar(),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: BlocSelector<MainBloc, MainState, bool>(
                  selector: (state) => state.isLoading,
                  builder: (context, state) {
                    return state ? LinearProgressIndicator() : SizedBox();
                  },
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      FieldPre(
                        flex: 1,
                        initialValue:
                            state.solPeDoc?.list.first.estado ?? "Sin dato",
                        label: 'Estado',
                        color: Colors.grey,
                        colorfondo: Colors.grey[300]!,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {},
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 1,
                        initialValue:
                            state.solPeDoc?.list.first.pedidonumber ??
                            "Sin dato",
                        label: 'Pedido',
                        color: Colors.grey,
                        colorfondo: Colors.grey[300]!,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {},
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 1,
                        initialValue:
                            state.solPeDoc?.list.first.iden ??
                            "Sin dato",
                        label: 'id',
                        color: Colors.grey,
                        colorfondo: Colors.grey[300]!,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {},
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 2,
                        initialValue:
                            state.solPeDoc?.list.first.proyecto ?? "Sin dato",
                        label: 'Proyecto',
                        color: Colors.grey,
                        colorfondo: Colors.grey[300]!,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {},
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 2,
                        initialValue:
                            state.solPeDoc?.list.first.unidad ?? "Sin dato",
                        label: 'Unidad',
                        color: Colors.grey,
                        colorfondo: Colors.grey[300]!,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {},
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 1,
                        initialValue:
                            state.solPeDoc?.list.first.pdi ?? "Sin dato",
                        label: 'PDI',
                        color: Colors.grey,
                        colorfondo: Colors.grey[300]!,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {},
                      ),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      FieldPre(
                        flex: 3,
                        initialValue:
                            state.solPeDoc?.list.first.circuito ?? "Error",
                        label: 'Circuito',
                        opciones:
                            state.ficha?.fficha.ficha
                                .map((e) => e.circuito.toUpperCase())
                                .toSet()
                                .toList() ??
                            [],
                        color: Colors.black,
                        edit: editar || widget.esNuevo,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {
                          context
                              .read<MainBloc>()
                              .solPeDocController
                              .campo
                              .cambiar(
                                tipo: CampoSolpe.circuito,
                                value: value,
                                index: -1,
                              );
                        },
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 5,
                        initialValue:
                            state.solPeDoc?.list.first.eccomentario ?? "Error",
                        label: 'Comentario',
                        color: Colors.black,
                        edit: editar || widget.esNuevo,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {
                          context
                              .read<MainBloc>()
                              .solPeDocController
                              .campo
                              .cambiar(
                                tipo: CampoSolpe.eccomentario,
                                value: value,
                                index: -1,
                              );
                        },
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 1,
                        initialValue:
                            state.solPeDoc?.list.first.pedido ?? "Error",
                        label: 'Pedido Agendado',
                        color: Colors.black,
                        edit: editar || widget.esNuevo,
                        tipoCampo: TipoCampo.desplegable,
                        opciones: pedidos,
                        asignarValor: (value) {
                          print(value);
                          context
                              .read<MainBloc>()
                              .solPeDocController
                              .campo
                              .cambiar(
                                tipo: CampoSolpe.pedido,
                                value: value,
                                index: -1,
                              );
                        },
                      ),
                      const Gap(10),
                      FieldPre(
                        flex: 3,
                        initialValue:
                            state.solPeDoc?.list.first.ecpersona ?? "Error",
                        label: 'Persona',
                        color: Colors.grey,
                        colorfondo: Colors.grey[300]!,
                        edit: false,
                        tipoCampo: TipoCampo.texto,
                        asignarValor: (value) {},
                      ),
                    ],
                  ),
                  const Gap(10),
                  if (editar || widget.esNuevo)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // context
                        //     //     .read<MainBloc>()
                        //     //     .solPeDocController
                        //     //     .list
                        //     //     .agregar;
                        //   },
                        //   child: const Text('Pegar De Excel'),
                        // ),
                        SolPeBotonPegarExcel(),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<MainBloc>()
                                .solPeDocController
                                .list
                                .agregar;
                          },
                          child: const Text('Agregar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<MainBloc>()
                                .solPeDocController
                                .list
                                .eliminar;
                          },
                          child: const Text('Eliminar'),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     context
                        //         .read<MainBloc>()
                        //         .fichaFichaController
                        //         .lista
                        //         .reset;
                        //   },
                        //   child: const Text('Limpiar'),
                        // ),
                      ],
                    ),
                  const Gap(10),
                  SolpeDocTitles(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return SolPeRow(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
