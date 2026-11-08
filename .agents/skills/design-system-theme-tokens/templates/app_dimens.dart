import 'package:flutter/material.dart';

/// Centralized structural dimensions, padding tokens, and responsive breakpoints.
class AppDimens {
  // Page and Container Padding
  static const EdgeInsets paddingPage = EdgeInsets.all(16.0);
  static const double paddingBody = 16.0;

  // Border Radii Tokens
  static const double radiusSm = 8.0;
  static const double radius = 16.0;                    // Standard component border radius
  static const double cardRadius = 12.0;                // Standard card curvature
  static const double modalRadius = 24.0;               // Modal and bottom sheet curvature

  // Header and Footer Layout Constraints
  static const double footerHeight = 65.0;              // Standard action footer height
  static const EdgeInsets footerPadding = EdgeInsets.fromLTRB(16, 8, 16, 12);
  static const double footerImageHeight = 75.0;
  static const double logoWidth = 240.0;

  // Component Heights and Dimensions
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  static const double searchBarHeight = 48.0;
  static const double textFieldHeight = 48.0;
  static const double iconSizeSm = 16.0;
  static const double iconSize = 20.0;                  // Canonical vector icon size
  static const double iconSizeLg = 28.0;
  static const double iconCircleHeight = 62.0;          // Avatar / Circle icon container

  // Canonical Bootstrap Responsive Grid Breakpoints (matching bootstrap_ui_flutter)
  static const double breakpointXs = 0.0;               // Mobile Portrait (<576px)
  static const double breakpointSm = 576.0;             // Mobile Landscape / Small Tablet (>=576px)
  static const double breakpointMd = 768.0;             // Tablet (>=768px)
  static const double breakpointLg = 992.0;             // Desktop / Laptop (>=992px)
  static const double breakpointXl = 1200.0;            // Large Desktop (>=1200px)
  static const double breakpointXxl = 1400.0;           // Ultra-wide Displays (>=1400px)
}
