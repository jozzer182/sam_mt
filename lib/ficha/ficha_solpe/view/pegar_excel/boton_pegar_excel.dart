// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/main_bloc.dart';
import 'dialog_paste_excel.dart';

class SolPeBotonPegarExcel extends StatefulWidget {
  const SolPeBotonPegarExcel({
    Key? key,
  }) : super(key: key);

  @override
  State<SolPeBotonPegarExcel> createState() => _SolPeBotonPegarExcelState();
}

class _SolPeBotonPegarExcelState extends State<SolPeBotonPegarExcel> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // List<NuevoIngresoBSingle> nuevoIngresoList =
        //     state.nuevoIngresoB?.nuevoIngresoList ?? [];
        return ElevatedButton(
          child: const Text('Pegar datos de Excel'),
          onPressed: () async {
            bool seLogroPegar = await context
                .read<MainBloc>()
                .solPeDocController
                .pegar
                .seLogroPegar;
            if (!seLogroPegar) {
              showDialog(
                context: context,
                builder: (context) {
                  return const PasteExcelDialog();
                },
              );
            }
          },
        );
      },
    );
  }
}
