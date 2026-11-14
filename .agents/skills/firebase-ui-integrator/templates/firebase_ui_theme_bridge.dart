import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Bridges ambient Flutter [ThemeData] and Material Design 3 design tokens.
/// Ensures pre-built Firebase UI widgets (inputs, buttons, cards, auth dialogs)
/// visually conform to the project's Material Design 3 design system per RULE-UI-006.
class FirebaseUiThemeBridge {
  FirebaseUiThemeBridge._();

  /// Compiles a [ThemeData] instance configured with Material Design 3 Light tokens.
  static ThemeData lightTheme() {
    return AppTheme.lightTheme();
  }

  /// Compiles a [ThemeData] instance configured with Material Design 3 Dark tokens.
  static ThemeData darkTheme() {
    return AppTheme.darkTheme();
  }
}
