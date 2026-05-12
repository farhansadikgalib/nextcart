// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_init.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the [OrderNotificationService] alive and wired to the current user's
/// orders stream. Re-evaluates whenever auth state changes.

@ProviderFor(orderNotificationService)
final orderNotificationServiceProvider = OrderNotificationServiceProvider._();

/// Keeps the [OrderNotificationService] alive and wired to the current user's
/// orders stream. Re-evaluates whenever auth state changes.

final class OrderNotificationServiceProvider
    extends
        $FunctionalProvider<
          OrderNotificationService,
          OrderNotificationService,
          OrderNotificationService
        >
    with $Provider<OrderNotificationService> {
  /// Keeps the [OrderNotificationService] alive and wired to the current user's
  /// orders stream. Re-evaluates whenever auth state changes.
  OrderNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderNotificationServiceHash();

  @$internal
  @override
  $ProviderElement<OrderNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrderNotificationService create(Ref ref) {
    return orderNotificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderNotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderNotificationService>(value),
    );
  }
}

String _$orderNotificationServiceHash() =>
    r'56f6a7cd634402aaf3006001f8b6a770eae32f52';
