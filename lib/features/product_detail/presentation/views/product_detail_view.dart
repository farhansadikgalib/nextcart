import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';
import 'package:nextcart/features/product_detail/presentation/viewmodels/product_detail_viewmodel.dart';
import 'package:nextcart/features/products/data/firebase_product_repository.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/features/wishlist/presentation/viewmodels/wishlist_viewmodel.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/price_tag.dart';
import 'package:nextcart/shared/widgets/product_image.dart';
import 'package:nextcart/shared/widgets/quantity_stepper.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  const ProductDetailView({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  int _imageIndex = 0;

  String? _uid() => ref.read(firebaseAuthProvider).currentUser?.uid;

  Future<void> _addToCart(Product product, int qty) async {
    final uid = _uid();
    if (uid == null) return;
    HapticFeedback.mediumImpact();
    await ref
        .read(cartRepositoryProvider)
        .addOrIncrement(uid, product, qty: qty);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  Future<void> _buyNow(Product product, int qty) async {
    final uid = _uid();
    if (uid == null) return;
    HapticFeedback.mediumImpact();
    await ref
        .read(cartRepositoryProvider)
        .addOrIncrement(uid, product, qty: qty);
    if (!mounted) return;
    context.push(Routes.checkout);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final productAsync = ref.watch(productByIdProvider(widget.productId));
    final qty = ref.watch(productQuantityProvider(widget.productId));

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      extendBodyBehindAppBar: true,
      body: productAsync.when(
        loading: () => const ProductDetailSkeleton(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(productByIdProvider(widget.productId)),
        ),
        data: (product) {
          if (product == null) {
            return const EmptyState(
              icon: FontAwesomeIcons.boxOpen,
              title: 'Product not found',
              message: 'This product may have been removed.',
            );
          }
          final images =
              product.images.isEmpty ? <String>[''] : product.images;
          final savings = product.originalPrice - product.price;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 380,
                backgroundColor: scheme.surface,
                foregroundColor: scheme.onSurface,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: _CircleButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                actions: [
                  _WishlistButton(product: product),
                  _CircleButton(
                    icon: FontAwesomeIcons.cartShopping,
                    onTap: () => context.go(Routes.cart),
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: scheme.surfaceContainerHighest),
                      CarouselSlider.builder(
                        itemCount: images.length,
                        itemBuilder: (_, i, _) => ProductImage(
                          url: images[i],
                          fit: BoxFit.cover,
                        ),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: double.infinity,
                          onPageChanged: (i, _) =>
                              setState(() => _imageIndex = i),
                        ),
                      ),
                      // Soft gradient to keep app-bar icons readable on
                      // any product photo.
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 96,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Page-indicator dots
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (i) {
                            final active = i == _imageIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              height: 6,
                              width: active ? 22 : 6,
                              decoration: BoxDecoration(
                                color: active
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            );
                          }),
                        ),
                      ),
                      if (product.isOnSale)
                        Positioned(
                          top: 100,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(FontAwesomeIcons.tag,
                                    color: Colors.white, size: 12),
                                const SizedBox(width: 6),
                                Text(
                                  '${product.discountPercent}% OFF',
                                  style:
                                      theme.textTheme.labelMedium?.copyWith(
                                    color: scheme.onPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  transform: Matrix4.translationValues(0, -24, 0),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatPrice(product.price),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (product.isOnSale)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                formatPrice(product.originalPrice),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (product.isOnSale)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "You save ${formatPrice(savings)}",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _MetaChip(
                            icon: product.inStock
                                ? FontAwesomeIcons.circleCheck
                                : FontAwesomeIcons.circleXmark,
                            label: product.inStock
                                ? 'In stock · ${product.stock}'
                                : 'Out of stock',
                            color: product.inStock
                                ? scheme.primary
                                : scheme.error,
                          ),
                          const SizedBox(width: 8),
                          const _MetaChip(
                            icon: FontAwesomeIcons.truckFast,
                            label: 'Cash on Delivery',
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Quantity',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          QuantityStepper(
                            value: qty,
                            onChanged: (v) => ref
                                .read(productQuantityProvider(widget.productId)
                                    .notifier)
                                .set(v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description.isEmpty
                            ? 'No description available.'
                            : product.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) {
          if (product == null) return null;
          return Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: OutlinedButton.icon(
                        onPressed: product.inStock
                            ? () => _addToCart(product, qty)
                            : null,
                        icon: const FaIcon(
                          FontAwesomeIcons.cartPlus,
                          size: 16,
                        ),
                        label: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 6,
                      child: FilledButton.icon(
                        onPressed: product.inStock
                            ? () => _buyNow(product, qty)
                            : null,
                        icon: const FaIcon(FontAwesomeIcons.bolt, size: 16),
                        label: const Text('Buy Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.black87, size: 16),
          ),
        ),
      ),
    );
  }
}

class _WishlistButton extends ConsumerWidget {
  const _WishlistButton({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWished = ref.watch(isInWishlistProvider(product.id));
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(wishlistControllerProvider.notifier).toggle(product);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FaIcon(
              isWished
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              color: isWished ? Colors.red : Colors.black87,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
