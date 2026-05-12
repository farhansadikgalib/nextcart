import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';
part 'wishlist_item.g.dart';

@freezed
sealed class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    required String productId,
    required String title,
    required String image,
    required double price,
    required double originalPrice,
    required int discountPercent,
    DateTime? addedAt,
  }) = _WishlistItem;

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);

  factory WishlistItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data() ?? <String, dynamic>{};
    return WishlistItem(
      id: snap.id,
      productId: (data['productId'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      image: (data['image'] ?? '') as String,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (data['originalPrice'] as num?)?.toDouble() ?? 0,
      discountPercent: (data['discountPercent'] as num?)?.toInt() ?? 0,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate(),
    );
  }
}
