import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';
import '../dialogs/solpe_doc_confirmacion.dart';

class SolPeDocAnularButton extends StatefulWidget {
  const SolPeDocAnularButton({Key? key}) : super(key: key);

  @override
  State<SolPeDocAnularButton> createState() => _SolPeDocAnularButtonState();
}

class _SolPeDocAnularButtonState extends State<SolPeDocAnularButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () async {
            bool? deseaContinuar = await showDialog<bool>(
              context: context,
              builder: (context) {
                return SolPeConfirmacionGuardar();
              },
            );
            if (deseaContinuar == null || !deseaContinuar) {
              return;
            }
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            context.read<MainBloc>().solPeDocController.enviar("Anulado");
          },
          child: const Text('Anular'),
        );
      },
    );
  }
}
