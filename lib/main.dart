import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'presentation/home/home_screen.dart';

void main() {
  runApp(const LogistoApp());
}

/// Root application host configuring Bootstrap theme extensions.
/// All presentation screens strictly consume bootstrap_ui_flutter (RULE-UI-006).
class LogistoApp extends StatelessWidget {
  /// Explicit [ThemeMode] overriding system brightness preference.
  /// When `null`, the application defaults to [ThemeMode.system].
  final ThemeMode? themeMode;

  /// Creates a [LogistoApp] root application widget.
  ///
  /// [themeMode] optionally forces light, dark, or system theme mode.
  const LogistoApp({super.key, this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logisto',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: BsThemeData.lightTheme.bodyBg,
        extensions: [BsThemeData.lightTheme],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: BsThemeData.darkTheme.bodyBg,
        extensions: [BsThemeData.darkTheme],
      ),
      home: Builder(
        builder: (context) => Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
