import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } on GoogleSignInException catch (e) {
      if (!ref.mounted) return;
      state = AsyncError(_googleMessage(e), StackTrace.current);
    } on FirebaseAuthException catch (e) {
      if (!ref.mounted) return;
      state = AsyncError(_firebaseMessage(e), StackTrace.current);
    } on SocketException catch (_) {
      if (!ref.mounted) return;
      state = AsyncError(
        'No internet connection. Please check your network and try again.',
        StackTrace.current,
      );
    } catch (e, st) {
      if (!ref.mounted) return;
      if (_isNetworkError(e)) {
        state = AsyncError(
          'No internet connection. Please check your network and try again.',
          StackTrace.current,
        );
      } else {
        state = AsyncError(
          'Something went wrong. Please try again.',
          st,
        );
      }
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncError(e, st);
    }
  }

  String _googleMessage(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Sign-in was cancelled. Tap the button to try again.';
      case GoogleSignInExceptionCode.interrupted:
        return 'Sign-in was interrupted. Please try again.';
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'Google Sign-In is not configured correctly.';
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'Google account provider error.';
      default:
        if (_isNetworkError(e)) {
          return 'No internet connection. Please check your network and try again.';
        }
        return 'Sign-in failed. Please try again.';
    }
  }

  String _firebaseMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return 'No internet connection. Please check your network and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support for help.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'Sign-in credentials expired. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return 'Sign-in failed. Please try again.';
    }
  }

  bool _isNetworkError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('network') ||
        msg.contains('socket') ||
        msg.contains('connection');
  }
}
