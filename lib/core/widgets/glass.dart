import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Soft gradient + colored "blobs" used as the canvas behind glass surfaces.
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surface,
            scheme.primaryContainer.withValues(alpha: 0.35),
            scheme.surface,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _Blob(scheme.primary.withValues(alpha: 0.30), 320),
          ),
          Positioned(
            bottom: -140,
            right: -100,
            child: _Blob(scheme.secondary.withValues(alpha: 0.25), 360),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob(this.color, this.size);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

/// Frosted-glass container. Wraps child in a backdrop blur + translucent fill
/// with a hairline highlight border — the iOS "liquid glass" recipe.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding,
    this.blur = 28,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isLight ? 0.55 : 0.10),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: isLight ? 0.7 : 0.18),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Full-width primary CTA pill with a soft glass tint over the seed colour.
class GlassPrimaryButton extends StatelessWidget {
  const GlassPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withValues(alpha: 0.92),
                  scheme.primary.withValues(alpha: 0.78),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(22),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: scheme.onPrimary,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              FaIcon(icon, size: 16, color: scheme.onPrimary),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              label,
                              style: TextStyle(
                                color: scheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
