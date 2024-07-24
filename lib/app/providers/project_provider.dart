import 'package:flutter/material.dart';

import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List cashes = [];
  List<Project> projects = [];

  void addProject(Project project) {
    // print("=================================");
    // print(project.id);
    // print(project.name);
    // print(project.money);
    // print("=================================");
    projects.add(project);
    notifyListeners();
  }

  void updateProject({required Project project}) {
    projects[projects.indexWhere((oldProject) => oldProject.id == project.id)] =
        project;
    notifyListeners();
  }

  void deleteProject(Project project) {
    projects.remove(project);
    notifyListeners();
  }
}
