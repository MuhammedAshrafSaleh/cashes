import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageManager {
  static Future<String> uploadCashImage({
    required File imageFile,
    required String id,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('images/$id.jpg');
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      print("==================================================");
      print(imageUrl);
      print("==================================================");
      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw e; // Re-throw the exception to handle it in the calling function
    }
  }

  static Future<String> uploadClinetImage({
    required File imageFile,
    required String id,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('clients_images/$id.jpg');
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      print("==================================================");
      print(imageUrl);
      print("==================================================");
      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw e; // Re-throw the exception to handle it in the calling function
    }
  }
}
