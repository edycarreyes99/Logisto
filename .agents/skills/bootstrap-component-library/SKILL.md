---
name: bootstrap-component-library
description: |
  Comprehensive procedural guide and reference implementation framework for Flutter Material Design 3
  components integrated with bootstrap_ui_flutter 12-column responsive grids. Enforces 100% exclusive usage
  of Flutter Material Design 3 for visual components while using bootstrap_ui_flutter exclusively for responsive grids.
  Mandatory trigger conditions:
  - Trigger when constructing new UI screens, forms, modals, tables, or reusable widgets in Flutter.
  - Trigger when refactoring views to use Flutter Material Design 3 components and Bootstrap responsive grids.
  - Trigger when configuring responsive 12-column layouts with BsContainer, BsRow, and BsCol.
  Do NOT trigger when:
  - Do not trigger for headless backend data queries, repository streams, or pure domain modeling.
  - Do not trigger for localization translation synchronization alone.
license: Apache-2.0
metadata:
  version: 2.0.0
  category: presentation
  publisher: Architecture Standards Team
---

# Material Design 3 Component Library and Bootstrap Responsive Grid Specification

> Standard: Universal Multiplatform Design System Specification  
> Scope: Entire presentation layer (`lib/presentation/`, `lib/core/widgets/`)  
> Governance: Zero Emojis, 100% Technical English, Strict Automated Validation  
> Rule Conformance: RULE-UI-006 (Material 3 Visuals, Bootstrap Grid Only), RULE-UI-002 (12-Column Grid)  
> Component Catalog: [references/component-reference-catalog.md](references/component-reference-catalog.md)  
> Screen Template: [templates/pure-bootstrap-screen-template.dart](templates/pure-bootstrap-screen-template.dart)  

---

## 1. Executive Summary & Objective

This specification establishes the authoritative design system and component architecture for the application. All user interface presentation components derive exclusively from Flutter Material Design 3 (`package:flutter/material.dart`, `ThemeData(useMaterial3: true)`), delivering high accessibility, fluid interactive physics, state-of-the-art visual styling, and consistent cross-platform ergonomics across Web, Windows, macOS, Android, and iOS.

To ensure 100% responsive fluid adaptation across all screen sizes and device form factors without brittle `MediaQuery` arithmetic, the layout engine integrates `bootstrap_ui_flutter` EXCLUSIVELY for its 12-column responsive grid system (`BsContainer`, `BsRow`, `BsCol`, `BsColConfig`, `BsBreakpoints`). All non-grid visual components from `bootstrap_ui_flutter` and Cupertino controls are strictly prohibited.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Constructing any presentation view, feature screen, layout body, card, table, dialog, or dashboard.
- Implementing user input forms using Material 3 `TextField`, `TextFormField`, `DropdownButtonFormField`, `Checkbox`, `Radio`, or `Switch`.
- Structuring responsive multi-column layouts across mobile, tablet, and desktop breakpoints using `BsContainer`, `BsRow`, `BsCol`, and `BsColConfig`.
- Displaying dialogs (`showDialog`, `AlertDialog`), bottom sheets (`showModalBottomSheet`), snackbars (`ScaffoldMessenger`), or progress indicators (`CircularProgressIndicator`, `LinearProgressIndicator`).
- Refactoring legacy code containing prohibited Bootstrap visual components (`BsButton`, `BsCard`, `BsModal`, `BsInput`, `BsNavbar`, `BsTable`, `BsListGroup`) or Cupertino widgets.

### 2.2. When to Avoid This Skill
- Writing domain repositories, Firestore DTO serialization, or business use cases.
- Configuring dependency injection bindings in `lib/locator.dart`.
- Running headless integration tests without UI inspection.

---

## 3. Pre-Flight Verification (Step 0)

Execute pre-flight checks before authoring or modifying any presentation component:

```bash
# 1. Verify bootstrap_ui_flutter dependency in pubspec.yaml for grid support
grep 'bootstrap_ui_flutter' pubspec.yaml

# 2. Check for prohibited Bootstrap visual components in presentation code
rg --glob 'lib/presentation/**' '\b(BsCard|BsButton|BsModal|showBsModal|BsInput|BsNavbar|BsTable|BsListGroup)\b'

# 3. Ensure ThemeData provides useMaterial3: true and ColorScheme tokens in lib/theme/
test -f lib/theme/firebase_ui_theme_bridge.dart && echo "Theme system ready."
```

---

## 4. Canonical Specification & Standards

### 4.1. Core Component Mapping & Guidelines

#### 1. Responsive Grid Engine (From `bootstrap_ui_flutter`)
- `BsContainer`: Root layout wrapper. Always use `BsContainer.fluid(child: ...)` or `BsContainer(fluid: true, child: ...)` for responsive layouts.
- `BsRow`: Flexbox row distributing columns along a 12-unit horizontal track with configurable gutters and alignment.
- `BsCol`: Column child spanning fractional track widths specified via `config: BsColConfig(xs: 12, sm: 12, md: 6, lg: 4, xl: 3, xxl: 2)`.

#### 2. Navigation & Headers (Material Design 3)
- `AppBar`: Top application header bar with `title`, `actions`, `leading`, and surface elevation tint.
- `NavigationDrawer` / `Drawer`: Side navigation drawer for desktop and mobile navigation shells.
- `NavigationBar` / `NavigationRail`: Adaptive bottom or vertical side navigation for responsive screen sizes.

#### 3. Buttons (Material Design 3)
- `FilledButton`: Primary high-emphasis action button.
- `FilledButton.tonal`: Secondary medium-emphasis action button.
- `ElevatedButton`: Alternative surface-elevated action button.
- `OutlinedButton`: Medium-emphasis bordered button for secondary actions.
- `TextButton`: Low-emphasis text action button.
- `IconButton`: Compact icon-only button for toolbars and actions.

#### 4. Cards & Surfaces (Material Design 3)
- `Card`: Primary content container. Use `Card.outlined` or `Card(elevation: 0, shape: RoundedRectangleBorder(...))` for clean, modern information density.
- `Material`: Base rendering surface providing elevation and theme ink response.

#### 5. Form Input Controls (Material Design 3)
- `TextFormField` & `TextField`: Text input fields styled via `InputDecoration` (`outline` borders, label, hint, error text).
- `DropdownButtonFormField<T>` / `DropdownMenu<T>`: Styled dropdown selector with label and error state.
- `Checkbox`: Square toggle selection control.
- `Radio<T>`: Mutually exclusive option selector.
- `Switch`: Adaptive toggle switch.
- `Slider`: Continuous numerical range selector.

#### 6. Dialogs & Overlays (Material Design 3)
- `showDialog` with `AlertDialog`: Centered prompt with `title`, `content`, and `actions`.
- `showModalBottomSheet`: Bottom slide-up sheet for contextual mobile operations.

#### 7. Feedback & Notifications (Material Design 3)
- `ScaffoldMessenger.of(context).showSnackBar`: Non-intrusive toast messages via `SnackBar`.
- `MaterialBanner`: Persistent top-of-screen message.
- `Badge`: Small visual count or status badge attached to widgets.
- `Chip` / `FilterChip` / `ActionChip`: Compact semantic labels and filter tags.

#### 8. Indicators & Loading (Material Design 3)
- `CircularProgressIndicator`: Spinning circular indeterminate loader.
- `LinearProgressIndicator`: Horizontal progress bar.

#### 9. Tables & Lists (Material Design 3)
- `DataTable` & `PaginatedDataTable`: Multi-column tabular data rendering on desktop displays.
- `ListTile`: Standardized single-row representation with `leading`, `title`, `subtitle`, and `trailing`.
- `ListView`: Scrolling vertical list of tiles or cards.

---

### 4.2. Theme Access via Context
Access Material Design 3 color scheme and typography tokens directly from `Theme.of(context)`:

```dart
final theme = Theme.of(context);
final Color primaryColor = theme.colorScheme.primary;
final Color surfaceColor = theme.colorScheme.surface;
final TextStyle titleStyle = theme.textTheme.titleMedium!;
```

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Establish Root Scaffold and AppBar
Construct screens using `Scaffold` and `AppBar`:

```dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';

class CompliantScreen extends StatelessWidget {
  const CompliantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logisto System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: const BsContainer.fluid(
        child: ResponsiveBody(),
      ),
    );
  }
}
```

### Step 2: Structure 12-Column Responsive Content (Laptop Priority)
Implement layout bodies using `BsRow` and `BsCol` with explicit `BsColConfig` settings, optimizing for laptop viewports (1280x720+) while adapting across tablets and mobile:

```dart
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: BsRow(
        children: [
          // On laptop (xl: 1280x720+): 8 columns; on tablet: 12 or 8; on mobile: 12
          BsCol(
            config: const BsColConfig(xs: 12, md: 8, xl: 8),
            child: const MainContentCard(),
          ),
          // On laptop (xl: 1280x720+): 4 columns; on tablet: 12 or 4; on mobile: 12
          BsCol(
            config: const BsColConfig(xs: 12, md: 4, xl: 4),
            child: const SideFilterPanel(),
          ),
        ],
      ),
    );
  }
}
```

### Step 3: Implement Reusable Content Cards
Wrap content inside Material Design 3 `Card` widgets with explicit padding and text styling:

```dart
class MainContentCard extends StatelessWidget {
  const MainContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operations', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {},
              child: const Text('Execute'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Failure Scenario | Root Cause | Preventive Invariant |
| :--- | :--- | :--- |
| **Prohibited BsButton Import** | Using deprecated Bootstrap buttons instead of Material 3. | CI Regex Gate in `RULE-UI-006` blocks PRs containing `BsButton`. |
| **Modal Overflow in Landscape** | Fixed dialog height exceeding landscape screen height. | Wrap dialog content in `SingleChildScrollView` inside `AlertDialog`. |
| **Form Validation Bypassed** | Using uncontrolled text fields without form bindings. | Always wrap inputs in Flutter `Form` and bind `TextFormField.validator`. |
| **Dark Mode Contrast Breakdown** | Hardcoding `Colors.white` or `Colors.black`. | Always query `theme.colorScheme.surface` and `theme.colorScheme.onSurface`. |
| **Responsive Grid Misalignment** | Omitting explicit `BsColConfig` across device breakpoints. | Always declare explicit breakpoint spans (`xs`, `md`, `xl`). |

---

## 7. Verification & Quality Gates

Run automated audit scripts to ensure zero prohibited Bootstrap non-grid widgets or Cupertino visual widgets:

```bash
# 1. Verify zero prohibited Bootstrap visual widgets in presentation code
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(BsCard|BsButton|BsModal|showBsModal|BsInput|BsSelect|BsCheckbox|BsRadio|BsSwitch|BsRange|BsNavbar|BsTable|BsListGroup|BsOffcanvas|BsToast|BsAlert|BsSpinner|BsProgress|BsBadge)\b'

# 2. Verify zero Cupertino visual controls
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(CupertinoButton|CupertinoNavigationBar|CupertinoTabBar|CupertinoActivityIndicator|CupertinoAlertDialog)\b'

# 3. Verify Flutter static analysis passes cleanly
flutter analyze
```
