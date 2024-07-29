import 'package:flutter/material.dart';

import '../core/theme.dart';

Widget imageCard({
  required ImageProvider image,
  required String name,
  required BuildContext context,
}) {
  return AspectRatio(
    aspectRatio: 2 / 3,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image layer
            Image(
              image: image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child; // Display the image once loaded
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ); // Show a progress indicator while loading
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ); // Show an error icon if image fails to load
              },
            ),
            // Gradient overlay and text
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  stops: const [0.3, 0.9],
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 15),
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
