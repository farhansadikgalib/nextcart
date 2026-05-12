import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nextcart/core/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_viewmodel.g.dart';

const _recentSearchesKey = 'recent_searches';
const _maxRecent = 10;

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void set(String q) => state = q;
  void clear() => state = '';
}

@riverpod
class RecentSearches extends _$RecentSearches {
  late FlutterSecureStorage _secure;

  @override
  Future<List<String>> build() async {
    _secure = ref.read(secureStorageProvider);
    final raw = await _secure.read(key: _recentSearchesKey);
    if (raw == null || raw.isEmpty) return const [];
    final list = (jsonDecode(raw) as List).cast<String>();
    return list;
  }

  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = state.value ?? const <String>[];
    final updated = [
      trimmed,
      ...current.where((q) => q.toLowerCase() != trimmed.toLowerCase()),
    ].take(_maxRecent).toList();
    await _secure.write(
      key: _recentSearchesKey,
      value: jsonEncode(updated),
    );
    state = AsyncData(updated);
  }

  Future<void> clear() async {
    await _secure.delete(key: _recentSearchesKey);
    state = const AsyncData(<String>[]);
  }
}
