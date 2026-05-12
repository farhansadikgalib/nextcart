import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
sealed class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
    String? phone,
    String? address,
    String? city,
    DateTime? createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data() ?? <String, dynamic>{};
    return AppUser(
      id: snap.id,
      name: (data['name'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      photoUrl: data['photoUrl'] as String?,
      phone: data['phone'] as String?,
      address: data['address'] as String?,
      city: data['city'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
