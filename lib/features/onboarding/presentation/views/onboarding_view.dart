import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/core/storage/local_storage.dart';
import 'package:nextcart/core/widgets/glass.dart';
import 'package:nextcart/features/onboarding/presentation/viewmodels/onboarding_viewmodel.dart';
import 'package:nextcart/features/splash/presentation/viewmodels/splash_viewmodel.dart';

class _Slide {
  const _Slide(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}

const _slides = <_Slide>[
  _Slide(
    FontAwesomeIcons.bagShopping,
    'Shop the essentials',
    'Hand-picked products from local brands, delivered to your door.',
  ),
  _Slide(
    FontAwesomeIcons.bolt,
    'Fast, friendly delivery',
    'Track every order from confirmed to delivered in real time.',
  ),
  _Slide(
    FontAwesomeIcons.moneyBillWave,
    'Cash on Delivery',
    'Pay when your order arrives — no cards, no fuss.',
  ),
];

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final secure = ref.read(secureStorageProvider);
    await secure.write(key: onboardingSeenKey, value: 'true');
    if (!mounted) return;
    final loggedIn = ref.read(firebaseAuthProvider).currentUser != null;
    context.go(loggedIn ? Routes.home : Routes.auth);
  }

  void _next() {
    final page = ref.read(onboardingPageProvider);
    if (page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final page = ref.watch(onboardingPageProvider);
    final isLast = page == _slides.length - 1;

    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _finish,
                    style: TextButton.styleFrom(
                      foregroundColor: scheme.onSurfaceVariant,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (i) =>
                        ref.read(onboardingPageProvider.notifier).set(i),
                    itemCount: _slides.length,
                    itemBuilder: (_, i) {
                      final s = _slides[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GlassSurface(
                              radius: 32,
                              padding: const EdgeInsets.all(32),
                              child: FaIcon(
                                s.icon,
                                size: 56,
                                color: scheme.primary,
                              ),
                            ),
                            const SizedBox(height: 36),
                            Text(
                              s.title,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: scheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              s.subtitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _Dots(count: _slides.length, current: page),
                const SizedBox(height: 28),
                GlassPrimaryButton(
                  label: isLast ? 'Get Started' : 'Next',
                  onPressed: _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 28 : 8,
          decoration: BoxDecoration(
            color: active
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
