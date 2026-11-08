import 'package:shared_preferences/shared_preferences.dart';

/// High-level asynchronous wrapper over local SharedPreferences storage.
class AuthPreferences {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keySyncCompleted = 'initial_sync_completed';
  static const String _keyLanguage = 'selected_language';
  static const String _keyThemeMode = 'selected_theme_mode';

  final SharedPreferences _prefs;
  AuthPreferences._(this._prefs);

  /// Asynchronously creates an [AuthPreferences] instance.
  ///
  /// Returns a singleton [AuthPreferences] initialized with device preferences.
  static Future<AuthPreferences> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthPreferences._(prefs);
  }

  /// Stores active session credentials to device storage.
  ///
  /// - [token]: Authentication token.
  /// - [userId]: Unique user identifier.
  /// Returns a [Future] completing once written.
  Future<void> saveSession({required String token, required String userId}) async {
    await _prefs.setString(_keyToken, token);
    await _prefs.setString(_keyUserId, userId);
  }

  /// Retrieves the persisted session token, if any.
  ///
  /// Returns the stored token string or null if not found.
  String? getToken() => _prefs.getString(_keyToken);

  /// Retrieves the persisted user identifier, if any.
  ///
  /// Returns the stored user ID string or null if not found.
  String? getUserId() => _prefs.getString(_keyUserId);

  /// Checks whether an active, non-empty session token is present.
  ///
  /// Returns true if a valid session exists; false otherwise.
  bool isSessionValid() => (getToken()?.isNotEmpty ?? false);

  /// Persists the selected language code.
  Future<void> saveLanguageCode(String code) async {
    await _prefs.setString(_keyLanguage, code);
  }

  /// Retrieves the persisted language code.
  String getLanguageCode() => _prefs.getString(_keyLanguage) ?? 'en';

  /// Persists the selected theme mode preference.
  Future<void> saveThemeModeName(String name) async {
    await _prefs.setString(_keyThemeMode, name);
  }

  /// Retrieves the persisted theme mode preference name.
  String getThemeModeName() => _prefs.getString(_keyThemeMode) ?? 'system';

  /// Updates the flag indicating whether initial sync warmup has completed.
  Future<void> setSyncCompleted(bool value) async => await _prefs.setBool(_keySyncCompleted, value);

  /// Checks whether initial synchronization completed.
  bool getSyncCompleted() => _prefs.getBool(_keySyncCompleted) ?? false;

  /// Clears all stored session credentials from preferences.
  Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keySyncCompleted);
  }
}
