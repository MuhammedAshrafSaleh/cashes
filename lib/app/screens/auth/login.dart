import 'package:cashes/app/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/firebase configurations/firebase_auth_manager.dart';
import '../../core/regex.dart';
import '../../core/theme.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_text_btn.dart';
import '../../widget/custom_textfield.dart';

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
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'Zmzm Invoices',
                  style: TextStyle(
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
                        text: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegEx.validateEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: _passwordController,
                        text: 'Password',
                        hasIcon: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomBtn(
                        text: 'Login',
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
                  text1: 'Don’t have an account?',
                  text2: 'Register Now',
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
