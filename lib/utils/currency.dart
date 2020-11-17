import 'package:intl/intl.dart';

currencyFormat(double value) {
  return NumberFormat.simpleCurrency(locale: 'pt_BR').format(value);
}