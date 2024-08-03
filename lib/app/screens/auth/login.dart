import 'package:cashes/app/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/firebase configurations/firebase_auth_manager.dart';
import '../../core/regex.dart';
import '../../core/theme.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_text_btn.dart';
import '../../widget/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  static const routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: What is SchedulerBinding ?
    // TODO: Login Screen Is Shown and then going to the Home Screen
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // AuthManagerProvider authProvider =
      //     Provider.of<AuthManagerProvider>(context, listen: false);
      // FirebaseAuthManager.checkUserState(
      //     context: context, authProvider: authProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 100,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                 AppLocalizations.of(context)!.login,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                 Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: _emailController,
                        text: AppLocalizations.of(context)!.email,
                        keyboardType: TextInputType.emailAddress,
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return  AppLocalizations.of(context)!
                                .emailValidation;
                          }
                          if (!RegEx.validateEmail(value)) {
                            return AppLocalizations.of(context)!.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: _passwordController,
                        text: AppLocalizations.of(context)!.password,
                        hasIcon: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return  AppLocalizations.of(context)!
                                .passwordValidation;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomBtn(
                        text: AppLocalizations.of(context)!.logIn,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirebaseAuthManager.login(
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            _emailController.clear();
                            _passwordController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                CustomTextButton(
                  text1: AppLocalizations.of(context)!.dontHaveAccount,
                  text2: AppLocalizations.of(context)!.register,
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
