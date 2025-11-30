import 'package:flutter/material.dart';
import 'auth_services.dart';
// import 'home_screen.dart';

class passwordResetScreen extends StatefulWidget {
  passwordResetScreenState createState() => passwordResetScreenState();
}

class passwordResetScreenState extends State<passwordResetScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthService authService = AuthService();
  bool loading = false;
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Contraseña')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ColumnData(),
          ),
        ),
      ),
    );
  }

  List<Widget> ColumnData() {
    return [
      Text(
        'Se enviará un correo para el cambio de la contraseña, solo a usuarios registrados.',
        maxLines: 3,
      ),
      SizedBox(height: 30.0),
      TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'Correo',
          border: OutlineInputBorder(),
          errorText: authService.errorPassworReset,
          errorMaxLines: 4,
        ),
      ),
      SizedBox(height: 30.0),
      loading
          ? CircularProgressIndicator()
          : ElevatedButton(
              child: Text('Enviar correo'),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                if (emailController.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Favor ingresar un correo electrónico'),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  await authService.passwordReset(email: emailController.text, context: context);
                  if (authService.errorPassworReset == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Correcto. Ciere sesión e inicie nuevamente con su correo y contraseña'),
                      backgroundColor: Colors.green,
                    ));
                  }
                }
                setState(() {
                  loading = false;
                });
              },
            ),
    ];
  }
}
