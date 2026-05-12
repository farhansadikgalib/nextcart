import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/features/wishlist/data/firebase_wishlist_repository.dart';
import 'package:nextcart/features/wishlist/domain/models/wishlist_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_viewmodel.g.dart';

@riverpod
bool isInWishlist(Ref ref, String productId) {
  final items = ref.watch(wishlistStreamProvider).value ?? const <WishlistItem>[];
  return items.any((item) => item.productId == productId);
}

@riverpod
class WishlistController extends _$WishlistController {
  @override
  void build() {}

  String? _uid() => ref.read(firebaseAuthProvider).currentUser?.uid;

  Future<void> toggle(Product product) async {
    final uid = _uid();
    if (uid == null) return;
    await ref.read(wishlistRepositoryProvider).toggle(uid, product);
  }

  Future<void> remove(String itemId) async {
    final uid = _uid();
    if (uid == null) return;
    await ref.read(wishlistRepositoryProvider).remove(uid, itemId);
  }

  Future<void> clear() async {
    final uid = _uid();
    if (uid == null) return;
    await ref.read(wishlistRepositoryProvider).clear(uid);
  }
}
