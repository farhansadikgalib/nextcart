import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/features/products/domain/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_product_repository.g.dart';

class FirebaseProductRepository implements ProductRepository {
  FirebaseProductRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('products');

  Query<Map<String, dynamic>> _applySort(
    Query<Map<String, dynamic>> q,
    ProductSort sort,
  ) {
    switch (sort) {
      case ProductSort.newest:
        return q.orderBy('createdAt', descending: true);
      case ProductSort.priceAsc:
        return q.orderBy('price');
      case ProductSort.priceDesc:
        return q.orderBy('price', descending: true);
    }
  }

  @override
  Stream<List<Product>> watchAll({ProductSort sort = ProductSort.newest}) {
    return _applySort(_col, sort)
        .snapshots()
        .map((snap) => snap.docs.map(Product.fromFirestore).toList());
  }

  @override
  Stream<List<Product>> watchByCategory(
    String categoryId, {
    ProductSort sort = ProductSort.newest,
  }) {
    // Sort client-side: combining where() with orderBy() on a different
    // field requires a Firestore composite index per (sort × category).
    // For a small catalog the network cost is negligible.
    return _col
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snap) {
      final products = snap.docs.map(Product.fromFirestore).toList();
      _sortInPlace(products, sort);
      return products;
    });
  }

  void _sortInPlace(List<Product> products, ProductSort sort) {
    switch (sort) {
      case ProductSort.newest:
        products.sort((a, b) {
          final ad = a.createdAt;
          final bd = b.createdAt;
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
        });
      case ProductSort.priceAsc:
        products.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceDesc:
        products.sort((a, b) => b.price.compareTo(a.price));
    }
  }

  @override
  Future<List<Product>> getAll() async {
    final snap = await _col.orderBy('createdAt', descending: true).get();
    return snap.docs.map(Product.fromFirestore).toList();
  }

  @override
  Future<Product?> getById(String id) async {
    final snap = await _col.doc(id).get();
    if (!snap.exists) return null;
    return Product.fromFirestore(snap);
  }
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  return FirebaseProductRepository(ref.watch(firestoreProvider));
}

@riverpod
Stream<List<Product>> productsStream(
  Ref ref, {
  ProductSort sort = ProductSort.newest,
}) {
  return ref.watch(productRepositoryProvider).watchAll(sort: sort);
}

@riverpod
Stream<List<Product>> productsByCategoryStream(
  Ref ref,
  String categoryId, {
  ProductSort sort = ProductSort.newest,
}) {
  return ref
      .watch(productRepositoryProvider)
      .watchByCategory(categoryId, sort: sort);
}

@riverpod
Future<Product?> productById(Ref ref, String id) {
  return ref.watch(productRepositoryProvider).getById(id);
}
