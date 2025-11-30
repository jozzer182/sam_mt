import 'package:intl/intl.dart';

toMCOP(int precio, int number) {
  if (number == 0) return '';
  return NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 1,
  ).format((precio * number) / 1000000);
}