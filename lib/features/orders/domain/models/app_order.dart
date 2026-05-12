import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_order.freezed.dart';
part 'app_order.g.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled;

  static OrderStatus parse(String? value) {
    switch (value) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };
}

@freezed
sealed class OrderLine with _$OrderLine {
  const factory OrderLine({
    required String productId,
    required String title,
    required String image,
    required double price,
    required int quantity,
  }) = _OrderLine;

  factory OrderLine.fromJson(Map<String, dynamic> json) =>
      _$OrderLineFromJson(json);

  factory OrderLine.fromMap(Map<String, dynamic> data) => OrderLine(
        productId: (data['productId'] ?? '') as String,
        title: (data['title'] ?? '') as String,
        image: (data['image'] ?? '') as String,
        price: (data['price'] as num?)?.toDouble() ?? 0,
        quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      );
}

extension OrderLineX on OrderLine {
  double get lineTotal => price * quantity;
  Map<String, dynamic> toMap() => <String, dynamic>{
        'productId': productId,
        'title': title,
        'image': image,
        'price': price,
        'quantity': quantity,
      };
}

@freezed
sealed class AppOrder with _$AppOrder {
  const factory AppOrder({
    required String id,
    required List<OrderLine> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
    required String deliveryPhone,
    required String customerName,
    required String city,
    @Default('cash_on_delivery') String paymentMethod,
    @Default(OrderStatus.pending) OrderStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppOrder;

  factory AppOrder.fromJson(Map<String, dynamic> json) =>
      _$AppOrderFromJson(json);

  factory AppOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data() ?? <String, dynamic>{};
    return AppOrder(
      id: snap.id,
      items: ((data['items'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(OrderLine.fromMap)
          .toList(growable: false),
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0,
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0,
      deliveryAddress: (data['deliveryAddress'] ?? '') as String,
      deliveryPhone: (data['deliveryPhone'] ?? '') as String,
      customerName: (data['customerName'] ?? '') as String,
      city: (data['city'] ?? '') as String,
      paymentMethod:
          (data['paymentMethod'] ?? 'cash_on_delivery') as String,
      status: OrderStatus.parse(data['status'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
