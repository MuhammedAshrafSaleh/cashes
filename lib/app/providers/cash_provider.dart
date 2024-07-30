import 'dart:io';

import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/core/firebase%20configurations/firebase_storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/cash.dart';

class CashProvider extends ChangeNotifier {
  List<Cash> cashes = [];
  File? currentImage;
  void changeCurrentImage(newImage) {
    currentImage = newImage;
    notifyListeners();
  }

  void changeCashes(newCashes) {
    cashes = newCashes;
    notifyListeners();
  }

  void getCashes({
    required String userId,
    required project,
  }) async {
    cashes = await FirebaseFirestoreManager.getAllCashes(
      userId: userId,
      projectId: project.id,
    );
    int total = 0;
    for (var cash in cashes) {
      total += int.parse(cash.price ?? '');
    }
    project.money = total.toString();
    await FirebaseFirestoreManager.updateProject(
      project: project,
      userId: userId,
    );
    notifyListeners();
  }

  Future addCash({
    required cash,
    required userId,
    required project,
    File? imageFile,
  }) async {
    if (imageFile != null) {
      var uuid = const Uuid();
      String imageUrl = await FirebaseStorageManager.uploadCashImage(
        imageFile: imageFile,
        id: uuid.v4(),
      );
      cash.imageURl = imageUrl;
    }
    await FirebaseFirestoreManager.addtCashesByUserIdAndProjectId(
      cash: cash,
      userId: userId,
      projectId: project.id,
    );
    getCashes(userId: userId, project: project);
  }

  void updateCash({
    required Cash cash,
    required project,
    required userId,
    imageFile,
  }) async {
    if (imageFile != null) {
      var uuid = const Uuid();
      String imageUrl = await FirebaseStorageManager.uploadCashImage(
        imageFile: imageFile,
        id: uuid.v4(),
      );
      cash.imageURl = imageUrl;
    }
    await FirebaseFirestoreManager.updateCash(
      cash: cash,
      projectId: project.id,
      userId: userId,
    );
    getCashes(userId: userId, project: project);
  }

  void deleteCash({
    required cash,
    required userId,
    required project,
  }) async {
    await FirebaseFirestoreManager.deleteCashByUserIdAndProjectId(
      userId: userId,
      projectId: project.id,
      cash: cash,
    );
    await FirebaseStorageManager.deleteCashImage(cashId: cash.id);
    getCashes(userId: userId, project: project);
  }
}
