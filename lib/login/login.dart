import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/login/password_reset.dart';
import 'package:v_al_sam_v02/theme_compat.dart';
import '../version.dart';
import 'auth_services.dart';
// import 'package:get/get.dart';
import 'register_other_screen.dart';
import 'register_screen.dart';
// import 'home_screen.dart';

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return CupertinoPageTransition(
        primaryRouteAnimation:
            CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false,
        child: child,
      );
    },
  );
}

class LoginScreen extends StatefulWidget {
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthService authService = AuthService();
  bool loading = false;
  @override
  Widget build(context) {
    return Scaffold(
      persistentFooterButtons: [
        InkWell(
          // onTap: () async {
          //   var url = Uri.parse('https://www.youtube.com/watch?v=tcwUR55QYvI');
          //   await launchUrl(url);
          // },
          child: Text(
            Version.data,
            style: Theme.of(context).textTheme.overline,
          ),
        )
      ],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ColumnData(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> ColumnData() {
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    return [
      ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(colors: [
          Color.fromARGB(255, 245, 66, 221),
          Colors.blue.shade900,
          Color.fromARGB(255, 100, 0, 131),
        ]).createShader(bounds
            // Rect.fromLTRB(0, 0, bounds.width, bounds.height),
            ),
        child: Column(
          children: [
            Image.asset(
              'images/pole2.png',
              height: 150,
            ),
            // Text('SAM', style: const TextStyle(fontSize: 40)),
          ],
        ),
      ),
      ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(colors: [
          Color.fromARGB(255, 245, 66, 221),
          Colors.blue.shade900,
          Color.fromARGB(255, 100, 0, 131),
        ]).createShader(bounds
            // Rect.fromLTRB(0, 0, bounds.width, bounds.height),
            ),
        child: Column(
          children: [
            // Image.asset(
            //   'images/truck.png',
            //   height: 150,
            // ),
            Text('SAM+', style: const TextStyle(fontSize: 40)),
          ],
        ),
      ),
      SizedBox(height: 20.0),
      TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          labelText: 'Correo',
          border: OutlineInputBorder(),
          errorText: authService.errorCall,
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
      SizedBox(height: 30.0),
      TextButton(
        child: Text('Olvidé la contraseña'),
        onPressed: () => goTo(passwordResetScreen()),
      ),
      SizedBox(height: 10.0),
      TextButton(
        child: Text('Registro Usuarios Enel'),
        onPressed: () => goTo(RegisterScreen()),
      ),
      SizedBox(height: 10.0),
      TextButton(
        child: Text('Registro Usuarios EECC'),
        onPressed: () => goTo(RegisterOthers()),
      ),
    ];
  }

  Widget ButtonLoginLoading() {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return ElevatedButton(
        child: Text('Iniciar Sesión'),
        onPressed: () async {
          setState(() {
            loading = true;
          });
          if (emailController.text == "" || passwordController.text == "") {
            // Get.snackbar('Atención', 'Se requiere correo y contraseña');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Se requiere correo y contraseña'),
              backgroundColor: Colors.orange,
            ));
          } else {
            User? result = await authService.login(
                emailController.text, passwordController.text, context);
            if (result != null) {
              context.read<MainBloc>().add(LoadData());
              // print('Succes for email ${result.email}');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Se han ingresado correctamente'),
                backgroundColor: Colors.green,
              ));
            }
          }
          setState(() {
            loading = false;
          });
        },
      );
    }
  }
}
