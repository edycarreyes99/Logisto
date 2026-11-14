import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/theme/app_colors.dart';
import 'package:logisto/theme/firebase_ui_theme_bridge.dart';

void main() {
  group('FirebaseUiThemeBridge Unit Tests', () {
    test('lightTheme compiles with valid Material Design 3 tokens', () {
      final theme = FirebaseUiThemeBridge.lightTheme();

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundLight);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.error, AppColors.error);

      // Verify input decoration theme mirrors Material 3 standards
      expect(theme.inputDecorationTheme.filled, isTrue);
      expect(
        theme.inputDecorationTheme.fillColor,
        AppColors.surfaceLight,
      );

      // Verify card theme mirrors Material 3 standards
      expect(theme.cardTheme.color, AppColors.surfaceLight);
      expect(theme.cardTheme.elevation, 0.0);
    });

    test('darkTheme compiles with valid Material Design 3 dark tokens', () {
      final theme = FirebaseUiThemeBridge.darkTheme();

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
      expect(theme.primaryColor, AppColors.primaryDark);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundDark);
      expect(theme.colorScheme.primary, AppColors.primaryDark);
      expect(theme.colorScheme.error, AppColors.errorDark);

      // Verify input decoration theme mirrors Material 3 dark
      expect(theme.inputDecorationTheme.filled, isTrue);
      expect(
        theme.inputDecorationTheme.fillColor,
        AppColors.surfaceContainerDark,
      );

      // Verify card theme mirrors Material 3 dark
      expect(theme.cardTheme.color, AppColors.surfaceContainerDark);
      expect(theme.cardTheme.elevation, 0.0);
    });
  });
}
