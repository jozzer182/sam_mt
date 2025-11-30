import 'package:intl/intl.dart';

toCurrency(String? string){
  if(string == null || string.isEmpty) return '';
  return NumberFormat.decimalPattern('en').format(double.parse(string));
}

toCurrencyEU(String? string){
  if(string == null || string.isEmpty) return '';
  return '\$ ${NumberFormat.decimalPattern('en_EU').format(int.parse(string))} €';
}

toCurrencyCOP(String? string){
  if(string == null || string.isEmpty) return '';
  return '\$ ${NumberFormat.decimalPattern('es').format(int.parse(string))} COP';
}

toCurrency$(String? string){
  if(string == null || string.isEmpty) return '';
  return '\$ ${NumberFormat.decimalPattern('es').format(int.parse(string))}';
}

toCurrency$fixed(String? string) {
  if (string == null || string.isEmpty) return '';
  return '\$ ${NumberFormat.decimalPattern('es').format(num.parse(string))}';
}

String enMillon(num valor) {
  return toCurrency$((valor / 1000000).toStringAsFixed(0));
}

String enMillon1(num valor) {
  String value = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 1,
  ).format((valor) / 1000000);
  // String value = toCurrency$('${(valor / 1000000).toStringAsFixed(1)}');
  if (valor == 0) {
    return '-';
  }
  if (value.length >= 2 && value.endsWith('0')) {
    return value.substring(0, value.length - 2);
  }
  return value;
}