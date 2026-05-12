import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_storage.g.dart';

/// Secure storage provider for sensitive data (tokens, keys).
@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

/// Helper class for common storage operations.
class LocalStorage {
  const LocalStorage(this._secure);

  final FlutterSecureStorage _secure;

  // ── Tokens ───────────────────────────────────────────────────────────

  Future<void> saveToken(String token) =>
      _secure.write(key: 'access_token', value: token);

  Future<String?> getToken() => _secure.read(key: 'access_token');

  Future<void> saveRefreshToken(String token) =>
      _secure.write(key: 'refresh_token', value: token);

  Future<String?> getRefreshToken() => _secure.read(key: 'refresh_token');

  Future<void> clearTokens() async {
    await _secure.delete(key: 'access_token');
    await _secure.delete(key: 'refresh_token');
  }

  // ── Generic Key-Value ────────────────────────────────────────────────

  Future<void> write(String key, String value) =>
      _secure.write(key: key, value: value);

  Future<String?> read(String key) => _secure.read(key: key);

  Future<void> delete(String key) => _secure.delete(key: key);

  Future<void> clearAll() => _secure.deleteAll();
}
