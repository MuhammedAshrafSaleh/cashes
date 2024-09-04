import 'dart:io';

import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/core/firebase%20configurations/firebase_storage_manager.dart';
import 'package:cashes/app/models/client_transefer.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/utls.dart';
import '../widget/custom_dialog_widget.dart';

class ClientsTranseferProvider extends ChangeNotifier {
  List<ClientTransefer>? clintes = [];
  File? currentImage;
  void changeClients(List<ClientTransefer>? newClients) {
    clintes = newClients;
    notifyListeners();
  }

  void changeCurrentImage(newImage) {
    currentImage = newImage;
    notifyListeners();
  }

  Future<void> getAllClientTransfers({
    required userId,
    required projectId,
  }) async {
    clintes = await FirebaseFirestoreManager.getAllClientTransfers(
      userId: userId,
      projectId: projectId,
    );
    notifyListeners();
  }

  void addClientTranserfer({
    required userId,
    required projectId,
    required ClientTransefer client,
    File? imageFile,
    required context,
  }) async {
    try {
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.addingNow);
      if (imageFile != null) {
        String imageURL = await FirebaseStorageManager.uploadClinetImage(
          imageFile: imageFile,
          id: client.id!,
        );
        client.imageURL = imageURL;
      }
      await FirebaseFirestoreManager.addClientTranserfer(
        userId: userId,
        projectId: projectId,
        client: client,
      );
      getAllClientTransfers(projectId: projectId, userId: userId);
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

  void updateClientTransfer({
    required userId,
    required projectId,
    required ClientTransefer client,
    imageFile,
    required context,
    required isImageUpdated,
  }) async {
    try {
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.updatingNow);
      if (imageFile != null) {
        // if (isImageUpdated) {
        //   await FirebaseStorageManager.deleteClientImage(
        //       clientId: getIdFromClientId(url: client.imageURL!));
        // }
        var uid = const Uuid();
        String imageURL = await FirebaseStorageManager.uploadClinetImage(
          imageFile: imageFile,
          id: uid.v4(),
        );
        client.imageURL = imageURL;
      }
      await FirebaseFirestoreManager.updateClientTransfer(
        userId: userId,
        projectId: projectId,
        client: client,
      );
      getAllClientTransfers(projectId: projectId, userId: userId);
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

  void deleteClientTransfer({
    required userId,
    required projectId,
    required ClientTransefer client,
    required context,
  }) async {
    try {
      DialogUtls.showLoading(
          context: context, message: AppLocalizations.of(context)!.deletingNow);
      await FirebaseStorageManager.deleteClientImage(
          clientId: getIdFromClientId(url: client.imageURL!));
      await FirebaseFirestoreManager.deleteClientTransfer(
        userId: userId,
        projectId: projectId,
        client: client,
      );
      getAllClientTransfers(projectId: projectId, userId: userId);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context,
          message: AppLocalizations.of(context)!.deletedSuccessfully);
      Navigator.pop(context);
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
