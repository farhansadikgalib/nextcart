import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/features/orders/data/firebase_order_repository.dart';
import 'package:nextcart/features/orders/domain/models/app_order.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/price_tag.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class OrderView extends ConsumerWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: const IosBackButton(),
      ),
      body: ordersAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (orders) {
          if (orders.isEmpty) {
            return EmptyState(
              icon: FontAwesomeIcons.receipt,
              title: 'No orders yet',
              message: 'Your past orders will appear here.',
              actionLabel: 'Start shopping',
              onAction: () => context.go(Routes.home),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _OrderTile(order: orders[i]),
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final AppOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = order.createdAt == null
        ? '—'
        : DateFormat('d MMM y · h:mm a').format(order.createdAt!);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () =>
          GoRouter.of(context).push(Routes.orderDetailPath(order.id)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id.substring(0, order.id.length.clamp(0, 6))}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  formatPrice(order.total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final OrderStatus status;

  Color _bg(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      OrderStatus.pending => scheme.secondaryContainer,
      OrderStatus.confirmed => scheme.tertiaryContainer,
      OrderStatus.shipped => scheme.primaryContainer,
      OrderStatus.delivered => scheme.primary,
      OrderStatus.cancelled => scheme.errorContainer,
    };
  }

  Color _fg(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      OrderStatus.pending => scheme.onSecondaryContainer,
      OrderStatus.confirmed => scheme.onTertiaryContainer,
      OrderStatus.shipped => scheme.onPrimaryContainer,
      OrderStatus.delivered => scheme.onPrimary,
      OrderStatus.cancelled => scheme.onErrorContainer,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg(context),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _fg(context),
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
