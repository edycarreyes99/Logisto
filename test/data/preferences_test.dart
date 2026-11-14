import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/language_enum.dart';
import 'package:logisto/core/enums/theme_mode_enum.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppPreferences Encapsulated Key-Value Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saves and retrieves session tokens and IDs', () async {
      final prefs = await AppPreferences.getInstance();
      await prefs.saveSession(token: 'jwt_token_123', userId: 'user_456');

      expect(prefs.getToken(), 'jwt_token_123');
      expect(prefs.getUserId(), 'user_456');

      await prefs.clearSession();
      expect(prefs.getToken(), isNull);
      expect(prefs.getUserId(), isNull);
    });

    test(
      'saves and retrieves active organization and business unit context',
      () async {
        final prefs = await AppPreferences.getInstance();
        expect(prefs.getActiveOrgId(), isNull);
        expect(prefs.getActiveBuId(), isNull);

        await prefs.saveActiveOrgId('org_castillo');
        await prefs.saveActiveBuId('bu_billar');

        expect(prefs.getActiveOrgId(), 'org_castillo');
        expect(prefs.getActiveBuId(), 'bu_billar');
      },
    );

    test('persists onboarding flag', () async {
      final prefs = await AppPreferences.getInstance();
      expect(prefs.isOnboardingCompleted(), isFalse);

      await prefs.setOnboardingCompleted(true);
      expect(prefs.isOnboardingCompleted(), isTrue);
    });

    test(
      'persists and retrieves strongly-typed language and theme enums',
      () async {
        final prefs = await AppPreferences.getInstance();
        expect(prefs.getLanguage(), LanguageEnum.es); // Default fallback
        expect(prefs.getThemeMode(), ThemeModeEnum.light);

        await prefs.saveLanguage(LanguageEnum.en);
        await prefs.saveThemeMode(ThemeModeEnum.dark);

        expect(prefs.getLanguage(), LanguageEnum.en);
        expect(prefs.getThemeMode(), ThemeModeEnum.dark);

        await prefs.clearAll();
        expect(prefs.getLanguage(), LanguageEnum.es);
      },
    );
  });
}
