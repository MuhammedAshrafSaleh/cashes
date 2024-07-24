import 'package:flutter/material.dart';

import '../core/theme.dart';

// ignore: must_be_immutable
class CustomTextButton extends StatelessWidget {
  CustomTextButton(
      {super.key,
      required this.onPressed,
      required this.text1,
      required this.text2});
  void Function()? onPressed;
  String text1;
  String text2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text1,
          style: const TextStyle(color: AppTheme.primaryColor),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text2,
            style: const TextStyle(color: AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }
}
