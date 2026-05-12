import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/core/storage/local_storage.dart';
import 'package:nextcart/features/profile/data/firebase_user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

const _themeModeKey = 'theme_mode';

@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  late FlutterSecureStorage _secure;

  @override
  ThemeMode build() {
    _secure = ref.read(secureStorageProvider);
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final raw = await _secure.read(key: _themeModeKey);
    final mode = switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    if (mode != state) state = mode;
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _secure.write(key: _themeModeKey, value: mode.name);
  }
}

@riverpod
class ProfileEditor extends _$ProfileEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> save({
    required String phone,
    required String address,
    required String city,
  }) async {
    state = const AsyncLoading();
    try {
      final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (uid == null) throw StateError('Not signed in');
      await ref.read(userRepositoryProvider).updateProfile(
            userId: uid,
            phone: phone,
            address: address,
            city: city,
          );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
