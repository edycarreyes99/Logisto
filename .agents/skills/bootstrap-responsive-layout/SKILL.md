---
name: bootstrap-responsive-layout
description: |
  Procedural guide for designing and implementing responsive multiplatform layouts using bootstrap_ui_flutter.
  Constructs 12-column responsive layouts across mobile, tablet, desktop, and web screen breakpoints.
  Mandatory trigger conditions:
  - Trigger when structuring responsive screens, multi-column card grids, or adaptive headers in Flutter.
  - Trigger when replacing manual MediaQuery screen width branching with standard Bootstrap grid rules.
  Do NOT trigger when:
  - Do not trigger for non-layout tasks such as backend data querying or service registration.
  - Do not trigger for raw localization translation editing.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: presentation
  publisher: Architecture Standards Team
---

# Bootstrap Responsive Layout Engine

> Standard: Universal Multiplatform Layout Architecture  
> Scope: lib/presentation/, lib/core/widgets/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill prescribes standard procedures for implementing responsive Flutter user interfaces using `bootstrap_ui_flutter`. It eliminates brittle, manual `MediaQuery` screen width checks by establishing a deterministic 12-column grid engine powered by standard Bootstrap 5.3 breakpoints (`xs`, `sm`, `md`, `lg`, `xl`, `xxl`), guaranteeing seamless transitions between phones, foldables, tablets, laptops, and ultra-wide desktop monitors.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Designing any new feature screen, catalog grid, dashboard, or settings page.
- Structuring adaptive form layouts with multi-column inputs on wide displays.
- Refactoring legacy views that use `MediaQuery.of(context).size.width` arithmetic.

### 2.2. When to Avoid This Skill
- Building purely headless background logic or domain services.
- Designing custom canvas vector graphics or Lottie animations.
- Configuring database indexes or Firestore security rules.

---

## 3. Pre-Flight Verification (Step 0)

Ensure `bootstrap_ui_flutter` is installed and declared in `pubspec.yaml`:

```bash
# Check bootstrap_ui_flutter in dependencies
grep 'bootstrap_ui_flutter' pubspec.yaml
```

Verify that breakpoint constants in `lib/theme/app_dimens.dart` align with standard Bootstrap widths:
- `breakpointXs = 0.0`
- `breakpointSm = 576.0`
- `breakpointMd = 768.0`
- `breakpointLg = 992.0`
- `breakpointXl = 1200.0`
- `breakpointXxl = 1400.0`

---

## 4. Canonical Specification & Standards

### 4.1. Core Components
- `BsContainer`: Root responsive container wrapping views. Use `fluid: true` for edge-to-edge multiplatform apps.
- `BsRow`: Horizontal layout row organizing children into responsive column tracks.
- `BsCol`: Column child spanning a configurable number of the 12 available track units via `ColSize`.
- `ColSize`: Breakpoint span definition for `xs`, `sm`, `md`, `lg`, `xl`, `xxl`.

### 4.2. Breakpoint Grid Rules
| Breakpoint | Minimum Width | Typical Target Device | Standard Card Column Span |
| :--- | :--- | :--- | :--- |
| `xs` | 0px | Mobile Portrait (<576px) | `xs: 12` (Full width single item) |
| `sm` | 576px | Mobile Landscape / Small Tablet | `sm: 12` or `sm: 6` (1 or 2 items) |
| `md` | 768px | Tablet Portrait / Foldables | `md: 6` (2 items per row) |
| `lg` | 992px | Desktop / Laptop / Tablet Landscape | `lg: 4` (3 items per row) |
| `xl` | 1200px | High-DPI Desktop Monitors | `xl: 3` (4 items per row) |
| `xxl` | 1400px | Ultra-Wide Displays | `xxl: 3` (4 items per row) |

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Wrap Screen with BsContainer
Wrap the primary screen body inside a `BsContainer`:

```dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';

class ResponsiveScreenWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BsContainer(
            fluid: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

### Step 2: Implement Responsive Grid Layout
Arrange child items using `BsRow` and `BsCol` with explicit `ColSize`:

```dart
// lib/presentation/stations/widgets/stations_grid.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import '../../../domain/models/station_model.dart';
import 'stations_card.dart';

class StationsGrid extends StatelessWidget {
  final List<StationModel> stations;

  const StationsGrid({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return BsRow(
      children: stations.map((station) {
        return BsCol(
          sizes: const ColSize(
            xs: 12, // 1 column on mobile
            sm: 12,
            md: 6,  // 2 columns on tablet
            lg: 4,  // 3 columns on standard desktop
            xl: 3,  // 4 columns on large monitors
            xxl: 3,
          ),
          child: StationsCard(station: station),
        );
      }).toList(),
    );
  }
}
```

### Step 3: Implement Responsive Multi-Column Form
Arrange input fields adaptively (stacked on mobile, side-by-side on desktop):

```dart
// lib/presentation/stations/widgets/station_form_fields.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import '../../../core/validators/text_field_validator.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/app_localizations.dart';

class StationFormFields extends StatelessWidget {
  final TextFieldValidator nameValidator;
  final TextFieldValidator locationValidator;

  const StationFormFields({
    super.key,
    required this.nameValidator,
    required this.locationValidator,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BsRow(
      children: [
        BsCol(
          sizes: const ColSize(xs: 12, md: 6),
          child: AppTextField(
            validator: nameValidator,
            label: l10n.createNewItem,
          ),
        ),
        BsCol(
          sizes: const ColSize(xs: 12, md: 6),
          child: AppTextField(
            validator: locationValidator,
            label: l10n.catalogTitle,
          ),
        ),
      ],
    );
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| Dynamic desktop window resize | Layout overflow or unexpected line wrapping | Always ensure total column spans in any `BsRow` sum to 12 across matching breakpoints. |
| Nested scrollable widgets | `Vertical viewport was given unbounded height` | Wrap `BsContainer` in a `SingleChildScrollView` or ensure parent constraints are bounded. |
| Zero items in collection | Empty `BsRow` collapses unexpectedly | Display an explicit `AppEmptyState` placeholder rather than an empty row. |

---

## 7. Verification & Quality Gates

Run automated checks to confirm no direct manual screen width calculations exist in UI widgets:

```bash
# Verify no MediaQuery width checks exist in presentation files
rg --glob 'lib/presentation/**' 'MediaQuery\.of\(context\)\.size\.width'
```

Checklist (see full [references/bootstrap-grid-validation-checklist.md](references/bootstrap-grid-validation-checklist.md)):
- [ ] Root views use `BsContainer(fluid: true)`.
- [ ] Grid lists and forms use `BsRow` and `BsCol`.
- [ ] `ColSize` declares explicit spans across `xs`, `sm`, `md`, `lg`, `xl`, `xxl`.
- [ ] No manual screen width branching or pixel arithmetic.
- [ ] Zero lint warnings with `flutter analyze`.
