---
name: multiplatform-responsive-auditor
description: |
  Comprehensive procedural verification framework for asserting universal multiplatform runtime
  readiness (Web, Windows, macOS Intel & Apple Silicon, Android, iOS) and executing automated 100%
  responsive audits across all 6 Bootstrap breakpoints in portrait and landscape orientations.
  Mandatory trigger conditions:
  - Trigger when verifying multiplatform compilation across Web, Windows, macOS, Android, and iOS.
  - Trigger when asserting responsive layout adaptation and orientation resilience (portrait & landscape).
  - Trigger when auditing for RenderFlex layout overflow errors or broken responsive breakpoints.
  Do NOT trigger when:
  - Do not trigger for raw database collection or DTO creation without UI concerns.
  - Do not trigger for localization translation editing alone.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: testing
  publisher: Architecture Standards Team
---

# Multiplatform Responsive Auditor & Execution Verification Framework

> Standard: Universal Multiplatform & Responsive Verification Specification  
> Scope: Platform compilation, responsive widget tests, and layout overflow audits  
> Governance: Zero Emojis, 100% Technical English, Strict Automated Validation  
> Rule Conformance: RULE-QUAL-002 (Multiplatform & Responsive Verification), RULE-ARCH-007 (Targets)  
> Target Matrix: [references/target-matrix-specification.md](references/target-matrix-specification.md)  
> Test Harness: [templates/responsive-test-harness-template.dart](templates/responsive-test-harness-template.dart)  

---

## 1. Executive Summary & Objective

Modern enterprise Flutter applications must execute flawlessly across five diverse target environments: **Web, Windows, macOS (Intel & Apple Silicon), Android, and iOS**. A failure on any single operating system compromises system integrity. Concurrently, user interfaces must deliver 100% responsive fluid adaptation across smartphones, foldables, tablets, laptops, and ultra-wide displays in both **Portrait** and **Landscape** orientations without layout clipping or `RenderFlex` overflow errors.

This skill prescribes the exact procedural workflows for executing multiplatform compilation audits, authoring automated responsive test matrices, and running adversarial layout tests against all 6 Bootstrap 5.3 breakpoints.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Preparing a release candidate or continuous integration gate check across platform targets.
- Verifying that newly created or refactored screens adapt seamlessly across all device sizes.
- Testing screen orientation rotation between portrait and landscape modes.
- Investigating or preventing `RenderFlex overflowed by ... pixels` exceptions.
- Verifying native desktop and web compilation health.

### 2.2. When to Avoid This Skill
- Scaffolding backend domain business logic without UI presentations.
- Authoring raw database migration schemas or indexing rules.
- Translating ARB localization keys.

---

## 3. Pre-Flight Verification (Step 0)

Execute these diagnostic pre-flight checks before initiating multiplatform verification:

```bash
# 1. Inspect supported Flutter devices and target tooling
flutter devices
flutter doctor

# 2. Verify platform folders exist in the workspace root
test -d web && test -d windows && test -d macos && test -d android && test -d ios && echo "All 5 platform targets present."

# 3. Check for existing responsive widget tests
ls test/presentation/responsive/ 2>/dev/null || echo "No responsive tests authored yet."
```

---

## 4. Canonical Specification & Standards

### 4.1. Multiplatform Platform Target Invariants
1. **Web:**
   - Must build with `flutter build web --wasm-dry-run` without dart:io compilation failures.
   - Persistence must function via IndexedDB.
2. **Windows Desktop:**
   - 64-bit desktop executable compiles via `windows/`.
   - Dynamic window resizing must not crash visual trees.
3. **macOS Desktop:**
   - Universal binary compatibility: supports both **Apple Silicon (arm64)** and **Intel (x86_64)** architectures.
   - Conforms to macOS window framing and keyboard navigation.
4. **Android:**
   - Minimum SDK `minSdkVersion 21`. Supports Android 5.0 through Android 15+.
   - Seamlessly adapts across phone, foldable, and tablet aspect ratios.
5. **iOS:**
   - Minimum deployment target iOS 13.0+.
   - Adheres to device safe areas (Notch, Dynamic Island, Home Indicator) in portrait and landscape.

### 4.2. Form Factor Hierarchy & Laptop Priority Invariant
While the application executes across mobile devices, tablets, laptops, and desktops, **laptops from 1280x720 upwards are designated as the PRIMARY operational target**. Layouts, component sizing, grid columns, and information density must be optimized first and foremost for laptop screens (1280x720, 1280x800, 1366x768, 1440x900, 1536x864, 1920x1080), while guaranteeing 100% responsive fluid adaptation across mobile handsets and tablets in both portrait and landscape.

### 4.3. The 7-Point Responsive Orientation Matrix
Every user interface screen MUST be systematically verified against this standard test matrix:
1. `xs_mobile_portrait`: `Size(360, 800)` - Compact portrait smartphone.
2. `sm_mobile_landscape`: `Size(800, 360)` - Rotated smartphone in landscape.
3. `md_tablet_portrait`: `Size(768, 1024)` - iPad / Android tablet portrait.
4. `lg_tablet_landscape`: `Size(1024, 768)` - Rotated tablet / small laptop.
5. `xl_laptop_primary_720`: `Size(1280, 720)` - Primary target: benchmark laptop display.
6. `xl_laptop_standard_800`: `Size(1280, 800)` - Standard 16:10 laptop / desktop display.
7. `xxl_ultrawide`: `Size(1920, 1080)` - Full HD / 4K widescreen monitor.

### 4.4. Layout Invariants
- **Zero RenderFlex Overflow:** `expect(tester.takeException(), isNull)` MUST hold true across every breakpoint.
- **Scroll Resilience:** Any view whose content can exceed vertical height in landscape (such as forms or modal dialogs) MUST wrap body content in a `SingleChildScrollView` or `scrollable: true` container.
- **Laptop First Density:** At `xl` (1280x720+), layouts must take full advantage of screen width, using multi-column cards, visible action bars, and expanded navigation headers.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Create the Screen Responsive Test Suite
Create a dedicated test file in `test/presentation/responsive/[feature]_screen_responsive_test.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/presentation/stations/stations_screen.dart';

void main() {
  const viewportMatrix = <String, Size>{
    'xs_mobile_portrait': Size(360, 800),
    'sm_mobile_landscape': Size(800, 360),
    'md_tablet_portrait': Size(768, 1024),
    'lg_tablet_landscape': Size(1024, 768),
    'xl_laptop_primary_720': Size(1280, 720), // Primary target: benchmark laptop
    'xl_laptop_standard_800': Size(1280, 800),
    'xxl_ultrawide': Size(1920, 1080),
  };

  for (final entry in viewportMatrix.entries) {
    testWidgets('StationsScreen adapts flawlessly on ${entry.key}', (tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFF0D6EFD),
          builder: (context, _) => const StationsScreen(
            stations: [],
            onRefresh: _noop,
            onSearch: _noopValue,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert zero exceptions and zero RenderFlex overflow
      expect(tester.takeException(), isNull);
    });
  }
}

void _noop() {}
void _noopValue(String _) {}
```

### Step 2: Execute Responsive Test Matrix
Run the responsive test suite and inspect for overflow warnings:

```bash
flutter test test/presentation/responsive/
```

### Step 3: Run Multiplatform Dry-Run Builds
Verify target compilation across supported SDK platforms:

```bash
# Web verification
flutter build web --wasm-dry-run

# Code analysis verification
flutter analyze
```

---

## 6. Edge Cases & Defensive Invariants

| Failure Scenario | Root Cause | Preventive Invariant |
| :--- | :--- | :--- |
| **Mobile Landscape Overflow** | Fixed heights exceeding 360px viewport height when phone is rotated. | Wrap content bodies in `SingleChildScrollView` or scrollable containers. |
| **Modal Clipping in Landscape** | Modal dialog height exceeds screen height. | Set `scrollable: true` on `BsModal` to enable independent body scrolling. |
| **Desktop Window Crash on Resize** | Hardcoded pixel math throwing divide-by-zero or negative constraints. | Rely strictly on Bootstrap 12-column grid engine (`BsRow`, `BsCol`). |
| **Platform Unresolved Plugin** | Using mobile-only camera or biometric package without desktop fallback. | Implement platform capability checks before invoking platform channels. |
| **Dart:io Import on Web Target** | Direct `dart:io` reference in common presentation code. | Use conditional imports or abstract storage/file interfaces. |

---

## 7. Verification & Quality Gates

The quality gate passes only when all responsive and platform tests succeed:

```bash
# 1. Run all responsive widget tests with expanded reporting
flutter test test/presentation/responsive/ --reporter expanded

# 2. Verify zero RenderFlex overflow mentions across all logs
flutter test 2>&1 | grep -i "RenderFlex overflowed" && exit 1 || echo "Zero overflow exceptions."

# 3. Verify zero linter warnings across all files
flutter analyze --fatal-infos
```

