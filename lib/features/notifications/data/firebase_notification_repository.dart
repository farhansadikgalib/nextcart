import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/notifications/domain/models/app_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_notification_repository.g.dart';

class FirebaseNotificationRepository {
  FirebaseNotificationRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('notifications');

  Stream<List<AppNotification>> watchAll(String userId) {
    return _col(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(AppNotification.fromFirestore).toList());
  }

  Stream<int> watchUnreadCount(String userId) {
    return _col(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.size);
  }

  Future<void> add(String userId, AppNotification notification) async {
    await _col(userId).add(AppNotification.toFirestore(notification));
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    await _col(userId).doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final snap =
        await _col(userId).where('isRead', isEqualTo: false).get();
    if (snap.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> delete(String userId, String notificationId) async {
    await _col(userId).doc(notificationId).delete();
  }

  Future<void> clearAll(String userId) async {
    final snap = await _col(userId).get();
    if (snap.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

@Riverpod(keepAlive: true)
FirebaseNotificationRepository notificationRepository(Ref ref) {
  return FirebaseNotificationRepository(ref.watch(firestoreProvider));
}

@riverpod
Stream<List<AppNotification>> notificationsStream(Ref ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) return Stream.value(const []);
  return ref.watch(notificationRepositoryProvider).watchAll(user.uid);
}

@riverpod
Stream<int> unreadNotificationCount(Ref ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) return Stream.value(0);
  return ref.watch(notificationRepositoryProvider).watchUnreadCount(user.uid);
}
