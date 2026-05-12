// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_product_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'22c5bd4af0ab95a637cd4000ae04af5ff27938b5';

@ProviderFor(productsStream)
final productsStreamProvider = ProductsStreamFamily._();

final class ProductsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  ProductsStreamProvider._({
    required ProductsStreamFamily super.from,
    required ProductSort super.argument,
  }) : super(
         retry: null,
         name: r'productsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsStreamHash();

  @override
  String toString() {
    return r'productsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Product>> create(Ref ref) {
    final argument = this.argument as ProductSort;
    return productsStream(ref, sort: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsStreamHash() => r'999aec8de304b85de5b2f6003a1660fe38c20b26';

final class ProductsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Product>>, ProductSort> {
  ProductsStreamFamily._()
    : super(
        retry: null,
        name: r'productsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductsStreamProvider call({ProductSort sort = ProductSort.newest}) =>
      ProductsStreamProvider._(argument: sort, from: this);

  @override
  String toString() => r'productsStreamProvider';
}

@ProviderFor(productsByCategoryStream)
final productsByCategoryStreamProvider = ProductsByCategoryStreamFamily._();

final class ProductsByCategoryStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  ProductsByCategoryStreamProvider._({
    required ProductsByCategoryStreamFamily super.from,
    required (String, {ProductSort sort}) super.argument,
  }) : super(
         retry: null,
         name: r'productsByCategoryStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsByCategoryStreamHash();

  @override
  String toString() {
    return r'productsByCategoryStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Product>> create(Ref ref) {
    final argument = this.argument as (String, {ProductSort sort});
    return productsByCategoryStream(ref, argument.$1, sort: argument.sort);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByCategoryStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsByCategoryStreamHash() =>
    r'46b8f63917d9f390a4193ad386f09534c43ef30b';

final class ProductsByCategoryStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<Product>>,
          (String, {ProductSort sort})
        > {
  ProductsByCategoryStreamFamily._()
    : super(
        retry: null,
        name: r'productsByCategoryStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductsByCategoryStreamProvider call(
    String categoryId, {
    ProductSort sort = ProductSort.newest,
  }) => ProductsByCategoryStreamProvider._(
    argument: (categoryId, sort: sort),
    from: this,
  );

  @override
  String toString() => r'productsByCategoryStreamProvider';
}

@ProviderFor(productById)
final productByIdProvider = ProductByIdFamily._();

final class ProductByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Product?>, Product?, FutureOr<Product?>>
    with $FutureModifier<Product?>, $FutureProvider<Product?> {
  ProductByIdProvider._({
    required ProductByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productByIdHash();

  @override
  String toString() {
    return r'productByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product?> create(Ref ref) {
    final argument = this.argument as String;
    return productById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productByIdHash() => r'a673dd302629ad55441e6136d97ebda4b8f86afe';

final class ProductByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product?>, String> {
  ProductByIdFamily._()
    : super(
        retry: null,
        name: r'productByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductByIdProvider call(String id) =>
      ProductByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'productByIdProvider';
}
