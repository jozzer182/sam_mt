import 'package:flutter/material.dart';


class FieldSwitch extends StatelessWidget {
  final String label;
  final String initialValue;
  // final CampoFicha campo;
  final bool edit;
  final int? flex;
  final int item;
  const FieldSwitch({
    required this.flex,
    required this.edit,
    // required this.campo,
    required this.initialValue,
    required this.label,
    this.item = -1,
    key,
  });

  @override
  Widget build(BuildContext context) {
    bool value = initialValue == "true" ? true : false;
    if (flex == null) {
      return SizedBox(
        height: 40,
        child: _intField(value, context),
      );
    }
    return Expanded(
      flex: flex!,
      child: _intField(value, context),
    );
  }

  Row _intField(bool value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          value: value,
          onChanged: !edit
              ? null
              : (valor) {
                  // print(valor.toString());
                  // context.read<MainBloc>().fichasController().onCambiarFicha(
                  //       item: item,
                  //       campo: campo,
                  //       valor: valor.toString(),
                  //     );
                },
        ),
      ],
    );
  }
}
