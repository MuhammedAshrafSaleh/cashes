import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/models/app_user.dart';
import 'package:cashes/app/models/project.dart';
import 'package:flutter/material.dart';

class AuthManagerProvider extends ChangeNotifier {
  AppUser? currentUser;
  List<AppUser> users = [];
  List<Map<AppUser, Project>> notifications = [];
  // List<Map<String, String>> noticationsText = [];
  void updateUser(AppUser? newUser) {
    currentUser = newUser;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    users = await FirebaseFirestoreManager.getAllUsers();
    notifications = [];
    // Do something with the list of users
    for (var user in users) {
      var projects = await FirebaseFirestoreManager.getAllProjectByUserId(
          userId: user.id!);
      for (var project in projects) {
        if (project.hasNotification == "تم الاضافة" ||
            project.hasNotification == 'تم التعديل') {
          notifications.add({user: project});
          print(
              "${user.name} : ${project.hasNotification} بند فى عهدة ${project.name}");
        }
      }
    }
    print(notifications.length);
    notifyListeners();
  }

  Future<void> removeNotification(Project project, AppUser user) async {
    project.hasNotification = null;
    await FirebaseFirestoreManager.updateProject(
      project: project,
      userId: user.id,
    );
    fetchUsers();
  }
}
