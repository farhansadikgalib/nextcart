import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/theme/app_theme.dart';
import 'package:nextcart/features/auth/data/firebase_auth_repository.dart';
import 'package:nextcart/features/auth/domain/models/app_user.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';
import 'package:nextcart/features/orders/data/firebase_order_repository.dart';
import 'package:nextcart/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final userAsync = ref.watch(currentAppUserProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final ordersCount = ref
        .watch(ordersStreamProvider)
        .maybeWhen(data: (o) => o.length, orElse: () => 0);
    final cartCount = ref
        .watch(cartStreamProvider)
        .maybeWhen(
          data: (c) => c.fold<int>(0, (s, x) => s + x.quantity),
          orElse: () => 0,
        );

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: userAsync.when(
        loading: () => const ProfileSkeleton(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _Hero(user: user, orders: ordersCount, cartItems: cartCount),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  children: [
                    _Section(
                      title: 'Preferences',
                      child: _ThemeRow(
                        mode: themeMode,
                        onChanged: (m) => ref
                            .read(themeModeControllerProvider.notifier)
                            .setMode(m),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Section(
                      title: 'Account',
                      padded: false,
                      child: Column(
                        children: [
                          _Tile(
                            icon: FontAwesomeIcons.receipt,
                            title: 'My Orders',
                            trailing: ordersCount == 0
                                ? null
                                : Text('$ordersCount'),
                            onTap: () => context.push(Routes.orders),
                          ),
                          _Tile(
                            icon: FontAwesomeIcons.locationDot,
                            title: 'Address',
                            onTap: () => context.push(Routes.address),
                          ),
                          _Tile(
                            icon: FontAwesomeIcons.shieldHalved,
                            title: 'Privacy Policy',
                            onTap: () => context.push(Routes.privacy),
                          ),
                          _Tile(
                            icon: FontAwesomeIcons.lifeRing,
                            title: 'Help & Support',
                            onTap: () => context.push(Routes.help),
                          ),
                          _Tile(
                            icon: FontAwesomeIcons.fileLines,
                            title: 'Terms',
                            onTap: () => context.push(Routes.terms),
                          ),
                          const Divider(height: 1),
                          _Tile(
                            icon: FontAwesomeIcons.rightFromBracket,
                            title: 'Sign out',
                            danger: true,
                            onTap: () => _confirmSignOut(context, ref),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'NextCart · v1.0.0',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign out?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "You'll need to sign back in to shop.",
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
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          side: BorderSide(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: const Text('Sign out'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (yes != true) return;
    try {
      // Call the repository directly — it's keepAlive, so no risk of the
      // notifier being autodisposed during the await and throwing when
      // setting state. The router's authStateChanges listener handles the
      // redirect to /auth once Firebase clears the session.
      await ref.read(authRepositoryProvider).signOut();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Sign out failed: $e'),
        ),
      );
    }
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.user,
    required this.orders,
    required this.cartItems,
  });
  final AppUser user;
  final int orders;
  final int cartItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, Color(0xFFA2CB8B)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _Avatar(photoUrl: user.photoUrl, size: 84),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  _StatTile(label: 'Orders', value: '$orders'),
                  _Divider(),
                  _StatTile(label: 'Cart', value: '$cartItems'),
                  _Divider(),
                  _StatTile(label: 'Saved', value: '—'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl, required this.size});
  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: (photoUrl == null || photoUrl!.isEmpty)
            ? Container(
                color: Colors.white,
                child: const FaIcon(
                  FontAwesomeIcons.user,
                  color: AppTheme.primary,
                  size: 36,
                ),
              )
            : CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(color: Colors.white),
                errorWidget: (_, _, _) => Container(
                  color: Colors.white,
                  child: const FaIcon(
                    FontAwesomeIcons.user,
                    color: AppTheme.primary,
                    size: 36,
                  ),
                ),
              ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.padded = true,
  });
  final String title;
  final Widget child;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, padded ? 6 : 0),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: padded
                ? const EdgeInsets.fromLTRB(16, 8, 16, 16)
                : EdgeInsets.zero,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.danger = false,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = danger
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: 28,
        child: Center(child: FaIcon(icon, color: color, size: 18)),
      ),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      trailing: trailing != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                trailing!,
                const SizedBox(width: 10),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            )
          : FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  const _ThemeRow({required this.mode, required this.onChanged});
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.circleHalfStroke,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 12),
        const Expanded(child: Text('Appearance')),
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: ThemeMode.system,
              icon: FaIcon(FontAwesomeIcons.circleHalfStroke, size: 14),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              icon: FaIcon(FontAwesomeIcons.sun, size: 14),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              icon: FaIcon(FontAwesomeIcons.moon, size: 14),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}
