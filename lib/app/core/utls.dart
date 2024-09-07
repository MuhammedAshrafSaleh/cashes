import 'package:intl/intl.dart';

String formatDate(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('yMMMd');
  return formatter.format(dateTime);
}

String formatDateWithoutTime(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('yMMMd');
  return formatter.format(dateTime);
}

String getIdfromImage({required String url}) {
  // Find the last '/' to get the file name
  String fileName = url.split('/').last.split('?').first;

  // Extract the ID by getting the part after 'images%2F'
  String id = fileName.split('%2F').last.split('.').first;
  return id;
}

String getIdFromClientId({required String url}) {
  String id = url.split('%2F').last.split('.').first;
  return id;
}
