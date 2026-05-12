import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _tabs = <_TabSpec>[
    _TabSpec(Routes.home, FontAwesomeIcons.house, 'Home'),
    _TabSpec(Routes.categories, FontAwesomeIcons.tableCellsLarge, 'Categories'),
    _TabSpec(Routes.cart, FontAwesomeIcons.cartShopping, 'Cart'),
    _TabSpec(Routes.profile, FontAwesomeIcons.user, 'Profile'),
  ];

  int _currentIndex(String location) {
    for (var i = _tabs.length - 1; i >= 0; i--) {
      if (location == _tabs[i].path ||
          location.startsWith('${_tabs[i].path}/')) {
        return i;
      }
    }
    return 0;
  }

  Future<void> _handleBack(BuildContext context, int index) async {
    if (index != 0) {
      // Not on Home → first back press goes to Home.
      context.go(Routes.home);
      return;
    }
    final exit = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _ExitDialog(),
    );
    if (exit ?? false) {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).matchedLocation;
    final index = _currentIndex(location);

    // Sum of quantities across cart items — that's the badge number shoppers
    // expect (NOT distinct items).
    final cartCount = ref
        .watch(cartStreamProvider)
        .maybeWhen(
          data: (items) => items.fold<int>(0, (sum, c) => sum + c.quantity),
          orElse: () => 0,
        );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack(context, index);
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) {
            if (i == index) return;
            context.go(_tabs[i].path);
          },
          destinations: [
            for (var i = 0; i < _tabs.length; i++)
              NavigationDestination(
                icon: _maybeBadged(
                  FaIcon(
                    _tabs[i].icon,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
                  count: _tabs[i].path == Routes.cart ? cartCount : 0,
                ),
                selectedIcon: _maybeBadged(
                  FaIcon(_tabs[i].icon, size: 18, color: scheme.primary),
                  count: _tabs[i].path == Routes.cart ? cartCount : 0,
                ),
                label: _tabs[i].label,
              ),
          ],
        ),
      ),
    );
  }

  Widget _maybeBadged(Widget child, {required int count}) {
    if (count <= 0) return child;
    return Badge.count(count: count, child: child);
  }
}

class _TabSpec {
  const _TabSpec(this.path, this.icon, this.label);
  final String path;
  final IconData icon;
  final String label;
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Exit NextCart?',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You can re-open the app any time to keep shopping.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(
                        color: theme.colorScheme.error.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Text('Exit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
