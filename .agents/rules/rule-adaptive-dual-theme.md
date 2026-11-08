---
id: RULE-UI-004
title: Adaptive Dual Theme System and Color Token Governance
category: theme
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
---

# Adaptive Dual Theme System and Color Token Governance

> Rule ID: RULE-UI-004  
> Severity: blocking  
> Target Scope: lib/**  
> Category: theme  

---

## 1. Architectural Invariant

All UI surfaces, texts, borders, icons, and components MUST adapt dynamically between Light and Dark themes via `AppColors` and Flutter's `ThemeData`.

Under no circumstances shall:
1. Feature widgets or components hardcode hexadecimal color values (e.g. `Color(0xFF...)`).
2. Code reference hardcoded color constants like `Colors.white`, `Colors.black`, or `Colors.grey`.
3. Widgets assume a static light or dark background without checking `Theme.of(context).brightness` or using adaptive helper methods like `AppColors.surfaceOf(context)`.

---

## 2. Rationale & Failure Impact

- **User Accessibility & Dark Mode Support:** Modern multiplatform applications must seamlessly support system-wide dark mode switches and high-contrast environments.
- **Visual Uniformity:** Centralizing color tokens in `AppColors` ensures contrast ratios conform to WCAG 2.1 AA standards across all screens.
- **Failure Impact:** Hardcoding `Colors.white` or hex literals creates unreadable dark text on dark surfaces, visual glitches when the OS theme flips, and broken theme switching.

---

## 3. Compliant Pattern (DO)

Resolve colors adaptively using semantic methods or theme attributes:

```dart
// lib/presentation/stations/widgets/stations_card.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimens.dart';
import '../../../theme/app_spacing.dart';

class StationsCard extends StatelessWidget {
  final String title;

  const StationsCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardOf(context),
        borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimaryOf(context),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Hardcoding hex values or raw Flutter color constants in presentation widgets:

```dart
// BAD: Hardcoded color literals and static color constants
class BadCard extends StatelessWidget {
  const BadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // VIOLATION: Hardcoded hex color literals!
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // Breaks in Dark Mode!
        border: Border.all(color: Colors.black12), // Inaccessible!
      ),
      child: const Text(
        'Weather Info',
        style: TextStyle(color: Colors.black), // Invisible on dark backgrounds!
      ),
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Scan presentation code for hardcoded color literals:

```bash
# Verify no hardcoded hex colors or direct Colors constants in presentation
rg --glob 'lib/presentation/**' 'Color\(0x|Colors\.[a-zA-Z]+'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
