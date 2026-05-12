// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String?,
  image: json['image'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'image': instance.image,
  'order': instance.order,
};
