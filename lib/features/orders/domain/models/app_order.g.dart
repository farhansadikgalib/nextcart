// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderLine _$OrderLineFromJson(Map<String, dynamic> json) => _OrderLine(
  productId: json['productId'] as String,
  title: json['title'] as String,
  image: json['image'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$OrderLineToJson(_OrderLine instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'title': instance.title,
      'image': instance.image,
      'price': instance.price,
      'quantity': instance.quantity,
    };

_AppOrder _$AppOrderFromJson(Map<String, dynamic> json) => _AppOrder(
  id: json['id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  deliveryAddress: json['deliveryAddress'] as String,
  deliveryPhone: json['deliveryPhone'] as String,
  customerName: json['customerName'] as String,
  city: json['city'] as String,
  paymentMethod: json['paymentMethod'] as String? ?? 'cash_on_delivery',
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.pending,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AppOrderToJson(_AppOrder instance) => <String, dynamic>{
  'id': instance.id,
  'items': instance.items,
  'subtotal': instance.subtotal,
  'deliveryFee': instance.deliveryFee,
  'total': instance.total,
  'deliveryAddress': instance.deliveryAddress,
  'deliveryPhone': instance.deliveryPhone,
  'customerName': instance.customerName,
  'city': instance.city,
  'paymentMethod': instance.paymentMethod,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};
