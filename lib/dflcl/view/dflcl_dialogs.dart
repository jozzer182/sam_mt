import 'package:flutter/material.dart';
import '../model/dflcl_model.dart';
import '../controller/dflcl_controller.dart';

class DflclDialogs {  static void showAddEditDialog({
    required BuildContext context,
    required DflclController controller,
    DflclSingle? item,
  }) {
    final bool isEditing = item != null;
    final String? dfOriginal = item?.df;

    final TextEditingController dfController = TextEditingController(text: item?.df ?? '');
    final TextEditingController lclController = TextEditingController(text: item?.lcl ?? '');
    final TextEditingController actualizadoController = TextEditingController(
      text: item?.actualizado ?? DateTime.now().toString().substring(0, 19)
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEditing ? 'Modificar Relación DF-LCL' : 'Agregar Nueva Relación DF-LCL',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dfController,
                decoration: const InputDecoration(
                  labelText: 'DF',
                  hintText: 'Ingrese el DF',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: lclController,
                decoration: const InputDecoration(
                  labelText: 'LCL',
                  hintText: 'Ingrese el LCL',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: actualizadoController,
                decoration: const InputDecoration(
                  labelText: 'Actualizado',
                  hintText: 'Fecha de actualización',
                ),
                enabled: false,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (dfController.text.isEmpty || lclController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('DF y LCL son obligatorios'),
                  ),
                );
                return;
              }

              final registro = DflclSingle(
                df: dfController.text,
                lcl: lclController.text,
                actualizado: actualizadoController.text,
              );

              bool success;
              if (isEditing) {
                success = await controller.modificarRegistro(
                  dfOriginal!,
                  registro,
                );
              } else {
                success = await controller.agregarRegistro(registro);
              }

              if (success && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(isEditing ? 'Guardar' : 'Agregar'),
          ),
        ],
      ),
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required String df,
    required DflclController controller,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Está seguro que desea eliminar el registro con DF: $df?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await controller.eliminarRegistro(df);
              if (success && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
