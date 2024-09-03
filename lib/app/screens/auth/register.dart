import 'package:flutter/material.dart';

import '../../core/firebase configurations/firebase_auth_manager.dart';
import '../../core/regex.dart';
import '../../core/theme.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_text_btn.dart';
import '../../widget/custom_textfield.dart';
import 'login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  static const routeName = 'RegisterScreen';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();
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
                  AppLocalizations.of(context)!.register,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor),
                ),
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: _nameController,
                        text: AppLocalizations.of(context)!.name,
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.nameValidation;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: _emailController,
                        text: AppLocalizations.of(context)!.email,
                        keyboardType: TextInputType.emailAddress,
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
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
                            return AppLocalizations.of(context)!
                                .passwordValidation;
                          }
                          if (value.length < 6) {
                            return AppLocalizations.of(context)!.lessPassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: _confirmedPasswordController,
                        text: AppLocalizations.of(context)!.confirmPassword,
                        hasIcon: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .confirmPasswordValidation;
                          } else if (value != _passwordController.text) {
                            return 'Passwords dose not matched';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomBtn(
                        text: AppLocalizations.of(context)!.register,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FirebaseAuthManager.createUser(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context);

                            _emailController.clear();
                            _passwordController.clear();
                            _nameController.clear();
                            _confirmedPasswordController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                CustomTextButton(
                    text1: AppLocalizations.of(context)!.alreadyHaveAccount,
                    text2: AppLocalizations.of(context)!.logIn,
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
