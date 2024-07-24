import 'package:cashes/app/models/app_user.dart';
import 'package:flutter/material.dart';

class AuthManagerProvider extends ChangeNotifier {
  AppUser? currentUser;
  
  void updateUser(AppUser? newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
