import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:v_al_sam_v02/bloc/main_bloc.dart';
import 'package:v_al_sam_v02/carretes/view/carretes_page.dart';
import 'package:v_al_sam_v02/deuda_almacen/view/deudaalmacen_page_reversed.dart';
import 'package:v_al_sam_v02/deuda_operativa/view/deudaoperativa_page_sort.dart';
import 'package:v_al_sam_v02/dflcl/view/dflcl_page.dart';
import 'package:v_al_sam_v02/medidaans/view/medidaans_page.dart';
import 'package:v_al_sam_v02/pdis/model/pdis_d.dart';
import 'package:v_al_sam_v02/mb52/mb52_b.dart';
import 'package:v_al_sam_v02/nuevo_ingreso/view/nuevoingreso_page.dart';
import 'package:v_al_sam_v02/ingresos/view/ingresos_page.dart';
import 'package:v_al_sam_v02/nuevo_traslado/view/nuevo_traslado_page.dart';
import 'package:v_al_sam_v02/informe_saldos/view/informe_saldos_page.dart';
import 'package:v_al_sam_v02/deuda_almacen/view/deudaalmacen_page.dart';
import 'package:v_al_sam_v02/deuda_bruta/view/deudabruta_page.dart';
import 'package:v_al_sam_v02/deuda_operativa/view/deudaoperativa_page.dart';
import 'package:v_al_sam_v02/planilla/view/planilla_page.dart';
import 'package:v_al_sam_v02/registros/view/registros_page.dart';
import 'package:v_al_sam_v02/login/auth_services.dart';
import 'package:v_al_sam_v02/resources/toCurrency.dart';
// import 'package:v_al_sam_v02/mb51/view/mb51screen.dart';
import 'package:v_al_sam_v02/user/user_model.dart';
import 'package:v_al_sam_v02/zan_por_codigo/por_codigo_page.dart';

import '../aportacion/view/aportacion_page.dart';
import '../chatarra/view/chatarra_list_page_new.dart';
import '../colas/view/colas_page.dart';
import '../conciliaciones/view/conciliaciones_page.dart';
import '../deuda_operativa/view/deudaoperativa_page_new.dart';
import '../deuda_operativa/view/deudaoperativa_page_person.dart';
// import '../dflcl/dflcl_page.dart';
import '../fechas_fem/view/fechasfem_page.dart';
import '../ficha/main/fichas/view/fichas_page.dart';
import '../homologacion/view/homologacion_page.dart';
import '../balances/view/balances_list_page.dart';
import '../inventario/view/inventario_page_new.dart';
import '../lcl/view/lcl_page_new.dart';
import '../matnocnt/view/matnocnt_new_page.dart';
import '../mb51/view/mb51_new_screen.dart';
import '../mb52/mb52screen.dart';
import '../mm60/view/mm60_new_page.dart';
import '../moecom/movil_depot/view/movil_depot_page.dart';
import '../pedidos/view/pedidos_page.dart';
import '../plataforma/view/plataforma_new_page.dart';
import '../rastreable/view/rastreable_page.dart';
import '../sustitutos/view/sustitutos_page.dart';
import '../transformadores/view/transformadores_page.dart';
import '../version.dart';

//-----------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------

const String messageVersion = 'Versión: 2.8 Se agrega listado de pedidos.';

//-----------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return CupertinoPageTransition(
        primaryRouteAnimation: CurveTween(
          curve: Curves.easeInOutCirc,
        ).animate(animation),
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false,
        child: child,
      );
    },
  );
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool loading = false;
  final uSFormat = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 0,
  );
  ScrollController _controller = new ScrollController();
  String? pdiText;

  void cambiarColor() {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: const Text('Escoge un color'),
          content: SingleChildScrollView(
            child: MaterialColorPicker(
              allowShades: false,
              onMainColorChange: (value) {
                if (value != null) {
                  BlocProvider.of<MainBloc>(
                    context,
                  ).add(ThemeColorChange(color: Color(value.value)));
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        );
      },
      context: context,
    );
  }

  @override
  void initState() {
    pdiText = context.read<MainBloc>().state.user?.pdi ?? '';
    // ignore: unused_local_variable
    String perfil = context.read<MainBloc>().state.user?.perfil ?? '';
    super.initState();
  }

  @override
  build(context) {
    if (context.read<MainBloc>().state.user == null ||
        context.read<MainBloc>().state.pdisB == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Cargando datos...'),
              SizedBox(height: 20),
              Text(
                'cargando usuario... ${context.read<MainBloc>().state.user?.correo ?? 'No cargado(aún)'}',
              ),
              SizedBox(height: 20),
              Text(
                'cargando PDIS... ${context.read<MainBloc>().state.pdisB?.pdis.length ?? 'No cargado(aún)'}',
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
    pdiText = context.read<MainBloc>().state.user?.pdi ?? '';
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Version.data, style: Theme.of(context).textTheme.labelSmall),
            Text(
              Version.status('Home', '$runtimeType'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
      appBar: AppBar(
        title: Text('SAM+'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: BlocSelector<MainBloc, MainState, bool>(
            selector: (state) => state.isLoading,
            builder: (context, state) {
              return state ? LinearProgressIndicator() : SizedBox();
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              var url = Uri.parse('https://sam2pmc--legacy-643p5ygn.web.app');
              await launchUrl(url);
            },
            child: Text('Versión\nAnterior', textAlign: TextAlign.center),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<MainBloc>().add(LoadData());
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => cambiarColor(),
            icon: const Icon(Icons.color_lens),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              BlocProvider.of<MainBloc>(context).add(ThemeChange());
            },
            icon: const Icon(Icons.brightness_4_outlined),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.question_mark),
            onPressed: () async {
              var url = Uri.parse('https://youtu.be/V1GxjbXQpm0');
              await launchUrl(url);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.account_tree),
          //   onPressed: () async {
          //     var url = Uri.parse(
          //         'https://drive.google.com/file/d/1cLfqcWlczzwn7iFf_SycGiAg1UDT_-AX/view?usp=sharing');
          //     await launchUrl(url);
          //   },
          // ),
          SizedBox(width: 10),
          SizedBox(
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  FirebaseAuth.instance.currentUser!.displayName ??
                      'Problema conexión',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  context
                      .read<MainBloc>()
                      .state
                      .pdisB!
                      .pdis
                      .firstWhere((e) => e.pdi == pdiText)
                      .pdi,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                BlocBuilder<MainBloc, MainState>(
                  builder: (context, state) {
                    List<Pdis> pdis = state.pdisB?.pdis ?? [];
                    User? user = state.user;
                    if (pdis.isEmpty) {
                      return const CircularProgressIndicator();
                    }
                    if (user!.permisos.contains("cambio_pdi")) {
                      return DropdownButtonFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: -2,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 10),
                        isDense: true,
                        value: pdiText,
                        items:
                            pdis.map((pdi) {
                              return DropdownMenuItem(
                                value: pdi.pdi,
                                child: Text(
                                  "${pdi.nombreCorto} - Z${pdi.zona}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) async {
                          context.read<MainBloc>().add(
                            Loading(isLoading: true),
                          );

                          await AuthService().updateUser(
                            value.toString(),
                            context.read<MainBloc>().state.user!,
                            pdis
                                .firstWhere((e) => e.pdi == value.toString())
                                .empresa,
                            context,
                          );
                          setState(() {
                            pdiText = value.toString();
                          });
                          context.read<MainBloc>().add(
                            Loading(isLoading: false),
                          );
                        },
                      );
                    }
                    if (user!.pdisadicionales.length > 1) {
                      return DropdownButtonFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: -2,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 10),
                        isDense: true,
                        value: pdiText,
                        items:
                            user!.pdisadicionales.map((pdi) {
                              return DropdownMenuItem(
                                value: pdi,
                                child: Text(
                                  pdi,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) async {
                          context.read<MainBloc>().add(
                            Loading(isLoading: true),
                          );

                          await AuthService().updateUser(
                            value.toString(),
                            context.read<MainBloc>().state.user!,
                            pdis
                                .firstWhere((e) => e.pdi == value.toString())
                                .empresa,
                            context,
                          );
                          setState(() {
                            pdiText = value.toString();
                          });
                          context.read<MainBloc>().add(
                            Loading(isLoading: false),
                          );
                        },
                      );
                    }
                    return Text(
                      context
                          .read<MainBloc>()
                          .state
                          .pdisB!
                          .pdis
                          .firstWhere((e) => e.pdi == pdiText)
                          .nombreCorto,
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: BlocListener<MainBloc, MainState>(
        listenWhen:
            (previous, current) =>
                previous.errorCounter != current.errorCounter,
        listener: (context, state) {
          print(state.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: state.messageColor,
              content: Text(state.message),
            ),
          );
        },
        child: BlocListener<MainBloc, MainState>(
          listenWhen:
              (previous, current) =>
                  previous.dialogCounter != current.dialogCounter,
          listener: (context, state) {
            print(state.dialogMessage);
            if (state.dialogMessage.isNotEmpty) {
              showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: Text('Atención'),
                    content: Text(state.dialogMessage),
                    actions: [
                      ElevatedButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }),
              );
            }
          },
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    User user = context.read<MainBloc>().state.user!;
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              horizontalList(),
              Text('INVENTARIO', style: Theme.of(context).textTheme.titleLarge),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  return GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    children: [
                      ElevatedButton(
                        onPressed:
                            state.nuevoIngresoB == null ||
                                    !user.permisos.contains("nuevo_ingreso")
                                ? null
                                : () => goTo(IngresosScreen()),
                        child: Text(
                          'NUEVO INGRESO',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            state.nuevoTrasladoB == null ||
                                    !user.permisos.contains("nuevo_traslado")
                                ? null
                                : () => goTo(TrasladoScreen()),
                        child: Text(
                          'NUEVO TRASLADO',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.ingresosB == null
                                ? null
                                : () => goTo(IngresosTablaScreen()),
                        child: Text(
                          'INGRESOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.inventarioB == null
                                ? null
                                : () => goTo(InventarioPageNew()),
                        child: Text(
                          'INVENTARIO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed:
                            state.saldos == null
                                ? null
                                : () => goTo(SaldosScreen()),
                        child: Text(
                          'INFORME DE SALDOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      // SizedBox(height: 10),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                'MOVIMIENTOS',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  return GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    children: [
                      ElevatedButton(
                        onPressed:
                            state.planillaB == null ||
                                    !user.permisos.contains("nueva_planilla")
                                ? null
                                : () => goTo(PlanillaPage()),
                        child: Text(
                          'NUEVA PLANILLA',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.registrosB == null
                                ? null
                                : () => goTo(RegistrosTablaScreen()),
                        child: Text(
                          'REGISTROS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            state.entregasMcList == null ||
                                    state.consumosMcList == null
                                ? null
                                : () => goTo(MovilDepotPage()),
                        child: Text(
                          'MOE-COM',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed:
                      //       // state.planillaB == null ||
                      //       //         !user.permisos.contains("nueva_planilla")
                      //       //     ?
                      //       null,
                      //   // : () => goTo(PlanillaPage())
                      //   child: Text(
                      //     'COM\n[EN DESARROLLO]',
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed:
                            state.registrosB == null ||
                                    !user.permisos.contains("crear_libretos")
                                ? null
                                : () => goTo(BalancesListPage()),
                        child: Text(
                          'BALANCES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed:
                            state.conciliaciones == null ||
                                    state.registrosB == null ||
                                    !user.permisos.contains("conciliar")
                                ? null
                                : () => goTo(ConciliacionesPage()),
                        child: Text(
                          'CONCILIACIONES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.dflclB == null
                                ? null
                                : () => goTo(DflclPage()),
                        child: Text(
                          'DFLCL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),

                      BlocBuilder<MainBloc, MainState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            onPressed:
                                state.medidaAns == null ||
                                        !user.permisos.contains("conciliar")
                                    ? null
                                    : () => goTo(MedidaAnsPage()),
                            child: Text(
                              'MEDIDA ANS [${state.medidaAns?.medidaAnsList.length ?? 0}]',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                          );
                        },
                      ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor:
                      //           Theme.of(context).colorScheme.primary),
                      //   onPressed: state.registrosB == null ||
                      //           !user.permisos.contains("aprobar_libretos")
                      //       ? null
                      //       : () => goTo(LibretosApPage()),
                      //   child: Text(
                      //     'APROBAR BALANCE',
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Text('SAP', style: Theme.of(context).textTheme.titleLarge),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  return GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.mb51B == null
                                ? null
                                : () async => goTo(MB51NewPage()),
                        child: Text(
                          'MB51',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.mb52B == null
                                ? null
                                : () async => goTo(Mb52Screen()),
                        child: Text(
                          'MB52',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.plataforma == null
                                ? null
                                : () => goTo(PlataformaNewPage()),
                        child: Text(
                          'PLATAFORMA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.lcl == null ? null : () => goTo(LCLPageN()),
                        child: Text(
                          'LCL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.matno == null
                                ? null
                                : () => goTo(MatnoNewPage()),
                        child: Text(
                          'NO CONTABILIZADO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.mm60 == null
                                ? null
                                : () => goTo(Mm60NewPage()),
                        child: Text(
                          'MM60',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                'PLANIFICACIÓN',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  int porcentaje = state.porcentajecarga;
                  String cargaFichas2 =
                      porcentaje == 100 ? '' : '($porcentaje%)';
                  return GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed:
                            state.fichas == null
                                ? null
                                : () {
                                  goTo(FichasPage());
                                },
                        // onPressed: null,
                        child: Text(
                          'FICHAS $cargaFichas2',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            // null
                            state.pedidos == null
                                ? null
                                : () => goTo(PedidosPage()),
                        child: Text(
                          'PEDIDOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            // null
                            state.fechasFEM == null
                                ? null
                                : () {
                                  goTo(FechasFEMPage());
                                },
                        child: Text(
                          'FECHAS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            // null
                            state.aportacion == null
                                ? null
                                : () {
                                  goTo(AportacionPage());
                                },
                        child: Text(
                          'APORTACIÓN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            // null
                            state.sustitutos == null
                                ? null
                                : () {
                                  goTo(SustitutosPage());
                                },
                        child: Text(
                          'SUSTITUTOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Text('ANÁLISIS', style: Theme.of(context).textTheme.titleLarge),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  return GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.mb51B == null
                                ? null
                                : () => goTo(PorCodigoPage()),
                        child: Text(
                          'POR CÓDIGO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                'LOGÍSTICA INVERSA',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  return GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    children: [
                      ElevatedButton(
                        onPressed:
                            state.chatarraList == null
                                ? null
                                : () => goTo(ChatarraListPageNew()),
                        child: const Text(
                          'CHATARRA',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed: () async {
                          var url = Uri.parse(
                            'https://docs.google.com/presentation/d/e/2PACX-1vSZmN7mU6UXb_fG_Bm1SANHexp94FsgOmoaARw97176t1n_xGsjp2hvo3EzKnN-hqHEQeSYdsC9pkHw/pub?start=true&loop=true&delayms=3000',
                          );
                          await launchUrl(url);
                        },
                        child: Text(
                          'INFORMACIÓN GENERAL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.homologacion == null
                                ? null
                                : () => goTo(HomologacionPage()),
                        child: Text(
                          'HOMOLOGACIÓN V21',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.carretes == null
                                ? null
                                : () => goTo(CarretesPage()),
                        child: Text(
                          'CARRETES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.transformadores == null
                                ? null
                                : () => goTo(TransformadoresPage()),
                        child: Text(
                          'TRANSFORMADORES',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.colas == null
                                ? null
                                : () => goTo(ColasPage()),
                        child: Text(
                          'COLAS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed:
                            state.rastreable == null
                                ? null
                                : () => goTo(RastreablePage()),
                        child: Text(
                          'RASTREABLE (BARCODE)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed: () async {
                          var url = Uri.parse(
                            'https://docs.google.com/spreadsheets/d/1i9wK6y81b85uHiMh5QH8ecSUqmYgNhdC/edit?usp=sharing&ouid=103142850021255685873&rtpof=true&sd=true',
                          );
                          await launchUrl(url);
                        },
                        child: Text(
                          'FORMATO BARCODE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed: () async {
                          var url = Uri.parse(
                            'https://docs.google.com/spreadsheets/d/1DBORDUW3zJR15fLwWBUkHKKyseRPbOHX/edit?usp=sharing&ouid=103142850021255685873&rtpof=true&sd=true',
                          );
                          await launchUrl(url);
                        },
                        child: Text(
                          'FORMATO REINTEGRO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed: () async {
                          var url = Uri.parse(
                            'https://docs.google.com/spreadsheets/d/1Rqus0DQul_WNV2hR8luL00zAEvjgP0EH/edit?usp=sharing&ouid=103142850021255685873&rtpof=true&sd=true',
                          );
                          await launchUrl(url);
                        },
                        child: Text(
                          'FORMATO OBSOLESCENCIA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container horizontalList() {
    return Container(
      height: 110.0,
      // margin: EdgeInsets.all(10.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        children: [
          BlocSelector<MainBloc, MainState, Mb52B?>(
            selector: (state) => state.mb52B,
            builder: (context, state) {
              if (state != null) {
                return cardSAP(snapshot: state.totalValor);
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
          Column(
            children: [
              SizedBox(
                height: 55,
                child: BlocBuilder<MainBloc, MainState>(
                  builder: (context, state) {
                    if (state.mb52B != null && state.deudaBrutaB != null) {
                      return chartDeuda(
                        snapshot: [
                          state.deudaBrutaB!.totalValor,
                          state.mb52B!.totalValor,
                          state.deudaBrutaB!.totalValor,
                        ],
                        title: 'Deuda Bruta',
                        page: DeudaBrutaScreen(),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state.mb52B != null &&
                      state.deudaAlmacenB != null &&
                      state.deudaBrutaB != null) {
                    return chartDeuda(
                      snapshot: [
                        state.deudaAlmacenB!.totalFaltantes,
                        state.mb52B!.totalValor,
                        state.deudaBrutaB!.totalValor,
                      ],
                      title: 'Deuda Almacén',
                      page: DeudaAlmacenScreen(),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state.mb52B != null &&
                      state.deudaAlmacenB != null &&
                      state.deudaBrutaB != null) {
                    return chartDeuda(
                      snapshot: [
                        state.deudaAlmacenB!.totalSobrantes,
                        state.mb52B!.totalValor,
                        state.deudaBrutaB!.totalValor,
                      ],
                      title: 'Sobrantes Almacén',
                      page: DeudaAlmacenRevScreen(),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
          Column(
            children: [
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state.mb52B != null &&
                      state.deudaOperativaB != null &&
                      state.deudaBrutaB != null) {
                    return chartDeuda(
                      snapshot: [
                        state.deudaOperativaB!.totalFaltantes,
                        state.mb52B!.totalValor,
                        state.deudaBrutaB!.totalValor,
                      ],
                      title: 'Deuda Operativa',
                      page: DeudaOperativaPageNew(),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state.mb52B != null &&
                      state.deudaOperativaB != null &&
                      state.deudaBrutaB != null) {
                    return chartDeuda(
                      snapshot: [
                        state.deudaOperativaB!.totalSobrantes,
                        state.mb52B!.totalValor,
                        state.deudaBrutaB!.totalValor,
                      ],
                      title: 'Sobrantes Operativos',
                      page: DeudaOperativaScreenOrder(),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
          // Column(
          //   children: [
          //     SizedBox(
          //       height: 55,
          //       child: BlocBuilder<MainBloc, MainState>(
          //         builder: (context, state) {
          //           if (state.mb52B != null &&
          //               state.deudaEnelB != null &&
          //               state.deudaBrutaB != null) {
          //             return chartDeuda(
          //               snapshot: [
          //                 state.deudaEnelB!.totalValor,
          //                 state.mb52B!.totalValor,
          //                 state.deudaBrutaB!.totalValor,
          //               ],
          //               title: 'Deuda Enel [DESAROLLO]',
          //               page: DeudaOperativaPersonPage(),
          //             );
          //           }
          //           return Center(child: CircularProgressIndicator());
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget cardSAP({required int snapshot}) {
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    return SizedBox(
      width: 250,
      height: 54,
      child: InkWell(
        onTap: () {
          goTo(Mb52Screen());
        },
        child: Card(
          color: Theme.of(context).colorScheme.onPrimary,
          elevation: 4.0,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Tooltip(
                message: '${uSFormat.format(snapshot)}',
                child: Text(
                  'SAP: ${enMillon1(snapshot)} MCOP',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chartDeuda({
    required List<int> snapshot,
    required String title,
    required page,
  }) {
    double rate = (snapshot[0] / snapshot[1]);
    double rate2 = (snapshot[0] / snapshot[2]);
    String percent = '${(rate * 100).toStringAsFixed(0)}%';
    String percent2 = '${(rate2 * 100).toStringAsFixed(0)}%';
    void goTo(Widget page) {
      Navigator.push(context, _createRoute(page));
    }

    return InkWell(
      onTap: () {
        goTo(page);
      },
      child: Ink(
        child: SizedBox(
          width: 250,
          child: Center(
            child: Tooltip(
              message: '${toCurrencyCOP(snapshot[0].toString())}',
              child: Card(
                color: Theme.of(context).colorScheme.onPrimary,
                elevation: 4.0,
                child: chartLine(
                  title: title,
                  rate: rate,
                  rate2: rate2,
                  number: '${enMillon1(snapshot[0])}MCOP ($percent)',
                  number2: '$percent2',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chartLine({
    required String title,
    required double rate,
    required double rate2,
    String? number,
    String? number2,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lineWidget = (constraints.maxWidth * rate).abs();
        final lineWidget2 = (constraints.maxWidth * rate2).abs();
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12,
                        ),
                      ),
                      if (number != null)
                        Text(
                          number,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 9,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                height: 10,
                width: lineWidget,
              ),
              Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                height: 10,
                width: lineWidget2,
                child: Center(
                  child: Text(
                    number2 ?? '',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
