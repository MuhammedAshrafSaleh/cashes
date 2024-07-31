import 'dart:io';

import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/core/firebase%20configurations/firebase_storage_manager.dart';
import 'package:cashes/app/models/client_transefer.dart';
import 'package:flutter/material.dart';

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
      DialogUtls.showLoading(context: context, message: 'Adding now...');
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
      DialogUtls.showMessage(context: context, message: 'Added Successfully');
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
    File? imageFile,
    required context,
  }) async {
    print('userId : $userId');
    print('projectId : $projectId');
    print('client : ${client.id}');
    if (imageFile != null) {
      print('=======================');
      print('Not Null');
      print('=======================');
      await FirebaseStorageManager.deleteClientImage(clientId: client.id!);
      String imageURL = await FirebaseStorageManager.uploadClinetImage(
        imageFile: imageFile,
        id: client.id!,
      );
      client.imageURL = imageURL;
    }
    // Check if the document exists
    final docRef =
        FirebaseFirestoreManager.getProjectsCollection(userId: userId)
            .doc(projectId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      // Handle the case where the document does not exist
      throw Exception('Document does not exist');
    }
    await FirebaseFirestoreManager.updateClientTransfer(
      userId: userId,
      projectId: projectId,
      client: client,
    );
    getAllClientTransfers(projectId: projectId, userId: userId);
    // try {
    //   DialogUtls.showLoading(context: context, message: 'Updating now...');
    //   if (imageFile != null) {
    //     var uid = const Uuid();
    //     String imageURL = await FirebaseStorageManager.uploadClinetImage(
    //       imageFile: imageFile,
    //       id: uid.v4(),
    //     );
    //     client.imageURL = imageURL;
    //   }
    //   await FirebaseFirestoreManager.updateClientTransfer(
    //     userId: userId,
    //     projectId: projectId,
    //     client: client,
    //   );
    //   getAllClientTransfers(projectId: projectId, userId: userId);
    //   DialogUtls.hideLoading(context: context);
    //   DialogUtls.showMessage(context: context, message: 'Updated Successfully');
    //   // Navigator.pop(context);
    //   // Navigator.pop(context);
    // } catch (e) {
    //   if (context.mounted) {
    //     DialogUtls.hideLoading(context: context);
    //     DialogUtls.showMessage(context: context, message: e.toString());
    //     Navigator.pop(context);
    //   }
    // }
  }

  void deleteClientTransfer({
    required userId,
    required projectId,
    required ClientTransefer client,
    required context,
  }) async {
    try {
      DialogUtls.showLoading(context: context, message: 'Deleting now...');
      await FirebaseFirestoreManager.deleteClientTransfer(
        userId: userId,
        projectId: projectId,
        client: client,
      );
      await FirebaseStorageManager.deleteClientImage(clientId: client.id!);
      getAllClientTransfers(projectId: projectId, userId: userId);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(context: context, message: 'Deleted Successfully');
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
