import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main_bloc.dart';
import '../controller/dflcl_controller.dart';
import '../model/dflcl_model.dart';
import 'dflcl_dialogs.dart';

class DflclPage extends StatefulWidget {
  const DflclPage({super.key});

  @override
  State<DflclPage> createState() => _DflclPageState();
}

class _DflclPageState extends State<DflclPage> {  late DflclController controller;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = context.read<MainBloc>().dflclController;
    // _fetchData();
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await controller.obtener;
    setState(() {
      _isLoading = false;
    });
  }  void _showAddEditDialog({DflclSingle? item}) {
    DflclDialogs.showAddEditDialog(
      context: context,
      controller: controller,
      item: item,
    );
  }
  void _showDeleteConfirmation(String df) {
    DflclDialogs.showDeleteConfirmation(
      context: context,
      df: df,
      controller: controller,
    );
  }  void _importCSV() {
    controller.handleCSVImport(context, (isLoading) {
      setState(() {
        _isLoading = isLoading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final dflclData = state.dflclB;
        final displayData = dflclData?.list ?? [];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gestión de DF-LCL'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchData,
                tooltip: 'Recargar datos',
              ),
              IconButton(
                icon: const Icon(Icons.upload_file),
                onPressed: _importCSV,
                tooltip: 'Importar CSV',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEditDialog(),
            child: const Icon(Icons.add),
            tooltip: 'Agregar nuevo registro',
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Buscar',
                    hintText: 'Buscar por DF o LCL',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        // _search('');
                      },
                    ),
                  ),
                  // onChanged: _search,
                ),
              ),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : dflclData == null || displayData.isEmpty
                        ? const Center(
                          child: Text(
                            'No hay datos disponibles.\nPuede agregar nuevos registros o importar desde CSV.',
                            textAlign: TextAlign.center,
                          ),
                        )
                        : ListView.builder(
                          itemCount: displayData.length,
                          itemBuilder: (context, index) {
                            final item = displayData[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      const TextSpan(
                                        text: 'DF: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: item.df),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const TextSpan(
                                            text: 'LCL: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: item.lcl),
                                        ],
                                      ),
                                    ),
                                    Text('Actualizado: ${item.actualizado}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed:
                                          () => _showAddEditDialog(item: item),
                                      tooltip: 'Editar',
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () =>
                                              _showDeleteConfirmation(item.df),
                                      tooltip: 'Eliminar',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
