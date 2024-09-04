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
        print(cash.imageURl);
        print(cash.imageURl);
        print(getIdfromImage(url: cash.imageURl!));
        print(getIdfromImage(url: cash.imageURl!));
      }
      await FirebaseFirestoreManager.addtCashesByUserIdAndProjectId(
        cash: cash,
        userId: userId,
        projectId: project.id,
      );
      getCashes(userId: userId, project: project);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.addSucceccfuly);
      // Navigator.pop(context);
      // Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }

  void updateCash({
    required Cash cash,
    required project,
    required userId,
    required context,
    required isImageUpdated,
    required imageFile,
  }) async {
    try {
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
      }
      await FirebaseFirestoreManager.updateCash(
        cash: cash,
        projectId: project.id,
        userId: userId,
      );
      getCashes(userId: userId, project: project);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.updatedSuccessfully);
      // Navigator.pop(context);
      // Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }

  void deleteCash({
    required Cash cash,
    required userId,
    required project,
    required context,
  }) async {
    try {
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.deletingNow);
      await FirebaseFirestoreManager.deleteCashByUserIdAndProjectId(
        userId: userId,
        projectId: project.id,
        cash: cash,
      );

      await FirebaseStorageManager.deleteCashImage(
          cashId: getIdfromImage(url: cash.imageURl!));
      getCashes(userId: userId, project: project);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.deletedSuccessfully);
      // Navigator.pop(context);
      // Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
        Navigator.pop(context);
      }
    }
  }
}
