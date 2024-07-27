import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List cashes = [];
  List<Project?> projects = [];
  Project? currentProject;
  void getProject({required Project project}) {
    currentProject = project;
    notifyListeners();
  }

  void getProjects({
    required String uId,
  }) async {
    projects =
        await FirebaseFirestoreManager.getAllProjectByUserId(userId: uId);
    for (var project in projects) {
      print(project?.name ?? 'name null');
    }
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
