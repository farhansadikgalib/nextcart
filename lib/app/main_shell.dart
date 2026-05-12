import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  Future<void> _handleBack(BuildContext context, int index) async {
    if (index != 0) {
      navigationShell.goBranch(0);
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
    final index = navigationShell.currentIndex;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

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
        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
          child: GNav(
            selectedIndex: index,
            onTabChange: (i) {
              HapticFeedback.lightImpact();
              navigationShell.goBranch(i, initialLocation: i == index);
            },
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            tabBorderRadius: 14,
            duration: const Duration(milliseconds: 300),
            color: scheme.onSurfaceVariant,
            activeColor: scheme.primary,
            tabBackgroundColor: scheme.primaryContainer.withValues(alpha: 0.4),
            iconSize: 18,
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: scheme.primary,
            ),
            tabs: [
              GButton(
                icon: FontAwesomeIcons.house,
                text: 'Home',
              ),
              GButton(
                icon: FontAwesomeIcons.tableCellsLarge,
                text: 'Categories',
              ),
              GButton(
                icon: FontAwesomeIcons.cartShopping,
                text: 'Cart',
                leading: cartCount > 0
                    ? Badge.count(
                        count: cartCount,
                        child: FaIcon(
                          FontAwesomeIcons.cartShopping,
                          size: 18,
                          color: index == 2
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                      )
                    : null,
              ),
              GButton(
                icon: FontAwesomeIcons.user,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
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
