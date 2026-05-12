// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductSortController)
final productSortControllerProvider = ProductSortControllerProvider._();

final class ProductSortControllerProvider
    extends $NotifierProvider<ProductSortController, ProductSort> {
  ProductSortControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productSortControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productSortControllerHash();

  @$internal
  @override
  ProductSortController create() => ProductSortController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductSort>(value),
    );
  }
}

String _$productSortControllerHash() =>
    r'0df7647464ac70b1eade76ef16fe1f6a08472cd0';

abstract class _$ProductSortController extends $Notifier<ProductSort> {
  ProductSort build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProductSort, ProductSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProductSort, ProductSort>,
              ProductSort,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
