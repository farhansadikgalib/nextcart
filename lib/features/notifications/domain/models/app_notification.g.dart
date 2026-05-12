// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      orderId: json['orderId'] as String,
      oldStatus: json['oldStatus'] as String,
      newStatus: json['newStatus'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'orderId': instance.orderId,
      'oldStatus': instance.oldStatus,
      'newStatus': instance.newStatus,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
