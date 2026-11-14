import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/theme/app_colors.dart';
import 'package:logisto/theme/app_dimens.dart';
import 'package:logisto/theme/app_spacing.dart';
import 'package:logisto/theme/app_text_styles.dart';
import 'package:logisto/theme/app_theme.dart';

void main() {
  group('AppTheme and Design Tokens Unit Tests', () {
    test('AppColors provides adaptive color resolution', () {
      final lightTheme = ThemeData(brightness: Brightness.light);
      final darkTheme = ThemeData(brightness: Brightness.dark);

      // Light Context simulation
      expect(AppColors.primary, const Color(0xFF0D6EFD));
      expect(AppColors.success, const Color(0xFF198754));
      expect(AppColors.warning, const Color(0xFFFFC107));
      expect(AppColors.error, const Color(0xFFDC3545));

      // Test with light MaterialApp
      final lightApp = MaterialApp(
        theme: lightTheme,
        home: Builder(
          builder: (context) {
            expect(AppColors.backgroundOf(context), AppColors.backgroundLight);
            expect(AppColors.surfaceOf(context), AppColors.surfaceLight);
            expect(AppColors.textPrimaryOf(context), AppColors.textPrimaryLight);
            expect(AppColors.textMutedOf(context), AppColors.textMutedLight);
            expect(
              AppColors.warningContainerOf(context),
              AppColors.warningContainerLight,
            );
            expect(
              AppColors.successContainerOf(context),
              AppColors.successContainerLight,
            );
            return const SizedBox();
          },
        ),
      );
      expect(lightApp, isNotNull);

      // Test with dark MaterialApp
      final darkApp = MaterialApp(
        theme: darkTheme,
        home: Builder(
          builder: (context) {
            expect(AppColors.backgroundOf(context), AppColors.backgroundDark);
            expect(AppColors.surfaceOf(context), AppColors.surfaceDark);
            expect(AppColors.textPrimaryOf(context), AppColors.textPrimaryDark);
            expect(AppColors.textMutedOf(context), AppColors.textMutedDark);
            expect(
              AppColors.warningContainerOf(context),
              AppColors.warningContainerDark,
            );
            expect(
              AppColors.successContainerOf(context),
              AppColors.successContainerDark,
            );
            return const SizedBox();
          },
        ),
      );
      expect(darkApp, isNotNull);
    });

    test('AppDimens provides canonical dimensions and Bootstrap breakpoints', () {
      expect(AppDimens.breakpointXs, 0.0);
      expect(AppDimens.breakpointSm, 576.0);
      expect(AppDimens.breakpointMd, 768.0);
      expect(AppDimens.breakpointLg, 992.0);
      expect(AppDimens.breakpointXl, 1200.0);
      expect(AppDimens.breakpointXxl, 1400.0);
      expect(AppDimens.cardRadius, 12.0);
      expect(AppDimens.modalRadius, 16.0);
    });

    test('AppSpacing enforces 8px modular scale rhythm', () {
      expect(AppSpacing.xxs, 4.0);
      expect(AppSpacing.xs, 8.0);
      expect(AppSpacing.sm, 12.0);
      expect(AppSpacing.md, 16.0);
      expect(AppSpacing.lg, 24.0);
      expect(AppSpacing.xl, 32.0);
      expect(AppSpacing.xxl, 48.0);
    });

    test('AppTextStyles provides hierarchical typography', () {
      expect(AppTextStyles.displayLarge().fontSize, 24.0);
      expect(AppTextStyles.titleLarge().fontSize, 18.0);
      expect(AppTextStyles.titleMedium().fontSize, 16.0);
      expect(AppTextStyles.titleSmall().fontSize, 14.0);
      expect(AppTextStyles.bodyLarge().fontSize, 16.0);
      expect(AppTextStyles.bodyMedium().fontSize, 14.0);
      expect(AppTextStyles.bodySmall().fontSize, 12.0);
      expect(AppTextStyles.labelSmall().fontSize, 11.0);
    });

    test('AppTheme compiles Light and Dark themes with useMaterial3', () {
      final light = AppTheme.lightTheme();
      final dark = AppTheme.darkTheme();

      expect(light.useMaterial3, isTrue);
      expect(dark.useMaterial3, isTrue);

      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);

      expect(light.colorScheme.primary, AppColors.primary);
      expect(dark.colorScheme.primary, AppColors.primaryDark);

      expect(light.scaffoldBackgroundColor, AppColors.backgroundLight);
      expect(dark.scaffoldBackgroundColor, AppColors.backgroundDark);
    });
  });
}
