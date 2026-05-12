import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/features/categories/data/firebase_category_repository.dart';
import 'package:nextcart/features/categories/domain/models/category.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/product_image.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class CategorieView extends ConsumerWidget {
  const CategorieView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Browse our collections',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: categoriesAsync.when(
                loading: () => const CategoryListSkeleton(),
                error: (e, _) => ErrorView(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(categoriesStreamProvider),
                ),
                data: (cats) {
                  if (cats.isEmpty) {
                    return const EmptyState(
                      icon: FontAwesomeIcons.tableCellsLarge,
                      title: 'No categories yet',
                      message: 'Seed your Firestore catalog to see categories.',
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.86,
                        ),
                    itemCount: cats.length,
                    itemBuilder: (_, i) =>
                        _CategoryTile(category: cats[i], index: i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.index});
  final Category category;
  final int index;

  static const _gradients = <List<Color>>[
    [Color(0xFFC7EABB), Color(0xFF84B179)], // sage
    [Color(0xFFFFE0B2), Color(0xFFFFB74D)], // amber
    [Color(0xFFB3E5FC), Color(0xFF4FC3F7)], // sky
    [Color(0xFFF8BBD0), Color(0xFFF06292)], // rose
    [Color(0xFFE1BEE7), Color(0xFFBA68C8)], // violet
    [Color(0xFFD7CCC8), Color(0xFFA1887F)], // taupe
    [Color(0xFFFFCCBC), Color(0xFFFF8A65)], // coral
    [Color(0xFFB2DFDB), Color(0xFF4DB6AC)], // teal
  ];

  bool get _hasImage =>
      (category.image ?? '').isNotEmpty || (category.icon ?? '').isNotEmpty;

  String? get _imageUrl =>
      (category.image?.isNotEmpty ?? false) ? category.image : category.icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = _gradients[index % _gradients.length];

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => GoRouter.of(
          context,
        ).push(Routes.productsByCategoryPath(category.id)),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _hasImage
                      ? ProductImage(url: _imageUrl, fit: BoxFit.cover)
                      : Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: gradient,
                            ),
                          ),
                          child: FaIcon(
                            _iconFor(category.name),
                            size: 26,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains("men's") && !n.contains('women')) {
      return FontAwesomeIcons.shirt;
    }
    if (n.contains("women")) return FontAwesomeIcons.personDress;
    if (n.contains('computer') || n.contains('gaming')) {
      return FontAwesomeIcons.laptop;
    }
    if (n.contains('home') || n.contains('living')) {
      return FontAwesomeIcons.couch;
    }
    if (n.contains('grocer') || n.contains('pet')) {
      return FontAwesomeIcons.basketShopping;
    }
    if (n.contains('health') || n.contains('beauty')) {
      return FontAwesomeIcons.spa;
    }
    if (n.contains('tv') || n.contains('appliance')) return FontAwesomeIcons.tv;
    if (n.contains('lifestyle') || n.contains('hobb')) {
      return FontAwesomeIcons.seedling;
    }
    if (n.contains('electronic')) return FontAwesomeIcons.headphones;
    if (n.contains('watch') || n.contains('bag')) {
      return FontAwesomeIcons.bagShopping;
    }
    if (n.contains('sport') || n.contains('outdoor')) {
      return FontAwesomeIcons.basketball;
    }
    if (n.contains('mother') || n.contains('baby')) {
      return FontAwesomeIcons.baby;
    }
    if (n.contains('automot') || n.contains('bike')) {
      return FontAwesomeIcons.motorcycle;
    }
    if (n.contains('phone')) return FontAwesomeIcons.mobileScreen;
    return FontAwesomeIcons.boxesStacked;
  }
}
