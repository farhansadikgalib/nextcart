import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';
import 'package:nextcart/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:nextcart/features/orders/data/firebase_order_repository.dart';
import 'package:nextcart/features/orders/domain/models/app_order.dart';
import 'package:nextcart/features/orders/domain/order_repository.dart';
import 'package:nextcart/features/profile/data/firebase_user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checkout_viewmodel.g.dart';

@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  AsyncValue<AppOrder?> build() => const AsyncData(null);

  Future<AppOrder?> placeOrder({
    required String customerName,
    required String phone,
    required String address,
    required String city,
  }) async {
    state = const AsyncLoading();
    try {
      final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (uid == null) throw StateError('Not signed in');

      final items = ref.read(cartStreamProvider).value ?? const [];
      if (items.isEmpty) throw StateError('Cart is empty');

      final subtotal = ref.read(cartSubtotalProvider);
      final delivery = ref.read(cartDeliveryFeeProvider);

      final details = CheckoutDetails(
        customerName: customerName,
        phone: phone,
        address: address,
        city: city,
        items: items,
        subtotal: subtotal,
        deliveryFee: delivery,
      );

      final order = await ref
          .read(orderRepositoryProvider)
          .placeOrder(uid, details);

      // persist profile defaults
      await ref.read(userRepositoryProvider).updateProfile(
            userId: uid,
            phone: phone,
            address: address,
            city: city,
          );

      // clear cart
      await ref.read(cartRepositoryProvider).clear(uid);

      state = AsyncData(order);
      return order;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
