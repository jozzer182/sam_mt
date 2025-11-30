import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../bloc/main_bloc.dart';
import '../controller/sustitutos_ctrl.dart';
import '../model/sustitutos_model.dart';

class SustitutosDialog extends StatelessWidget {
  final SustitutosSingle? sustituto;
  final bool esEdicion;

  // Constructor para crear un nuevo sustituto o editar uno existente
  const SustitutosDialog({
    Key? key,
    this.sustituto,
    this.esEdicion = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos de texto
    final TextEditingController e4eVController = TextEditingController(
        text: esEdicion ? sustituto?.e4eV : '');
    final TextEditingController descripcionVController = TextEditingController(
        text: esEdicion ? sustituto?.descripcionV : '');
    final TextEditingController e4eNController = TextEditingController(
        text: esEdicion ? sustituto?.e4eN : '');
    final TextEditingController descripcionNController = TextEditingController(
        text: esEdicion ? sustituto?.descripcionN : '');

    // Keys para el formulario y los campos
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Text(esEdicion ? 'Editar Sustituto' : 'Agregar Nuevo Sustituto'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: e4eVController,
                decoration: const InputDecoration(
                  labelText: 'Código Viejo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el código viejo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descripcionVController,
                decoration: const InputDecoration(
                  labelText: 'Descripción Código Viejo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: e4eNController,
                decoration: const InputDecoration(
                  labelText: 'Código Nuevo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el código nuevo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descripcionNController,
                decoration: const InputDecoration(
                  labelText: 'Descripción Código Nuevo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Validar el formulario
            if (formKey.currentState!.validate()) {
              // Crear un objeto con los datos
              final SustitutosSingle nuevoSustituto = SustitutosSingle(
                e4eV: e4eVController.text.trim(),
                descripcionV: descripcionVController.text.trim(),
                e4eN: e4eNController.text.trim(),
                descripcionN: descripcionNController.text.trim(),
              );

              // Obtener el controlador y realizar la acción correspondiente
              final controlador = SustitutosController(BlocProvider.of<MainBloc>(context).bl);
              
              if (esEdicion) {
                // Actualizar sustituto existente
                controlador.actualizarSustituto(sustituto!, nuevoSustituto);
              } else {
                // Agregar nuevo sustituto
                controlador.agregarSustituto(nuevoSustituto);
              }
              
              Navigator.of(context).pop();
            }
          },
          child: Text(esEdicion ? 'Actualizar' : 'Guardar'),
        ),
      ],
    );
  }
}