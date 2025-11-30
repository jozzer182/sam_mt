import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Version {
  static String data = 'Versión: 21.8 Corrección de consumos repetidos/anulados, Se cambia BD de carga_mc planillas_mc, MB51, MB52, MATNOCNT, sustitutos';
  static String status(String page, String clase) {
    clase = clase.substring(clase.indexOf(":") + 1, clase.length);
    return "Conectado como: ${FirebaseAuth.instance.currentUser?.email ?? "Error"}, Fecha y hora: ${DateTime.now().toString().substring(0, 16)}, Página actual: $page($clase)";
  }

  // static String get user => FirebaseAuth.instance.currentUser?.email ?? "Error";

  Route createRoute(Widget page) {
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
}

//initialization
Version version = Version();
