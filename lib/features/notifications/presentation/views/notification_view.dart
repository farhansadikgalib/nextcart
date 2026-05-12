import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/features/notifications/data/firebase_notification_repository.dart';
import 'package:nextcart/features/notifications/domain/models/app_notification.dart';
import 'package:nextcart/features/orders/domain/models/app_order.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const IosBackButton(),
        title: const Text('Notifications'),
        actions: [
          if ((notificationsAsync.value ?? const []).isNotEmpty)
            PopupMenuButton<String>(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 16),
              onSelected: (value) {
                final uid =
                    ref.read(firebaseAuthProvider).currentUser?.uid;
                if (uid == null) return;
                final repo = ref.read(notificationRepositoryProvider);
                if (value == 'read_all') {
                  repo.markAllAsRead(uid);
                } else if (value == 'clear_all') {
                  _confirmClear(context, ref);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'read_all',
                  child: Text('Mark all as read'),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Text('Clear all'),
                ),
              ],
            ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyState(
              icon: FontAwesomeIcons.bellSlash,
              title: 'No notifications',
              message: 'You\'ll be notified when your order status changes.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) =>
                _NotificationTile(notification: notifications[i]),
          );
        },
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all notifications?'),
        content: const Text('This will remove all your notifications.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (yes ?? false) {
      final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (uid == null) return;
      await ref.read(notificationRepositoryProvider).clearAll(uid);
    }
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});
  final AppNotification notification;

  IconData _statusIcon(String status) {
    return switch (OrderStatus.parse(status)) {
      OrderStatus.confirmed => FontAwesomeIcons.circleCheck,
      OrderStatus.shipped => FontAwesomeIcons.truck,
      OrderStatus.delivered => FontAwesomeIcons.boxOpen,
      OrderStatus.cancelled => FontAwesomeIcons.circleXmark,
      _ => FontAwesomeIcons.bell,
    };
  }

  Color _statusColor(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;
    return switch (OrderStatus.parse(status)) {
      OrderStatus.confirmed => Colors.blue,
      OrderStatus.shipped => Colors.purple,
      OrderStatus.delivered => scheme.primary,
      OrderStatus.cancelled => scheme.error,
      _ => Colors.orange,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = _statusColor(context, notification.newStatus);
    final date = notification.createdAt == null
        ? ''
        : _formatTimeAgo(notification.createdAt!);

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: FaIcon(
          FontAwesomeIcons.trashCan,
          size: 18,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) {
        final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
        if (uid == null) return;
        ref
            .read(notificationRepositoryProvider)
            .delete(uid, notification.id);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Mark as read on tap.
          if (!notification.isRead) {
            final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
            if (uid != null) {
              ref
                  .read(notificationRepositoryProvider)
                  .markAsRead(uid, notification.id);
            }
          }
          // Navigate to order detail.
          if (notification.orderId.isNotEmpty) {
            context.push(Routes.orderDetailPath(notification.orderId));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? theme.colorScheme.surface
                : color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? theme.colorScheme.outlineVariant.withValues(alpha: 0.5)
                  : color.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    _statusIcon(notification.newStatus),
                    size: 16,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (date.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 10,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('d MMM y').format(dateTime);
  }
}
