import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main_bloc.dart';
import '../model/conciliacion_enum.dart';
import '../model/conciliacion_model.dart';

class DialogSeleccionarCampos extends StatelessWidget {
  const DialogSeleccionarCampos({
    Key? key,
    // required this.listaCampos,
  }) : super(key: key);

  // final List<CampoConciliacion> listaCampos;

  @override
  Widget build(BuildContext context) {
    List<CampoConciliacion> listaCampos = [
      CampoConciliacion.balanceestado,
      CampoConciliacion.planillatrabajoestado,
      CampoConciliacion.descargosestado,
      CampoConciliacion.docseguridadestado,
      CampoConciliacion.medidapatestado,
      CampoConciliacion.formatoarrimeestado,
      CampoConciliacion.planoestado,
      CampoConciliacion.docsalmacenestado,
      CampoConciliacion.regfotograficoestado,
      CampoConciliacion.cortesobraestado,
      CampoConciliacion.pruebasconcretoestado,
      CampoConciliacion.varios1estado,
      CampoConciliacion.varios2estado,
      CampoConciliacion.varios3estado,
    ];

    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        Conciliacion conciliacion = state.conciliacion!;
        return AlertDialog(
          title: const Text('Seleccionar Campos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (CampoConciliacion campo in listaCampos)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(campo.name.substring(0, campo.name.length - 6)),
                    Checkbox(
                      value: conciliacion.getCampo(campo) == '' ? false : true,
                      onChanged: (value) {
                        // print(value.toString());
                        context
                            .read<MainBloc>()
                            .conciliacionCtrl
                            .cambiarCampos.changeConciliacion(
                              campo: campo,
                              value: value ?? true ? 'false' : '',
                            );
                      },
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
