// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:v_al_sam_v02/conciliacion/model/conciliacion_enum.dart';


class Conciliacion {
  String id;
  String lcl;
  String conciliacion;
  String nodo;
  String estado;
  String numero;
  String comentario;
  String fecha;
  String persona;
  String lm;
  String lmfecha;
  String personaenel;
  String personacontrato;
  String balance;
  String balancesam;
  String planillatrabajo;
  String descargos;
  String docseguridad;
  String medidapat;
  String formatoarrime;
  String plano;
  String docsalmacen;
  String regfotografico;
  String cortesobra;
  String pruebasconcreto;
  String varios1;
  String varios2;
  String varios3;
  String balanceestado;
  String planillatrabajoestado;
  String descargosestado;
  String docseguridadestado;
  String medidapatestado;
  String formatoarrimeestado;
  String planoestado;
  String docsalmacenestado;
  String regfotograficoestado;
  String cortesobraestado;
  String pruebasconcretoestado;
  String varios1estado;
  String varios2estado;
  String varios3estado;
  String planillafirmada;
  String planillafirmadaestado;
  bool esPrimeravez = false;
  String proyecto;
  Conciliacion({
    required this.id,
    required this.lcl,
    required this.conciliacion,
    required this.nodo,
    required this.estado,
    required this.numero,
    required this.comentario,
    required this.fecha,
    required this.persona,
    required this.lm,
    required this.lmfecha,
    required this.personaenel,
    required this.personacontrato,
    required this.balance,
    required this.balancesam,
    required this.planillatrabajo,
    required this.descargos,
    required this.docseguridad,
    required this.medidapat,
    required this.formatoarrime,
    required this.plano,
    required this.docsalmacen,
    required this.regfotografico,
    required this.cortesobra,
    required this.pruebasconcreto,
    required this.varios1,
    required this.varios2,
    required this.varios3,
    required this.balanceestado,
    required this.planillatrabajoestado,
    required this.descargosestado,
    required this.docseguridadestado,
    required this.medidapatestado,
    required this.formatoarrimeestado,
    required this.planoestado,
    required this.docsalmacenestado,
    required this.regfotograficoestado,
    required this.cortesobraestado,
    required this.pruebasconcretoestado,
    required this.varios1estado,
    required this.varios2estado,
    required this.varios3estado,
    required this.planillafirmada,
    required this.planillafirmadaestado,
    this.esPrimeravez = false,
    required this.proyecto,
  });

  toList() {
    return [
      id,
      lcl,
      conciliacion,
      nodo,
      estado,
      numero,
      comentario,
      fecha,
      persona,
      lm,
      lmfecha,
      personaenel,
      personacontrato,
      balance,
      balancesam,
      planillatrabajo,
      descargos,
      docseguridad,
      medidapat,
      formatoarrime,
      plano,
      docsalmacen,
      regfotografico,
      cortesobra,
      pruebasconcreto,
      varios1,
      varios2,
      varios3,
      balanceestado,
      planillatrabajoestado,
      descargosestado,
      docseguridadestado,
      medidapatestado,
      formatoarrimeestado,
      planoestado,
      docsalmacenestado,
      regfotograficoestado,
      cortesobraestado,
      pruebasconcretoestado,
      varios1estado,
      varios2estado,
      varios3estado,
      planillafirmada,
      planillafirmadaestado,
      proyecto,
    ];
  }

  getCampo(CampoConciliacion campo) {
    if (campo == CampoConciliacion.id) return id;
    if (campo == CampoConciliacion.lcl) return lcl;
    if (campo == CampoConciliacion.conciliacion) return conciliacion;
    if (campo == CampoConciliacion.nodo) return nodo;
    if (campo == CampoConciliacion.estado) return estado;
    if (campo == CampoConciliacion.numero) return numero;
    if (campo == CampoConciliacion.comentario) return comentario;
    if (campo == CampoConciliacion.fecha) return fecha;
    if (campo == CampoConciliacion.persona) return persona;
    if (campo == CampoConciliacion.lm) return lm;
    if (campo == CampoConciliacion.lmfecha) return lmfecha;
    if (campo == CampoConciliacion.personaenel) return personaenel;
    if (campo == CampoConciliacion.personacontrato) return personacontrato;
    if (campo == CampoConciliacion.balance) return balance;
    if (campo == CampoConciliacion.balancesam) return balancesam;
    if (campo == CampoConciliacion.planillatrabajo) return planillatrabajo;
    if (campo == CampoConciliacion.descargos) return descargos;
    if (campo == CampoConciliacion.docseguridad) return docseguridad;
    if (campo == CampoConciliacion.medidapat) return medidapat;
    if (campo == CampoConciliacion.formatoarrime) return formatoarrime;
    if (campo == CampoConciliacion.plano) return plano;
    if (campo == CampoConciliacion.docsalmacen) return docsalmacen;
    if (campo == CampoConciliacion.regfotografico) return regfotografico;
    if (campo == CampoConciliacion.cortesobra) return cortesobra;
    if (campo == CampoConciliacion.pruebasconcreto) return pruebasconcreto;
    if (campo == CampoConciliacion.varios1) return varios1;
    if (campo == CampoConciliacion.varios2) return varios2;
    if (campo == CampoConciliacion.varios3) return varios3;
    if (campo == CampoConciliacion.balanceestado) return balanceestado;
    if (campo == CampoConciliacion.planillatrabajoestado)
      return planillatrabajoestado;
    if (campo == CampoConciliacion.descargosestado) return descargosestado;
    if (campo == CampoConciliacion.docseguridadestado)
      return docseguridadestado;
    if (campo == CampoConciliacion.medidapatestado) return medidapatestado;
    if (campo == CampoConciliacion.formatoarrimeestado)
      return formatoarrimeestado;
    if (campo == CampoConciliacion.planoestado) return planoestado;
    if (campo == CampoConciliacion.docsalmacenestado) return docsalmacenestado;
    if (campo == CampoConciliacion.regfotograficoestado)
      return regfotograficoestado;
    if (campo == CampoConciliacion.cortesobraestado) return cortesobraestado;
    if (campo == CampoConciliacion.pruebasconcretoestado)
      return pruebasconcretoestado;
    if (campo == CampoConciliacion.varios1estado) return varios1estado;
    if (campo == CampoConciliacion.varios2estado) return varios2estado;
    if (campo == CampoConciliacion.varios3estado) return varios3estado;
    if (campo == CampoConciliacion.planillafirmada) return planillafirmada;
    if (campo == CampoConciliacion.planillafirmadaestado)
      return planillafirmadaestado;
    if (campo == CampoConciliacion.esprimeravez) return esPrimeravez;
    if (campo == CampoConciliacion.proyecto) return proyecto;
  }

  Conciliacion copyWith({
    String? id,
    String? lcl,
    String? conciliacion,
    String? nodo,
    String? estado,
    String? numero,
    String? comentario,
    String? fecha,
    String? persona,
    String? lm,
    String? lmfecha,
    String? personaenel,
    String? personacontrato,
    String? balance,
    String? balancesam,
    String? planillatrabajo,
    String? descargos,
    String? docseguridad,
    String? medidapat,
    String? formatoarrime,
    String? plano,
    String? docsalmacen,
    String? regfotografico,
    String? cortesobra,
    String? pruebasconcreto,
    String? varios1,
    String? varios2,
    String? varios3,
    String? balanceestado,
    String? planillatrabajoestado,
    String? descargosestado,
    String? docseguridadestado,
    String? medidapatestado,
    String? formatoarrimeestado,
    String? planoestado,
    String? docsalmacenestado,
    String? regfotograficoestado,
    String? cortesobraestado,
    String? pruebasconcretoestado,
    String? varios1estado,
    String? varios2estado,
    String? varios3estado,
    String? planillafirmada,
    String? planillafirmadaestado,
    bool? esPrimeravez,
    String? proyecto,
  }) {
    return Conciliacion(
      id: id ?? this.id,
      lcl: lcl ?? this.lcl,
      conciliacion: conciliacion ?? this.conciliacion,
      nodo: nodo ?? this.nodo,
      estado: estado ?? this.estado,
      numero: numero ?? this.numero,
      comentario: comentario ?? this.comentario,
      fecha: fecha ?? this.fecha,
      persona: persona ?? this.persona,
      lm: lm ?? this.lm,
      lmfecha: lmfecha ?? this.lmfecha,
      personaenel: personaenel ?? this.personaenel,
      personacontrato: personacontrato ?? this.personacontrato,
      balance: balance ?? this.balance,
      balancesam: balancesam ?? this.balancesam,
      planillatrabajo: planillatrabajo ?? this.planillatrabajo,
      descargos: descargos ?? this.descargos,
      docseguridad: docseguridad ?? this.docseguridad,
      medidapat: medidapat ?? this.medidapat,
      formatoarrime: formatoarrime ?? this.formatoarrime,
      plano: plano ?? this.plano,
      docsalmacen: docsalmacen ?? this.docsalmacen,
      regfotografico: regfotografico ?? this.regfotografico,
      cortesobra: cortesobra ?? this.cortesobra,
      pruebasconcreto: pruebasconcreto ?? this.pruebasconcreto,
      varios1: varios1 ?? this.varios1,
      varios2: varios2 ?? this.varios2,
      varios3: varios3 ?? this.varios3,
      balanceestado: balanceestado ?? this.balanceestado,
      planillatrabajoestado:
          planillatrabajoestado ?? this.planillatrabajoestado,
      descargosestado: descargosestado ?? this.descargosestado,
      docseguridadestado: docseguridadestado ?? this.docseguridadestado,
      medidapatestado: medidapatestado ?? this.medidapatestado,
      formatoarrimeestado: formatoarrimeestado ?? this.formatoarrimeestado,
      planoestado: planoestado ?? this.planoestado,
      docsalmacenestado: docsalmacenestado ?? this.docsalmacenestado,
      regfotograficoestado: regfotograficoestado ?? this.regfotograficoestado,
      cortesobraestado: cortesobraestado ?? this.cortesobraestado,
      pruebasconcretoestado:
          pruebasconcretoestado ?? this.pruebasconcretoestado,
      varios1estado: varios1estado ?? this.varios1estado,
      varios2estado: varios2estado ?? this.varios2estado,
      varios3estado: varios3estado ?? this.varios3estado,
      planillafirmada: planillafirmada ?? this.planillafirmada,
      planillafirmadaestado:
          planillafirmadaestado ?? this.planillafirmadaestado,
      esPrimeravez: esPrimeravez ?? this.esPrimeravez,
      proyecto: proyecto ?? this.proyecto,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lcl': lcl,
      'conciliacion': conciliacion,
      'nodo': nodo,
      'estado': estado,
      'numero': numero,
      'comentario': comentario,
      'fecha': fecha,
      'persona': persona,
      'lm': lm,
      'lmfecha': lmfecha,
      'personaenel': personaenel,
      'personacontrato': personacontrato,
      'balance': balance,
      'balancesam': balancesam,
      'planillatrabajo': planillatrabajo,
      'descargos': descargos,
      'docseguridad': docseguridad,
      'medidapat': medidapat,
      'formatoarrime': formatoarrime,
      'plano': plano,
      'docsalmacen': docsalmacen,
      'regfotografico': regfotografico,
      'cortesobra': cortesobra,
      'pruebasconcreto': pruebasconcreto,
      'varios1': varios1,
      'varios2': varios2,
      'varios3': varios3,
      'balanceestado': balanceestado,
      'planillatrabajoestado': planillatrabajoestado,
      'descargosestado': descargosestado,
      'docseguridadestado': docseguridadestado,
      'medidapatestado': medidapatestado,
      'formatoarrimeestado': formatoarrimeestado,
      'planoestado': planoestado,
      'docsalmacenestado': docsalmacenestado,
      'regfotograficoestado': regfotograficoestado,
      'cortesobraestado': cortesobraestado,
      'pruebasconcretoestado': pruebasconcretoestado,
      'varios1estado': varios1estado,
      'varios2estado': varios2estado,
      'varios3estado': varios3estado,
      'planillafirmada': planillafirmada,
      'planillafirmadaestado': planillafirmadaestado,
      'esprimeravez': esPrimeravez,
      'proyecto': proyecto,
    };
  }

  factory Conciliacion.fromMap(Map<String, dynamic> map) {
    return Conciliacion(
      id: map['id'].toString(),
      lcl: map['lcl'].toString(),
      conciliacion: map['conciliacion'].toString(),
      nodo: map['nodo'].toString(),
      estado: map['estado'].toString(),
      numero: map['numero'].toString(),
      comentario: map['comentario'].toString(),
      fecha: map['fecha'].toString().length > 16
          ? map['fecha'].toString().substring(0, 16)
          : map['fecha'].toString(),
      persona: map['persona'].toString(),
      lm: map['lm'].toString(),
      lmfecha: map['lmfecha'].toString().length > 10
          ? map['lmfecha'].toString().substring(0, 10)
          : map['lmfecha'].toString(),
      personaenel: map['personaenel'].toString(),
      personacontrato: map['personacontrato'].toString(),
      balance: map['balance'].toString(),
      balancesam: map['balancesam'].toString(),
      planillatrabajo: map['planillatrabajo'].toString(),
      descargos: map['descargos'].toString(),
      docseguridad: map['docseguridad'].toString(),
      medidapat: map['medidapat'].toString(),
      formatoarrime: map['formatoarrime'].toString(),
      plano: map['plano'].toString(),
      docsalmacen: map['docsalmacen'].toString(),
      regfotografico: map['regfotografico'].toString(),
      cortesobra: map['cortesobra'].toString(),
      pruebasconcreto: map['pruebasconcreto'].toString(),
      varios1: map['varios1'].toString(),
      varios2: map['varios2'].toString(),
      varios3: map['varios3'].toString(),
      balanceestado: map['balanceestado'].toString(),
      planillatrabajoestado: map['planillatrabajoestado'].toString(),
      descargosestado: map['descargosestado'].toString(),
      docseguridadestado: map['docseguridadestado'].toString(),
      medidapatestado: map['medidapatestado'].toString(),
      formatoarrimeestado: map['formatoarrimeestado'].toString(),
      planoestado: map['planoestado'].toString(),
      docsalmacenestado: map['docsalmacenestado'].toString(),
      regfotograficoestado: map['regfotograficoestado'].toString(),
      cortesobraestado: map['cortesobraestado'].toString(),
      pruebasconcretoestado: map['pruebasconcretoestado'].toString(),
      varios1estado: map['varios1estado'].toString(),
      varios2estado: map['varios2estado'].toString(),
      varios3estado: map['varios3estado'].toString(),
      planillafirmada: map['planillafirmada'].toString(),
      planillafirmadaestado: map['planillafirmadaestado'].toString(),
      // esPrimeravez: map['esprimeravez'].toString() == 'true' ? true : false,
      proyecto: map['proyecto'].toString(),
    );
  }

  factory Conciliacion.fromNuevo({
    required String persona,
  }) {
    return Conciliacion(
      id: '',
      lcl: '',
      conciliacion: '',
      nodo: '',
      estado: 'carga archivos',
      numero: '',
      comentario: '',
      fecha: DateTime.now().toString().substring(0, 16),
      persona: persona,
      lm: '',
      lmfecha: '',
      personaenel: '',
      personacontrato: persona,
      balance: '',
      balancesam: '',
      planillatrabajo: '',
      descargos: '',
      docseguridad: '',
      medidapat: '',
      formatoarrime: '',
      plano: '',
      docsalmacen: '',
      regfotografico: '',
      cortesobra: '',
      pruebasconcreto: '',
      varios1: '',
      varios2: '',
      varios3: '',
      balanceestado: 'false',
      planillatrabajoestado: 'false',
      descargosestado: 'false',
      docseguridadestado: 'false',
      medidapatestado: '',
      formatoarrimeestado: '',
      planoestado: '',
      docsalmacenestado: '',
      regfotograficoestado: '',
      cortesobraestado: '',
      pruebasconcretoestado: '',
      varios1estado: '',
      varios2estado: '',
      varios3estado: '',
      planillafirmada: '',
      planillafirmadaestado: '',
      proyecto: '',
    );
  }

  factory Conciliacion.anulada() {
    return Conciliacion(
      id: '',
      lcl: '',
      conciliacion: '',
      nodo: '',
      estado: 'anulada',
      numero: '',
      comentario: '',
      fecha: DateTime.now().toString().substring(0, 16),
      persona: '',
      lm: '',
      lmfecha: '',
      personaenel: '',
      personacontrato: ' ',
      balance: '',
      balancesam: '',
      planillatrabajo: '',
      descargos: '',
      docseguridad: '',
      medidapat: '',
      formatoarrime: '',
      plano: '',
      docsalmacen: '',
      regfotografico: '',
      cortesobra: '',
      pruebasconcreto: '',
      varios1: '',
      varios2: '',
      varios3: '',
      balanceestado: 'false',
      planillatrabajoestado: 'false',
      descargosestado: 'false',
      docseguridadestado: 'false',
      medidapatestado: '',
      formatoarrimeestado: '',
      planoestado: '',
      docsalmacenestado: '',
      regfotograficoestado: '',
      cortesobraestado: '',
      pruebasconcretoestado: '',
      varios1estado: '',
      varios2estado: '',
      varios3estado: '',
      planillafirmada: '',
      planillafirmadaestado: '',
      proyecto: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Conciliacion.fromJson(String source) =>
      Conciliacion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Conciliacion(id: $id, lcl: $lcl, conciliacion: $conciliacion, nodo: $nodo, estado: $estado, numero: $numero, comentario: $comentario, fecha: $fecha, persona: $persona, lm: $lm, personaenel: $personaenel balance: $balance, balancesam: $balancesam planillatrabajo: $planillatrabajo, descargos: $descargos, docseguridad: $docseguridad, medidapat: $medidapat, formatoarrime: $formatoarrime, plano: $plano, docsalmacen: $docsalmacen, regfotografico: $regfotografico, cortesobra: $cortesobra, pruebasconcreto: $pruebasconcreto, varios1: $varios1, varios2: $varios2, varios3: $varios3, balanceestado: $balanceestado, planillatrabajoestado: $planillatrabajoestado, descargosestado: $descargosestado, docseguridadestado: $docseguridadestado, medidapatestado: $medidapatestado, formatoarrimeestado: $formatoarrimeestado, planoestado: $planoestado, docsalmacenestado: $docsalmacenestado, regfotograficoestado: $regfotograficoestado, cortesobraestado: $cortesobraestado, pruebasconcretoestado: $pruebasconcretoestado, varios1estado: $varios1estado, varios2estado: $varios2estado, varios3estado: $varios3estado, planillafirmada: $planillafirmada, planillafirmadaestado: $planillafirmadaestado)';
  }

  @override
  bool operator ==(covariant Conciliacion other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.lcl == lcl &&
        other.conciliacion == conciliacion &&
        other.nodo == nodo &&
        other.estado == estado &&
        other.numero == numero &&
        other.comentario == comentario &&
        other.fecha == fecha &&
        other.persona == persona &&
        other.lm == lm &&
        other.personaenel == personaenel &&
        other.balance == balance &&
        other.balancesam == balancesam &&
        other.planillatrabajo == planillatrabajo &&
        other.descargos == descargos &&
        other.docseguridad == docseguridad &&
        other.medidapat == medidapat &&
        other.formatoarrime == formatoarrime &&
        other.plano == plano &&
        other.docsalmacen == docsalmacen &&
        other.regfotografico == regfotografico &&
        other.cortesobra == cortesobra &&
        other.pruebasconcreto == pruebasconcreto &&
        other.varios1 == varios1 &&
        other.varios2 == varios2 &&
        other.varios3 == varios3 &&
        other.balanceestado == balanceestado &&
        other.planillatrabajoestado == planillatrabajoestado &&
        other.descargosestado == descargosestado &&
        other.docseguridadestado == docseguridadestado &&
        other.medidapatestado == medidapatestado &&
        other.formatoarrimeestado == formatoarrimeestado &&
        other.planoestado == planoestado &&
        other.docsalmacenestado == docsalmacenestado &&
        other.regfotograficoestado == regfotograficoestado &&
        other.cortesobraestado == cortesobraestado &&
        other.pruebasconcretoestado == pruebasconcretoestado &&
        other.varios1estado == varios1estado &&
        other.varios2estado == varios2estado &&
        other.varios3estado == varios3estado &&
        other.planillafirmada == planillafirmada &&
        other.planillafirmadaestado == planillafirmadaestado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lcl.hashCode ^
        conciliacion.hashCode ^
        nodo.hashCode ^
        estado.hashCode ^
        numero.hashCode ^
        comentario.hashCode ^
        fecha.hashCode ^
        persona.hashCode ^
        lm.hashCode ^
        personaenel.hashCode ^
        balance.hashCode ^
        balancesam.hashCode ^
        planillatrabajo.hashCode ^
        descargos.hashCode ^
        docseguridad.hashCode ^
        medidapat.hashCode ^
        formatoarrime.hashCode ^
        plano.hashCode ^
        docsalmacen.hashCode ^
        regfotografico.hashCode ^
        cortesobra.hashCode ^
        pruebasconcreto.hashCode ^
        varios1.hashCode ^
        varios2.hashCode ^
        varios3.hashCode ^
        balanceestado.hashCode ^
        planillatrabajoestado.hashCode ^
        descargosestado.hashCode ^
        docseguridadestado.hashCode ^
        medidapatestado.hashCode ^
        formatoarrimeestado.hashCode ^
        planoestado.hashCode ^
        docsalmacenestado.hashCode ^
        regfotograficoestado.hashCode ^
        cortesobraestado.hashCode ^
        pruebasconcretoestado.hashCode ^
        varios1estado.hashCode ^
        varios2estado.hashCode ^
        varios3estado.hashCode ^
        planillafirmada.hashCode ^
        planillafirmadaestado.hashCode;
  }
}
