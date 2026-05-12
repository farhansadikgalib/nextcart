import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/auth/domain/models/app_user.dart';
import 'package:nextcart/features/profile/domain/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_user_repository.g.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String userId) =>
      _firestore.collection('users').doc(userId);

  @override
  Future<AppUser?> getUser(String userId) async {
    final snap = await _doc(userId).get();
    if (!snap.exists) return null;
    return AppUser.fromFirestore(snap);
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? phone,
    String? address,
    String? city,
  }) async {
    final updates = <String, dynamic>{};
    if (phone != null) updates['phone'] = phone;
    if (address != null) updates['address'] = address;
    if (city != null) updates['city'] = city;
    if (updates.isEmpty) return;
    await _doc(userId).update(updates);
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return FirebaseUserRepository(ref.watch(firestoreProvider));
}
