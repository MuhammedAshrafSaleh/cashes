import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List cashes = [];
  List<Project?> projects = [];

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
      projectId: projects.length,
    );
    getProjects(uId: uId);
  }

  void updateProject({required Project project}) {
    projects[projects
        .indexWhere((oldProject) => oldProject!.id == project.id)] = project;
    notifyListeners();
  }

  void deleteProject(Project project) {
    projects.remove(project);
    notifyListeners();
  }
}
