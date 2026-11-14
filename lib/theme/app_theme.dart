import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimens.dart';

/// Central theme factory providing complete, production-ready ThemeData for
/// both Light and Dark operating modes using Flutter Material Design 3.
/// Conforms strictly to RULE-UI-004 and RULE-UI-006.
class AppTheme {
  AppTheme._();

  /// Builds the canonical Light ThemeData configuration.
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.backgroundLight,
      primaryContainer: const Color(0xFFCFE2FF),
      onPrimaryContainer: const Color(0xFF084298),
      secondary: AppColors.secondary,
      onSecondary: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainerHighest: AppColors.surfaceContainerLight,
      onSurfaceVariant: AppColors.textMutedLight,
      outline: AppColors.borderLight,
      outlineVariant: AppColors.borderLight,
      error: AppColors.error,
      onError: AppColors.backgroundLight,
      errorContainer: AppColors.errorContainerLight,
      onErrorContainer: AppColors.onErrorContainerLight,
    );

    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBg: AppColors.backgroundLight,
      cardBg: AppColors.surfaceLight,
      borderColor: AppColors.borderLight,
    );
  }

  /// Builds the canonical Dark ThemeData configuration.
  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.backgroundDark,
      primaryContainer: const Color(0xFF084298),
      onPrimaryContainer: const Color(0xFFCFE2FF),
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.backgroundLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceContainerDark,
      onSurfaceVariant: AppColors.textMutedDark,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.borderDark,
      error: AppColors.errorDark,
      onError: AppColors.backgroundDark,
      errorContainer: AppColors.errorContainerDark,
      onErrorContainer: AppColors.onErrorContainerDark,
    );

    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBg: AppColors.backgroundDark,
      cardBg: AppColors.surfaceContainerDark,
      borderColor: AppColors.borderDark,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBg,
    required Color cardBg,
    required Color borderColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: colorScheme,
      cardColor: cardBg,
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          side: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 10.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(
          colorScheme.surfaceContainerHighest,
        ),
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          color: colorScheme.onSurface,
        ),
        dataTextStyle: TextStyle(
          fontSize: 13.0,
          color: colorScheme.onSurface,
        ),
        dividerThickness: 1.0,
        horizontalMargin: 12.0,
        columnSpacing: 16.0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        labelStyle: TextStyle(
          fontSize: 12.0,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.modalRadius),
        ),
        elevation: 3.0,
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
