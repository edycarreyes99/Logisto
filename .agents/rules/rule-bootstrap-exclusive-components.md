---
id: RULE-UI-006
title: Exclusive Flutter Material Design 3 Component Enforcement with Bootstrap Responsive Grid
trigger: "Triggered when authoring or reviewing UI components to enforce Flutter Material 3 widgets while using bootstrap_ui_flutter exclusively for responsive grid layouts."
category: presentation
severity: blocking
scope:
  include:
    - "lib/presentation/**"
    - "lib/core/widgets/**"
  exclude:
    - "test/**"
---

# Exclusive Flutter Material Design 3 Component Enforcement with Bootstrap Responsive Grid

> Rule ID: RULE-UI-006  
> Severity: blocking  
> Target Scope: lib/presentation/**, lib/core/widgets/**  
> Category: presentation  

---

## 1. Architectural Invariant

All presentation screens, decomposed sub-widgets, and reusable controls MUST EXCLUSIVELY consume visual UI components, helpers, and styling from Flutter Material Design 3 (`package:flutter/material.dart`, `ThemeData(useMaterial3: true)`).

From `bootstrap_ui_flutter` (`package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart`), ONLY the 12-column responsive grid layout system (`BsContainer`, `BsRow`, `BsCol`, `BsColConfig`, `BsBreakpoints`) is permitted to ensure 100% responsive multiplatform layout across all device types and screen sizes.

The direct importation, instantiation, or consumption of visual, non-grid components from `bootstrap_ui_flutter` or Cupertino (`package:flutter/cupertino.dart`) is STRICTLY PROHIBITED in the presentation layer.

### 1.1. Prohibited Visual Component Catalog:
Under no circumstances shall presentation code instantiate:
1. **Bootstrap Visual Cards & Surfaces:** `BsCard`, `BsCardHeader`, `BsCardBody`, `BsCardFooter`, `BsCardImage`, `BsCardGroup`.
2. **Bootstrap Buttons:** `BsButton`, `BsButtonGroup`, `BsCloseButton`.
3. **Bootstrap Form Inputs & Selection:** `BsInput`, `BsSelect`, `BsSelectBox`, `BsCheckbox`, `BsRadio`, `BsSwitch`, `BsRange`, `BsInputGroup`.
4. **Bootstrap Dialogs & Overlays:** `BsModal`, `showBsModal`, `BsModalHeader`, `BsModalBody`, `BsModalFooter`, `BsOffcanvas`, `showBsOffcanvas`.
5. **Bootstrap Navigation & Bars:** `BsNavbar`, `BsNavbarBrand`, `BsNavbarNav`, `BsNavbarItem`, `BsNavbarLink`, `BsNavbarCollapse`, `BsNavbarToggler`, `BsNav`, `BsTabContent`, `BsTabPane`.
6. **Bootstrap Feedback & Status:** `BsBadge`, `BsAlert`, `BsToast`, `BsToastManager`, `BsSpinner`, `BsProgress`, `BsProgressBar`, `BsTooltip`.
7. **Bootstrap Tables & Lists:** `BsTable`, `BsTableHead`, `BsTableBody`, `BsTableRow`, `BsTableCell`, `BsListGroup`, `BsListGroupItem`, `BsAccordion`, `BsAccordionItem`.
8. **Cupertino Visual Controls:** `CupertinoButton`, `CupertinoNavigationBar`, `CupertinoTabBar`, `CupertinoActivityIndicator`, `CupertinoActionSheet`, `CupertinoAlertDialog`, `CupertinoTextField`, `CupertinoSwitch`, `CupertinoSlider`, `CupertinoSegmentedControl`.
9. **Bootstrap Theme & Extension Tokens:** `BsThemeData`, `context.bs`. The application theme and design tokens MUST derive exclusively from Flutter Material Design 3 (`ThemeData` with `useMaterial3: true`).

### 1.2. Permitted Foundational Flutter & Grid Primitives:
1. **Permitted Bootstrap UI Flutter Primitives (Grid & Breakpoints ONLY):**
   - `BsContainer`, `BsContainer.fluid`
   - `BsRow`
   - `BsCol`, `BsColConfig`, `ColSize`
   - `BsBreakpoints`
2. **Permitted Material Design 3 & Flutter Visual Primitives:**
   - Surfaces & Scaffold: `Scaffold`, `AppBar`, `Card`, `Material`, `Surface`, `Drawer`, `NavigationDrawer`, `NavigationRail`, `NavigationBar`.
   - Buttons: `FilledButton`, `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `FloatingActionButton`, `SegmentedButton`.
   - Inputs & Form: `TextField`, `TextFormField`, `DropdownButtonFormField`, `DropdownMenu`, `Checkbox`, `Radio`, `Switch`, `Slider`.
   - Dialogs & Feedback: `AlertDialog`, `SimpleDialog`, `Dialog`, `ModalBottomSheet`, `SnackBar`, `MaterialBanner`, `CircularProgressIndicator`, `LinearProgressIndicator`, `Tooltip`.
   - Content & Indicators: `Badge`, `Chip`, `InputChip`, `FilterChip`, `ActionChip`, `Divider`, `DataTable`, `PaginatedDataTable`, `ListTile`, `ListView`.
   - Base Flutter Primitives: `Widget`, `StatelessWidget`, `StatefulWidget`, `State`, `BuildContext`, `Key`, `GlobalKey`, `SizedBox`, `Padding`, `Center`, `Align`, `Expanded`, `Flexible`, `Stack`, `Positioned`, `SingleChildScrollView`, `Column`, `Row`, `Wrap`, `GestureDetector`, `InkWell`, `AnimatedBuilder`, `ListenableBuilder`.

### 1.3. Mandatory Canonical Replacements:
| Prohibited Bootstrap Widget | Mandatory Material Design 3 Replacement | Permitted Bootstrap Grid |
| :--- | :--- | :--- |
| `BsNavbar` | `AppBar` / Material 3 Header / `NavigationDrawer` | None (Use M3 AppBar/Drawer) |
| `BsButton` | `FilledButton`, `ElevatedButton`, `OutlinedButton`, `TextButton` | None |
| `BsCard` | `Card`, `Card.outlined`, `Card.filled` | Wrap inside `BsCol` |
| `BsModal` / `showBsModal` | `showDialog` with `AlertDialog` / `Dialog` | None |
| `BsOffcanvas` | `NavigationDrawer` / `Drawer` / `ModalBottomSheet` | None |
| `BsNav` / `BsTabContent` | `TabBar` / `TabBarView` / `NavigationBar` | None |
| `BsAlert` / `BsToast` | `SnackBar` via `ScaffoldMessenger`, `MaterialBanner` | None |
| `BsSpinner` | `CircularProgressIndicator` | None |
| `BsProgress` | `LinearProgressIndicator` | None |
| `BsInput` | `TextField`, `TextFormField` | None |
| `BsSelect` / `BsDropdown` | `DropdownButtonFormField`, `DropdownMenu` | None |
| `BsCheckbox` | `Checkbox`, `CheckboxListTile` | None |
| `BsRadio` | `Radio`, `RadioListTile` | None |
| `BsBadge` | `Badge`, `Chip` | None |
| `BsTable` | `DataTable`, `PaginatedDataTable`, `Table` | Wrap inside `BsCol` |
| `BsListGroup` | `ListView`, `Column` with `ListTile` or `Card` | Wrap inside `BsCol` |
| `BsVerticalRule` | `Divider`, `VerticalDivider` | None |

### 1.4. Firebase UI Packages Integration & Reconciliation Invariant:
When consuming official Firebase UI libraries (`firebase_ui_firestore`, `firebase_ui_auth`), presentation code MUST adhere to these guardrails:
1. **Headless Query Decoupling (`firebase_ui_firestore`):**
   - Engineers MUST use `FirestoreQueryBuilder<T>` to manage pagination, real-time streaming, loading, and error handling headlessly. The UI builder MUST render presentation exclusively using Material Design 3 components: `DataTable` or `Card` on desktop viewports and `ListTile` or `Card` on mobile and tablet viewports (RULE-UI-007), inside responsive `BsContainer`, `BsRow`, and `BsCol` layouts.
   - When `FirestoreListView<T>` is consumed, its `itemBuilder`, `emptyBuilder`, `errorBuilder`, and `loadingBuilder` callbacks MUST return Material Design 3 widgets (`Card`, `ListTile`, `CircularProgressIndicator`), strictly prohibiting Bootstrap visual components.
2. **Federated Authentication Theming & Builders (`firebase_ui_auth`):**
   - Pre-built authentication screens (`SignInScreen`, `RegisterScreen`, `ProfileScreen`) are permitted as specialized federated auth handlers, provided:
     a) Ambient Flutter `ThemeData` is configured with `useMaterial3: true` and semantic `ColorScheme` tokens (`AppColors`, `ThemeData.light`, `ThemeData.dark`).
     b) All customizable visual builder hooks (`headerBuilder`, `sideBuilder`, `footerBuilder`, `subtitleBuilder`) MUST strictly consume Material Design 3 components (`Card`, `FilledButton`, `Text`, `Badge`) placed within responsive Bootstrap grid structures (`BsContainer`, `BsRow`, `BsCol`).
     c) Desktop wide layout MUST utilize `sideBuilder` to implement a responsive split-screen wireframe, while mobile layout utilizes `headerBuilder`.

### 1.5. Mobile Material Design 3 Primary Action Pattern (Extended FAB):
On mobile and tablet viewports (`width < BsBreakpoints.lg`), primary creation or submission actions (e.g., 'New Product', 'New Branch', 'New Client', 'New Tab') MUST NOT be rendered as wide buttons with text labels (`FilledButton.icon(label: Text(...))`) inside the `AppBar.actions` slot, as this crowds the toolbar and violates Material Design 3 mobile ergonomics.
Instead:
- On desktop viewports (`width >= BsBreakpoints.lg`), primary creation actions are rendered in `AppBar.actions` using `FilledButton.icon`.
- On mobile and tablet viewports (`width < BsBreakpoints.lg`), primary creation actions MUST be exposed via `FloatingActionButton.extended` attached to `Scaffold.floatingActionButton` (or `LogistoScaffold(floatingActionButton: ...)`).

---

## 2. Rationale & Failure Impact

- **True Design System Unity:** Flutter Material Design 3 provides a deeply integrated, accessibility-tested, multiplatform UI framework with native animations, theme adaptation, keyboard accessibility, and platform ergonomics across Web, Windows, macOS, Android, and iOS.
- **Bootstrap 12-Column Responsive Precision:** Relying on `bootstrap_ui_flutter` exclusively for `BsContainer`, `BsRow`, `BsCol`, and `BsColConfig` preserves deterministic 12-column grid responsiveness across all 6 breakpoints (`xs`, `sm`, `md`, `lg`, `xl`, `xxl`), eliminating brittle `MediaQuery` arithmetic while leveraging Material 3 visual beauty.
- **Failure Impact:** Mixing third-party visual components with Material 3 results in styling clashes, broken theme inheritance (`Theme.of(context)`), inconsistent typography, and poor user ergonomics.

---

## 3. Compliant Pattern (DO)

Construct the presentation screen using Material Design 3 widgets structured within the Bootstrap responsive grid:

```dart
// lib/presentation/stations/stations_screen.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import '../../l10n/app_localizations.dart';

class StationsScreen extends StatelessWidget {
  const StationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stationsCatalogTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BsRow(
            children: [
              BsCol(
                config: const BsColConfig(xs: 12, md: 6, xl: 4),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.stationOverview,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: Text(l10n.createNewItem),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Instantiating non-grid visual components from `bootstrap_ui_flutter` or Cupertino:

```dart
// BAD: Instantiating prohibited Bootstrap visual components
class BadScreen extends StatelessWidget {
  const BadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BsContainer.fluid(
      child: Column(
        children: [
          // VIOLATION: BsNavbar is prohibited! Use Material 3 AppBar or NavigationDrawer.
          BsNavbar(brand: BsNavbarBrand(child: Text('Bad App'))),
          // VIOLATION: BsCard is prohibited! Use Material 3 Card.
          BsCard(
            header: BsCardHeader(child: Text('Card Header')),
            body: BsCardBody(
              children: [
                // VIOLATION: BsButton is prohibited! Use Material 3 FilledButton/ElevatedButton.
                BsButton(label: 'Click Me', onPressed: () {}),
                // VIOLATION: BsInput is prohibited! Use Material 3 TextField.
                BsInput(placeholder: 'Enter name'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 5. Automated Validation & Audit Gate

Verify zero consumption of prohibited Bootstrap visual components and Cupertino widgets:

```bash
# 1. Prohibit non-grid Bootstrap UI Flutter visual widgets
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(BsCard|BsButton|BsModal|showBsModal|BsInput|BsSelect|BsCheckbox|BsRadio|BsSwitch|BsRange|BsNavbar|BsTable|BsListGroup|BsOffcanvas|BsToast|BsAlert|BsSpinner|BsProgress|BsBadge)\b'

# 2. Prohibit Cupertino visual widgets
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(CupertinoButton|CupertinoNavigationBar|CupertinoTabBar|CupertinoActivityIndicator|CupertinoAlertDialog)\b'

# 3. Assert permitted Bootstrap responsive grid usage
rg --glob 'lib/presentation/**' '\b(BsContainer|BsRow|BsCol|BsColConfig)\b'
```
