import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/features/wishlist/domain/models/wishlist_item.dart';
import 'package:nextcart/features/wishlist/domain/wishlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_wishlist_repository.g.dart';

class FirebaseWishlistRepository implements WishlistRepository {
  FirebaseWishlistRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('wishlist');

  @override
  Stream<List<WishlistItem>> watchWishlist(String userId) {
    return _col(userId).orderBy('addedAt', descending: true).snapshots().map(
          (snap) => snap.docs.map(WishlistItem.fromFirestore).toList(),
        );
  }

  @override
  Future<void> toggle(String userId, Product product) async {
    final col = _col(userId);
    final existing = await col
        .where('productId', isEqualTo: product.id)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      await existing.docs.first.reference.delete();
    } else {
      await col.add(<String, dynamic>{
        'productId': product.id,
        'title': product.title,
        'image': product.primaryImage ?? '',
        'price': product.price,
        'originalPrice': product.originalPrice,
        'discountPercent': product.discountPercent,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<void> remove(String userId, String itemId) async {
    await _col(userId).doc(itemId).delete();
  }

  @override
  Future<void> clear(String userId) async {
    final snap = await _col(userId).get();
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

@Riverpod(keepAlive: true)
WishlistRepository wishlistRepository(Ref ref) {
  return FirebaseWishlistRepository(ref.watch(firestoreProvider));
}

@riverpod
Stream<List<WishlistItem>> wishlistStream(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final user = auth.currentUser;
  if (user == null) return Stream.value(const <WishlistItem>[]);
  return ref.watch(wishlistRepositoryProvider).watchWishlist(user.uid);
}
