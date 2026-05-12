// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num).toDouble(),
  discountPercent: (json['discountPercent'] as num).toInt(),
  categoryId: json['categoryId'] as String,
  stock: (json['stock'] as num).toInt(),
  sourceUrl: json['sourceUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'images': instance.images,
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'discountPercent': instance.discountPercent,
  'categoryId': instance.categoryId,
  'stock': instance.stock,
  'sourceUrl': instance.sourceUrl,
  'createdAt': instance.createdAt?.toIso8601String(),
};
