import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:flutter/material.dart';

import '../models/cash.dart';

class CashProvider extends ChangeNotifier {
  List<Cash> cashes = [];

  void getCashes({
    required String userId,
    required String projectId,
  }) async {
    cashes = await FirebaseFirestoreManager.getAllCashes(
        userId: userId, projectId: projectId);
    for (var cash in cashes) {
      print(cash.name ?? 'name null');
    }
    notifyListeners();
  }

  Future addCash({
    required cash,
    required userId,
    required projectId,
  }) async {
    await FirebaseFirestoreManager.addtCashesByUserIdAndProjectId(
        cash: cash, userId: userId, projectId: projectId);
    getCashes(userId: userId, projectId: projectId);
  }

  void updateCash(
      {required Cash cash, required projectId, required userId}) async {
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
