import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';
import 'package:nextcart/features/products/data/firebase_product_repository.dart';
import 'package:nextcart/features/wishlist/data/firebase_wishlist_repository.dart';
import 'package:nextcart/features/wishlist/domain/models/wishlist_item.dart';
import 'package:nextcart/features/wishlist/presentation/viewmodels/wishlist_viewmodel.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/price_tag.dart';
import 'package:nextcart/shared/widgets/product_image.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class WishlistView extends ConsumerWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistStreamProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const IosBackButton(),
        title: const Text('Wishlist'),
        actions: [
          if ((wishlistAsync.value ?? const []).isNotEmpty)
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.trashCan, size: 16),
              tooltip: 'Clear wishlist',
              onPressed: () => _confirmClear(context, ref),
            ),
        ],
      ),
      body: wishlistAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: FontAwesomeIcons.heart,
              title: 'Your wishlist is empty',
              message: 'Save items you love to find them easily later.',
              actionLabel: 'Browse products',
              onAction: () => context.go(Routes.home),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _WishlistTile(item: items[i]),
          );
        },
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear wishlist?'),
        content:
            const Text('This will remove all items from your wishlist.'),
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
      await ref.read(wishlistControllerProvider.notifier).clear();
    }
  }
}

class _WishlistTile extends ConsumerWidget {
  const _WishlistTile({required this.item});
  final WishlistItem item;

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
          ref.read(wishlistControllerProvider.notifier).remove(item.id),
      child: GestureDetector(
        onTap: () => context.push(Routes.productDetailPath(item.productId)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
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
                    PriceTag(
                      price: item.price,
                      originalPrice: item.originalPrice,
                      discountPercent: item.discountPercent,
                      dense: true,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _AddToCartButton(item: item),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(wishlistControllerProvider.notifier)
                                .remove(item.id);
                          },
                          child: FaIcon(
                            FontAwesomeIcons.solidHeart,
                            size: 18,
                            color: theme.colorScheme.error,
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
      ),
    );
  }
}

class _AddToCartButton extends ConsumerWidget {
  const _AddToCartButton({required this.item});
  final WishlistItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
        onPressed: () async {
          HapticFeedback.mediumImpact();
          final uid =
              ref.read(firebaseAuthProvider).currentUser?.uid;
          if (uid == null) return;
          final product =
              await ref.read(productByIdProvider(item.productId).future);
          if (product == null) return;
          await ref
              .read(cartRepositoryProvider)
              .addOrIncrement(uid, product);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.title} added to cart'),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(12),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: const FaIcon(FontAwesomeIcons.cartPlus, size: 12),
        label: const Text('Add to Cart'),
      );
  }
}
