import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/orders/domain/models/app_order.dart';
import 'package:nextcart/features/orders/domain/order_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_order_repository.g.dart';

class FirebaseOrderRepository implements OrderRepository {
  FirebaseOrderRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('orders');

  @override
  Stream<List<AppOrder>> watchOrders(String userId) {
    return _col(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(AppOrder.fromFirestore).toList());
  }

  @override
  Future<AppOrder?> getById(String userId, String orderId) async {
    final snap = await _col(userId).doc(orderId).get();
    if (!snap.exists) return null;
    return AppOrder.fromFirestore(snap);
  }

  @override
  Future<AppOrder> placeOrder(String userId, CheckoutDetails details) async {
    final orderRef = _col(userId).doc();
    final items = details.items
        .map((c) => OrderLine(
              productId: c.productId,
              title: c.title,
              image: c.image,
              price: c.price,
              quantity: c.quantity,
            ))
        .toList(growable: false);

    final data = <String, dynamic>{
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': details.subtotal,
      'deliveryFee': details.deliveryFee,
      'total': details.total,
      'deliveryAddress': details.address,
      'deliveryPhone': details.phone,
      'customerName': details.customerName,
      'city': details.city,
      'paymentMethod': 'cash_on_delivery',
      'status': OrderStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await orderRef.set(data);

    return AppOrder(
      id: orderRef.id,
      items: items,
      subtotal: details.subtotal,
      deliveryFee: details.deliveryFee,
      total: details.total,
      deliveryAddress: details.address,
      deliveryPhone: details.phone,
      customerName: details.customerName,
      city: details.city,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  return FirebaseOrderRepository(ref.watch(firestoreProvider));
}

@riverpod
Stream<List<AppOrder>> ordersStream(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final user = auth.currentUser;
  if (user == null) return Stream.value(const <AppOrder>[]);
  return ref.watch(orderRepositoryProvider).watchOrders(user.uid);
}

@riverpod
Future<AppOrder?> orderById(Ref ref, String orderId) {
  final auth = ref.watch(firebaseAuthProvider);
  final user = auth.currentUser;
  if (user == null) return Future.value(null);
  return ref.watch(orderRepositoryProvider).getById(user.uid, orderId);
}
