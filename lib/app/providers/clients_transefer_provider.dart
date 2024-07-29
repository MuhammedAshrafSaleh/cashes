import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/models/client_transefer.dart';
import 'package:flutter/material.dart';

class ClientsTranseferProvider extends ChangeNotifier {
  List<ClientTransefer>? clintes = [];
  void changeClients(List<ClientTransefer>? newClients) {
    clintes = newClients;
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
  }) async {

    
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
  }) async {
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
    getAllClientTransfers(projectId: projectId, userId: userId);
  }
}
