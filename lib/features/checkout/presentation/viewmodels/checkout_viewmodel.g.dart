// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckoutController)
final checkoutControllerProvider = CheckoutControllerProvider._();

final class CheckoutControllerProvider
    extends $NotifierProvider<CheckoutController, AsyncValue<AppOrder?>> {
  CheckoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutControllerHash();

  @$internal
  @override
  CheckoutController create() => CheckoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AppOrder?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AppOrder?>>(value),
    );
  }
}

String _$checkoutControllerHash() =>
    r'688b875fddf1a5ef9102607fbf45f5e47c63bf54';

abstract class _$CheckoutController extends $Notifier<AsyncValue<AppOrder?>> {
  AsyncValue<AppOrder?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppOrder?>, AsyncValue<AppOrder?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppOrder?>, AsyncValue<AppOrder?>>,
              AsyncValue<AppOrder?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
