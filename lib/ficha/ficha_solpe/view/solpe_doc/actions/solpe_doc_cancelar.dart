import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';

class SolPeDocCancelarButton extends StatefulWidget {
  const SolPeDocCancelarButton({Key? key}) : super(key: key);

  @override
  State<SolPeDocCancelarButton> createState() => _SolPeDocCancelarButtonState();
}

class _SolPeDocCancelarButtonState extends State<SolPeDocCancelarButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            context.read<MainBloc>().solPeDocController.editChanger;
            context.read<MainBloc>().solPeDocController.revertSecure;
          },
          child: const Text('Cancelar'),
        );
      },
    );
  }
}
