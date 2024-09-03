import 'package:cashes/app/core/theme.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/cash_provider.dart';
import 'package:cashes/app/providers/clients_transefer_provider.dart';
import 'package:cashes/app/providers/project_provider.dart';
import 'package:cashes/app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app/screens/auth/login.dart';
import 'app/screens/auth/register.dart';
import 'app/screens/cash/cash_screen.dart';
import 'app/screens/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBrvayavi4ct8opgoxVgFPfEc0zjbm_AO0',
      appId: "1:532663268674:android:77ab54ae0eb3789d61c4db",
      messagingSenderId: '532663268674',
      projectId: 'cashes-ce55e',
      storageBucket: 'cashes-ce55e.appspot.com',
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthManagerProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
        ChangeNotifierProvider(create: (context) => CashProvider()),
        ChangeNotifierProvider(create: (context) => ClientsTranseferProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightMode,
      initialRoute: SplashScreen.routeName,
      routes: {
        RegisterScreen.routeName: (_) => RegisterScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        CashScreen.routeName: (_) => const CashScreen(),
        SplashScreen.routeName: (_) => const SplashScreen(),
      },
      locale: Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
// TODO: Which is best ? To using futureBuilding
// TODO: Why Context is confilet with me