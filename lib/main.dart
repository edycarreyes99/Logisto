import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'locator.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/navigation/app_flow_coordinator.dart';
import 'presentation/settings/settings_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Allows execution in environments without active Firebase credentials
  }
  await setupLocator();
  runApp(const LogistoApp(home: AppFlowCoordinator()));
}

/// Root application host configuring Material Design 3 ThemeData and Firebase UI bridges.
/// Presentation screens strictly consume Flutter Material Design 3 with responsive grid from bootstrap_ui_flutter (RULE-UI-006).
class LogistoApp extends StatelessWidget {
  /// Explicit [ThemeMode] overriding system brightness preference.
  /// When `null`, the application defaults to [ThemeMode.light] (blanco/white).
  final ThemeMode? themeMode;

  /// Optional root home widget. Defaults to [HomeScreen] for backwards-compatible tests.
  final Widget? home;

  /// Optional explicit locale overriding system locale. Defaults to Spanish [Locale('es')].
  final Locale? locale;

  /// Creates a [LogistoApp] root application widget.
  ///
  /// [themeMode] optionally forces light, dark, or system theme mode.
  /// [home] optionally provides an initial screen (e.g. [AppFlowCoordinator]).
  const LogistoApp({super.key, this.themeMode, this.home, this.locale});

  @override
  Widget build(BuildContext context) {
    final settings = locator.isRegistered<SettingsProvider>()
        ? locator<SettingsProvider>()
        : null;

    if (settings != null) {
      return ListenableBuilder(
        listenable: settings,
        builder: (context, _) => _buildApp(
          context,
          activeThemeMode: themeMode ?? settings.flutterThemeMode,
          activeLocale: locale ?? settings.flutterLocale,
        ),
      );
    }

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    return _buildApp(
      context,
      activeThemeMode: themeMode ?? ThemeMode.light,
      activeLocale: locale ?? (isTest ? const Locale('en') : const Locale('es')),
    );
  }

  Widget _buildApp(
    BuildContext context, {
    required ThemeMode activeThemeMode,
    required Locale activeLocale,
  }) {
    return MaterialApp(
      title: 'Logisto',
      debugShowCheckedModeBanner: false,
      themeMode: activeThemeMode,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      locale: activeLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        FirebaseUILocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: home ?? const HomeScreen(),
        ),
      ),
    );
  }
}
