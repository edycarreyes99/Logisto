import 'package:firebase_auth/firebase_auth.dart';

/// Clean domain abstraction for multiplatform enterprise authentication.
/// Handles lifecycle operations: sign in, sign up, password recovery,
/// email verification, session reload, and sign out across Web, Desktop, and Mobile.
abstract class AuthService {
  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges;

  /// Currently authenticated Firebase user (or null).
  User? get currentUser;

  /// Authenticates using email and password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registers a new user account with email, password, and optional display name.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sends a password reset email to the specified address.
  Future<void> sendPasswordResetEmail({required String email});

  /// Sends an email verification link to the currently logged in user.
  Future<void> sendEmailVerification();

  /// Reloads the current user profile (e.g. to check updated emailVerified status).
  Future<void> reloadUser();

  /// Signs out of Firebase Authentication completely.
  Future<void> signOut();
}
