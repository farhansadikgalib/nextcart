import 'package:nextcart/app/app_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/notifications/data/firebase_notification_repository.dart';
import 'package:nextcart/features/notifications/data/order_notification_service.dart';
import 'package:nextcart/features/orders/data/firebase_order_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_init.g.dart';

/// Keeps the [OrderNotificationService] alive and wired to the current user's
/// orders stream. Re-evaluates whenever auth state changes.
@Riverpod(keepAlive: true)
OrderNotificationService orderNotificationService(Ref ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  final service = OrderNotificationService(repo);

  // Initialize local notifications with tap callback for navigation.
  service.init(
    onTapNotification: (response) {
      final orderId = response.payload;
      if (orderId != null && orderId.isNotEmpty) {
        final router = ref.read(appRouterProvider);
        router.push(Routes.orderDetailPath(orderId));
      }
    },
  );

  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user != null) {
    final ordersStream =
        ref.watch(orderRepositoryProvider).watchOrders(user.uid);
    service.startListening(user.uid, ordersStream);
  }

  ref.onDispose(service.stopListening);

  return service;
}
