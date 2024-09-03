import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

class FirebaseStorageManager {
  static Future<XFile> compressImage({
    required File imageFile,
    int quality = 95,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    final String targetPath =
        p.join(Directory.systemTemp.path, 'temp.${format.name}');
    final XFile? compressedImage =
        await FlutterImageCompress.compressAndGetFile(
            imageFile.path, targetPath,
            quality: quality, format: format);

    if (compressedImage == null) {
      throw ("Failed to compress the image");
    }

    return compressedImage;
  }

  static Future<String> uploadCashImage({
    required File imageFile,
    required String id,
  }) async {
    try {
      // Print original file size
      final originalSize = await imageFile.length();
      print('Original size: ${originalSize / 1024} KB');

      // Compress the image
      XFile compressedImage = await compressImage(
        imageFile: imageFile,
        quality: 50, // Adjust the quality as needed
      );

      // Print compressed file size
      final compressedSize = await compressedImage.length();
      print('Compressed size: ${compressedSize / 1024} KB');

      final storageRef = FirebaseStorage.instance.ref().child('images/$id.jpg');
      final uploadTask = await storageRef.putFile(File(compressedImage.path));
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
      // Print original file size
      final originalSize = await imageFile.length();
      print('Original size: ${originalSize / 1024} KB');

      // Compress the image
      XFile compressedImage = await compressImage(
        imageFile: imageFile,
        quality: 50, // Adjust the quality as needed
      );

      // Print compressed file size
      final compressedSize = await compressedImage.length();
      print('Compressed size: ${compressedSize / 1024} KB');

      final storageRef =
          FirebaseStorage.instance.ref().child('clients_images/$id.jpg');
      final uploadTask = await storageRef.putFile(File(compressedImage.path));
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

  static Future<void> deleteClientImage({required String clientId}) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('clients_images/$clientId.jpg');
      await storageRef.delete();
      print('Image deleted successfully');
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  static Future<void> deleteCashImage({required String cashId}) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('images/$cashId.jpg');
      await storageRef.delete();
      print('Image deleted successfully');
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }
}
