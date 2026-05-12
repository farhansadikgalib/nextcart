import 'package:nextcart/features/products/domain/models/product.dart';
import 'package:nextcart/features/wishlist/domain/models/wishlist_item.dart';

abstract class WishlistRepository {
  Stream<List<WishlistItem>> watchWishlist(String userId);
  Future<void> toggle(String userId, Product product);
  Future<void> remove(String userId, String itemId);
  Future<void> clear(String userId);
}
