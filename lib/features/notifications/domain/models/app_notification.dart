import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

@freezed
sealed class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    required String orderId,
    required String oldStatus,
    required String newStatus,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  factory AppNotification.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data() ?? <String, dynamic>{};
    return AppNotification(
      id: snap.id,
      title: (data['title'] ?? '') as String,
      body: (data['body'] ?? '') as String,
      orderId: (data['orderId'] ?? '') as String,
      oldStatus: (data['oldStatus'] ?? '') as String,
      newStatus: (data['newStatus'] ?? '') as String,
      isRead: (data['isRead'] as bool?) ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(AppNotification n) => {
        'title': n.title,
        'body': n.body,
        'orderId': n.orderId,
        'oldStatus': n.oldStatus,
        'newStatus': n.newStatus,
        'isRead': n.isRead,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
