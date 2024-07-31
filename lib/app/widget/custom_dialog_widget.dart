import 'package:flutter/material.dart';

import '../core/theme.dart';

class DialogUtls {
  static void showLoading(
      {required BuildContext context, required String message}) {
    showDialog(
      barrierDismissible: false, // to not close the dialog
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: AppTheme.primaryColor),
              const SizedBox(width: 10),
              Text(
                message,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        );
      },
    );
  }

  static void hideLoading({required BuildContext context}) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String? title,
    String? posActionTitle,
    Function? posActionFucntion,
    String? negActionTitle,
    Function? negActionFucntion,
  }) {
    List<Widget> actions = [];
    if (posActionTitle != null) {
      actions.add(
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            posActionFucntion!.call();
          },
          child: Text(
            posActionTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      );
    }
    if (negActionTitle != null) {
      actions.add(
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            negActionFucntion!.call();
          },
          child: Text(
            negActionTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      );
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title == null
                ? null
                : Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
            content: Text(
              message,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            // actions: actions,
          );
        });
  }

  static void showDeleteConfirmationDialog(
      {required BuildContext context, deleteFunction}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteFunction();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Deleted successfully',
                      textDirection: TextDirection.ltr,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
