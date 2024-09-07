import 'package:cashes/app/core/theme.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/firebase configurations/firebase_auth_manager.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      print('Device is connected to the internet');
      if (mounted) {
        Future.delayed(
          const Duration(seconds: 2),
          () {
            if (mounted) {
              AuthManagerProvider authProvider =
                  Provider.of<AuthManagerProvider>(context, listen: false);
              FirebaseAuthManager.checkUserState(
                  context: context, authProvider: authProvider);
            }
          },
        );
      }
    } else {
      print('Device is not connected to the internet');
      if (mounted) {
        _showNoInternetDialog();
      }
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.noInternet),
          content: Text(AppLocalizations.of(context)!.internetFail),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkConnection(); // Retry on button press
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}
