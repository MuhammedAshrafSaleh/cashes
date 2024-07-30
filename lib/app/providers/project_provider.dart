import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/models/cash.dart';
import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List cashes = [];
  List projects = [];
  Project? currentProject;
  void changeProject({required Project? project}) {
    currentProject = project;
    notifyListeners();
  }

  void changeProjects(newProjects) {
    projects = newProjects;
    notifyListeners();
  }

  void getProjects({
    required String uId,
  }) async {
    projects =
        await FirebaseFirestoreManager.getAllProjectByUserId(userId: uId);
    // for (var project in projects) {
    //   List<Cash> cashes = await FirebaseFirestoreManager.getAllCashes(
    //     userId: uId,
    //     projectId: project.id,
    //   );
    //   var total = 0;
    //   for (var cash in cashes) {
    //     total += int.parse(cash.price ?? '');
    //     print("total= $total");
    //   }
    //   project.money = total.toString();
    // }
    notifyListeners();
  }

  void addProject({
    required Project project,
    required String uId,
  }) async {
    await FirebaseFirestoreManager.addProjects(
      project: project,
      userId: uId,
    );
    getProjects(uId: uId);
  }

  void updateProject({required Project project, required userId}) async {
    await FirebaseFirestoreManager.updateProject(
      project: project,
      userId: userId,
    );
    getProjects(uId: userId);
  }

  void deleteProject({required Project project, required String userId}) async {
    await FirebaseFirestoreManager.removeProjectById(
      userId: userId,
      projectId: project.id!,
    );
    getProjects(uId: userId);
  }
}
