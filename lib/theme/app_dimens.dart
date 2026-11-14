import 'package:flutter/material.dart';

/// Centralized structural dimensions, padding tokens, and responsive breakpoints.
/// Conforms to RULE-UI-002 and RULE-UI-006.
class AppDimens {
  AppDimens._();

  // Page and Container Padding
  static const EdgeInsets paddingPage = EdgeInsets.all(16.0);
  static const double paddingBody = 16.0;

  // Border Radii Tokens
  static const double radiusSm = 8.0;
  static const double radius = 12.0;
  static const double cardRadius = 12.0;
  static const double modalRadius = 16.0;

  // Header and Navigation Heights
  static const double navbarHeight = 56.0;
  static const double sidebarWidth = 250.0;
  static const double footerHeight = 65.0;

  // Component Heights and Dimensions
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double searchBarHeight = 40.0;
  static const double textFieldHeight = 48.0;
  static const double iconSizeSm = 16.0;
  static const double iconSize = 20.0;
  static const double iconSizeLg = 24.0;

  // Canonical Bootstrap Responsive Grid Breakpoints (matching bootstrap_ui_flutter)
  static const double breakpointXs = 0.0;
  static const double breakpointSm = 576.0;
  static const double breakpointMd = 768.0;
  static const double breakpointLg = 992.0;
  static const double breakpointXl = 1200.0;
  static const double breakpointXxl = 1400.0;
}
