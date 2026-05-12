// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_notification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationRepository)
final notificationRepositoryProvider = NotificationRepositoryProvider._();

final class NotificationRepositoryProvider
    extends
        $FunctionalProvider<
          FirebaseNotificationRepository,
          FirebaseNotificationRepository,
          FirebaseNotificationRepository
        >
    with $Provider<FirebaseNotificationRepository> {
  NotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<FirebaseNotificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseNotificationRepository create(Ref ref) {
    return notificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseNotificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseNotificationRepository>(
        value,
      ),
    );
  }
}

String _$notificationRepositoryHash() =>
    r'644a974a3176c434f1fcbae510045a48aa58c4af';

@ProviderFor(notificationsStream)
final notificationsStreamProvider = NotificationsStreamProvider._();

final class NotificationsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppNotification>>,
          List<AppNotification>,
          Stream<List<AppNotification>>
        >
    with
        $FutureModifier<List<AppNotification>>,
        $StreamProvider<List<AppNotification>> {
  NotificationsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<AppNotification>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AppNotification>> create(Ref ref) {
    return notificationsStream(ref);
  }
}

String _$notificationsStreamHash() =>
    r'cbb2e483cdfe7942d848db1f7d6675686bac6cfe';

@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = UnreadNotificationCountProvider._();

final class UnreadNotificationCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  UnreadNotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return unreadNotificationCount(ref);
  }
}

String _$unreadNotificationCountHash() =>
    r'0130c547578cfd858e4d12b0c7e25c1cec0c9a25';
