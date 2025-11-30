import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:v_al_sam_v02/home/home.dart';
import 'package:v_al_sam_v02/login/login.dart';
import 'package:v_al_sam_v02/config.dart';
import 'firebase_options.dart';
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/login/validate_email.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'listener_messages_errors.dart';
import 'version.dart';

void main() async {
  print(Version.data);
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno
  await AppConfig.load();
  
  await initLocalStorage();
  
  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.setLanguageCode("es");

  // Inicializar Supabase usando configuración centralizada
  await supabase.Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    debug: AppConfig.isDebug,
  );

  runApp(App());
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 10), (_) => checkStatusAccount());
    super.initState();
  }

  Future checkStatusAccount() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.reload();
    }
    setState(() {
      FirebaseAuth.instance.authStateChanges();
      // PersonData();
    });
    print('Timer called');
  }

  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) => MainBloc()..add(LoadData()),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            themeMode: ThemeMode.light,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: state.themeColor ?? Colors.deepPurple,
                brightness: state.isDark ? Brightness.dark : Brightness.light,
              ),
              // Definiendo explícitamente la correspondencia de estilos de texto para compatibilidad
              textTheme: TextTheme(
                // Los estilos antiguos y sus equivalentes modernos
                titleLarge: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ), // Antiguo headline6
                titleMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ), // Antiguo subtitle1
                titleSmall: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ), // Antiguo subtitle2
                labelLarge: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ), // Antiguo button
                labelSmall: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ), // Antiguo overline
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: state.themeColor ?? Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              // Definiendo explícitamente la correspondencia de estilos de texto para compatibilidad
              textTheme: TextTheme(
                // Los estilos antiguos y sus equivalentes modernos
                titleLarge: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ), // Antiguo headline6
                titleMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ), // Antiguo subtitle1
                titleSmall: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ), // Antiguo subtitle2
                labelLarge: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ), // Antiguo button
                labelSmall: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ), // Antiguo overline
              ),
            ),
            debugShowCheckedModeBanner: false,
            // showPerformanceOverlay : true,
            title: 'SAM+',
            home: ListenerCustom(
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      (snapshot.data!.emailVerified ||
                          FirebaseAuth.instance.currentUser?.email
                                  .toString()
                                  .toLowerCase() ==
                              'dorelly.rodriguez@inmel.co')) {
                    return
                    // EntregaSinProyectoPage();
                    // IngresosScreen();
                    HomePage();
                  } else if (snapshot.hasData) {
                    return ValidateEmail();
                  }
                  return LoginScreen();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
