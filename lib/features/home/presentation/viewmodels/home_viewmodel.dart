import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextcart/features/categories/data/firebase_category_repository.dart';
import 'package:nextcart/features/categories/domain/models/category.dart';
import 'package:nextcart/features/products/data/firebase_product_repository.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/features/products/domain/product_repository.dart';

// Generated once per app launch. keepAlive ensures the same seed is reused for
// the entire app session, so navigating away from Home (to Cart/Profile/etc.)
// and back does not reshuffle. Cold-starting the app produces a new seed.
final homeShuffleSeedProvider = Provider<int>((ref) {
  ref.keepAlive();
  return DateTime.now().microsecondsSinceEpoch;
});

final shuffledHomeCategoriesProvider =
    Provider<AsyncValue<List<Category>>>((ref) {
  final seed = ref.watch(homeShuffleSeedProvider);
  return ref.watch(categoriesStreamProvider).whenData((cats) {
    final list = [...cats];
    list.shuffle(Random(seed));
    return list;
  });
});

final shuffledFeaturedProductsProvider =
    Provider<AsyncValue<List<Product>>>((ref) {
  final seed = ref.watch(homeShuffleSeedProvider);
  return ref
      .watch(productsStreamProvider(sort: ProductSort.newest))
      .whenData((products) {
    final list = [...products];
    list.shuffle(Random(seed ^ 0x9E3779B9));
    return list;
  });
});
