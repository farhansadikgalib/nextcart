import 'package:nextcart/core/constants/app_constants.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';
import 'package:nextcart/features/cart/domain/models/cart_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_viewmodel.g.dart';

@riverpod
double cartSubtotal(Ref ref) {
  final items = ref.watch(cartStreamProvider).value ?? const <CartItem>[];
  return items.fold<double>(0, (sum, c) => sum + c.subtotal);
}

@riverpod
double cartDeliveryFee(Ref ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  if (subtotal == 0) return 0;
  return subtotal >= AppConstants.freeDeliveryThreshold
      ? 0
      : AppConstants.deliveryFee;
}

@riverpod
double cartTotal(Ref ref) {
  return ref.watch(cartSubtotalProvider) +
      ref.watch(cartDeliveryFeeProvider);
}

@riverpod
class CartController extends _$CartController {
  @override
  void build() {}

  String? _uid() => ref.read(firebaseAuthProvider).currentUser?.uid;

  Future<void> setQuantity(String itemId, int qty) async {
    final uid = _uid();
    if (uid == null) return;
    await ref
        .read(cartRepositoryProvider)
        .updateQuantity(uid, itemId, qty);
  }

  Future<void> remove(String itemId) async {
    final uid = _uid();
    if (uid == null) return;
    await ref.read(cartRepositoryProvider).remove(uid, itemId);
  }

  Future<void> clear() async {
    final uid = _uid();
    if (uid == null) return;
    await ref.read(cartRepositoryProvider).clear(uid);
  }
}
