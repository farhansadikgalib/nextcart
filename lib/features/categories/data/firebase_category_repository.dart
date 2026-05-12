import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/categories/domain/category_repository.dart';
import 'package:nextcart/features/categories/domain/models/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_category_repository.g.dart';

class FirebaseCategoryRepository implements CategoryRepository {
  FirebaseCategoryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('categories');

  @override
  Stream<List<Category>> watchAll() {
    return _col.orderBy('order').snapshots().map(
          (snap) => snap.docs.map(Category.fromFirestore).toList(),
        );
  }

  @override
  Future<List<Category>> getAll() async {
    final snap = await _col.orderBy('order').get();
    return snap.docs.map(Category.fromFirestore).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final snap = await _col.doc(id).get();
    if (!snap.exists) return null;
    return Category.fromFirestore(snap);
  }
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  return FirebaseCategoryRepository(ref.watch(firestoreProvider));
}

@riverpod
Stream<List<Category>> categoriesStream(Ref ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
}
