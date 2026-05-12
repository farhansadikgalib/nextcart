// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: json['id'] as String,
  productId: json['productId'] as String,
  title: json['title'] as String,
  image: json['image'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  addedAt: json['addedAt'] == null
      ? null
      : DateTime.parse(json['addedAt'] as String),
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'title': instance.title,
  'image': instance.image,
  'price': instance.price,
  'quantity': instance.quantity,
  'addedAt': instance.addedAt?.toIso8601String(),
};
