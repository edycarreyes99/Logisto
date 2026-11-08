---
id: RULE-UI-003
title: Project-Prefixed Reusable Component Controls
category: presentation
severity: blocking
scope:
  include:
    - "lib/presentation/**"
  exclude:
    - "test/**"
---

# Project-Prefixed Reusable Component Controls

> Rule ID: RULE-UI-003  
> Severity: blocking  
> Target Scope: lib/presentation/**  
> Category: presentation  

---

## 1. Architectural Invariant

All core UI controls (buttons, cards, search bars, text fields, dropdowns, badges, modals, empty states, and loading indicators) MUST be consumed via the project-prefixed reusable components defined in `lib/core/widgets/` (e.g. `AppButton`, `AppCard`, `AppTextField`, `AppSearchBar`, `AppDropdown`, `AppBadge`, `AppModal`, `AppEmptyState`, `AppLoadingIndicator`).

Under no circumstances shall:
1. Feature screens or decomposed sub-widgets instantiate bare Flutter buttons (`ElevatedButton`, `TextButton`, `OutlinedButton`, `FilledButton`).
2. Feature screens use un-themed `TextField`, `TextFormField`, or raw inputs directly.
3. Feature screens recreate ad-hoc cards or container wrappers instead of using `AppCard`.

---

## 2. Rationale & Failure Impact

- **Design System Fidelity:** Project-prefixed controls encapsulate theme tokens (`AppColors`), spacing rhythm (`AppSpacing`), corner curvature (`AppDimens`), accessibility, loading states, and disabled styling.
- **Global Theme Updates:** When visual requirements change (e.g. brand redesign, new hover animations, or focus borders), modifying the core project-prefixed component updates every screen across the app instantaneously.
- **Failure Impact:** Scattering raw buttons and text fields throughout feature screens leads to visual inconsistencies, broken dark mode contrast, missing focus indicators, and duplicate styling logic.

---

## 3. Compliant Pattern (DO)

Use project-prefixed components with strongly-typed variant and size enums:

```dart
// lib/presentation/stations/widgets/stations_header.dart
import 'package:flutter/material.dart';
import '../../../core/enums/button_variant_enum.dart';
import '../../../core/enums/button_size_enum.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../l10n/app_localizations.dart';

class StationsHeader extends StatelessWidget {
  final VoidCallback onAddStation;
  final ValueChanged<String> onSearchChanged;

  const StationsHeader({
    super.key,
    required this.onAddStation,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            hintText: l10n.searchPlaceholder,
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 16),
        AppButton(
          text: l10n.createNewItem,
          variant: ButtonVariantEnum.primary,
          size: ButtonSizeEnum.md,
          onPressed: onAddStation,
        ),
      ],
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Directly embedding bare Flutter button and input widgets:

```dart
// BAD: Using bare Flutter buttons and un-themed text fields directly in feature UI
class BadHeader extends StatelessWidget {
  const BadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // VIOLATION: Bare TextField without design tokens or reactive validation!
        TextField(decoration: InputDecoration(hintText: 'Search')),

        // VIOLATION: Bare ElevatedButton bypasses design system!
        ElevatedButton(
          onPressed: () {},
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Scan feature screens for bare button and text field usage:

```bash
# Verify no bare ElevatedButton, TextButton, OutlinedButton, or TextField in presentation
rg --glob 'lib/presentation/**' 'ElevatedButton\(|TextButton\(|OutlinedButton\(|FilledButton\(|TextField\('
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
