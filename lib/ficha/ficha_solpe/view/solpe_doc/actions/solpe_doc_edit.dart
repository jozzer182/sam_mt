import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/main_bloc.dart';

class SolPeDocEditButton extends StatefulWidget {
  const SolPeDocEditButton({Key? key}) : super(key: key);

  @override
  State<SolPeDocEditButton> createState() => _SolPeDocEditButtonState();
}

class _SolPeDocEditButtonState extends State<SolPeDocEditButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            context.read<MainBloc>().solPeDocController.editChanger;
            context.read<MainBloc>().solPeDocController.setSecure;
          },
          child: const Text('Editar'),
        );
      },
    );
  }
}
