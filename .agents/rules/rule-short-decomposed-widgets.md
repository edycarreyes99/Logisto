---
id: RULE-UI-001
title: Short Decomposed Widgets and Bounded Nesting Depth
category: presentation
severity: critical
scope:
  include:
    - "lib/presentation/**"
  exclude:
    - "test/**"
---

# Short Decomposed Widgets and Bounded Nesting Depth

> Rule ID: RULE-UI-001  
> Severity: critical  
> Target Scope: lib/presentation/**  
> Category: presentation  

---

## 1. Architectural Invariant

All presentation widget `build` methods MUST NOT exceed 40 lines of code.

Under no circumstances shall:
1. A widget's visual tree exceed 3 levels of syntactic nesting depth.
2. A single monolithic screen file combine app bars, complex headers, multi-item grids, filter controls, and empty views in one file.
3. Complex visual subtrees be declared inline; they MUST be extracted into dedicated, single-responsibility sub-widgets located in `presentation/[feature]/widgets/`.

---

## 2. Rationale & Failure Impact

- **Readability and Maintainability:** Giant `build` methods (100+ lines) are difficult to parse, review, and debug. Extracting sub-widgets creates self-documenting visual hierarchies.
- **Rebuild Optimization:** When state updates occur, fine-grained sub-widgets limit widget rebuilds to the exact subtree that depends on the mutated data, preventing expensive top-level screen recalculations.
- **Failure Impact:** Deeply nested widget trees degrade rendering performance, increase git merge conflicts, make UI refactoring error-prone, and cause frame drops on complex screens.

---

## 3. Compliant Pattern (DO)

A clean, declarative screen delegating rendering to decomposed sub-widgets under 40 lines of build code:

```dart
// lib/presentation/stations/stations_screen.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import '../../locator.dart';
import 'stations_provider.dart';
import 'widgets/stations_header.dart';
import 'widgets/stations_grid.dart';
import 'widgets/stations_empty_view.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  late final StationsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = locator<StationsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _provider.initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BsContainer(
          fluid: true,
          child: Column(
            children: [
              const StationsHeader(),
              AnimatedBuilder(
                animation: _provider,
                builder: (context, _) {
                  return _provider.stations.isEmpty
                      ? const StationsEmptyView()
                      : StationsGrid(stations: _provider.stations);
                },
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

A bloated monolithic build method mixing layout, styles, deep containers, and inline logic:

```dart
// BAD: Monolithic 120-line build method with 8 levels of widget nesting
class BadStationScreen extends StatelessWidget {
  const BadStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.blue),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Deeply nested title'), // Level 6+ nesting!
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Hundreds of lines of inline ListView, dialog triggers, cards...
          ],
        ),
      ),
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Scan presentation files to flag oversized `build` methods exceeding 40 lines:

```bash
# Verify widget build method line lengths
python3 -c "
import pathlib, re

for f in pathlib.Path('lib/presentation').rglob('*.dart'):
    content = f.read_text(encoding='utf-8')
    matches = re.finditer(r'Widget build\(BuildContext context\)\s*\{', content)
    for m in matches:
        start = m.start()
        # Find closing brace matching depth
        brace_count = 1
        lines = 1
        for char in content[m.end():]:
            if char == '{': brace_count += 1
            elif char == '}':
                brace_count -= 1
                if brace_count == 0: break
            if char == '\n': lines += 1
        if lines > 40:
            print(f'FAIL: {f} build method has {lines} lines (exceeds 40)')
"
```

Expected output: 0 failures. Any oversized build method must be refactored into sub-widgets.
