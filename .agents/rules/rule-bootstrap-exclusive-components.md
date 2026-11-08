---
id: RULE-UI-006
title: Exclusive Bootstrap UI Flutter Component Enforcement and Material Cupertino Prohibition
category: presentation
severity: blocking
scope:
  include:
    - "lib/presentation/**"
    - "lib/core/widgets/**"
  exclude:
    - "test/**"
---

# Exclusive Bootstrap UI Flutter Component Enforcement and Material Cupertino Prohibition

> Rule ID: RULE-UI-006  
> Severity: blocking  
> Target Scope: lib/presentation/**, lib/core/widgets/**  
> Category: presentation  

---

## 1. Architectural Invariant

All presentation screens, decomposed sub-widgets, and project-prefixed controls MUST EXCLUSIVELY consume visual UI components, helpers, and utilities from `bootstrap_ui_flutter` (`package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart`).

The direct importation, instantiation, or consumption of visual user interface widgets from Flutter Material Design (`package:flutter/material.dart`) or Cupertino (`package:flutter/cupertino.dart`) is STRICTLY PROHIBITED in the presentation layer.

### 1.1. Prohibited Visual Component Catalog:
Under no circumstances shall presentation code instantiate:
1. **Material Containers & Surfaces:** `Scaffold`, `AppBar`, `Card`, `Drawer`, `BottomNavigationBar`, `NavigationBar`, `NavigationRail`, `BottomSheet`, `SnackBar`, `Banner`.
2. **Material Buttons:** `ElevatedButton`, `FilledButton`, `TextButton`, `OutlinedButton`, `FloatingActionButton`, `IconButton` (from Material), `SegmentedButton`.
3. **Material Inputs & Selection:** `TextField`, `TextFormField`, `DropdownButton`, `DropdownButtonFormField`, `Checkbox`, `Radio`, `Switch`, `Slider`, `RangeSlider`.
4. **Material Dialogs & Indicators:** `AlertDialog`, `SimpleDialog`, `Dialog`, `CircularProgressIndicator`, `LinearProgressIndicator`, `Tooltip`, `Divider`.
5. **Material Lists & Tiles:** `ListTile`, `ExpansionTile`, `Chip`, `InputChip`.
6. **Cupertino Visual Controls:** `CupertinoButton`, `CupertinoNavigationBar`, `CupertinoTabBar`, `CupertinoActivityIndicator`, `CupertinoActionSheet`, `CupertinoAlertDialog`, `CupertinoTextField`, `CupertinoSwitch`, `CupertinoSlider`, `CupertinoSegmentedControl`.
7. **Platform Raw Icons:** Raw Material `Icons` or Cupertino `CupertinoIcons` must be replaced by `BsIcon` using `BsIcons`.

### 1.2. Permitted Foundational Flutter Primitives:
The following non-visual structural primitives from the Flutter framework remain permitted:
- Base primitives: `Widget`, `StatelessWidget`, `StatefulWidget`, `State`, `BuildContext`, `Key`, `GlobalKey`.
- Layout primitives: `SizedBox`, `Padding`, `Center`, `Align`, `Expanded`, `Flexible`, `Stack`, `Positioned`, `SingleChildScrollView`, `Column`, `Row`, `Wrap`.
- Event & State primitives: `GestureDetector`, `InkWell`, `AnimatedBuilder`, `ListenableBuilder`, `ValueListenableBuilder`.
- Geometry & Paint primitives: `EdgeInsets`, `BorderRadius`, `Color`, `BoxDecoration`, `CrossAxisAlignment`, `MainAxisAlignment`, `Alignment`.

### 1.3. Mandatory Canonical Replacements:
| Prohibited Material / Cupertino Widget | Mandatory Bootstrap UI Flutter Replacement |
| :--- | :--- |
| `Scaffold` | `BsContainer.fluid` with `BsNavbar` header and page body |
| `AppBar` | `BsNavbar` (`BsNavbarBrand`, `BsNavbarNav`, `BsNavbarLink`, `BsNavbarCollapse`) |
| `ElevatedButton` / `CupertinoButton` | `BsButton` (`variant: BsButtonVariant`, `size: BsButtonSize`, `outline: true`) |
| `Card` | `BsCard` (`header: BsCardHeader`, `body: BsCardBody`, `footer: BsCardFooter`) |
| `AlertDialog` / `CupertinoAlertDialog` | `BsModal` / `showBsModal` (`BsModalHeader`, `BsModalBody`, `BsModalFooter`) |
| `Drawer` | `BsOffcanvas` / `showBsOffcanvas` (`placement: .start` or `.end`) |
| `BottomNavigationBar` / `CupertinoTabBar` | `BsNav` (`BsTabContent`, `BsTabPane`, `variant: .pills`) |
| `SnackBar` | `BsToast` / `BsToastManager.show` or `BsAlert` |
| `CircularProgressIndicator` | `BsSpinner.border()` or `BsSpinner.grow()` |
| `LinearProgressIndicator` | `BsProgress` (`BsProgressBar`) |
| `TextField` / `TextFormField` | `BsInput` (`placeholder`, `size: BsInputSize`, `validator`, `disabled`) |
| `DropdownButton` / `DropdownButtonFormField` | `BsSelect<T>` or `BsDropdown` (`BsDropdownMenu`, `BsDropdownItem`) |
| `Checkbox` | `BsCheckbox` |
| `Radio` | `BsRadio` |
| `Switch` / `CupertinoSwitch` | `BsCheckbox` (`isSwitch: true`) |
| `Slider` / `CupertinoSlider` | `BsRange` |
| `Divider` | `BsVerticalRule` (horizontal) or utility `.borderBottom()` |
| `Tooltip` | `BsTooltip` |
| `Icons` / `CupertinoIcons` | `BsIcon` with `BsIcons` |
| `ListTile` | `BsListGroup` with `BsListGroupItem` |
| `ExpansionTile` | `BsAccordion` with `BsAccordionItem` |

---

## 2. Rationale & Failure Impact

- **True Design System Unity:** Mixing Material Design and Cupertino visual styles creates disjointed, inconsistent user experiences across operating systems. Enforcing a single design language powered by `bootstrap_ui_flutter` ensures pixel-perfect UI consistency across Web, Windows, macOS, Android, and iOS.
- **Responsive 12-Column Cohesion:** Material and Cupertino widgets carry built-in platform margin assumptions and fixed constraints that fight against the Bootstrap 12-column responsive grid engine (`BsContainer`, `BsRow`, `BsCol`).
- **Failure Impact:** Inadvertent use of Material buttons, dialogs, or drawers reintroduces Material 3 elevation, ink ripples, and mobile-biased behaviors on desktop and web, breaking responsive layouts, accessibility navigation, and desktop ergonomics.

---

## 3. Compliant Pattern (DO)

Construct the presentation screen exclusively using `bootstrap_ui_flutter` components:

```dart
// lib/presentation/stations/stations_screen.dart
import 'package:flutter/widgets.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import '../../domain/models/weather_station_model.dart';

class StationsScreen extends StatelessWidget {
  final List<WeatherStationModel> stations;
  final VoidCallback onRefresh;
  final ValueChanged<String> onSearch;

  const StationsScreen({
    super.key,
    required this.stations,
    required this.onRefresh,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final bs = context.bs;

    return BsContainer.fluid(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Application Navigation Bar Header (Replaces AppBar)
          BsNavbar(
            expand: BsNavbarExpand.lg,
            brand: const BsNavbarBrand(child: Text('Weather Logisto')),
            collapse: BsNavbarCollapse(
              children: [
                const BsNavbarSpacer(),
                BsButton(
                  label: 'Sync',
                  icon: BsIcons.arrowRepeat,
                  variant: BsButtonVariant.primary,
                  size: BsButtonSize.sm,
                  onPressed: onRefresh,
                ),
              ],
            ),
          ),
          // Content Layout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BsRow(
              children: stations.map((station) {
                return BsCol(
                  config: const BsColConfig(xs: 12, sm: 12, md: 6, lg: 4, xl: 3),
                  child: BsCard(
                    body: BsCardBody(
                      children: [
                        Text(station.name),
                        Text(station.statusName),
                        const SizedBox(height: 8),
                        Text(station.locationSummary),
                        const SizedBox(height: 12),
                        BsButton(
                          label: 'View Details',
                          variant: BsButtonVariant.primary,
                          outline: true,
                          size: BsButtonSize.sm,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Instantiating Material Design or Cupertino visual widgets in the presentation layer:

```dart
// lib/presentation/stations/bad_stations_screen.dart
// VIOLATION: Using Material Scaffold, AppBar, and ElevatedButton!
import 'package:flutter/material.dart';

class BadStationsScreen extends StatelessWidget {
  const BadStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // PROHIBITED: Scaffold, AppBar, ElevatedButton violate RULE-UI-006!
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Stations'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Refresh'),
        ),
      ),
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Execute targeted static analysis scans using `rg` across `lib/presentation/` and `lib/core/widgets/` to verify zero prohibited Material and Cupertino visual components:

```bash
# 1. Verify zero prohibited Material visual containers and buttons
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(Scaffold|AppBar|ElevatedButton|FilledButton|TextButton|OutlinedButton|FloatingActionButton|ListTile|ExpansionTile|AlertDialog|SimpleDialog|SnackBar|Drawer|BottomNavigationBar)\b'

# 2. Verify zero prohibited Cupertino visual controls
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(CupertinoButton|CupertinoNavigationBar|CupertinoTabBar|CupertinoActivityIndicator|CupertinoAlertDialog|CupertinoTextField|CupertinoSwitch)\b'

# 3. Verify zero bare Material text inputs and progress indicators
rg --glob 'lib/presentation/**' --glob 'lib/core/widgets/**' \
  '\b(TextFormField|DropdownButtonFormField|CircularProgressIndicator|LinearProgressIndicator)\b'
```

If any matches are returned, the build fails the quality gate immediately.

