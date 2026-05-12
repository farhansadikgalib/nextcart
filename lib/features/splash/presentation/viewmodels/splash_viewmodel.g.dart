// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splashDestination)
final splashDestinationProvider = SplashDestinationProvider._();

final class SplashDestinationProvider
    extends
        $FunctionalProvider<
          AsyncValue<SplashDestination>,
          SplashDestination,
          FutureOr<SplashDestination>
        >
    with
        $FutureModifier<SplashDestination>,
        $FutureProvider<SplashDestination> {
  SplashDestinationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashDestinationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashDestinationHash();

  @$internal
  @override
  $FutureProviderElement<SplashDestination> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SplashDestination> create(Ref ref) {
    return splashDestination(ref);
  }
}

String _$splashDestinationHash() => r'fe43b3d6af338f34c26744c7c71e621972f26a78';
