import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';
import 'package:nextcart/features/cart/domain/models/cart_item.dart';
import 'package:nextcart/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/price_tag.dart';
import 'package:nextcart/shared/widgets/product_image.dart';
import 'package:nextcart/shared/widgets/quantity_stepper.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartAsync = ref.watch(cartStreamProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final delivery = ref.watch(cartDeliveryFeeProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          if ((cartAsync.value ?? const []).isNotEmpty)
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.trashCan, size: 16),
              tooltip: 'Clear cart',
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: cartAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: FontAwesomeIcons.cartShopping,
              title: 'Your cart is empty',
              message: 'Browse products and add items to get started.',
              actionLabel: 'Start shopping',
              onAction: () => context.go(Routes.home),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 220),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _CartTile(item: items[i]),
          );
        },
      ),
      bottomSheet: (cartAsync.value ?? const []).isEmpty
          ? null
          : SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SummaryRow(label: 'Subtotal', value: subtotal),
                    const SizedBox(height: 4),
                    _SummaryRow(
                      label: 'Delivery',
                      value: delivery,
                      hint: delivery == 0 ? 'Free' : null,
                    ),
                    const Divider(height: 20),
                    _SummaryRow(label: 'Total', value: total, isTotal: true),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.push(Routes.checkout),
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('This will remove all items from your cart.'),
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
      await ref.read(cartControllerProvider.notifier).clear();
    }
  }
}

class _CartTile extends ConsumerWidget {
  const _CartTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(item.id),
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
      onDismissed: (_) =>
          ref.read(cartControllerProvider.notifier).remove(item.id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: ProductImage(
                url: item.image,
                borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(height: 6),
                  PriceTag(price: item.price, dense: true),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      QuantityStepper(
                        value: item.quantity,
                        onChanged: (q) => ref
                            .read(cartControllerProvider.notifier)
                            .setQuantity(item.id, q),
                        dense: true,
                      ),
                      const Spacer(),
                      Text(
                        formatPrice(item.subtotal),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.hint,
    this.isTotal = false,
  });
  final String label;
  final double value;
  final String? hint;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = isTotal
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final valueStyle = isTotal
        ? theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          )
        : theme.textTheme.bodyMedium;
    return Row(
      children: [
        Text(label, style: labelStyle),
        const Spacer(),
        if (hint != null) ...[
          Text(
            hint!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(formatPrice(value), style: valueStyle),
      ],
    );
  }
}
