import 'dart:io';

import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/core/firebase%20configurations/firebase_storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/cash.dart';

class CashProvider extends ChangeNotifier {
  List<Cash> cashes = [];
  var currentImage;
  void changeCurrentImage(newImage) {
    currentImage = newImage;
    notifyListeners();
  }
  void getCashes({
    required String userId,
    required String projectId,
  }) async {
    cashes = await FirebaseFirestoreManager.getAllCashes(
      userId: userId,
      projectId: projectId,
    );
    notifyListeners();
  }

  Future addCash({
    required cash,
    required userId,
    required projectId,
    File? imageFile,
  }) async {
    if (imageFile != null) {
      var uuid = const Uuid();
      String imageUrl = await FirebaseStorageManager.uploadImage(
        imageFile: imageFile,
        id: uuid.v4(),
      );
      cash.imageURl = imageUrl;
      print("============================================");
      print(imageUrl);
      print("============================================");
    }
    await FirebaseFirestoreManager.addtCashesByUserIdAndProjectId(
      cash: cash,
      userId: userId,
      projectId: projectId,
    );
    getCashes(userId: userId, projectId: projectId);
  }

  void updateCash({
    required Cash cash,
    required projectId,
    required userId,
    imageFile,
  }) async {
    if (imageFile != null) {
      var uuid = const Uuid();
      String imageUrl = await FirebaseStorageManager.uploadImage(
        imageFile: imageFile,
        id: uuid.v4(),
      );
      cash.imageURl = imageUrl;
      print("============================================");
      print(imageUrl);
      print("============================================");
    }
    await FirebaseFirestoreManager.updateCash(
      cash: cash,
      projectId: projectId,
      userId: userId,
    );
    getCashes(projectId: projectId, userId: userId);
  }

  void deleteCash({
    required cash,
    required userId,
    required projectId,
  }) async {
    await FirebaseFirestoreManager.deleteCashByUserIdAndProjectId(
      userId: userId,
      projectId: projectId,
      cash: cash,
    );
    getCashes(userId: userId, projectId: projectId);
  }
}
