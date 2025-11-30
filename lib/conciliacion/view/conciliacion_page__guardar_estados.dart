import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main_bloc.dart';
import '../model/conciliacion_enum.dart';
import '../model/conciliacion_model.dart';
import 'conciliacion_fields_v2.dart';

class ConciliacionGuardarEstado extends StatefulWidget {
  final String estadoAnterior;
  const ConciliacionGuardarEstado({required this.estadoAnterior, Key? key})
    : super(key: key);

  @override
  State<ConciliacionGuardarEstado> createState() =>
      _ConciliacionGuardarEstadoState();
}

class _ConciliacionGuardarEstadoState extends State<ConciliacionGuardarEstado> {
  bool sendEmail = true;
  @override
  Widget build(BuildContext context) {
    List<String> correos = [];
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        Conciliacion conciliacion = state.conciliacion!;
        return AlertDialog(
          title: Text('Seguro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Seguro que desea guardar?'),
              const SizedBox(height: 10),
              FieldPre(
                flex: null,
                initialValue: conciliacion.comentario,
                campo: CampoConciliacion.comentario,
                label: 'Comentario',
                color: Colors.grey,
                edit: true,
                tipoCampo: TipoCampo.texto,
              ),
              const SizedBox(height: 10),
              FieldPre(
                flex: null,
                initialValue: conciliacion.estado,
                campo: CampoConciliacion.estado,
                label: 'estado',
                color: Colors.grey,
                edit: false,
                tipoCampo: TipoCampo.texto,
              ),
              const SizedBox(height: 10),
              FieldPre(
                flex: null,
                initialValue: conciliacion.persona,
                campo: CampoConciliacion.persona,
                label: 'persona',
                color: Colors.grey,
                edit: false,
                tipoCampo: TipoCampo.texto,
              ),
              const SizedBox(height: 10),
              FieldPre(
                flex: null,
                initialValue: conciliacion.fecha,
                campo: CampoConciliacion.fecha,
                label: 'fecha',
                color: Colors.grey,
                edit: false,
                tipoCampo: TipoCampo.texto,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: sendEmail,
                    onChanged: (value) {
                      // print('value: $value');
                      // print('sendEmail: $sendEmail');
                      setState(() {
                        sendEmail = !sendEmail;
                      });
                    },
                  ),
                  const Text(
                    '¿Desea enviar una confirmación por correo electrónico?',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // obtener los correos
              if (sendEmail)
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Correos',
                    hintText: 'Ingrese los correos separados por comas',
                  ),
                  onChanged: (value) {
                    correos = value.split(',');
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context
                    .read<MainBloc>()
                    .conciliacionCtrl
                    .cambiarCampos
                    .changeConciliacion(
                      campo: CampoConciliacion.estado,
                      value: widget.estadoAnterior,
                    );
                // print('estado anterior: ${widget.estadoAnterior}');
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                //guardar la conciliacion
                context.read<MainBloc>().conciliacionCtrl.agregarConciliacion(
                  context: context,
                  sendEmail: sendEmail,
                  correos: correos,
                );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
