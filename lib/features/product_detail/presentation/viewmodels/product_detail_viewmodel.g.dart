// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductQuantity)
final productQuantityProvider = ProductQuantityFamily._();

final class ProductQuantityProvider
    extends $NotifierProvider<ProductQuantity, int> {
  ProductQuantityProvider._({
    required ProductQuantityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productQuantityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productQuantityHash();

  @override
  String toString() {
    return r'productQuantityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductQuantity create() => ProductQuantity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductQuantityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productQuantityHash() => r'9993fae205625f3aed80d4c9052e2440a27db5f9';

final class ProductQuantityFamily extends $Family
    with $ClassFamilyOverride<ProductQuantity, int, int, int, String> {
  ProductQuantityFamily._()
    : super(
        retry: null,
        name: r'productQuantityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductQuantityProvider call(String productId) =>
      ProductQuantityProvider._(argument: productId, from: this);

  @override
  String toString() => r'productQuantityProvider';
}

abstract class _$ProductQuantity extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get productId => _$args;

  int build(String productId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
