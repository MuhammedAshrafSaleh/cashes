import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

String formatDate(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter =
      DateFormat.yMMMd('ar'); // Set the locale to Arabic
  return formatter.format(dateTime);
}

String formateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat.jm('ar'); // Set the locale to Arabic
  return formatter.format(dateTime);
}

String formatDateWithoutTime(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
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

Future<File?> pickGallaryImage() async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // maxHeight: 400,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickCameraImage() async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
