import 'package:flutter/material.dart';


class FieldDate extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final int? flex;
  final String initialValue;
  // final CampoFicha campo;
  final String label;
  final Color color;
  final Color colorfondo;
  final int item;
  final bool edit;
  final bool tachado;
  FieldDate({
    required this.flex,
    required this.initialValue,
    // required this.campo,
    required this.label,
    required this.color,
    this.colorfondo = Colors.transparent,
    this.tachado = false,
    this.edit = false,
    this.item = -1,
    key,
  });

  @override
  Widget build(BuildContext context) {
    if (!edit) {
      controller.text = initialValue;
      if (flex == null) {
        return SizedBox(
          height: 40,
          child: readField(),
        );
      }
      return Expanded(
        flex: flex!,
        child: readField(),
      );
    }

    controller.text = initialValue;
    if (flex == null) {
      return SizedBox(
        height: 40,
        child: _intField(context),
      );
    }
    return Expanded(
      flex: flex!,
      child: _intField(context),
    );
  }

  TextField _intField(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: controller,
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2030),
        );
        if (newDate != null) {
          // context.read<MainBloc>().fichasController().onCambiarFicha(
          //       campo: campo,
          //       item: item,
          //       valor:
          //           '${newDate.year}/${newDate.month.toString().padLeft(2, '0')}/${newDate.day.toString().padLeft(2, '0')}',
          //     );
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
        ),
      ),
    );
  }

    TextField readField() {
    return TextField(
        textAlign: TextAlign.center,
        controller: controller,
        onChanged: (value) {
          controller.text = initialValue;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: colorfondo,
          contentPadding: const EdgeInsets.all(8.0),
          labelText: label,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
        ),
        style: TextStyle(
          fontSize: 12,
          decoration: tachado ? TextDecoration.lineThrough : null,
        ));
  }

}
