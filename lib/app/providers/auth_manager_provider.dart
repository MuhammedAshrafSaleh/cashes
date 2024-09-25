import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/models/app_user.dart';
import 'package:flutter/material.dart';

class AuthManagerProvider extends ChangeNotifier {
  AppUser? currentUser;
  List<AppUser> users = [];
  void updateUser(AppUser? newUser) {
    currentUser = newUser;
    notifyListeners();
  }

  void fetchUsers() async {
    users = await FirebaseFirestoreManager.getAllUsers();
    // Do something with the list of users
    for (var user in users) {
      print(user.name);
    }
    notifyListeners();
  }
}
