import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nextcart/features/notifications/data/firebase_notification_repository.dart';
import 'package:nextcart/features/notifications/domain/models/app_notification.dart';
import 'package:nextcart/features/orders/domain/models/app_order.dart';

/// Handles local push notifications and writing notification documents
/// when an order status changes.
class OrderNotificationService {
  OrderNotificationService(this._notificationRepo);

  final FirebaseNotificationRepository _notificationRepo;

  final _localPlugin = FlutterLocalNotificationsPlugin();
  StreamSubscription<List<AppOrder>>? _ordersSub;

  /// Keeps the last-known status per order so we can detect changes.
  final _statusCache = <String, OrderStatus>{};

  // ── Initialisation ──────────────────────────────────────────────────

  Future<void> init({
    DidReceiveNotificationResponseCallback? onTapNotification,
  }) async {
    // Local notifications setup.
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localPlugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: onTapNotification,
    );

    // Request push notification permission.
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    // Create Android notification channel.
    if (Platform.isAndroid) {
      await _localPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'order_updates',
              'Order Updates',
              description: 'Notifications for order status changes',
              importance: Importance.high,
            ),
          );
    }
  }

  // ── Start watching orders ───────────────────────────────────────────

  void startListening(String userId, Stream<List<AppOrder>> ordersStream) {
    _ordersSub?.cancel();
    _statusCache.clear();

    _ordersSub = ordersStream.listen((orders) {
      for (final order in orders) {
        final prev = _statusCache[order.id];
        _statusCache[order.id] = order.status;

        // Skip the initial load — only notify on real changes.
        if (prev == null) continue;
        if (prev == order.status) continue;

        _onStatusChanged(userId, order, prev);
      }
    });
  }

  void stopListening() {
    _ordersSub?.cancel();
    _ordersSub = null;
    _statusCache.clear();
  }

  // ── Handle a detected status change ────────────────────────────────

  Future<void> _onStatusChanged(
    String userId,
    AppOrder order,
    OrderStatus oldStatus,
  ) async {
    final title = 'Order ${_shortId(order.id)}';
    final body = _bodyText(oldStatus, order.status);

    // 1. Persist to Firestore so the notification screen shows it.
    final notification = AppNotification(
      id: '',
      title: title,
      body: body,
      orderId: order.id,
      oldStatus: oldStatus.name,
      newStatus: order.status.name,
    );
    await _notificationRepo.add(userId, notification);

    // 2. Show a local push notification.
    await _showLocal(title, body, order.id);
  }

  Future<void> _showLocal(String title, String body, String orderId) async {
    const android = AndroidNotificationDetails(
      'order_updates',
      'Order Updates',
      channelDescription: 'Notifications for order status changes',
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    await _localPlugin.show(
      id: orderId.hashCode,
      title: title,
      body: body,
      notificationDetails:
          const NotificationDetails(android: android, iOS: ios),
      payload: orderId,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────

  String _shortId(String id) => '#${id.substring(0, 6).toUpperCase()}';

  String _bodyText(OrderStatus from, OrderStatus to) {
    return switch (to) {
      OrderStatus.confirmed =>
        'Your order has been confirmed and is being prepared.',
      OrderStatus.shipped => 'Your order is on the way!',
      OrderStatus.delivered =>
        'Your order has been delivered. Enjoy your purchase!',
      OrderStatus.cancelled => 'Your order has been cancelled.',
      _ => 'Order status changed from ${from.label} to ${to.label}.',
    };
  }
}
