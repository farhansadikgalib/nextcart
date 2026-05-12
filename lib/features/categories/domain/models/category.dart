import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
sealed class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? icon,
    String? image,
    @Default(0) int order,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  factory Category.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data() ?? <String, dynamic>{};
    return Category(
      id: snap.id,
      name: (data['name'] ?? '') as String,
      icon: data['icon'] as String?,
      image: data['image'] as String?,
      order: (data['order'] as num?)?.toInt() ?? 0,
    );
  }
}
