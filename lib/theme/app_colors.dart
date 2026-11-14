import 'package:flutter/material.dart';

/// Centralized design token repository for all application color palettes.
/// Provides distinct semantic color tokens for both Light and Dark themes,
/// ensuring full WCAG AA contrast compliance and visual consistency.
/// Conforms to RULE-UI-004.
class AppColors {
  AppColors._();

  // Brand and Accent Colors
  static const Color primary = Color(0xFF0D6EFD);
  static const Color primaryDark = Color(0xFF6EA8FE);
  static const Color secondary = Color(0xFF6C757D);
  static const Color secondaryDark = Color(0xFF8A939B);

  // Semantic Feedback States
  static const Color success = Color(0xFF198754);
  static const Color successContainerLight = Color(0xFFD1E7DD);
  static const Color successContainerDark = Color(0xFF0F5132);
  static const Color onSuccessContainerLight = Color(0xFF0F5132);
  static const Color onSuccessContainerDark = Color(0xFFD1E7DD);

  static const Color warning = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFFFDA6A);
  static const Color warningContainerLight = Color(0xFFFFF3CD);
  static const Color warningContainerDark = Color(0xFF664D03);
  static const Color onWarningContainerLight = Color(0xFF664D03);
  static const Color onWarningContainerDark = Color(0xFFFFF3CD);

  static const Color error = Color(0xFFDC3545);
  static const Color errorDark = Color(0xFFEA868F);
  static const Color errorContainerLight = Color(0xFFF8D7DA);
  static const Color errorContainerDark = Color(0xFF842029);
  static const Color onErrorContainerLight = Color(0xFF842029);
  static const Color onErrorContainerDark = Color(0xFFF8D7DA);

  static const Color info = Color(0xFF0DCAF0);

  // Light Theme Surfaces and Typography
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLight = Color(0xFFF8F9FA);
  static const Color borderLight = Color(0xFFDEE2E6);
  static const Color textPrimaryLight = Color(0xFF212529);
  static const Color textMutedLight = Color(0xFF6C757D);

  // Dark Theme Surfaces and Typography
  static const Color backgroundDark = Color(0xFF212529);
  static const Color surfaceDark = Color(0xFF212529);
  static const Color surfaceContainerDark = Color(0xFF2B3035);
  static const Color borderDark = Color(0xFF495057);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textMutedDark = Color(0xFFADB5BD);

  /// Resolves the adaptive background canvas color based on current theme brightness.
  static Color backgroundOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }

  /// Resolves the adaptive surface container color based on current theme brightness.
  static Color surfaceOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? surfaceDark
        : surfaceLight;
  }

  /// Resolves secondary surface container color based on current theme brightness.
  static Color surfaceContainerOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? surfaceContainerDark
        : surfaceContainerLight;
  }

  /// Resolves the adaptive card container color based on current theme brightness.
  static Color cardOf(BuildContext context) {
    return surfaceOf(context);
  }

  /// Resolves the adaptive border outline color based on current theme brightness.
  static Color borderOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? borderDark
        : borderLight;
  }

  /// Resolves the adaptive primary text color based on current theme brightness.
  static Color textPrimaryOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textPrimaryDark
        : textPrimaryLight;
  }

  /// Resolves the adaptive muted text color based on current theme brightness.
  static Color textMutedOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textMutedDark
        : textMutedLight;
  }

  /// Resolves the warning container background based on current theme brightness.
  static Color warningContainerOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? warningContainerDark
        : warningContainerLight;
  }

  /// Resolves the warning text/icon color on warning containers based on theme brightness.
  static Color onWarningContainerOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? onWarningContainerDark
        : onWarningContainerLight;
  }

  /// Resolves the success container background based on current theme brightness.
  static Color successContainerOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? successContainerDark
        : successContainerLight;
  }

  /// Resolves the success text/icon color on success containers based on theme brightness.
  static Color onSuccessContainerOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? onSuccessContainerDark
        : onSuccessContainerLight;
  }
}
