import 'package:intl/intl.dart';

class AppDate {
  static String format(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(date);
  }
}
