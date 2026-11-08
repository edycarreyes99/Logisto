import 'package:flutter/material.dart';

/// Global provider managing active application theme mode.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Active Flutter [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Updates the application theme mode.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }
}
