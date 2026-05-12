import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/widgets/app_icon_badge.dart';
import 'package:nextcart/core/widgets/glass.dart';
import 'package:nextcart/features/splash/presentation/viewmodels/splash_viewmodel.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  String _route(SplashDestination dest) => switch (dest) {
    SplashDestination.onboarding => Routes.onboarding,
    SplashDestination.auth => Routes.auth,
    SplashDestination.home => Routes.home,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    ref.listen<AsyncValue<SplashDestination>>(splashDestinationProvider, (
      _,
      next,
    ) {
      next.whenData((dest) {
        if (context.mounted) context.go(_route(dest));
      });
    });

    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIconBadge(size: 104, radius: 24),
                const SizedBox(height: 28),
                Text(
                  'NextCart',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Shop simple. Shop happy.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

