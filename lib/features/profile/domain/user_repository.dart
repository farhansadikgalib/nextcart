import 'package:nextcart/features/auth/domain/models/app_user.dart';

abstract class UserRepository {
  Future<void> updateProfile({
    required String userId,
    String? phone,
    String? address,
    String? city,
  });
  Future<AppUser?> getUser(String userId);
}
