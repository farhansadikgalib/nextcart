// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) =>
    _WishlistItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num).toInt(),
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$WishlistItemToJson(_WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'title': instance.title,
      'image': instance.image,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'discountPercent': instance.discountPercent,
      'addedAt': instance.addedAt?.toIso8601String(),
    };
