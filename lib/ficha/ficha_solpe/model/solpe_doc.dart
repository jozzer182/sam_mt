import 'solpe_reg.dart';

class SolPeDoc {
  List<SolPeReg> list = [];
  List<SolPeReg> listSecure = [];
  bool editar = false;
  bool esNuevo = false;
  List<String> destinatarios = [];
  String comentario = "";
  String circuito = "";
  String pedido = "";
  SolPeDoc({
    required this.list,
  });
}
