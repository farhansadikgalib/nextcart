// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_cart_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartRepository)
final cartRepositoryProvider = CartRepositoryProvider._();

final class CartRepositoryProvider
    extends $FunctionalProvider<CartRepository, CartRepository, CartRepository>
    with $Provider<CartRepository> {
  CartRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartRepositoryHash();

  @$internal
  @override
  $ProviderElement<CartRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartRepository create(Ref ref) {
    return cartRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartRepository>(value),
    );
  }
}

String _$cartRepositoryHash() => r'806e339a53d248881dabd4a148d3e6a886794a5b';

@ProviderFor(cartStream)
final cartStreamProvider = CartStreamProvider._();

final class CartStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CartItem>>,
          List<CartItem>,
          Stream<List<CartItem>>
        >
    with $FutureModifier<List<CartItem>>, $StreamProvider<List<CartItem>> {
  CartStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<CartItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CartItem>> create(Ref ref) {
    return cartStream(ref);
  }
}

String _$cartStreamHash() => r'7f2d567b32ac3b836fb0fa93ece352ac0ab5741e';
