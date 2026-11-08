---
id: RULE-UI-002
title: Bootstrap Responsive Grid Layout Engine
category: presentation
severity: blocking
scope:
  include:
    - "lib/presentation/**"
    - "lib/core/widgets/**"
  exclude:
    - "test/**"
---

# Bootstrap Responsive Grid Layout Engine

> Rule ID: RULE-UI-002  
> Severity: blocking  
> Target Scope: lib/presentation/**, lib/core/widgets/**  
> Category: presentation  

---

## 1. Architectural Invariant

All responsive multi-column layouts across mobile, tablet, desktop, and web MUST be structured using `bootstrap_ui_flutter` (`BsContainer`, `BsRow`, `BsCol`, `BsColConfig`).

The primary layout design priority is for **laptop viewports from 1280x720 upwards**, while guaranteeing fluid responsive adaptation across tablets and mobile phones in both portrait and landscape.

Under no circumstances shall:
1. Presentation code use ad-hoc manual screen width arithmetic or arbitrary `MediaQuery.of(context).size.width` branching logic.
2. Layouts hardcode device-specific pixel thresholds (e.g. `if (width > 600)`).
3. Responsive grids omit explicit breakpoint spans when columns must adapt across device sizes (`xs`, `sm`, `md`, `lg`, `xl`, `xxl`).

---

## 2. Rationale & Failure Impact

- **Consistent Multiplatform Adaptation:** Flutter targets phones, foldables, tablets, laptops, desktops, and web browsers. A unified 12-column grid engine ensures layouts adapt predictably according to standard responsive design principles.
- **Laptop-First Priority:** Optimizing first for laptops (1280x720+) provides users with rich multi-column dashboards, while mobile and tablet devices gracefully wrap content into 1 or 2 columns without clipping.
- **Maintainability:** Hardcoding arbitrary `MediaQuery` checks produces brittle, inconsistent UI with layout overflow glitches whenever window dimensions change.
- **Failure Impact:** Direct width arithmetic leads to UI clipping, horizontal scroll leaks, fractured tablet designs, and difficult multiplatform QA.

---

## 3. Compliant Pattern (DO)

Use `bootstrap_ui_flutter` classes with `BsColConfig` specifying explicit column spans across canonical breakpoints:

```dart
// lib/presentation/stations/widgets/stations_grid.dart
import 'package:flutter/widgets.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import '../../../domain/models/weather_station_model.dart';
import 'stations_card.dart';

class StationsGrid extends StatelessWidget {
  final List<WeatherStationModel> stations;

  const StationsGrid({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return BsRow(
      children: stations.map((station) {
        return BsCol(
          // 12 cols on mobile (xs), 6 cols on tablet (md), 4 cols on compact laptop (lg), 3 cols on standard laptop (xl: 1280x720+)
          config: const BsColConfig(
            xs: 12,
            sm: 12,
            md: 6,
            lg: 4,
            xl: 3,
            xxl: 3,
          ),
          child: StationsCard(station: station),
        );
      }).toList(),
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Manual `MediaQuery` screen width calculation and branching:

```dart
// BAD: Manual MediaQuery width checks and branching
class BadLayout extends StatelessWidget {
  const BadLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // VIOLATION: Manual width branching instead of Bootstrap grid engine!
    if (width < 600) {
      return Column(children: [Text('Mobile View')]);
    } else if (width < 1200) {
      return Row(children: [Text('Tablet View')]);
    } else {
      return Row(children: [Text('Desktop View')]);
    }
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Scan presentation widgets for prohibited manual `MediaQuery.of(context).size.width` branching:

```bash
# Verify no direct MediaQuery width branching in presentation
rg --glob 'lib/presentation/**' 'MediaQuery\.of\(context\)\.size\.width'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
