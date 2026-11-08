---
id: RULE-DATA-004
title: Encapsulated Local Key-Value Storage
category: data
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
---

# Encapsulated Local Key-Value Storage

> Rule ID: RULE-DATA-004  
> Severity: blocking  
> Target Scope: lib/**  
> Category: data  

---

## 1. Architectural Invariant

All device-local key-value persistence via `SharedPreferences` MUST be strictly encapsulated within dedicated wrapper services located exclusively in `lib/data/preferences/` (e.g., `AuthPreferences`, `AppPreferences`).

Under no circumstances shall:
1. Any file outside of `lib/data/preferences/` call `SharedPreferences.getInstance()` or invoke `prefs.getString()`, `prefs.setString()`, `prefs.getBool()`, etc.
2. Presentation widgets, controllers, providers, or Domain services access raw storage keys or invoke SharedPreferences directly.
3. Storage keys be exposed as public constants or dynamic string literals across the application.
4. Preference wrappers store or return unvalidated raw string tokens when strongly-typed Enums (e.g., `LanguageEnum`, `ThemeModeEnum`) represent the underlying domain concepts.

---

## 2. Rationale & Failure Impact

- **Type Safety & Schema Integrity:** SharedPreferences operates on loosely-typed key-value maps with raw string keys. Scattering preference calls throughout UI widgets or domain services inevitably causes typo-induced data corruption, key collisions, and broken default values.
- **Testability & Mocking:** When UI or Domain code directly touches `SharedPreferences.getInstance()`, unit tests require complex platform channel mocking. Wrapping preferences into an injectable service registered in `lib/locator.dart` enables seamless interface mocking and isolated testing.
- **Security & Lifecycle Isolation:** Sensitive credentials (such as auth tokens and user IDs) require deterministic purging on logout. Centralizing persistence methods into a single class guarantees that session teardown operations completely invalidate all stored tokens.

---

## 3. Compliant Pattern (DO)

All preferences are accessed through a dedicated singleton wrapper registered via GetIt in `lib/locator.dart`:

```dart
// lib/data/preferences/auth_preferences.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/enums/language_enum.dart';
import '../../core/enums/theme_mode_enum.dart';

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
  static Future<AuthPreferences> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthPreferences._(prefs);
  }

  /// Stores active session credentials.
  Future<void> saveSession({required String token, required String userId}) async {
    await _prefs.setString(_keyToken, token);
    await _prefs.setString(_keyUserId, userId);
  }

  /// Retrieves the persisted session token.
  String? getToken() => _prefs.getString(_keyToken);

  /// Persists the selected language code using strongly-typed enum.
  Future<void> saveLanguage(LanguageEnum language) async {
    await _prefs.setString(_keyLanguage, language.code);
  }

  /// Retrieves the persisted language choice.
  LanguageEnum getLanguage() {
    final code = _prefs.getString(_keyLanguage);
    return LanguageEnum.fromCode(code);
  }

  /// Clears all stored session credentials from preferences.
  Future<void> clearSession() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keySyncCompleted);
  }
}
```

Presentation and Domain consume `AuthPreferences` via dependency injection:

```dart
// lib/core/providers/locale_provider.dart
import 'package:flutter/foundation.dart';
import '../../data/preferences/auth_preferences.dart';
import '../enums/language_enum.dart';

class LocaleProvider extends ChangeNotifier {
  final AuthPreferences _preferences;
  LanguageEnum _currentLanguage;

  LocaleProvider(this._preferences)
      : _currentLanguage = _preferences.getLanguage();

  LanguageEnum get currentLanguage => _currentLanguage;

  Future<void> setLanguage(LanguageEnum language) async {
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    await _preferences.saveLanguage(language);
    notifyListeners();
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Directly invoking `SharedPreferences` inside widgets, screens, or domain services is strictly forbidden:

```dart
// BAD: Direct SharedPreferences access in presentation widget
class BadSettingsScreen extends StatelessWidget {
  const BadSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Change Language',
      onPressed: () async {
        // VIOLATION: Calling SharedPreferences.getInstance() directly in UI
        final prefs = await SharedPreferences.getInstance();
        // VIOLATION: Using raw string literal key and string value
        await prefs.setString('lang', 'es');
      },
    );
  }
}

// BAD: Direct SharedPreferences access in Domain service
class BadDomainService {
  Future<void> process() async {
    // VIOLATION: Domain layer must never import or consume persistence SDKs
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Execute the following commands to detect violations of this rule:

```bash
# 1. Ensure SharedPreferences is only imported inside data/preferences/
rg "package:shared_preferences/shared_preferences.dart" lib/ \
  --glob '!lib/data/preferences/**' \
  --glob '!lib/locator.dart' \
  --glob '!lib/app_initializer.dart'

# 2. Check for raw SharedPreferences instantiation outside data/preferences/
rg "SharedPreferences\.getInstance" lib/ \
  --glob '!lib/data/preferences/**' \
  --glob '!lib/locator.dart' \
  --glob '!lib/app_initializer.dart'
```

If any matches are returned outside `lib/data/preferences/` (or initialization wiring), refactor the call into a dedicated preference wrapper class.
