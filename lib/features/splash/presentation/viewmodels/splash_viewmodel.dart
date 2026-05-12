import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/core/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_viewmodel.g.dart';

const onboardingSeenKey = 'onboarding_seen';

enum SplashDestination { onboarding, auth, home }

@riverpod
Future<SplashDestination> splashDestination(Ref ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 900));

  final FlutterSecureStorage secure = ref.read(secureStorageProvider);
  final seen = (await secure.read(key: onboardingSeenKey)) == 'true';
  if (!seen) return SplashDestination.onboarding;

  final user = ref.read(firebaseAuthProvider).currentUser;
  return user == null ? SplashDestination.auth : SplashDestination.home;
}
