import 'package:flutter/material.dart';

/// Renders `assets/icon/icon.png` (the launcher artwork) as an iOS-style
/// rounded square with a soft drop shadow. Used by splash and auth so the
/// in-app hero matches the home-screen icon exactly.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({super.key, this.size = 104, this.radius = 24});

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/icon/icon.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
