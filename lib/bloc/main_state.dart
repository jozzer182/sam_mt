part of 'main_bloc.dart';

class MainState {
  bool isLoading;
  int errorCounter;
  int messageCounter;
  int dialogCounter;
  String dialogMessage;
  Color messageColor;
  String message;
  bool isDark = false;
  Color? themeColor;
  Mm60B? mm60B;
  Mb52B? mb52B;
  Mb51B? mb51B;
  RegistrosB? registrosB;
  IngresosB? ingresosB;
  PeopleModel? peopleB;
  PdisB? pdisB;
  // ProyectosB? proyectosB;
  Plataforma? plataforma;
  InventarioB? inventarioB;
  DeudaBrutaB? deudaBrutaB;
  DeudaAlmacenB? deudaAlmacenB;
  DeudaOperativaB? deudaOperativaB;
  DeudaEnelB? deudaEnelB;
  NuevoIngresoB? nuevoIngresoB;
  NuevoTrasladoB? nuevoTrasladoB;
  PlanillaB? planillaB;
  PlanillaEditB? planillaEditB;
  Saldos? saldos;
  TablaPlan? tablaPlan;
  Lcl? lcl;
  Carretes? carretes;
  Homologacion? homologacion;
  Transformadores? transformadores;
  Colas? colas;
  Rastreable? rastreable;
  Users? users;
  User? user;
  Matno? matno;
  Perfiles? perfiles;
  Conciliaciones? conciliaciones;
  Conciliacion? conciliacion;
  ChatarraList? chatarraList;
  Chatarra? chatarra;
  Mm60? mm60;
  MedidaAns? medidaAns;
  FechasFEM? fechasFEM;
  Fichas? fichas;
  String? year;
  Ficha? ficha;
  int porcentajecarga;
  Pedidos? pedidos;
  SolPeList? solPeList;
  SolPeDoc? solPeDoc;
  Aportacion? aportacion;
  Sustitutos? sustitutos;
  Dflcl? dflclB;
  DomainList? dominios;
  EntregasMcList? entregasMcList;
  MovilDepotList? movilDepotList;
  ConsumosMcList? consumosMcList;

  MainState({
    this.isLoading = false,
    this.errorCounter = 0,
    this.messageCounter = 0,
    this.dialogCounter = 0,
    this.dialogMessage = '',
    this.messageColor = Colors.red,
    this.message = '',
    this.isDark = false,
    this.themeColor,
    this.mm60B,
    this.mb52B,
    this.mb51B,
    this.registrosB,
    this.ingresosB,
    this.peopleB,
    this.pdisB,
    // this.proyectosB,
    this.plataforma,
    this.inventarioB,
    this.deudaBrutaB,
    this.deudaAlmacenB,
    this.deudaOperativaB,
    this.deudaEnelB,
    this.nuevoIngresoB,
    this.nuevoTrasladoB,
    this.planillaB,
    this.planillaEditB,
    this.saldos,
    this.tablaPlan,
    this.lcl,
    this.carretes,
    this.homologacion,
    this.transformadores,
    this.colas,
    this.rastreable,
    this.users,
    this.user,
    this.matno,
    this.perfiles,
    this.conciliaciones,
    this.conciliacion,
    this.chatarraList,
    this.chatarra,
    this.mm60,
    this.medidaAns,
    this.fechasFEM,
    this.fichas,
    this.year,
    this.ficha,
    this.porcentajecarga = 0,
    this.pedidos,
    this.solPeList,
    this.solPeDoc,
    this.aportacion,
    this.sustitutos,
    this.dflclB,
    this.dominios,
    this.entregasMcList,
    this.movilDepotList,
    this.consumosMcList,
  });

  initial() {
    isLoading = false;
    errorCounter = 0;
    messageCounter = 0;
    dialogCounter = 0;
    dialogMessage = '';
    messageColor = Colors.red;
    message = '';
    isDark = false;
    themeColor = null;
    mm60B = null;
    mb52B = null;
    mb51B = null;
    registrosB = null;
    ingresosB = null;
    peopleB = null;
    pdisB = null;
    // proyectosB = null;
    plataforma = null;
    inventarioB = null;
    deudaBrutaB = null;
    deudaAlmacenB = null;
    deudaOperativaB = null;
    deudaEnelB = null;
    nuevoIngresoB = null;
    nuevoTrasladoB = null;
    planillaB = null;
    planillaEditB = null;
    saldos = null;
    tablaPlan = null;
    lcl = null;
    carretes = null;
    homologacion = null;
    transformadores = null;
    colas = null;
    rastreable = null;
    users = null;
    user = null;
    matno = null;
    perfiles = null;
    conciliaciones = null;
    conciliacion = null;
    chatarraList = null;
    chatarra = null;
    mm60 = null;
    medidaAns = null;
    fechasFEM = null;
    fichas = null;
    year = null;
    ficha = null;
    porcentajecarga = 0;
    pedidos = null;
    solPeList = null;
    solPeDoc = null;
    aportacion = null;
    sustitutos = null;
    dflclB = null;
    dominios = null;
    entregasMcList = null;
    movilDepotList = null;
    consumosMcList = null;
  }

  MainState copyWith({
    bool? isLoading,
    int? errorCounter,
    int? messageCounter,
    int? dialogCounter,
    String? dialogMessage,
    Color? messageColor,
    String? message,
    bool? isDark,
    Color? themeColor,
    Mm60B? mm60B,
    Mb52B? mb52B,
    Mb51B? mb51B,
    RegistrosB? registrosB,
    IngresosB? ingresosB,
    PeopleModel? peopleB,
    PdisB? pdisB,
    // ProyectosB? proyectosB,
    Plataforma? plataforma,
    InventarioB? inventarioB,
    DeudaBrutaB? deudaBrutaB,
    DeudaAlmacenB? deudaAlmacenB,
    DeudaOperativaB? deudaOperativaB,
    DeudaEnelB? deudaEnelB,
    NuevoIngresoB? nuevoIngresoB,
    NuevoTrasladoB? nuevoTrasladoB,
    PlanillaB? planillaB,
    PlanillaEditB? planillaEditB,
    Saldos? saldos,
    TablaPlan? tablaPlan,
    Lcl? lcl,
    Carretes? carretes,
    Homologacion? homologacion,
    Transformadores? transformadores,
    Colas? colas,
    Rastreable? rastreable,
    Users? users,
    User? user,
    Matno? matno,
    Perfiles? perfiles,
    Conciliaciones? conciliaciones,
    Conciliacion? conciliacion,
    ChatarraList? chatarraList,
    Chatarra? chatarra,
    Mm60? mm60,
    MedidaAns? medidaAns,
    FechasFEM? fechasFEM,
    Fichas? fichas,
    String? year,
    Ficha? ficha,
    int? porcentajecarga,
    Pedidos? pedidos,
    SolPeList? solPeList,
    SolPeDoc? solPeDoc,
    Aportacion? aportacion,
    Sustitutos? sustitutos,
    Dflcl? dflcl,
    DomainList? dominios,
    EntregasMcList? entregasMcList,
    MovilDepotList? movilDepotList,
    ConsumosMcList? consumosMcList,
  }) {
    return MainState(
      isLoading: isLoading ?? this.isLoading,
      errorCounter: errorCounter ?? this.errorCounter,
      messageCounter: messageCounter ?? this.messageCounter,
      dialogCounter: dialogCounter ?? this.dialogCounter,
      dialogMessage: dialogMessage ?? this.dialogMessage,
      messageColor: messageColor ?? this.messageColor,
      message: message ?? this.message,
      isDark: isDark ?? this.isDark,
      themeColor: themeColor ?? this.themeColor,
      mm60B: mm60B ?? this.mm60B,
      mb52B: mb52B ?? this.mb52B,
      mb51B: mb51B ?? this.mb51B,
      registrosB: registrosB ?? this.registrosB,
      ingresosB: ingresosB ?? this.ingresosB,
      peopleB: peopleB ?? this.peopleB,
      pdisB: pdisB ?? this.pdisB,
      // proyectosB: proyectosB ?? this.proyectosB,
      plataforma: plataforma ?? this.plataforma,
      inventarioB: inventarioB ?? this.inventarioB,
      deudaBrutaB: deudaBrutaB ?? this.deudaBrutaB,
      deudaAlmacenB: deudaAlmacenB ?? this.deudaAlmacenB,
      deudaOperativaB: deudaOperativaB ?? this.deudaOperativaB,
      deudaEnelB: deudaEnelB ?? this.deudaEnelB,
      nuevoIngresoB: nuevoIngresoB ?? this.nuevoIngresoB,
      nuevoTrasladoB: nuevoTrasladoB ?? this.nuevoTrasladoB,
      planillaB: planillaB ?? this.planillaB,
      planillaEditB: planillaEditB ?? this.planillaEditB,
      saldos: saldos ?? this.saldos,
      tablaPlan: tablaPlan ?? this.tablaPlan,
      lcl: lcl ?? this.lcl,
      carretes: carretes ?? this.carretes,
      homologacion: homologacion ?? this.homologacion,
      transformadores: transformadores ?? this.transformadores,
      colas: colas ?? this.colas,
      rastreable: rastreable ?? this.rastreable,
      users: users ?? this.users,
      user: user ?? this.user,
      matno: matno ?? this.matno,
      perfiles: perfiles ?? this.perfiles,
      conciliaciones: conciliaciones ?? this.conciliaciones,
      conciliacion: conciliacion ?? this.conciliacion,
      chatarraList: chatarraList ?? this.chatarraList,
      chatarra: chatarra ?? this.chatarra,
      mm60: mm60 ?? this.mm60,
      medidaAns: medidaAns ?? this.medidaAns,
      fechasFEM: fechasFEM ?? this.fechasFEM,
      fichas: fichas ?? this.fichas,
      year: year ?? this.year,
      ficha: ficha ?? this.ficha,
      porcentajecarga: porcentajecarga ?? this.porcentajecarga,
      pedidos: pedidos ?? this.pedidos,
      solPeList: solPeList ?? this.solPeList,
      solPeDoc: solPeDoc ?? this.solPeDoc,
      aportacion: aportacion ?? this.aportacion,
      sustitutos: sustitutos ?? this.sustitutos,
      dflclB: dflcl ?? this.dflclB,
      dominios: dominios ?? this.dominios,
      entregasMcList: entregasMcList ?? this.entregasMcList,
      movilDepotList: movilDepotList ?? this.movilDepotList,
      consumosMcList: consumosMcList ?? this.consumosMcList,
    );
  }
}
