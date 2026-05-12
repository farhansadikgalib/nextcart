// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderLine {

 String get productId; String get title; String get image; double get price; int get quantity;
/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineCopyWith<OrderLine> get copyWith => _$OrderLineCopyWithImpl<OrderLine>(this as OrderLine, _$identity);

  /// Serializes this OrderLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,title,image,price,quantity);

@override
String toString() {
  return 'OrderLine(productId: $productId, title: $title, image: $image, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $OrderLineCopyWith<$Res>  {
  factory $OrderLineCopyWith(OrderLine value, $Res Function(OrderLine) _then) = _$OrderLineCopyWithImpl;
@useResult
$Res call({
 String productId, String title, String image, double price, int quantity
});




}
/// @nodoc
class _$OrderLineCopyWithImpl<$Res>
    implements $OrderLineCopyWith<$Res> {
  _$OrderLineCopyWithImpl(this._self, this._then);

  final OrderLine _self;
  final $Res Function(OrderLine) _then;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? title = null,Object? image = null,Object? price = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLine].
extension OrderLinePatterns on OrderLine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLine value)  $default,){
final _that = this;
switch (_that) {
case _OrderLine():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLine value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String title,  String image,  double price,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that.productId,_that.title,_that.image,_that.price,_that.quantity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String title,  String image,  double price,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _OrderLine():
return $default(_that.productId,_that.title,_that.image,_that.price,_that.quantity);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String title,  String image,  double price,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderLine() when $default != null:
return $default(_that.productId,_that.title,_that.image,_that.price,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderLine implements OrderLine {
  const _OrderLine({required this.productId, required this.title, required this.image, required this.price, required this.quantity});
  factory _OrderLine.fromJson(Map<String, dynamic> json) => _$OrderLineFromJson(json);

@override final  String productId;
@override final  String title;
@override final  String image;
@override final  double price;
@override final  int quantity;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineCopyWith<_OrderLine> get copyWith => __$OrderLineCopyWithImpl<_OrderLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,title,image,price,quantity);

@override
String toString() {
  return 'OrderLine(productId: $productId, title: $title, image: $image, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$OrderLineCopyWith<$Res> implements $OrderLineCopyWith<$Res> {
  factory _$OrderLineCopyWith(_OrderLine value, $Res Function(_OrderLine) _then) = __$OrderLineCopyWithImpl;
@override @useResult
$Res call({
 String productId, String title, String image, double price, int quantity
});




}
/// @nodoc
class __$OrderLineCopyWithImpl<$Res>
    implements _$OrderLineCopyWith<$Res> {
  __$OrderLineCopyWithImpl(this._self, this._then);

  final _OrderLine _self;
  final $Res Function(_OrderLine) _then;

/// Create a copy of OrderLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? title = null,Object? image = null,Object? price = null,Object? quantity = null,}) {
  return _then(_OrderLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AppOrder {

 String get id; List<OrderLine> get items; double get subtotal; double get deliveryFee; double get total; String get deliveryAddress; String get deliveryPhone; String get customerName; String get city; String get paymentMethod; OrderStatus get status; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppOrderCopyWith<AppOrder> get copyWith => _$AppOrderCopyWithImpl<AppOrder>(this as AppOrder, _$identity);

  /// Serializes this AppOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppOrder&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.deliveryPhone, deliveryPhone) || other.deliveryPhone == deliveryPhone)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.city, city) || other.city == city)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(items),subtotal,deliveryFee,total,deliveryAddress,deliveryPhone,customerName,city,paymentMethod,status,createdAt,updatedAt);

@override
String toString() {
  return 'AppOrder(id: $id, items: $items, subtotal: $subtotal, deliveryFee: $deliveryFee, total: $total, deliveryAddress: $deliveryAddress, deliveryPhone: $deliveryPhone, customerName: $customerName, city: $city, paymentMethod: $paymentMethod, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AppOrderCopyWith<$Res>  {
  factory $AppOrderCopyWith(AppOrder value, $Res Function(AppOrder) _then) = _$AppOrderCopyWithImpl;
@useResult
$Res call({
 String id, List<OrderLine> items, double subtotal, double deliveryFee, double total, String deliveryAddress, String deliveryPhone, String customerName, String city, String paymentMethod, OrderStatus status, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$AppOrderCopyWithImpl<$Res>
    implements $AppOrderCopyWith<$Res> {
  _$AppOrderCopyWithImpl(this._self, this._then);

  final AppOrder _self;
  final $Res Function(AppOrder) _then;

/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? items = null,Object? subtotal = null,Object? deliveryFee = null,Object? total = null,Object? deliveryAddress = null,Object? deliveryPhone = null,Object? customerName = null,Object? city = null,Object? paymentMethod = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,deliveryPhone: null == deliveryPhone ? _self.deliveryPhone : deliveryPhone // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppOrder].
extension AppOrderPatterns on AppOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppOrder value)  $default,){
final _that = this;
switch (_that) {
case _AppOrder():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppOrder value)?  $default,){
final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<OrderLine> items,  double subtotal,  double deliveryFee,  double total,  String deliveryAddress,  String deliveryPhone,  String customerName,  String city,  String paymentMethod,  OrderStatus status,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
return $default(_that.id,_that.items,_that.subtotal,_that.deliveryFee,_that.total,_that.deliveryAddress,_that.deliveryPhone,_that.customerName,_that.city,_that.paymentMethod,_that.status,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<OrderLine> items,  double subtotal,  double deliveryFee,  double total,  String deliveryAddress,  String deliveryPhone,  String customerName,  String city,  String paymentMethod,  OrderStatus status,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AppOrder():
return $default(_that.id,_that.items,_that.subtotal,_that.deliveryFee,_that.total,_that.deliveryAddress,_that.deliveryPhone,_that.customerName,_that.city,_that.paymentMethod,_that.status,_that.createdAt,_that.updatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<OrderLine> items,  double subtotal,  double deliveryFee,  double total,  String deliveryAddress,  String deliveryPhone,  String customerName,  String city,  String paymentMethod,  OrderStatus status,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AppOrder() when $default != null:
return $default(_that.id,_that.items,_that.subtotal,_that.deliveryFee,_that.total,_that.deliveryAddress,_that.deliveryPhone,_that.customerName,_that.city,_that.paymentMethod,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppOrder implements AppOrder {
  const _AppOrder({required this.id, required final  List<OrderLine> items, required this.subtotal, required this.deliveryFee, required this.total, required this.deliveryAddress, required this.deliveryPhone, required this.customerName, required this.city, this.paymentMethod = 'cash_on_delivery', this.status = OrderStatus.pending, this.createdAt, this.updatedAt}): _items = items;
  factory _AppOrder.fromJson(Map<String, dynamic> json) => _$AppOrderFromJson(json);

@override final  String id;
 final  List<OrderLine> _items;
@override List<OrderLine> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double subtotal;
@override final  double deliveryFee;
@override final  double total;
@override final  String deliveryAddress;
@override final  String deliveryPhone;
@override final  String customerName;
@override final  String city;
@override@JsonKey() final  String paymentMethod;
@override@JsonKey() final  OrderStatus status;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppOrderCopyWith<_AppOrder> get copyWith => __$AppOrderCopyWithImpl<_AppOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppOrder&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.deliveryPhone, deliveryPhone) || other.deliveryPhone == deliveryPhone)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.city, city) || other.city == city)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_items),subtotal,deliveryFee,total,deliveryAddress,deliveryPhone,customerName,city,paymentMethod,status,createdAt,updatedAt);

@override
String toString() {
  return 'AppOrder(id: $id, items: $items, subtotal: $subtotal, deliveryFee: $deliveryFee, total: $total, deliveryAddress: $deliveryAddress, deliveryPhone: $deliveryPhone, customerName: $customerName, city: $city, paymentMethod: $paymentMethod, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppOrderCopyWith<$Res> implements $AppOrderCopyWith<$Res> {
  factory _$AppOrderCopyWith(_AppOrder value, $Res Function(_AppOrder) _then) = __$AppOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, List<OrderLine> items, double subtotal, double deliveryFee, double total, String deliveryAddress, String deliveryPhone, String customerName, String city, String paymentMethod, OrderStatus status, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$AppOrderCopyWithImpl<$Res>
    implements _$AppOrderCopyWith<$Res> {
  __$AppOrderCopyWithImpl(this._self, this._then);

  final _AppOrder _self;
  final $Res Function(_AppOrder) _then;

/// Create a copy of AppOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? items = null,Object? subtotal = null,Object? deliveryFee = null,Object? total = null,Object? deliveryAddress = null,Object? deliveryPhone = null,Object? customerName = null,Object? city = null,Object? paymentMethod = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AppOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLine>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: null == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,deliveryPhone: null == deliveryPhone ? _self.deliveryPhone : deliveryPhone // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
