import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/shared/widgets/price_tag.dart';
import 'package:nextcart/shared/widgets/product_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ProductImage(
                      url: product.primaryImage,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    if (product.isOnSale)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PriceTag(
                      price: product.price,
                      originalPrice: product.originalPrice,
                      discountPercent: product.discountPercent,
                      dense: true,
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
