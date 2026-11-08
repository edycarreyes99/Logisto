import 'package:flutter/material.dart';

/// Centralized design token repository for all application color palettes.
///
/// Provides distinct semantic color tokens for both Light and Dark themes,
/// ensuring full WCAG contrast compliance and visual consistency.
class AppColors {
  // Brand and Accent Colors (Universal)
  static const Color primary = Color(0xFF1E3A8A);       // Deep Institutional Primary Blue
  static const Color primaryLight = Color(0xFF3B82F6);  // Accent / Active Electric Blue
  static const Color secondary = Color(0xFF10B981);     // Emerald Secondary / Positive Action

  // Light Theme Surfaces and Backgrounds
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9);
  static const Color cardLight = Color(0xFFF8FAFC);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark Theme Surfaces and Backgrounds
  static const Color backgroundDark = Color(0xFF0F172A); // Deep Slate Navy Canvas
  static const Color surfaceDark = Color(0xFF1E293B);    // Elevated Slate Surface
  static const Color cardDark = Color(0xFF334155);       // Elevated Slate Card
  static const Color borderDark = Color(0xFF475569);     // High-contrast Dark Border

  // Typography Tokens (Light Theme)
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);

  // Typography Tokens (Dark Theme)
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textMutedDark = Color(0xFF94A3B8);

  // Semantic Feedback States (Light & Dark Compatible)
  static const Color success = Color(0xFF16A34A);       // Emerald Positive Alerts
  static const Color error = Color(0xFFDC2626);         // Destructive / Validation Error
  static const Color warning = Color(0xFFF59E0B);       // Warning / Attention Required
  static const Color info = Color(0xFF0284C7);          // Informational Blue

  // Canonical Brand Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Resolves the adaptive background canvas color based on current theme brightness.
  ///
  /// - [context]: Build context to query current ThemeData brightness.
  /// Returns [backgroundDark] if dark mode is active; otherwise [backgroundLight].
  static Color backgroundOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }

  /// Resolves the adaptive surface container color based on current theme brightness.
  ///
  /// - [context]: Build context to query current ThemeData brightness.
  /// Returns [surfaceDark] if dark mode is active; otherwise [surfaceLight].
  static Color surfaceOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? surfaceDark
        : surfaceLight;
  }

  /// Resolves the adaptive card container color based on current theme brightness.
  ///
  /// - [context]: Build context to query current ThemeData brightness.
  /// Returns [cardDark] if dark mode is active; otherwise [cardLight].
  static Color cardOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardDark
        : cardLight;
  }

  /// Resolves the adaptive border outline color based on current theme brightness.
  ///
  /// - [context]: Build context to query current ThemeData brightness.
  /// Returns [borderDark] if dark mode is active; otherwise [borderLight].
  static Color borderOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? borderDark
        : borderLight;
  }

  /// Resolves the adaptive primary text color based on current theme brightness.
  ///
  /// - [context]: Build context to query current ThemeData brightness.
  /// Returns [textPrimaryDark] if dark mode is active; otherwise [textPrimaryLight].
  static Color textPrimaryOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textPrimaryDark
        : textPrimaryLight;
  }

  /// Resolves the adaptive muted text color based on current theme brightness.
  ///
  /// - [context]: Build context to query current ThemeData brightness.
  /// Returns [textMutedDark] if dark mode is active; otherwise [textMutedLight].
  static Color textMutedOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textMutedDark
        : textMutedLight;
  }
}
