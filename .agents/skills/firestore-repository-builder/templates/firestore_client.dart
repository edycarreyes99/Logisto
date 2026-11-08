import 'package:cloud_firestore/cloud_firestore.dart';

/// Configures and manages the universal Cloud Firestore client instance.
///
/// Ensures offline persistence is enabled across all supported targets:
/// IndexedDB on Web, local SQLite/LevelDB disk cache on mobile and desktop.
class FirestoreClient {
  /// The underlying Cloud Firestore client instance.
  final FirebaseFirestore firestore;

  /// Creates a [FirestoreClient] with an optional injected [FirebaseFirestore] instance.
  ///
  /// - [instance]: Optional custom Firestore instance for testing or dependency injection.
  FirestoreClient({FirebaseFirestore? instance})
      : firestore = instance ?? FirebaseFirestore.instance;

  /// Asynchronously initializes Firestore with multiplatform persistence settings.
  ///
  /// Returns a configured [FirestoreClient] instance ready for application-wide use.
  static Future<FirestoreClient> initialize() async {
    final instance = FirebaseFirestore.instance;

    instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    return FirestoreClient(instance: instance);
  }

  /// Manually enables network connectivity for remote synchronization.
  ///
  /// Returns a [Future] completing once network access is restored.
  Future<void> enableNetwork() => firestore.enableNetwork();

  /// Manually disables network connectivity to enforce offline mode.
  ///
  /// Returns a [Future] completing once network access is disabled.
  Future<void> disableNetwork() => firestore.disableNetwork();

  /// Clears the local persistent cache from disk or IndexedDB storage.
  ///
  /// Throws [FirebaseException] if the client is still active when called.
  /// Returns a [Future] completing once the cache has been wiped.
  Future<void> clearPersistence() => firestore.clearPersistence();
}
