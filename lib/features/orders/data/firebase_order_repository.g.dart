// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_order_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderRepository)
final orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider
    extends
        $FunctionalProvider<OrderRepository, OrderRepository, OrderRepository>
    with $Provider<OrderRepository> {
  OrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'432f330cde94ba283fd05e03b4d1db1cff2aab25';

@ProviderFor(ordersStream)
final ordersStreamProvider = OrdersStreamProvider._();

final class OrdersStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppOrder>>,
          List<AppOrder>,
          Stream<List<AppOrder>>
        >
    with $FutureModifier<List<AppOrder>>, $StreamProvider<List<AppOrder>> {
  OrdersStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<AppOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AppOrder>> create(Ref ref) {
    return ordersStream(ref);
  }
}

String _$ordersStreamHash() => r'7848b851f54063c2645858d74080213b0d99a078';

@ProviderFor(orderById)
final orderByIdProvider = OrderByIdFamily._();

final class OrderByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppOrder?>,
          AppOrder?,
          FutureOr<AppOrder?>
        >
    with $FutureModifier<AppOrder?>, $FutureProvider<AppOrder?> {
  OrderByIdProvider._({
    required OrderByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderByIdHash();

  @override
  String toString() {
    return r'orderByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AppOrder?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AppOrder?> create(Ref ref) {
    final argument = this.argument as String;
    return orderById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderByIdHash() => r'e4ba8c88e6c5f6425644bfea9699ac3cd51f5034';

final class OrderByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AppOrder?>, String> {
  OrderByIdFamily._()
    : super(
        retry: null,
        name: r'orderByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderByIdProvider call(String orderId) =>
      OrderByIdProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderByIdProvider';
}
