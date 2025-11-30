// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';
import '../dialogs/solpe_doc_destinatarios.dart';
import '../dialogs/solpe_doc_confirmacion.dart';
import '../dialogs/solpe_doc_validacion.dart';

class SolpeDocGuardar extends StatefulWidget {
  const SolpeDocGuardar({Key? key}) : super(key: key);

  @override
  State<SolpeDocGuardar> createState() => _SolpeDocGuardarState();
}

class _SolpeDocGuardarState extends State<SolpeDocGuardar> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String errores =
            context.read<MainBloc>().solPeDocController.list.validar;
        if (errores.isNotEmpty) {
          await showDialog(
              context: context,
              builder: (context) {
                return SolPeDocValidacionDialog(
                  validacion: errores,
                );
              });
          return;
        }
        //Mensaje emergente de confirmacion
        bool? deseaContinuar = await showDialog<bool>(
          context: context,
          builder: (context) {
            return SolPeConfirmacionGuardar();
          },
        );

        if (deseaContinuar == null || !deseaContinuar) {
          return;
        }

        //Destinatarios
        deseaContinuar = await showDialog<bool>(
          context: context,
          builder: (context) {
            return EmailDestinatarios();
          },
        );
        if (deseaContinuar == null || !deseaContinuar) {
          return;
        }

        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        context.read<MainBloc>().solPeDocController.enviar("Solicitado");
      },
      child: const Text('Guardar'),
    );
  }
}
