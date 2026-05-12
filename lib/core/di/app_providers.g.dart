// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global app-level providers for dependency injection.
///
/// Feature-specific providers live inside each feature's
/// `presentation/providers/` folder.

@ProviderFor(localStorage)
final localStorageProvider = LocalStorageProvider._();

/// Global app-level providers for dependency injection.
///
/// Feature-specific providers live inside each feature's
/// `presentation/providers/` folder.

final class LocalStorageProvider
    extends $FunctionalProvider<LocalStorage, LocalStorage, LocalStorage>
    with $Provider<LocalStorage> {
  /// Global app-level providers for dependency injection.
  ///
  /// Feature-specific providers live inside each feature's
  /// `presentation/providers/` folder.
  LocalStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageHash();

  @$internal
  @override
  $ProviderElement<LocalStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalStorage create(Ref ref) {
    return localStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStorage>(value),
    );
  }
}

String _$localStorageHash() => r'e01fb17691e42af4a1f1a3e26f613e9b0ec536e8';
