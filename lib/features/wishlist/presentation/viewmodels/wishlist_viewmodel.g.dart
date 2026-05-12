// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isInWishlist)
final isInWishlistProvider = IsInWishlistFamily._();

final class IsInWishlistProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsInWishlistProvider._({
    required IsInWishlistFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isInWishlistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isInWishlistHash();

  @override
  String toString() {
    return r'isInWishlistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isInWishlist(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsInWishlistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isInWishlistHash() => r'7082ce33f5d22981357044405623483796c20ed5';

final class IsInWishlistFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  IsInWishlistFamily._()
    : super(
        retry: null,
        name: r'isInWishlistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsInWishlistProvider call(String productId) =>
      IsInWishlistProvider._(argument: productId, from: this);

  @override
  String toString() => r'isInWishlistProvider';
}

@ProviderFor(WishlistController)
final wishlistControllerProvider = WishlistControllerProvider._();

final class WishlistControllerProvider
    extends $NotifierProvider<WishlistController, void> {
  WishlistControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistControllerHash();

  @$internal
  @override
  WishlistController create() => WishlistController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$wishlistControllerHash() =>
    r'69c4fe5ae59aaf0c845fa7b7c43311d05d0c6d02';

abstract class _$WishlistController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
