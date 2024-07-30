import 'dart:io';

import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/core/firebase%20configurations/firebase_storage_manager.dart';
import 'package:cashes/app/models/client_transefer.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
  }) async {
    if (imageFile != null) {
      var uid = const Uuid();
      String imageURL = await FirebaseStorageManager.uploadClinetImage(
        imageFile: imageFile,
        id: uid.v4(),
      );
      client.imageURL = imageURL;
    }
    await FirebaseFirestoreManager.addClientTranserfer(
      userId: userId,
      projectId: projectId,
      client: client,
    );
    getAllClientTransfers(projectId: projectId, userId: userId);
  }

  void updateClientTransfer({
    required userId,
    required projectId,
    required ClientTransefer client,
    File? imageFile,
  }) async {
    if (imageFile != null) {
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
  }

  void deleteClientTransfer({
    required userId,
    required projectId,
    required ClientTransefer client,
  }) async {
    await FirebaseFirestoreManager.deleteClientTransfer(
      userId: userId,
      projectId: projectId,
      client: client,
    );
    await FirebaseStorageManager.deleteClientImage(clientId: client.id!);
    getAllClientTransfers(projectId: projectId, userId: userId);
  }
}
