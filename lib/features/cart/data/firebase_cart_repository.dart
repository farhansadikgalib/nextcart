import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/cart/domain/cart_repository.dart';
import 'package:nextcart/features/cart/domain/models/cart_item.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_cart_repository.g.dart';

class FirebaseCartRepository implements CartRepository {
  FirebaseCartRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('cart');

  @override
  Stream<List<CartItem>> watchCart(String userId) {
    return _col(userId).orderBy('addedAt').snapshots().map(
          (snap) => snap.docs.map(CartItem.fromFirestore).toList(),
        );
  }

  @override
  Future<void> addOrIncrement(
    String userId,
    Product product, {
    int qty = 1,
  }) async {
    final col = _col(userId);
    final existing = await col
        .where('productId', isEqualTo: product.id)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final current = (doc.data()['quantity'] as num?)?.toInt() ?? 1;
      await doc.reference.update({'quantity': current + qty});
    } else {
      await col.add(<String, dynamic>{
        'productId': product.id,
        'title': product.title,
        'image': product.primaryImage ?? '',
        'price': product.price,
        'quantity': qty,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<void> updateQuantity(
    String userId,
    String itemId,
    int quantity,
  ) async {
    if (quantity <= 0) {
      await remove(userId, itemId);
      return;
    }
    await _col(userId).doc(itemId).update({'quantity': quantity});
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
CartRepository cartRepository(Ref ref) {
  return FirebaseCartRepository(ref.watch(firestoreProvider));
}

@riverpod
Stream<List<CartItem>> cartStream(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final user = auth.currentUser;
  if (user == null) return Stream.value(const <CartItem>[]);
  return ref.watch(cartRepositoryProvider).watchCart(user.uid);
}
