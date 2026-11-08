---
name: design-system-theme-tokens
description: |
  Procedural guide for managing design tokens, adaptive color palettes, typography scales, and themes.
  Assembles ThemeData and BsThemeData for seamless, pixel-perfect Light and Dark theme adaptation.
  Mandatory trigger conditions:
  - Trigger when defining or updating brand colors, typography, spacing, or component metrics.
  - Trigger when configuring Light and Dark ThemeData compilation or BsThemeData extensions.
  Do NOT trigger when:
  - Do not trigger for non-visual backend data operations or repository implementations.
  - Do not trigger for form input validation rules without styling concerns.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: theme
  publisher: Architecture Standards Team
---

# Design System Theme Tokens Architecture

> Standard: Adaptive Dual-Theme System (Light & Dark)  
> Scope: lib/theme/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes the Design System Architecture in `lib/theme/`. It establishes an adaptive token pipeline supporting both Light and Dark themes, eliminating hardcoded hex colors, arbitrary spacing constants, and un-themed widgets. It coordinates 5 core modules (`app_colors.dart`, `app_dimens.dart`, `app_spacing.dart`, `app_text_styles.dart`, `app_theme.dart`) and integrates with `bootstrap_ui_flutter` theme extensions.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Introducing brand colors, semantic state tones (success, error, warning, info), or surface variations.
- Adjusting typography scales (display, title, body, caption) or font families.
- Updating modular spacing rhythm or responsive component dimensions.
- Compiling `ThemeData` light and dark configurations in `AppTheme`.

### 2.2. When to Avoid This Skill
- Implementing Firestore database transactions or DTO mappings.
- Writing reactive form state controllers (use `form-validation-orchestrator`).
- Creating feature screens (use `flutter-feature-scaffold`).

---

## 3. Pre-Flight Verification (Step 0)

Ensure `flutter/material.dart` and `bootstrap_ui_flutter` are accessible:

```bash
# Verify theme layer file existence
ls -la lib/theme/
```

Verify that all 5 canonical files exist or are scaffolded in `lib/theme/`:
- `app_colors.dart`
- `app_dimens.dart`
- `app_spacing.dart`
- `app_text_styles.dart`
- `app_theme.dart`

---

## 4. Canonical Specification & Standards

### 4.1. File Structure
```
lib/theme/
├── app_colors.dart          # Light and dark color palettes, semantic states, helpers
├── app_dimens.dart          # Corner radii, component heights, Bootstrap breakpoints
├── app_spacing.dart         # Modular 8px rhythm scale and component metrics
├── app_text_styles.dart     # Adaptive typography hierarchy
└── app_theme.dart           # ThemeData lightTheme & darkTheme with BsThemeData
```

### 4.2. Invariant Rules
- Feature code MUST NEVER use hardcoded hex values (e.g. `Color(0xFF...)`).
- Feature code MUST resolve colors via `AppColors` helpers (e.g., `AppColors.surfaceOf(context)`) or `Theme.of(context)`.
- All visual elements MUST render flawlessly in both Light and Dark modes.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Define Adaptive Color Tokens in app_colors.dart
Centralize all color values with static brightness-aware resolvers:

```dart
// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF10B981);

  // Light Surfaces
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9);
  static const Color cardLight = Color(0xFFF8FAFC);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);

  // Dark Surfaces
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);
  static const Color borderDark = Color(0xFF475569);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textMutedDark = Color(0xFF94A3B8);

  // Semantic Feedback States
  static const Color success = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0284C7);

  static Color backgroundOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? backgroundDark : backgroundLight;

  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight;

  static Color cardOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cardDark : cardLight;

  static Color borderOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? borderDark : borderLight;

  static Color textPrimaryOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;

  static Color textMutedOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textMutedDark : textMutedLight;
}
```

### Step 2: Establish Modular Spacing Rhythm in app_spacing.dart
Define spacing based on an 8px modular scale:

```dart
// lib/theme/app_spacing.dart
import 'package:flutter/material.dart';

class AppSpacing {
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  static const double pagePadding = space16;
  static const double cardPadding = space16;
  static const double elementGap = space12;

  static const SizedBox gapW8 = SizedBox(width: space8);
  static const SizedBox gapW16 = SizedBox(width: space16);
  static const SizedBox gapH8 = SizedBox(height: space8);
  static const SizedBox gapH16 = SizedBox(height: space16);
}
```

### Step 3: Configure Typography in app_text_styles.dart
Build adaptive text styles honoring brightness:

```dart
// lib/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle display(BuildContext context) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryOf(context),
      );

  static TextStyle title(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryOf(context),
      );

  static TextStyle body(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimaryOf(context),
      );

  static TextStyle caption(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textMutedOf(context),
      );
}
```

### Step 4: Assemble Dual ThemeData in app_theme.dart
Assemble `ThemeData` integrating `BsThemeData`:

```dart
// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'app_colors.dart';
import 'app_dimens.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.borderLight,
      extensions: [BsThemeData.lightTheme],
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.borderDark,
      extensions: [BsThemeData.darkTheme],
    );
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| OS switches theme while screen active | Screen remains stuck in previous palette | Ensure widgets rebuild by accessing `AppColors.surfaceOf(context)` inside `build()` method. |
| Contrast ratio fails accessibility standards | Text illegible on elevated cards | Validate that `textPrimaryLight` on `cardLight` and `textPrimaryDark` on `cardDark` meet WCAG 4.5:1 ratio. |
| Third-party widget lacks dark theme support | Blinding white container appears in dark mode | Wrap third-party widgets in a themed container with explicit `AppColors.cardOf(context)` background. |

---

## 7. Verification & Quality Gates

Run checks to confirm zero hardcoded hex colors exist in presentation code:

```bash
# Verify no hardcoded hex colors in presentation screens
rg --glob 'lib/presentation/**' 'Color\(0x'
```

Checklist (see full [references/design-tokens-validation-checklist.md](references/design-tokens-validation-checklist.md)):
- [ ] Both `lightTheme()` and `darkTheme()` are defined and compile cleanly.
- [ ] `BsThemeData.lightTheme` and `darkTheme` extensions are registered.
- [ ] All colors in `lib/presentation/` derive from `AppColors` or `Theme.of(context)`.
- [ ] Spacing values adhere to the 8px modular scale.
- [ ] Zero lint warnings with `flutter analyze`.
