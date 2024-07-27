import 'package:cashes/app/core/firebase%20configurations/firebase_firebase_manager.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../screens/home/home_screen.dart';
import '../../widget/custom_dialog_widget.dart';

class FirebaseAuthManager {
  static Future<void> createUser(
      {required email,
      required password,
      required name,
      required context}) async {
    try {
      DialogUtls.showLoading(context: context, message: 'Loading...');
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestoreManager.addUserToFireStore(
        user: AppUser(id: credential.user!.uid, email: email, name: name),
      );
      await FirebaseAuth.instance.signOut();
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context, message: 'Registered Successfully');
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(
            context: context, message: 'The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(
            context: context,
            message: 'The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(context: context, message: e.toString());
    }
  }

  static Future<void> login(
      {required email, required password, required context}) async {
    DialogUtls.showLoading(context: context, message: 'Loading...');
    try {
      var authProvider = Provider.of<AuthManagerProvider>(context,
          listen:
              false); // when you call the provider outside the build add listen:false
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // print(credential.user!.uid);
      DialogUtls.hideLoading(context: context);
      DialogUtls.showMessage(
          context: context, message: 'Successfully Loged In');
      var myCurrentUser =
          await FirebaseFirestoreManager.getUser(userId: credential.user!.uid);
      if (myCurrentUser != null) {
        authProvider.updateUser(myCurrentUser);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(
            context: context, message: 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(
            context: context,
            message: 'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      } else {
        DialogUtls.hideLoading(context: context);
        DialogUtls.showMessage(context: context, message: e.toString());
      }
    }
  }

  // TODO: How?
  static void checkUserState(
      {required context, required AuthManagerProvider authProvider}) {
    FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        var myCurrentUser =
            await FirebaseFirestoreManager.getUser(userId: user.uid);
        authProvider.updateUser(myCurrentUser);
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        } else {
          print('Context is no longer valid');
        }
        print('User is signed in!');
      }
    });
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
