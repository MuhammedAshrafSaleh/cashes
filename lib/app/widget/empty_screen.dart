import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EmptyScreen extends StatelessWidget {
  EmptyScreen({super.key, required this.message});
  String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/no_data.jpg"),
        Text(message, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
