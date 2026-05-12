import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String productId,
    required String title,
    required String image,
    required double price,
    required int quantity,
    DateTime? addedAt,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  factory CartItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data() ?? <String, dynamic>{};
    return CartItem(
      id: snap.id,
      productId: (data['productId'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      image: (data['image'] ?? '') as String,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate(),
    );
  }
}

extension CartItemX on CartItem {
  double get subtotal => price * quantity;
}
