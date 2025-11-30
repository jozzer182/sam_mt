// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:v_al_sam_v02/ficha/ficha_solpe/view/solpe_list_actions.dart';

import '../../../../bloc/main_bloc.dart';
import '../../../ficha_agendados/view/ficha_pedidos_page.dart';
import '../../../ficha_ficha/view/ficha__ficha_page.dart';
import '../../../ficha_ficha/view/actions_button/fficha_actions.dart';
import '../../../ficha_agendados/view/ficha_actions_agendados.dart';
import '../../../ficha_solpe/view/solpe_list_page.dart';

class FichaPage extends StatefulWidget {
  final bool esNuevo;
  const FichaPage({
    required this.esNuevo,
    Key? key,
  }) : super(key: key);

  @override
  State<FichaPage> createState() => _FichaPageState();
}

class _FichaPageState extends State<FichaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ValueNotifier<int> _selectedTabIndex;
  bool verDinero = false;

  @override
  void initState() {
    super.initState();
    // Configura el TabController con la cantidad de pestañas
    _tabController = TabController(length: 3, vsync: this);
    // Agrega un listener para detectar cambios de pestaña
    _tabController.addListener(_handleTabSelection);
    _selectedTabIndex = ValueNotifier<int>(0);
    // context.read<MainBloc>().fichaPedidosController.editar(false);
    // context.read<MainBloc>().fichaCambiosController().obtener();
    // context.read<MainBloc>().fichaSolicitadosController().obtener();
    context.read<MainBloc>().fichaFichaController.inicial.calculo;
  }

  void _handleTabSelection() {
    // Imprime el índice de la pestaña seleccionada en la consola
    // print("Pestaña seleccionada: ${_tabController.index}");
    // Actualiza el índice de la pestaña seleccionada
    _selectedTabIndex.value = _tabController.index;
  }

  @override
  void dispose() {
    // Asegúrate de liberar recursos cuando el widget se dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Text(state.ficha?.fficha.ficha.first.proyecto ?? '');
          },
        ),
        actions: [
          //FICHA
          Actionsficha(
            selectedTabIndex: _selectedTabIndex,
            tabController: _tabController,
          ),
          //PEDIDOS
          ActionsPedidos(
            selectedTabIndex: _selectedTabIndex,
            tabController: _tabController,
          ),
          ActionsSolPe(
            selectedTabIndex: _selectedTabIndex,
            tabController: _tabController,
          ),
          //CAMBIOS
          // ActionsEliminados(
          //   selectedTabIndex: _selectedTabIndex,
          //   tabController: _tabController,
          // ),
          // //OFICIAL
          // ActionsOficial(
          //   selectedTabIndex: _selectedTabIndex,
          //   tabController: _tabController,
          // ),
          const Gap(10),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72.0),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  // Tab(text: 'Resumen'),
                  Tab(text: 'Ficha'),
                  Tab(text: 'Agendados'),
                  // Tab(text: 'Solicitados'),
                  // Tab(text: 'Eliminados'),
                  // Tab(text: 'Oficial'),
                  Tab(text: 'Solicitud Pedidos'),
                ],
              ),
              BlocSelector<MainBloc, MainState, bool>(
                selector: (state) => state.isLoading,
                builder: (context, state) {
                  // print('called');
                  return state
                      ? const LinearProgressIndicator()
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Contenido de la Tab 1
          // FichaResumenPage(),
          // Contenido de la Tab 2
          FichaFichaPage(),
          // Contenido de la Tab 3
          FichaPedidosPage(),
          // Contenido de la Tab 4
          // FichaSolicitadosPage(),
          // Contenido de la Tab 5
          // FichaEliminadosPage(),
          // Contenido de la Tab 6
          // FichaOficialPage(),
          // // Contenido de la Tab 7
          SolPeListPage(),
          // Center(child: Text('En Construcción')),
        ],
      ),
    );
  }
}
