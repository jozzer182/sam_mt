import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';

import '../pdis/model/pdis_d.dart';
import '../dominios/model/dominios_model.dart';
import 'auth_services.dart';
// import 'home_screen.dart';

class RegisterOthers extends StatefulWidget {
  RegisterOthersState createState() => RegisterOthersState();
}

class RegisterOthersState extends State<RegisterOthers> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController pdiController = TextEditingController();
  String? empresaSeleccionada;
  // Future<List<Pdis>?>? futurePdi;
  // Future<List<Domain>>? futureDomain;
  @override
  void initState() {
    context.read<MainBloc>().pdisCtrl.obtener;
    context.read<MainBloc>().dominiosCtrl.obtener;

    // futureDomain = ApiCall().getDomains(context: context);
    super.initState();
  }

  AuthService authService = AuthService();
  bool loading = false;
  String? errorMail;
  String? selectedItem = 'Item 1';
  String? selectedItemPerfil = 'almacen';

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro EECC')),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state.pdisB == null || state.dominios == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                width: 500,
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ColumnData(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //Cuerpo del formulario
  List<Widget> ColumnData() {
    return [
      Text(
        'Favor indique su correo corporativo y una contraseña para acceder al aplicativo.',
        maxLines: 5,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 30.0),
      TextFormField(
        controller: nameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Por favor ingrese un nombre y apellido';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Nombre - Apellido',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
      ),
      SizedBox(height: 30.0),
      TextFormField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: telController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          labelText: 'Telefono',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
        validator: (value) {
          if (value != null && value.length < 10) {
            return 'Por favor ingrese un número válido (10 números)';
          } else {
            return null;
          }
        },
      ),
      SizedBox(height: 30.0),
      DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_person),
          labelText: 'Perfil',
          border: OutlineInputBorder(),
          errorMaxLines: 2,
        ),
        items: [
          DropdownMenuItem(child: Text('Almacén'), value: 'almacen'),
          DropdownMenuItem(child: Text('Operación'), value: 'operacion'),
          DropdownMenuItem(child: Text('Supervisores'), value: 'funcional'),
        ],
        value: selectedItemPerfil,
        onChanged: (String? value) {
          setState(() {
            selectedItemPerfil = value;
          });
        },
      ),
      SizedBox(height: 30.0),
      desplegable(),
      SizedBox(height: 30.0),
      TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'Correo',
          border: OutlineInputBorder(),
          errorText: authService.errorCall ?? errorMail,
          errorMaxLines: 2,
        ),
      ),
      SizedBox(height: 30.0),
      TextField(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        controller: passwordController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Contraseña',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 30.0),
      ButtonLoginLoading(),
    ];
  }

  //Contruimos el future builder para traer los datos de PDI y nombre
  desplegable() {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.pdisB == null) {
          return CircularProgressIndicator();
        }
        final snapshot = state.pdisB!.pdis;
        selectedItem = snapshot[0].empresa;
        return Column(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.factory),
                labelText: 'Empresa',
                border: OutlineInputBorder(),
                errorMaxLines: 2,
              ),
              items: items_dropdown(lista: snapshot),
              value: selectedItem,
              onChanged: (String? value) {
                setState(() {
                  selectedItem = value;
                  empresaSeleccionada = value;
                  final index = snapshot.indexWhere(
                    (element) => element.empresa == value,
                  );
                  // print(index);
                  // print(snapshot.data![index].pdi);
                  pdiController.text = snapshot[index].pdi;
                });
              },
            ),
            SizedBox(height: 30.0),
            TextField(
              enabled: false,
              controller: pdiController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.co_present_outlined),
                labelText: 'PDI',
                border: OutlineInputBorder(),
                errorMaxLines: 2,
              ),
            ),
          ],
        );
      },
    );
  }

  //Elementos de la lista desplegable, los dejo aparte por usar un MAP().tolist, se me hace mas organizado asi
  List<DropdownMenuItem<String>>? items_dropdown({List<Pdis>? lista}) {
    return lista!.map((e) {
      return DropdownMenuItem<String>(
        alignment: AlignmentDirectional.center,
        value: e.empresa,
        child: Container(width: 200, child: Text(e.empresa)),
      );
    }).toList();
  }

  //Toda la funcion del boton de loading, en donde reviso que todo este acorde.
  Widget ButtonLoginLoading() {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return ElevatedButton(
        child: Text('Registrarse'),
        onPressed: () async {
          errorMail = null;
          setState(() {
            loading = true;
          });

          List<Domain> dominios =
              context.read<MainBloc>().state.dominios?.list ?? [];
          bool estaEnDominio = dominios.any(
            (reg) => emailController.text.toLowerCase().contains(
              reg.domain.toLowerCase(),
            ),
          );
          // print('este Correo: ${emailController.text}');
          // print('esta en dominio: $estaEnDominio');
          // print('Dominios: ${dominios.map((e) => e.domain).toList()}');

          if (emailController.text == "" ||
              passwordController.text == "" ||
              nameController.text == "" ||
              telController.text == "") {
            errorMail = 'Se requieren los datos completos';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Por favor revise los campos, se requieren todos diligenciados',
                ),
                backgroundColor: Colors.red,
              ),
            );
            // Get.snackbar('Atención', 'Se requieren los datos completos');
            // } else if (!emailController.text.contains('@enel')) {
            //   errorMail =
            //       'Este registro es válido solo para usuarios con correo @enel.com';
          } else if (estaEnDominio) {
            // print('si esta contenido');
            User? result = await authService.register(
              email: emailController.text,
              password: passwordController.text,
              nombre: nameController.text,
              telefono: telController.text,
              empresa: empresaSeleccionada ?? '',
              pdi: pdiController.text,
              perfil: selectedItemPerfil ?? '',
              context: context,
            );
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Se registro correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
              // print('Succes for email ${result.email}');
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'El dominio del correo no se encuentra autorizado, comuniquese con su gestor de materiales para mas información',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() {
            loading = false;
          });
        },
      );
    }
  }
}
