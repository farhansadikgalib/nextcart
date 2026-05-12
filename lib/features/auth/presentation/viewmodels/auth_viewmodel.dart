import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextcart/features/auth/data/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      state = const AsyncData(null);
    } on GoogleSignInException catch (e) {
      state = AsyncError(_friendlyMessage(e), StackTrace.current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  String _friendlyMessage(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Sign-in cancelled.';
      case GoogleSignInExceptionCode.interrupted:
        return 'Sign-in was interrupted. Please try again.';
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'Google Sign-In is not configured correctly.';
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'Google account provider error.';
      default:
        return 'Sign-in failed. Please try again.';
    }
  }
}
