import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/features/categories/data/firebase_category_repository.dart';
import 'package:nextcart/features/products/data/firebase_product_repository.dart';
import 'package:nextcart/features/products/domain/product_repository.dart';
import 'package:nextcart/features/products/presentation/viewmodels/product_viewmodel.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/product_card.dart';
import 'package:nextcart/shared/widgets/skeletons.dart';

class ProductView extends ConsumerWidget {
  const ProductView({super.key, this.categoryId});
  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(productSortControllerProvider);
    final categoryAsync = categoryId == null
        ? null
        : ref.watch(categoriesStreamProvider);

    final title = categoryId == null
        ? 'All Products'
        : categoryAsync?.value
                ?.where((c) => c.id == categoryId)
                .map((c) => c.name)
                .firstOrNull ??
            'Products';

    final productsAsync = categoryId == null
        ? ref.watch(productsStreamProvider(sort: sort))
        : ref.watch(
            productsByCategoryStreamProvider(categoryId!, sort: sort),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: const IosBackButton(),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.search),
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _SortBar(
              current: sort,
              onChanged: (s) =>
                  ref.read(productSortControllerProvider.notifier).set(s),
            ),
          ),
        ),
      ),
      body: productsAsync.when(
        loading: () => const ProductGridSkeleton(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => categoryId == null
              ? ref.invalidate(productsStreamProvider(sort: sort))
              : ref.invalidate(
                  productsByCategoryStreamProvider(categoryId!, sort: sort),
                ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const EmptyState(
              icon: FontAwesomeIcons.boxOpen,
              title: 'No products found',
              message: 'Try a different category or check back later.',
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.66,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => ProductCard(
              product: products[i],
              onTap: () =>
                  context.push(Routes.productDetailPath(products[i].id)),
            ),
          );
        },
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  const _SortBar({required this.current, required this.onChanged});
  final ProductSort current;
  final ValueChanged<ProductSort> onChanged;

  String _label(ProductSort s) => switch (s) {
        ProductSort.newest => 'Newest',
        ProductSort.priceAsc => 'Price: Low → High',
        ProductSort.priceDesc => 'Price: High → Low',
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final s in ProductSort.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_label(s)),
                selected: current == s,
                onSelected: (_) => onChanged(s),
              ),
            ),
        ],
      ),
    );
  }
}
