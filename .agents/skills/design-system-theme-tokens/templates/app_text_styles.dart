import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography definitions supporting theme-adaptive color resolution.
class AppTextStyles {
  // Display Styles (Large headers, hero titles)
  static TextStyle displayLarge({Color? color}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle displayLargeBold({Color? color}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle displayMedium({Color? color}) => TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimaryLight,
  );

  // Title Styles (AppBars, Card headers, Section titles)
  static TextStyle titleLarge({Color? color}) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle titleLargeBold({Color? color}) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimaryLight,
  );

  // Body Styles (Standard paragraphs, form inputs, button labels)
  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodyLargeBold({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodyMediumBold({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textMutedLight,
  );

  static TextStyle bodySmallBold({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimaryLight,
  );
}
