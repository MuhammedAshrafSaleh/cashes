import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageManager {
  Future<String> uploadImage(File imageFile, String id) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('images/$id.jpg');
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw e; // Re-throw the exception to handle it in the calling function
    }
  }
}
