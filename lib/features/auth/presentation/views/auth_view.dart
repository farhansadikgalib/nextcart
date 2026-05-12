import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextcart/core/widgets/app_icon_badge.dart';
import 'package:nextcart/core/widgets/glass.dart';
import 'package:nextcart/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: scheme.errorContainer,
              content: Text(
                err.toString(),
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const AppIconBadge(size: 112, radius: 26),
                const SizedBox(height: 32),
                Text(
                  'Welcome to NextCart',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to start shopping, manage your cart,\nand track orders.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                GlassPrimaryButton(
                  label: state.isLoading
                      ? 'Signing in…'
                      : 'Continue with Google',
                  iconWidget: state.isLoading
                      ? null
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/icon/icon.png',
                            width: 20,
                            height: 20,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                  isLoading: state.isLoading,
                  onPressed: () => ref
                      .read(authControllerProvider.notifier)
                      .signInWithGoogle(),
                ),
                const SizedBox(height: 14),
                Text(
                  'By continuing you agree to our Terms and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
