import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ValidateEmail extends StatefulWidget {
  ValidateEmail({Key? key}) : super(key: key);

  @override
  State<ValidateEmail> createState() => _ValidateEmailState();
}

class _ValidateEmailState extends State<ValidateEmail> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validar Email'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '''Se le enviará un correo para comprobar que la dirección "${FirebaseAuth.instance.currentUser!.email}" ingresada es la correcta. Por favor revise su bandeja de entrada y de click en el enlace enviado.''',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text('Enviar Email de verificacion'),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await FirebaseAuth.instance.currentUser!
                          .sendEmailVerification()
                          .onError((error, stackTrace) {
                        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                error.toString()),
                            backgroundColor: Colors.red));
                      }).whenComplete(
                        () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Se ha enviado el correo correctamente, por favor revise en su bandeja de SPAM'),
                            backgroundColor: Colors.green)),
                      );
                      await Timer(Duration(seconds: 60), () {
                        setState(() {
                          loading = false;
                        });
                      });
                    }),
          ],
        ),
      ),
    );
  }
}
