import 'package:flutter/material.dart';

import '../../core/firebase configurations/firebase_auth_manager.dart';
import '../../core/regex.dart';
import '../../core/theme.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_text_btn.dart';
import '../../widget/custom_textfield.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  static const routeName = 'RegisterScreen';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: 'a@gmail.com');
  final TextEditingController _nameController =
      TextEditingController(text: 'Ashraf');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');
  final TextEditingController _confirmedPasswordController =
      TextEditingController(text: '123456');
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
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor),
                ),
                const Text(
                  'Zmzm Invoices',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CustomTextFormField(
                        controller: _nameController,
                        text: 'Name',
                        hasIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
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
                      CustomTextFormField(
                        controller: _confirmedPasswordController,
                        text: 'Confirm Password',
                        hasIcon: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your confirm password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords dose not matched';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomBtn(
                        text: 'Sign Up',
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
                    text1: 'Don’t have an account?',
                    text2: 'Log In',
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
