import 'package:nextcart/features/cart/domain/models/cart_item.dart';
import 'package:nextcart/features/products/domain/models/product.dart';

abstract class CartRepository {
  Stream<List<CartItem>> watchCart(String userId);
  Future<void> addOrIncrement(String userId, Product product, {int qty = 1});
  Future<void> updateQuantity(String userId, String itemId, int quantity);
  Future<void> remove(String userId, String itemId);
  Future<void> clear(String userId);
}
