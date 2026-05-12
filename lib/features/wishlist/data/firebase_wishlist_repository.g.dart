// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_wishlist_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wishlistRepository)
final wishlistRepositoryProvider = WishlistRepositoryProvider._();

final class WishlistRepositoryProvider
    extends
        $FunctionalProvider<
          WishlistRepository,
          WishlistRepository,
          WishlistRepository
        >
    with $Provider<WishlistRepository> {
  WishlistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistRepositoryHash();

  @$internal
  @override
  $ProviderElement<WishlistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WishlistRepository create(Ref ref) {
    return wishlistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WishlistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WishlistRepository>(value),
    );
  }
}

String _$wishlistRepositoryHash() =>
    r'3ab8ad3b02cc76f598c1a435b0af48c5a7b45f55';

@ProviderFor(wishlistStream)
final wishlistStreamProvider = WishlistStreamProvider._();

final class WishlistStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WishlistItem>>,
          List<WishlistItem>,
          Stream<List<WishlistItem>>
        >
    with
        $FutureModifier<List<WishlistItem>>,
        $StreamProvider<List<WishlistItem>> {
  WishlistStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<WishlistItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WishlistItem>> create(Ref ref) {
    return wishlistStream(ref);
  }
}

String _$wishlistStreamHash() => r'bf66d076f9b518f6ce31b4dbc08f96c17fb3695e';
