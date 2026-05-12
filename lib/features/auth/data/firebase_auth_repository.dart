import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/auth/domain/auth_repository.dart';
import 'package:nextcart/features/auth/domain/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_repository.g.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  bool _initialized = false;

  // Firebase Web OAuth client ID (from google-services.json, client_type 3).
  // Required on Android so Credential Manager mints an idToken accepted by
  // Firebase Auth — otherwise the account picker closes as `canceled`.
  static const _serverClientId =
      '178102738420-2g5fp33g5hod52fid4sk5b648gtlugac.apps.googleusercontent.com';

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    try {
      await _googleSignIn.initialize(serverClientId: _serverClientId);
    } catch (_) {
      // initialize() may throw if called twice or on unsupported platforms;
      // safe to swallow — calls below will surface real errors.
    }
    _initialized = true;
  }

  @override
  Stream<User?> authState() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<AppUser?> signInWithGoogle() async {
    await _ensureInitialized();

    final GoogleSignInAccount account = await _googleSignIn.authenticate(
      scopeHint: const ['email', 'profile'],
    );
    final GoogleSignInAuthentication tokens = account.authentication;

    final credential = GoogleAuthProvider.credential(idToken: tokens.idToken);

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) return null;

    return ensureUserDocument(firebaseUser);
  }

  @override
  Future<void> signOut() async {
    await _ensureInitialized();
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // ignore — proceed with Firebase sign-out
    }
    await _auth.signOut();
  }

  @override
  Future<AppUser?> ensureUserDocument(User firebaseUser) async {
    final ref = _firestore.collection('users').doc(firebaseUser.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      final data = <String, dynamic>{
        'name': firebaseUser.displayName ?? '',
        'email': firebaseUser.email ?? '',
        'photoUrl': firebaseUser.photoURL,
        'phone': firebaseUser.phoneNumber,
        'address': null,
        'city': null,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await ref.set(data);
    } else {
      // Keep name, email, and photo in sync with the auth provider.
      await ref.update(<String, dynamic>{
        'name': firebaseUser.displayName ?? '',
        'email': firebaseUser.email ?? '',
        'photoUrl': firebaseUser.photoURL,
      });
    }
    final fresh = await ref.get();
    return AppUser.fromFirestore(fresh);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
}

@riverpod
Stream<AppUser?> currentAppUser(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;
    final snap = await firestore.collection('users').doc(user.uid).get();
    if (!snap.exists) {
      await ref.read(authRepositoryProvider).ensureUserDocument(user);
      final fresh = await firestore.collection('users').doc(user.uid).get();
      return AppUser.fromFirestore(fresh);
    }
    return AppUser.fromFirestore(snap);
  });
}
