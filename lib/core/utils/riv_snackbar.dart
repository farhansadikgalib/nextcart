import 'package:flutter/material.dart';

/// A simple, reusable snackbar utility.
///
/// ```dart
/// Riv.snackbar(
///   context,
///   title: 'Success',
///   subtitle: 'Your changes have been saved.',
///   color: Colors.green,
/// );
/// ```
class Riv {
  Riv._();

  static void snackbar(
    BuildContext context, {
    required String title,
    String? subtitle,
    Color? color,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final bgColor = color ?? theme.colorScheme.primary;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: duration,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
  }
}
