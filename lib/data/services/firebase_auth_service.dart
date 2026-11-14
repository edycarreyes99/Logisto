import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../domain/services/auth_service.dart';

/// Concrete multiplatform implementation of [AuthService] backed by [FirebaseAuth].
/// Complies with universal desktop (macOS, Windows), mobile (Android, iOS), and web execution.
class FirebaseAuthService implements AuthService {
  final FirebaseAuth? _customAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _customAuth = firebaseAuth;

  FirebaseAuth? get _auth {
    if (_customAuth != null) return _customAuth;
    if (Firebase.apps.isNotEmpty) {
      try {
        return FirebaseAuth.instance;
      } catch (_) {}
    }
    return null;
  }

  @override
  Stream<User?> get authStateChanges =>
      _auth?.authStateChanges() ?? const Stream.empty();

  @override
  User? get currentUser => _auth?.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'no-firebase-app',
        message: 'Firebase is not initialized in this environment.',
      );
    }
    return await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'no-firebase-app',
        message: 'Firebase is not initialized in this environment.',
      );
    }
    final credential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    if (displayName != null && displayName.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(displayName.trim());
    }

    return credential;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    final auth = _auth;
    if (auth == null) return;
    await auth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth?.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> reloadUser() async {
    await _auth?.currentUser?.reload();
  }

  @override
  Future<void> signOut() async {
    await _auth?.signOut();
  }
}
