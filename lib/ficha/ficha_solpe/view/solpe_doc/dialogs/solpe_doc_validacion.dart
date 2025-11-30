import 'package:flutter/material.dart';

class SolPeDocValidacionDialog extends StatelessWidget {
  const SolPeDocValidacionDialog({Key? key, 
    required this.validacion,
  }) : super(key: key);

  final String validacion;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Falta información'),
      content: Text(validacion),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}