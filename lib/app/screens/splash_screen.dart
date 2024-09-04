import 'package:cashes/app/core/theme.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/firebase configurations/firebase_auth_manager.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      AuthManagerProvider authProvider =
          Provider.of<AuthManagerProvider>(context, listen: false);
      FirebaseAuthManager.checkUserState(
          context: context, authProvider: authProvider);
    });

    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/zmzm_logo.png",
                  width: 300,
                ),
              ),
              const CircularProgressIndicator(color: AppTheme.primaryColor),
            ],
          ),
        ));
  }
}
