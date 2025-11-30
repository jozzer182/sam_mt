import 'package:flutter/material.dart';

class SolPeConfirmacionGuardar extends StatelessWidget {
  const SolPeConfirmacionGuardar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ATENCIÓN'),
      content: Text('Esta seguro y desea continuar?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Continuar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
