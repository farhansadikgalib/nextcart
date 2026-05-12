// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  photoUrl: json['photoUrl'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'photoUrl': instance.photoUrl,
  'phone': instance.phone,
  'address': instance.address,
  'city': instance.city,
  'createdAt': instance.createdAt?.toIso8601String(),
};
