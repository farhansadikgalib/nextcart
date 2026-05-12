import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/features/auth/data/firebase_auth_repository.dart';
import 'package:nextcart/features/categories/data/firebase_category_repository.dart';
import 'package:nextcart/features/categories/domain/models/category.dart';
import 'package:nextcart/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:nextcart/features/products/data/firebase_product_repository.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/product_card.dart';
import 'package:nextcart/shared/widgets/product_image.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(shuffledHomeCategoriesProvider);
    final featuredAsync = ref.watch(shuffledFeaturedProductsProvider);
    final userAsync = ref.watch(currentAppUserProvider);
    final user = userAsync.value;
    final firstName = (user?.name ?? '').split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(categoriesStreamProvider);
            ref.invalidate(productsStreamProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName.isEmpty
                            ? 'Welcome back'
                            : 'Hi, $firstName 👋',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'What are you shopping today?',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push(Routes.search),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Search for products',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: _BannerCarousel(featuredAsync: featuredAsync),
              ),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Categories',
                  onSeeAll: () => context.go(Routes.categories),
                ),
              ),
              categoriesAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: CategoryGridSkeleton(),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: ErrorView(message: e.toString()),
                ),
                data: (cats) => SliverToBoxAdapter(
                  child: _CategoryGrid(categories: cats.take(8).toList()),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Featured Products',
                  onSeeAll: () => context.push(Routes.products),
                ),
              ),
              featuredAsync.when(
                loading: () =>
                    const SliverToBoxAdapter(child: ProductGridSkeleton()),
                error: (e, _) => SliverToBoxAdapter(
                  child: ErrorView(message: e.toString()),
                ),
                data: (products) {
                  if (products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: EmptyState(
                        icon: FontAwesomeIcons.boxOpen,
                        title: 'No products yet',
                        message:
                            'Once the catalog is seeded, products will appear here.',
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.66,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => ProductCard(
                          product: products[i],
                          onTap: () => context.push(
                            Routes.productDetailPath(products[i].id),
                          ),
                        ),
                        childCount: products.length,
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(onPressed: onSeeAll, child: const Text('See all')),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Categories will load once seeded.'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, i) => _CategoryTile(category: categories[i]),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => GoRouter.of(context).push(
        Routes.productsByCategoryPath(category.id),
      ),
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: (category.icon ?? category.image) != null
                ? ProductImage(url: category.icon ?? category.image)
                : FaIcon(
                    FontAwesomeIcons.boxesStacked,
                    size: 22,
                    color: theme.colorScheme.primary,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel({required this.featuredAsync});
  final AsyncValue<List<Product>> featuredAsync;

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  static const _autoplayInterval = Duration(seconds: 4);
  static const _maxItems = 5;

  final _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_autoplayInterval, _tick);
  }

  void _tick(Timer _) {
    if (!mounted || !_controller.hasClients) return;
    final count = _itemCount;
    if (count <= 1) return;
    final next = (_index + 1) % count;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  int get _itemCount =>
      (widget.featuredAsync.value?.length ?? 0).clamp(0, _maxItems);

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = widget.featuredAsync.value ?? const <Product>[];
    final items = products.take(_maxItems).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    if (_index >= items.length) _index = 0;

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push(Routes.productDetailPath(p.id)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductImage(url: p.primaryImage),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.isOnSale)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Save ${p.discountPercent}%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 6),
                            Text(
                              p.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 16,
            bottom: 12,
            child: _CarouselDots(count: items.length, current: _index),
          ),
        ],
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(count, (i) {
              final active = i == current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: active ? 1 : 0.55),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
