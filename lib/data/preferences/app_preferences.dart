import 'package:shared_preferences/shared_preferences.dart';
import '../../core/enums/language_enum.dart';
import '../../core/enums/theme_mode_enum.dart';

/// High-level asynchronous wrapper over local [SharedPreferences] storage.
/// Conforms to RULE-DATA-004 by encapsulating all key-value operations.
class AppPreferences {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyActiveOrgId = 'active_org_id';
  static const String _keyActiveBuId = 'active_bu_id';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyLanguage = 'selected_language';
  static const String _keyThemeMode = 'selected_theme_mode';

  final SharedPreferences _prefs;

  AppPreferences._(this._prefs);

  /// Asynchronously creates or initializes an [AppPreferences] instance.
  static Future<AppPreferences> getInstance({
    SharedPreferences? preferences,
  }) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    return AppPreferences._(prefs);
  }

  /// Stores active session credentials.
  Future<void> saveSession({
    required String token,
    required String userId,
  }) async {
    await _prefs.setString(_keyToken, token);
    await _prefs.setString(_keyUserId, userId);
  }

  /// Retrieves the persisted session token.
  String? getToken() => _prefs.getString(_keyToken);

  /// Retrieves the persisted user identifier.
  String? getUserId() => _prefs.getString(_keyUserId);

  /// Persists active Organization tenant identifier.
  Future<void> saveActiveOrgId(String orgId) async {
    await _prefs.setString(_keyActiveOrgId, orgId);
  }

  /// Retrieves the active Organization tenant identifier.
  String? getActiveOrgId() => _prefs.getString(_keyActiveOrgId);

  /// Persists active Business Unit (sucursal) identifier.
  Future<void> saveActiveBuId(String buId) async {
    await _prefs.setString(_keyActiveBuId, buId);
  }

  /// Retrieves the active Business Unit identifier.
  String? getActiveBuId() => _prefs.getString(_keyActiveBuId);

  /// Persists completion of first-time onboarding wizard.
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Returns whether first-time onboarding wizard has been finished.
  bool isOnboardingCompleted() =>
      _prefs.getBool(_keyOnboardingCompleted) ?? false;

  /// Persists selected language using strongly-typed [LanguageEnum].
  Future<void> saveLanguage(LanguageEnum language) async {
    await _prefs.setString(_keyLanguage, language.code);
  }

  /// Returns whether a language preference has been explicitly saved.
  bool hasLanguage() => _prefs.containsKey(_keyLanguage);

  /// Retrieves persisted language preference with fallback to Spanish.
  LanguageEnum getLanguage() {
    final code = _prefs.getString(_keyLanguage);
    return LanguageEnum.fromCode(code);
  }

  /// Persists selected theme mode using strongly-typed [ThemeModeEnum].
  Future<void> saveThemeMode(ThemeModeEnum mode) async {
    await _prefs.setString(_keyThemeMode, mode.storageKey);
  }

  /// Retrieves persisted theme mode with fallback to [ThemeModeEnum.light].
  ThemeModeEnum getThemeMode() {
    final key = _prefs.getString(_keyThemeMode);
    return ThemeModeEnum.fromStorageKey(key);
  }

  /// Clears active credentials and organization context upon logout.
  Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyActiveOrgId);
    await _prefs.remove(_keyActiveBuId);
  }

  /// Completely wipes all preferences (e.g. factory reset or testing).
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
