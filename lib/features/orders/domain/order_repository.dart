import 'package:nextcart/features/cart/domain/models/cart_item.dart';
import 'package:nextcart/features/orders/domain/models/app_order.dart';

class CheckoutDetails {
  const CheckoutDetails({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.city,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
  });

  final String customerName;
  final String phone;
  final String address;
  final String city;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;

  double get total => subtotal + deliveryFee;
}

abstract class OrderRepository {
  Stream<List<AppOrder>> watchOrders(String userId);
  Future<AppOrder?> getById(String userId, String orderId);
  Future<AppOrder> placeOrder(String userId, CheckoutDetails details);
}
