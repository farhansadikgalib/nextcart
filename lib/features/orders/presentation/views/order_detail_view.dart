import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/features/orders/data/firebase_order_repository.dart';
import 'package:nextcart/features/orders/domain/models/app_order.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/price_tag.dart';
import 'package:nextcart/shared/widgets/product_image.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class OrderDetailView extends ConsumerWidget {
  const OrderDetailView({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order details'),
        leading: const IosBackButton(),
      ),
      body: orderAsync.when(
        loading: () => const OrderDetailSkeleton(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (order) {
          if (order == null) {
            return const EmptyState(
              icon: FontAwesomeIcons.fileCircleQuestion,
              title: 'Order not found',
              message: 'This order may no longer exist.',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.gift,
                      color: theme.colorScheme.primary,
                      size: 26,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thank you for your order!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please keep ${formatPrice(order.total)} in cash ready on delivery.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Section(title: 'Status', child: _Timeline(status: order.status)),
              const SizedBox(height: 24),
              _Section(
                title: 'Delivery to',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.customerName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 4),
                    Text(order.deliveryPhone),
                    const SizedBox(height: 4),
                    Text('${order.deliveryAddress}, ${order.city}'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Section(
                title: 'Items',
                child: Column(
                  children: [
                    for (final item in order.items) ...[
                      Row(
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: ProductImage(
                              url: item.image,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.quantity} × ${formatPrice(item.price)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatPrice(item.lineTotal),
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                    ],
                    Row(
                      children: [
                        const Text('Subtotal'),
                        const Spacer(),
                        Text(formatPrice(order.subtotal)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Delivery'),
                        const Spacer(),
                        Text(formatPrice(order.deliveryFee)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatPrice(order.total),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.moneyBillWave,
                          color: theme.colorScheme.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cash on Delivery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go(Routes.home),
                  child: const Text('Continue shopping'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});
  final OrderStatus status;

  static const _track = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.shipped,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (status == OrderStatus.cancelled) {
      return Row(
        children: [
          FaIcon(
            FontAwesomeIcons.circleXmark,
            size: 18,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Text(
            'Cancelled',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }
    final currentIdx = _track.indexOf(status);
    return Column(
      children: List.generate(_track.length, (i) {
        final done = i <= currentIdx;
        final isLast = i == _track.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: done
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: done
                        ? Center(
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              size: 9,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: done
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _track[i].label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: done ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

