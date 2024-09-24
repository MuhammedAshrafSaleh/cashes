import 'package:cashes/app/core/firebase%20configurations/firebase_auth_manager.dart';
import 'package:cashes/app/core/regex.dart';
import 'package:cashes/app/screens/auth/login.dart';
import 'package:cashes/app/widget/custom_btn.dart';
import 'package:cashes/app/widget/custom_dialog_widget.dart';
import 'package:cashes/app/widget/custom_textfield.dart';
import 'package:cashes/app/widget/snakebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForegetPasswordScreen extends StatefulWidget {
  static const routeName = 'ForegetPasswordScreen';
  const ForegetPasswordScreen({super.key});

  @override
  State<ForegetPasswordScreen> createState() => _ForegetPasswordScreenState();
}

class _ForegetPasswordScreenState extends State<ForegetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset("assets/images/forgot-password.png"),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.emailValidation;
                        }
                        if (!RegEx.validateEmail(value)) {
                          return AppLocalizations.of(context)!.invalidEmail;
                        }
                        return null;
                      },
                      text: AppLocalizations.of(context)!.email,
                      hasIcon: false,
                    ),
                    const SizedBox(height: 20),
                    CustomBtn(
                      text: "إرسال ايميل",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          DialogUtls.showLoading(
                              context: context,
                              message: AppLocalizations.of(context)!.loading);
                          await FirebaseAuthManager.resetPassword(
                            email: emailController.text.trim(),
                          );
                          DialogUtls.hideLoading(context: context);
                          DialogUtls.showMessage(
                              context: context,
                              message: "تم إرسال رسالة إلى بريدك الخاص");
                          showSnackBar(
                            // content: "Email has been sent your email",
                            content: "يرجى فحص بريدك الألكترونى",
                            context: context,
                          );
                          emailController.clear();
                          Navigator.pushReplacementNamed(
                            context,
                            LoginScreen.routeName,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
