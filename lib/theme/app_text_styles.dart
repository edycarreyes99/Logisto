import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography definitions supporting theme-adaptive color resolution.
/// Conforms to RULE-UI-004.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge({Color? color}) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle titleLarge({Color? color}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle titleMedium({Color? color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle titleSmall({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyLarge({Color? color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle bodyMediumBold({Color? color}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle bodySmall({Color? color}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle labelSmall({Color? color}) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textMutedLight,
      );
}
