import 'dart:core';
import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(String time, String format) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return DateFormat(format ?? 'HH:mm').format(date);
  }
}
