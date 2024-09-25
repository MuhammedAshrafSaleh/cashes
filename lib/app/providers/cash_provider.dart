import 'dart:io';

import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/core/firebase%20configurations/firebase_storage_manager.dart';
import 'package:cashes/app/core/utls.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/cash.dart';
import '../widget/custom_dialog_widget.dart';

class CashProvider extends ChangeNotifier {
  List<Cash> cashes = [];
  File? currentImage;

  void changeCurrentImage(newImage) {
    currentImage = newImage;
    // print("Current Image Updated: $currentImage");
    notifyListeners();
  }

  void changeCashes(newCashes) {
    cashes = newCashes;
    notifyListeners();
  }

  Future<void> getCashes({
    required String userId,
    required project,
  }) async {
    cashes = await FirebaseFirestoreManager.getAllCashes(
      userId: userId,
      projectId: project.id,
    );
    cashes.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a.date ?? '') ?? DateTime(0);
      DateTime dateB = DateTime.tryParse(b.date ?? '') ?? DateTime(0);
      return dateA.compareTo(dateB);
    });
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

  Future<void> addCash({
    required cash,
    required userId,
    required project,
    File? imageFile,
    required context,
  }) async {
    try {
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.loading);
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
      await getCashes(userId: userId, project: project);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.addSucceccfuly);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }

  Future<void> updateCash({
    required Cash cash,
    required project,
    required userId,
    required context,
    required isImageUpdated,
    required imageFile,
  }) async {
    try {
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.loading);
      if (imageFile != null) {
        if (isImageUpdated) {
          await FirebaseStorageManager.deleteCashImage(
              cashId: getIdfromImage(url: cash.imageURl!));
        }
        var uuid = const Uuid();
        String imageUrl = await FirebaseStorageManager.uploadCashImage(
          imageFile: imageFile,
          id: uuid.v4(),
        );
        cash.imageURl = imageUrl;
        print("AddDDDDDDDDDDDDDDDDDDDDDDDDDD");
      }
      await FirebaseFirestoreManager.updateCash(
        cash: cash,
        projectId: project.id,
        userId: userId,
      );
      await getCashes(userId: userId, project: project);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.updatedSuccessfully);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }

  Future<void> deleteImageCash({
    required Cash cash,
    required project,
    required userId,
    required context,
  }) async {
    try {
      await FirebaseStorageManager.deleteCashImage(
          cashId: getIdfromImage(url: cash.imageURl!));
      cash.imageURl = '';
      await FirebaseFirestoreManager.updateCash(
        cash: cash,
        projectId: project.id,
        userId: userId,
      );
      await getCashes(userId: userId, project: project);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }

  Future<void> deleteCash({
    required Cash cash,
    required userId,
    required project,
    required context,
  }) async {
    try {
      await FirebaseFirestoreManager.deleteCashByUserIdAndProjectId(
        userId: userId,
        projectId: project.id,
        cash: cash,
      );

      await FirebaseStorageManager.deleteCashImage(
        cashId: getIdfromImage(url: cash.imageURl!),
      );

      await getCashes(userId: userId, project: project);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }
}
