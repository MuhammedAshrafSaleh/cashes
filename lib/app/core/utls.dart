import 'package:intl/intl.dart';

String formatDate(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  return formatter.format(dateTime);
}

String formatDateWithoutTime(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}
